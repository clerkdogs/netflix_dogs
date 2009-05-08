module NetflixDogs
  module Parser
    class Set < Array
    
      attr_accessor :number_of_results, :start_index, :results_per_page,
        :page, :per_page, :total_pages, :type, :xml, :parser
      attr_writer :member_type  
    
      # set_type is the outermost xml 
      def initialize(xml)
        self.xml = xml
        setup_parser
        add_pagination
        parse
        cleanup
      end
    
      def setup_parser
        xml_parser = Nokogiri.XML(xml)
        self.parser = xml_parser.child
        self.type =  parser.name # should be the first tag name in the file
      end
    
      def add_pagination
        load_stats
        calculate_pagination
      end 
    
      def load_stats
        tag = parser.search('number_of_results')
        self.number_of_results = tag.first.content.to_i if tag && tag.first
        tag = parser.search('start_index')
        self.start_index = tag.first.content.to_i if tag && tag.first
        tag = parser.search('results_per_page')
        self.results_per_page = tag.first.content.to_i if tag && tag.first
      end 
    
      def calculate_pagination
        self.per_page = results_per_page
        self.total_pages = ( number_of_results / per_page.to_f ).round
        self.page = ( (start_index + 1) / per_page.to_f ).round
      end   
    
    
      # MEMBERS ===============================
      # ---------------------------------------
    
      def member_type 
        @member_type ||= type.singularize  unless type.nil?
      end 
    
      def members
        parser.search(member_type)
      end 
      
      # PARSE =============
      # -------------------
      def parse 
        members.each do |xml_parser|
          # this class is essentially an Array with extra stuff, so append values ...
          self<< Member.new( xml_parser )
        end
        self  
      end 
      
      # -------------------
      
      def cleanup
        # to save on memory ...
        # self.xml = nil
        # self.parser = nil
      end         
    
    end    
  end
end    