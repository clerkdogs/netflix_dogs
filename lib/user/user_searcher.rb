module NetflixDogs
  class UserSearcher < Searcher 
    
    def go( hash={}, set=true )
      requester.add_to_query( hash ) 
      self.results = requester.go( :user )
       
      results_valid?
      if results.match(/xml/)
        if set
          Parser::Set.new( results )
        else
          Parser::Member.new( results )
        end 
      else
        results
      end       
    end 
    
    def results_valid? 
      raise InvalidUserCredentials, results.body if results.class == Net::HTTPUnauthorized
      raise AuthenticationError, results.body if results.class == Net::HTTPBadRequest 
    end  
    
  end # User  
end  # NetflixDogs