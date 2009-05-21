require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::Parser::Set do
  
  before(:all) do 
    # DATA constant set up in spec_helper
    @xml = File.open( "#{DATA}/catalog/title_search.xml", 'r' ).read
    @set = NetflixDogs::Parser::Set.new(@xml)
  end  
  
  describe 'parser setup' do
    it 'should pull the type from the first tag in the file' do
      @set.type.should == 'catalog_titles' 
    end
    
    it 'should guess at the member_type' do 
      @set.member_type.should == 'catalog_title'
    end
  end 
  
  describe 'statistics and pagination' do
    it 'should find the number of results' do  
      @set.number_of_results.should == 1101
    end 
    
    it 'should find the starting index' do 
      @set.start_index.should == 2
    end
    
    it 'should find the results per page' do 
      @set.results_per_page.should == 2
    end
    
    it 'should be on the right page' do 
      @set.page.should == 2
    end
    
    it 'should have the right per_page value' do 
      @set.per_page.should == 2
    end
    
    it 'should have the right number of pages' do 
      @set.total_pages.should == 551
    end 
    
    it 'should have the right total records' do
      pending
    end            
  end
  
  describe 'members' do 
    it 'should find all members' do  
      @set.members.size.should == 2
    end
    
    it 'should be an array like object of Member objects' do
      @set.each do |member| 
        member.class.should == NetflixDogs::Parser::Member
      end  
    end
    
    it 'each should have accessible attributes and values' do
      @set.first.genres.first.label.should == "Drama"
    end  
    
    it 'should find members when set has common, but irregular pluralization' do 
      xml = File.open( "#{DATA}/catalog/person_search.xml", 'r' ).read
      set = NetflixDogs::Parser::Set.new(xml)
      set.type.should == 'people'
      set.member_type.should == 'person'
      set.members.size.should == 2 
    end 
    
    it 'should find members when sets members are custom and provided in an argument' do
      xml = File.open( "#{DATA}/user/user_queue.xml", 'r' ).read
      set = NetflixDogs::Parser::Set.new(xml, {:child => 'queue_item'})
      set.type.should == 'queue'
      set.member_type.should == 'queue_item'
      set.members.size.should == 3
    end  
        
  end  
    
end  

