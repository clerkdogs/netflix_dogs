module NetflixDogs
  class Queue < UserSearcher 
    # FINDERS =========================
    def self.get( user )
      searcher = new( "users/#{user.netflix_id}/queues", user ) 
      searcher.go
    end
    
    def self.add_to_queue( user, movie_id ) 
      searcher = new( 'users/current', user ) 
      searcher.go( {}, false ) # returns feedback not path
    end   
    
  end # Queue  
end  # NetflixDogs