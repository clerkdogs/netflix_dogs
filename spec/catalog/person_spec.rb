require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::Person do

  describe 'class method #search' do 
    before(:each) do
      # stubbing the actual request and the parsing 
      @requester = NetflixDogs::Requester.new('catalog/people')
      NetflixDogs::Parser::Set.stub!( :new ).and_return( nil )
    end
    
    it 'should set the base path to \'catalog/people\'' do
      @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
    
      NetflixDogs::Requester.should_receive(:new).with('catalog/people').and_return(@requester)
      NetflixDogs::Person.search('Vince Vaughn')
    end
      
    it 'should set max_results option in query_string' do 
      @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
      NetflixDogs::Requester.should_receive(:new).with('catalog/people').and_return(@requester)
      NetflixDogs::Person.search('Vince Vaughn')
      @requester.query_string.should match(/max_results=10/) 
    end
      
    it 'should set start_index option in query_string' do 
      @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
      NetflixDogs::Requester.should_receive(:new).with('catalog/people').and_return(@requester)
      NetflixDogs::Person.search('Vince Vaughn')
      @requester.query_string.should match(/start_index=0/)
    end
      
    it 'should set the escaped title to \'term\' in the query_string' do
      @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
      NetflixDogs::Requester.should_receive(:new).with('catalog/people').and_return(@requester)
      NetflixDogs::Person.search('Vince Vaughn')
      @requester.query_string.should match(/term=Vince%20Vaughn/)
    end 
    
    it 'should customize the options' do 
      @requester.stub!(:go).and_return("<?xml") # so that the request doesn't actually go through
      NetflixDogs::Requester.should_receive(:new).with('catalog/people').and_return(@requester)
      NetflixDogs::Person.search('Vince Vaughn', {'start_index' => '15', 'max_results' => 20})
      @requester.query_string.should match(/start_index=15/)
      @requester.query_string.should match(/max_results=20/)
    end 
  end         

  describe 'class method #find' do
    # id provided on a previous call 
    before(:each) do
      # stubbing the actual request and the parsing 
      @requester = NetflixDogs::Requester.new('catalog/titles/movies')
      @xml = File.open( "#{DATA}/catalog/movie_detail.xml", 'r' ).read   
    end
    
    it 'should request details on a movie given an id' do
      NetflixDogs::Parser::Member.stub!( :new ).and_return( nil )
      NetflixDogs::Requester.should_receive(:new).with('catalog/people/152672').and_return(@requester)
      @requester.stub!(:go).and_return("<?xml")
      
      NetflixDogs::Person.find( 'http://api.netflix.com/catalog/people/152672' )
    end
    
    it 'should return a member parser' do 
      NetflixDogs::Requester.should_receive(:new).with('catalog/people/152672').and_return(@requester)
      @requester.stub!(:go).and_return( @xml )
      
      details = NetflixDogs::Person.find( 'http://api.netflix.com/catalog/people/152672' )
      details.class.should == NetflixDogs::Parser::Member
    end
  end       
end