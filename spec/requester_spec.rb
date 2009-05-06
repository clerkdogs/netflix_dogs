require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Requester do
  before(:each) do
    @requester = NetflixDogs::Requester.new( 'base_path' )
  end
  
  describe 'credentials' do 
    before(:all) do 
      # reset location 
      NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/netflix.yml'
    end  
    
    it 'should find the config file in the default location' do
      NetflixDogs::Requester.config_location.should include( 'netflix.yml' )
      File.exists?(NetflixDogs::Requester.config_location).should == true 
    end
      
    it 'should automatically load credentials' do
      NetflixDogs::Requester.credentials['key'].should == 'my_big_key'
      NetflixDogs::Requester.credentials['secret'].should == 'uber_secret'
      NetflixDogs::Requester.key.should == 'my_big_key'
      NetflixDogs::Requester.secret.should == 'uber_secret' 
    end
    
    it 'should have an instance method for key' do 
      credentials = NetflixDogs::Requester.new( 'base_path' )
      credentials.key.should == 'my_big_key'
    end 
    
    it 'should have an instance method for secret' do 
      credentials = NetflixDogs::Requester.new( 'base_path' )
      credentials.secret.should == 'uber_secret'
    end 
    
    # have to load separate real config file for this to go!
    it 'should load credentials from a custom location' do 
      NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/real_netflix.yml'
      NetflixDogs::Requester.config_location.should match(/real_netflix/)
      NetflixDogs::Requester.credentials['key'].should_not == 'my_big_key'
      NetflixDogs::Requester.credentials['secret'].should_not == 'uber_secret'
      NetflixDogs::Requester.key.should_not == 'my_big_key'
      NetflixDogs::Requester.secret.should_not == 'uber_secret'
    end  
  end     
  
  describe 'parameter packaging' do 
    it 'should be able to encode query string from a hash' do 
      @requester.build_query_string(
        'pizza' => 'good',
        'beer' => 'plenty'
      )
      @requester.query_string.should match(/^\?/) 
      @requester.query_string.should match(/(&)/)
      @requester.query_string.should match(/pizza=good/)
      @requester.query_string.should match(/beer=plenty/)
    end     
    
  end  
  
  describe 'non-user oauth packaging' do
    it 'should build a set of correct auth params'
    it 'should build those params into an auth query string'
    it 'should package the auth query url'
    it 'should create a signature'
  end  
  
  
  

end