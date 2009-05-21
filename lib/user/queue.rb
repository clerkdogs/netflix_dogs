module NetflixDogs
  class Queue < UserSearcher 
    
    # FINDERS ========================= 
    # ---------------------------------
    # General Queue Search options:
    #  sort - queue_sequence, date_added, or alphabetical
    #  start_index - same as for catalog searches 
    #  max_results - 500 or less, default = 25
    #  updated_min - Unix time format (seconds since epoch), to get stuff updated since a certain date 
    
    
    # Returns a list of available queues links for the user.
    # If no second argument is provided, queue list will be for current user.
    # Otherwise the queue list will be for user related to id in second argument.
    def self.list( user, id=nil )
      searcher = new( "users/#{id || user.netflix_id}/queues", user ) 
      searcher.go({}, false)
    end
    
    # Returns the queue details for a particular queue type.
    # options passed in:
    #   :type, should match any queue type listed in response from self.list method. 
    #     Default type is 'disc', other common options include 'instant'
    #   :id, If no id argument is provided it will search for current user queue.
    #     Otherwise it will search for the user related to the id argument
    #   :sort, specifies the sort order, default for netflix is queue_sequence
    #   :max_results, default is 25, max is max for queue or 500
    #   :start_index, pagination type of a parameter used to get the next set
    #   :updated_min, Unix epoch timestamp for queue changes since that time 
    def self.get( user, opts={} )
      opts = default_opts.merge( opts )
      id = opts[:id] || user.netflix_id
      type = opts[:type]
      params = {}
      params['sort']        = opts[:sort] if opts[:sort]
      params['max_results'] = opts[:max_results] if opts[:max_results]
      params['start_index'] = opts[:start_index] if opts[:start_index]
      params['updated_min'] = opts[:updated_min] if opts[:updated_min]
      
      searcher = new( "users/#{id}/queues/#{type}", user )
      searcher.go(params)                                          
    end
    
    # sends a post request with the etag and title_ref ie movie_id to the netflix
    # queue address. To send it to the instant vs the disc queue, add :type => 'instant'
    # to the options 
    def self.add_to_queue( user, movie_id, opts={} )
      opts = default_opts.merge( opts )
      params = {}
      params['etag'] = etag( user )
      params['title_ref'] = movie_id
      id = opts[:id] || user.netflix_id
      searcher = new( "users/#{id}/queues/#{opts[:type]}", user, :post )
      searcher.go( params, false ) # returns feedback not path 
    end   
    
    # HELPERS ====================
    
    # The etag is required for any request that posts data to Netflix. 
    # It is used by Netflix to accertain which version of the queue the application is 
    # working with. It is stored automatically in the set, when that data is provided
    def self.etag( user, opts={})
      opts.merge!( :max_results => 1 )
      get( user, opts ).etag
    end
    
    def self.default_opts 
      {:type => 'disc'}
    end      
    
    
  end # Queue  
end  # NetflixDogs