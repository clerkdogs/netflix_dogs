require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::UserSearcher do
  before(:each) do 
    @queue = NetflixDogs::Queue.new( 'base_path' ) 
  end

  # describe 'basics' do
  #   it 'should have a requester' do 
  #     @title.requester.class.should == NetflixDogs::Requester
  #   end 
  #   
  #   describe 'request' do
  #     # for these tests you need to have a Netflix API key and add that data to the 
  #     # real_netflix.yml file 
  #     before(:each) do
  #       NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/real_netflix.yml'
  #       NetflixDogs::Requester.load_credentials 
  #     end  
  #     
  #     it 'should be successful' do
  #       pending # turn this on as needed to avoid slamming Netflix repeatedly 
  #       lambda{ NetflixDogs::Title.search( 'Blue Velvet' ) }.should_not raise_error  
  #     end
  #   end 
  #   
  #   describe 'results' do 
  #     before(:each) do
  #       @xml = File.open( "#{DATA}/catalog/title_search.xml", 'r' ).read
  #       @requester = NetflixDogs::Requester.new('catalog/titles')
  #       @requester.stub!(:go).and_return(@xml)
  #       NetflixDogs::Requester.should_receive(:new).with('catalog/titles').and_return(@requester)
  #       @results =  NetflixDogs::Title.search( 'Blue Velvet' )
  #     end  
  #     
  #     it 'should return an array like thing' do 
  #       @results.should be_respond_to(:each)
  #       @results.should be_respond_to(:collect)
  #     end
  #       
  #     it 'should have pagination information' do 
  #       @results.per_page.should == 2
  #       @results.page.should == 2
  #     end   
  #     
  #     it 'should have the right number of entries' do 
  #       @results.size.should == 2
  #     end
  #     
  #     it 'each entry should be a member parser' do
  #       @results.first.class.should == NetflixDogs::Parser::Member
  #     end
  #       
  #     it 'the member should find its data on request' do
  #       @results.first.title.short.should == "Blue Velvet"
  #     end  
  #   end        
  # end            
     
end                            