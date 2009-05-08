module NetflixDogs
  class UserSearcher < Searcher 
    
    def initialize( path, user )
      super( path )
      self.requester.user = user
    end  
    
    def go( hash={}, set=true )
      requester.add_to_query( hash ) 
      self.results = requester.go( :user, u ) 
      # results_valid?
      # if set
      #   Parser::Set.new( results )
      # else
      #   Parser::Member.new( results )
      # end    
    end
  end # User  
end  # NetflixDogs