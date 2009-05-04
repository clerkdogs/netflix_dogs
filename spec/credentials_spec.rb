require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Credentials do
  before(:each) do 
  end   
  
  describe 'Application Credentials' do
    it 'should find the config file in the default location' do 
      NetflixDogs::ApplicationCredentials.config_location.should include( 'netflix.yml' )
      File.exists?(NetflixDogs::ApplicationCredentials.config_location).should == true 
    end
      
    it 'should load credentials' do 
      NetflixDogs::ApplicationCredentials.load_credentials
      NetflixDogs::ApplicationCredentials.credentials['key'].should == 'my_big_key'
      NetflixDogs::ApplicationCredentials.credentials['secret'].should == 'uber_secret'
      NetflixDogs::ApplicationCredentials.key.should == 'my_big_key'
      NetflixDogs::ApplicationCredentials.secret.should == 'uber_secret'
    end
  end
  
  describe 'User Credentials' do
    it 'should be initialized with a hash of user credential information'
    it 'should have a ...'
  end  
    
end  
