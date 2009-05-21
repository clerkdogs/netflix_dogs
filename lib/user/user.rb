module NetflixDogs
  class User < UserSearcher
    # FINDERS ========================= 
    
    # Returns parser with full information on the user: id, name, preferences and feeds
    # can be used to obtain information on the current user or another user.
    # To get user for current user, leave id blank, otherwise include a netflix id 
    # as the second argument
    def self.find( user, id=nil )
      searcher = new( base_path( user, id ), user ) 
      searcher.go( {}, false )
    end
    
    # returns netflix user id, for current user
    def self.current( user ) 
      searcher = new( 'users/current', user ) 
      member_parser = searcher.go( {}, false )
      struct = member_parser.send('current user'.to_sym )
      url = struct.href
      url.match(/\/([^\/]*)$/).captures.first
    end
    
    # HELPERS ========================= 
    
    private
      def self.base_path( user, id  )
        id = user.netflix_id if id.nil? && !user.netflix_id.blank?
        'users/' + id
      end  
    public      
    
  end # User  
end  # NetflixDogs    