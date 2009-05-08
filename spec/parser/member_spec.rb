require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::Parser::Member do
  
  before(:all) do 
    # DATA constant set up in spec_helper
    @xml = File.open( "#{DATA}/catalog/title_search.xml", 'r' ).read
    @set = NetflixDogs::Parser::Set.new(@xml)
    @member = NetflixDogs::Parser::Member.new( @set.members.first )
  end
  
  describe 'initialization' do 
    it 'should be a Member object' do  # more for testing the test, and the Set members function 
      @member.class.should == NetflixDogs::Parser::Member
    end
      
    it 'should have a parser' do 
      @member.parser.should_not be_nil
      @member.parser.class.should == Nokogiri::XML::Element
    end  
  end 
  
  describe 'finding tag values' do 
    it 'should find the content of a tag called \'id\' with the method member_id' do 
      @member.member_id.should == 'http://api.netflix.com/catalog/titles/movies/319022'
    end 
    
    it 'should find other inner_html content via the tag name' do
      @member.release_year.should == "1986"
    end
    
    describe 'getting values from attributes' do 
      it 'should produce an OpenStruct when pulling values from the attributes' do
        @member.title.class.should == OpenStruct
      end  
      
      it 'the OpenStruct should be able to report its attributes' do 
        @member.title.attributes.should == ['regular', 'short']
      end
        
      it 'should find the right values' do
        @member.title.short.should == "Blue Velvet"
        @member.title.regular.should == "Blue Velvet"
      end  
    end
    
    describe 'finding content in a link' do
      it 'should find the attributes for a link by the title attribute' do 
        @member.cast.class.should == OpenStruct
        @member.cast.href.should == "http://api.netflix.com/catalog/titles/movies/319022/cast"
        @member.cast.rel.should == "http://schemas.netflix.com/catalog/people.cast"
      end  
    end
    
    describe 'finding content in a category tag' do
      it 'should find the attributes for a category tag based on the last portion of the scheme' do 
        @member.genres.class.should == Array
        @member.genres.first.class.should == OpenStruct
        @member.genres.first.scheme.should == "http://api.netflix.com/categories/genres"
        @member.genres.first.label.should == "Drama"
        @member.genres.first.term.should == "Drama"
      end  
    end       
  end     

end