module NetflixDogs
  class User < UserSearcher
    # FINDERS =========================
    def self.find( id, user )
      searcher = new( base_path, user ) 
      searcher.go( {}, false )
    end
    
    def self.current( user ) 
      searcher = new( 'users/current', user ) 
      searcher.go( {}, false )
    end
    
    # HELPERS =========================
    def self.base_path( id=nil )
      id = user.netflix_id if id.nil? && !user.netflix_id.blank?
      'users/' + id
    end      
    
  end # User  
end  # NetflixDogs    