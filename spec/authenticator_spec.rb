require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Authenticator do
  before(:each) do 
  end
  
  describe 'credentials' do 
    it 'should find the config file in the default location' do 
      NetflixDogs::Authenticator.config_location.should include( 'netflix.yml' )
      File.exists?(NetflixDogs::Authenticator.config_location).should == true 
    end
      
    it 'should load credentials' do 
      NetflixDogs::Authenticator.load_credentials
      NetflixDogs::Authenticator.credentials['key'].should == 'my_big_key'
      NetflixDogs::Authenticator.credentials['secret'].should == 'uber_secret'
      NetflixDogs::Authenticator.key.should == 'my_big_key'
      NetflixDogs::Authenticator.secret.should == 'uber_secret' 
    end
    
    it 'should have an instance method for key' do
      credentials = NetflixDogs::Authenticator.new
      credentials.key.should == 'my_big_key'
    end 
    
    it 'should have an instance method for secret' do  
      credentials = NetflixDogs::Authenticator.new
      credentials.secret.should == 'uber_secret'
    end  
  end     
  
  it 'should create a oauth consumer gateway from the application credentials' do 
    authenticator = NetflixDogs::Authenticator.new
    gateway =  authenticator.gateway 
    gateway.key.should == 'my_big_key'
    gateway.secret.should == 'uber_secret'
  end  

end