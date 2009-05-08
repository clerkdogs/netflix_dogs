require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::Title do
  before(:each) do
    @title = NetflixDogs::Title.new( 'base_path' ) 
  end

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

  describe 'class method #find' do
    # id provided on a previous call
  end
  
  describe 'class method #similar' do 
    # id provided on a previous call
  end                
     
end