module NetflixDogs
  class Catalog 
    # uses application level authentication, no access_token required
    attr_accessor :base_path, :gateway, :query_string 
    
    # initialization ======================
    def initialize
      self.gateway = Authenticator.new.gateway
    end
    
    # package query string ================
    def encode_query_string( query_hash )
      self.query_string = "?"
      query_hash.each do |key, value|
        self.query_string << '&' unless query_string.size == 1
        self.query_string << URI.escape(key)
        self.query_string << '='
        self.query_string << URI.escape(value)
      end
      query_string  
    end
    
    def query_path
      base_path + query_string
    end   
    
    def request
      gateway.request( :get, query_path ) 
    end  
     
  end  
  
  class Title < Catalog
    # CLASS FIND METHODS ==================
    def self.search( title, opts={} )
      searcher = new
      searcher.base_path = search_base_path 
      searcher.encode_query_string({ 
        'term' => title,
        'max_results' => (opts['max_results'] || '10').to_s,
        'start_index' => (opts['start_index'] || '0').to_s 
      })
      result = searcher.request
    end
    
    def self.autocomplete( title )
      searcher = new
      searcher.base_path = autocomplete_base_path 
      searcher.encode_query_string({ 'term' => title })
      result = searcher.request 
    end
    
    def self.list( opts={} ) 
      searcher = new
      searcher.base_path = list_base_path 
      searcher.encode_query_string({ 
        'include_amg' => (opts['include_amg'] || false) == true ? '1' : '0',
        'include_tms' => (opts['include_tms'] || false) == true ? '1' : '0'
      })
      result = searcher.request 
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