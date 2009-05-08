module NetflixDogs
  class Searcher 
    
    attr_accessor :requester, :results
    
    def initialize( base_path )
      self.requester = Requester.new( base_path )
    end
    
    def go( hash, set=true )
      raise NotImplementedError, 'must implement \'go\' method in ' + self.to_s    
    end
    
    def results_valid?
      raise AuthenticationError, results.inspect unless results.include?( "<?xml" )
    end 
    
    def self.parse_url_id( url_id  )
        url_id.gsub( "#{Requester.api_url}/" , '') # remove api url from request
    end 
    
  end # Catalog  
end  # NetflixDogs     