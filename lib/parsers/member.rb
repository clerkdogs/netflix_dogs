# There are four type of xml tags in a Netflix Catalog members:
# 1) Standard tags: 
#     <id>http://api.netflix.com/catalog/titles/movies/319022</id>
#   The content is within the open and closing tags.
# 2) Unique tags with attributes as content:
#     <title short="Blue Velvet" regular="Blue Velvet"></title>
#   Each attribute is valid content, but the tag itself is unique within the memeber
# 3) Link tags with unique title attributes
#     <link href="http://www.netflix.com/Movie/Blue_Velvet/319022" rel="alternate" title="web page"></link>
#   The rel attribute is often an href link to information obout the content of the link.
# 4) Category chaos tags: 
#     <category scheme="http://api.netflix.com/categories/mpaa_ratings" label="R" term="R"></category>
#     <category scheme="http://api.netflix.com/categories/genres" label="Drama" term="Drama"></category>
#   There are groups of tags with the same name (so far just category). The label and term provide important
#   information about the scheme, which is a url. In most cases the important information in the url is the 
#   last term.    
#
# The Member model is a lazy parser with the expectation that you won't need all the data passed back. 
# Future iterations can also parse the file for those situations where the majority of 
# the information passed in xml is needed.

module NetflixDogs
  module Parser
    class Member 
      attr_accessor :parser
    
      def initialize( xml_parser, lazy=true ) 
        xml_parser = Nokogiri.XML( xml_parser ) if xml_parser.class == String
        self.parser = xml_parser 
      end
      
      def member_id
        find_in_tags( 'id' )
      end  
    
      # this is for lazy loading of the data
      def method_missing( name, *args )
        value = find_in_tags( name )
        raise NoMethodError, "'#{name.to_s}' not found in xml" unless value
        value 
      end
      
      def find_in_tags( name ) 
        value = find_tag_by_name( name )
        value = find_tag_by_link( name ) unless value
        value = find_tag_by_category( name ) unless value
        value
      end   
     
      # for tags of type 1) and type 2) 
      def find_tag_by_name( name )
        find do
          parser.search( name )
        end  
      end
    
      def find_tag_by_link( name )
        find do 
          parser.css("link[title='#{name}']") 
        end  
      end
    
      def find_tag_by_category( name )
        find do 
          parser.css("category[scheme='http://api.netflix.com/categories/#{name}']") 
        end   
      end
      
      def find
        found = yield
        if found.empty?
          value = false
        else
          if found.size == 1
            value = get_content( found.first )
          else
            value = [] 
            found.each do |f|
              value << get_content( f ) 
            end  
          end      
        end  
        value
      end  
          
    
      def get_content( found )
        found.content.blank? ? get_attributes( found ) : found.content
      end
      
      def get_attributes( found )
        set = OpenStruct.new 
        found.attributes.each do |key, value|
          set.send( "#{key}=", value.to_s )
        end
        set  
      end 
      
      def inspect
        parser.inspect
      end          
    
    end
  end
end    
