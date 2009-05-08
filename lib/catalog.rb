module NetflixDogs
  class Catalog 
    # uses application level authentication, no access_token required
    # so lots of extra coding is used in the Requester object
    attr_accessor :requester, :results
    
    def initialize( base_path )
      self.requester = Requester.new( base_path )
    end
    
    def go( hash )
      requester.add_to_query( hash ) 
      self.results = requester.go( :catalog ) 
      results_valid?
      Parser::Set.new( results )
    end
    
    def results_valid?
      raise AuthenticationError, results.inspect unless results.include?( "<?xml" )
    end     
  
  end  
  
  class Title < Catalog
    # CLASS FIND METHODS ==================
    def self.search( title, opts={} )
      searcher = new( search_base_path )
      results = searcher.go({ 
        'term' => title,
        'max_results' => (opts['max_results'] || '10').to_s,
        'start_index' => (opts['start_index'] || '0').to_s 
      })
    end
    
    def self.autocomplete( title )
      searcher = new( autocomplete_base_path )
      result = searcher.go({ 'term' => title })
    end
    
    def self.list( opts={} ) 
      searcher = new( list_base_path )
      results = searcher.go({ 
        'include_amg' => (opts['include_amg'] || false) == true ? '1' : '0',
        'include_tms' => (opts['include_tms'] || false) == true ? '1' : '0'
      }) 
    end
    
    # CONSTANTS ===========================
    def self.search_base_path
      'catalog/titles'
    end
    
    def self.autocomplete_base_path
      'catalog/titles/autocomplete'
    end
    
    def self.list_base_path
      'catalog/titles/index'
    end
               
  end # Title  
end  # NetflixDogs