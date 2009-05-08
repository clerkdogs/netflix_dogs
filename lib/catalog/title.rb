module NetflixDogs
  class Title < Catalog
    # CLASS FIND METHODS ==================
    def self.search( title, opts={} )
      searcher = new( search_base_path )
      searcher.go({ 
        'term' => title,
        'max_results' => (opts['max_results'] || '10').to_s,
        'start_index' => (opts['start_index'] || '0').to_s 
      })
    end
    
    def self.autocomplete( title )
      searcher = new( autocomplete_base_path )
      searcher.go({ 'term' => title })
    end
    
    def self.list( opts={} ) 
      searcher = new( list_base_path )
      searcher.go({ 
        'include_amg' => (opts['include_amg'] || false) == true ? '1' : '0',
        'include_tms' => (opts['include_tms'] || false) == true ? '1' : '0'
      }) 
    end 
    
    def self.find( url_id )
      id_path = parse_url_id( url_id )
      searcher = new( id_path ) 
      searcher.go({}, false)
    end
    
    def self.similar( url_id, opts={} ) 
      id_path = parse_url_id( url_id )
      searcher = new( "#{id_path}/similars" )
      searcher.go({ 
        'max_results' => (opts['max_results'] || '10').to_s,
        'start_index' => (opts['start_index'] || '0').to_s 
      }) 
    end
    
    def self.parse_url_id( url_id  )
      url_id.gsub( "#{Requester.api_url}/" , '') # remove api url from request
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
end # NetflixDogs    