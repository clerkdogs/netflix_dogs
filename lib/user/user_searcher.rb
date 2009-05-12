module NetflixDogs
  class UserSearcher < Searcher 
    
    def go( hash={}, set=true )
      requester.add_to_query( hash ) 
      self.results = requester.go( :user ) 
      # results_valid?
      # if set
      #   Parser::Set.new( results )
      # else
      #   Parser::Member.new( results )
      # end    
    end 
    
  end # User  
end  # NetflixDogs