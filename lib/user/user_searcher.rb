module NetflixDogs
  class UserSearcher < Searcher 
    attr_accessor :http_method
    
    def initialize( path, user, method=nil )
      self.http_method = method if method
      super( path, user )
    end   
    
    def go( hash={}, set=true )
      requester.http_method = http_method if http_method
      requester.add_to_query( hash ) 
      self.results = requester.go( :user )
       
      results_valid?
      self.results = results.body
      if set  
        opts = self.class.to_s.match(/Queue/) ? {:child => 'queue_item'} : {} 
        Parser::Set.new( results, opts )
      else
        Parser::Member.new( results )
      end 
    end 
    
    # not a true or false test, but a raise error and fail or go forward test, 
    # perhaps the ? is not appropriate, but it feels right
    def results_valid? 
      raise InvalidUserCredentials, results.body if results.class == Net::HTTPUnauthorized 
      raise AuthenticationError, results.body if 
        results.class != Net::HTTPOK &&
        results.class != Net::HTTPCreated
    end
    
    if defined?( RAILS_DEFAULT_LOGGER )
      def logger
        RAILS_DEFAULT_LOGGER
      end  
    end    
    
  end # User  
end  # NetflixDogs