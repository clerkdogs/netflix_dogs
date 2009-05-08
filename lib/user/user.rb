module NetflixDogs
  class User < UserSearcher
  
    def self.find( url_id, user )
      id_path = parse_url_id( url_id )
      searcher = new( id_path, user ) 
      searcher.go({}, false)
    end
    
  end # User  
end  # NetflixDogs    