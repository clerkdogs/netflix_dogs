module NetflixDogs
  class Person < CatalogSearcher 
    
    # CLASS FIND METHODS ==================
    def self.search( name, opts={} )
      searcher = new( search_base_path )
      searcher.go({ 
        'term' => name,
        'max_results' => (opts['max_results'] || '10').to_s,
        'start_index' => (opts['start_index'] || '0').to_s 
      })
    end 
    
    def self.find( url_id )
      id_path = parse_url_id( url_id )
      searcher = new( id_path ) 
      searcher.go({}, false)
    end 
    
    # PATHS ===============================
    private
      def self.search_base_path
        'catalog/people'
      end   
    public

  end # Person
end # NetflixDogs