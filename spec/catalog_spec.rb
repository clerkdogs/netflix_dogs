require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Catalog do
  before(:each) do
    @title = NetflixDogs::Title.new( 'base_path' ) 
  end

  describe 'basics' do
    it 'should have a requester' do 
      @title.requester.class.should == NetflixDogs::Requester
    end
    
    it 'should make a request'
    
  end 
  
  describe 'Title' do
    describe 'class method #search' do 
      before(:each) do
        # stubbing the actual request and the parsing 
        @requester = NetflixDogs::Requester.new('catalog/titles')
        @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
        NetflixDogs::Parser::Set.stub!( :new ).and_return( nil )
      end
      
      it 'should set the base path to \'catalog/titles\'' do
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        NetflixDogs::Title.search('Blue Velvet')
      end
        
      it 'should set max_results option in query_string' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        NetflixDogs::Title.search('Blue Velvet')
        @requester.query_string.should match(/max_results=10/) 
      end
        
      it 'should set start_index option in query_string' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        NetflixDogs::Title.search('Blue Velvet')
        @requester.query_string.should match(/start_index=0/)
      end
        
      it 'should set the escaped title to \'term\' in the query_string' do
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        NetflixDogs::Title.search('Blue Velvet')
        @requester.query_string.should match(/term=Blue%20Velvet/)
      end 
      
      it 'should customize the options' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        NetflixDogs::Title.search('Blue Velvet', {'start_index' => '15', 'max_results' => 20})
        @requester.query_string.should match(/start_index=15/)
        @requester.query_string.should match(/max_results=20/)
      end   
    end 
    
    describe 'class method #autocomplete' do
      before(:each) do
        # stubbing the actual request and the parsing 
        @requester = NetflixDogs::Requester.new('catalog/titles/autocomplete')
        @requester.stub!(:go).and_return("<?xml") 
        NetflixDogs::Parser::Set.stub!( :new ).and_return( nil )
      end
      
      it 'should set the base path to \'catalog/titles/autocomplete\'' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/autocomplete').and_return(@requester)
        NetflixDogs::Title.autocomplete('Blue Velv') 
      end
        
      it 'should set the escaped title to \'term\' in the query_string' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/autocomplete').and_return(@requester)
        NetflixDogs::Title.autocomplete('Blue Velv')
        @requester.query_string.should match(/term=Blue%20Velv/)  
      end
        
    end
    
    describe 'class method #list' do 
      before(:each) do
        # stubbing the actual request and the parsing 
        @requester = NetflixDogs::Requester.new('catalog/titles/index')
        @requester.stub!(:go).and_return("<?xml") 
        NetflixDogs::Parser::Set.stub!( :new ).and_return( nil )
      end
        
      it 'should set the base path to \'catalog/titles/index\'' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/index').and_return(@requester)
        NetflixDogs::Title.list
      end
        
      it 'should set the include_amg option in the query_string' do
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/index').and_return(@requester)
        NetflixDogs::Title.list
        @requester.query_string.should match(/include_amg=0/)  
      end
        
      it 'should set the include_tms option in the query_string' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/index').and_return(@requester)
        NetflixDogs::Title.list
        @requester.query_string.should match(/include_tms=0/) 
      end
      
      it 'should allow customization of options' do 
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles/index').and_return(@requester)
        NetflixDogs::Title.list({'include_amg' => true, 'include_tms' => true})
        @requester.query_string.should match(/include_tms=1/)
        @requester.query_string.should match(/include_amg=1/)
      end
    end
    
    describe 'request' do
      # for these tests you need to have a Netflix API key and add that data to the 
      # real_netflix.yml file 
      before(:each) do
        NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/real_netflix.yml'
        NetflixDogs::Requester.load_credentials 
      end  
      
      it 'should be successful' do
        pending # turn this on as needed to avoid slamming Netflix repeatedly 
        lambda{ NetflixDogs::Title.search( 'Blue Velvet' ) }.should_not raise_error  
      end
    end
    
    describe 'results' do 
      before(:each) do
        @xml = File.open( "#{DATA}/catalog/title_search.xml", 'r' ).read
        @requester = NetflixDogs::Requester.new('catalog/titles')
        @requester.stub!(:go).and_return(@xml)
        NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
        @results =  NetflixDogs::Title.search( 'Blue Velvet' )
      end  
      
      it 'should return an array like thing' do 
        @results.should be_respond_to(:each)
        @results.should be_respond_to(:collect)
      end
        
      it 'should have pagination information' do 
        @results.per_page.should == 2
        @results.page.should == 2
      end   
      
      it 'should have the right number of entries' do 
        @results.size.should == 2
      end
      
      it 'each entry should be a member parser' do
        @results.first.class.should == NetflixDogs::Parser::Member
      end
        
      it 'the member should find its data on request' do
        @results.first.title.short.should == "Blue Velvet"
      end  
    end      
     
  end   
end