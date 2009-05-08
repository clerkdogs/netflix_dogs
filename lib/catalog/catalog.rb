module NetflixDogs
  class Catalog < Searcher
    # uses application level authentication, no access_token required
    # so lots of extra coding is used in the Requester object
    
    def go( hash={}, set=true )
      requester.add_to_query( hash ) 
      self.results = requester.go( :catalog ) 
      results_valid?
      if set
        Parser::Set.new( results )
      else
        Parser::Member.new( results )
      end    
    end
    
    private
      def self.parse_url_id( url_id  )
        url_id.gsub( "#{Requester.api_url}/" , '') # remove api url from request
      end 
    public

  end # Catalog  
end  # NetflixDogs