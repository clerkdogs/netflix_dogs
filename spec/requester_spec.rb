require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Requester do
  before(:all) do 
    NetflixDogs::Requester.config_location = nil
  end
    
  before(:each) do
    @requester = NetflixDogs::Requester.new( 'base_path' )
  end
  
  describe 'credentials' do 
    before(:each) do 
      NetflixDogs::Requester.config_location = nil
    end  
    
    it 'should throw an error if the config file is not found' do 
      lambda { 
        NetflixDogs::Requester.config_location = '/not_here.yml' 
      }.should raise_error
    end
    
    it 'should throw an error if config file doesn\'t contain a key and secret' do 
      lambda{
        NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/bad_data.yml'
      }.should raise_error
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
      @requester.add_to_query(
        'pizza' => 'good',
        'beer' => 'plenty'
      ) 
      @requester.query_string.should == 'beer=plenty&pizza=good'
    end
    
    it 'should have a query path' do
      @requester.add_to_query( 
        'pizza' => 'good',
        'beer' => 'plenty'
      ) 
      @requester.query_path.should match(/base_path/) 
      @requester.query_path.should match(/\?/) 
      @requester.query_path.should match(/(&)/)
      @requester.query_path.should match(/pizza=good/)
      @requester.query_path.should match(/beer=plenty/)
    end       
    
  end  
  
  describe 'non-user oauth packaging' do
    it 'should have a set of correct auth params' do
      @requester.auth_hash['oauth_consumer_key'].should == 'my_big_key'
      @requester.auth_hash['oauth_signature_method'].should == "HMAC-SHA1"
      @requester.auth_hash['oauth_timestamp'].class.should == Time.now.to_i.class
      @requester.auth_hash['oauth_nonce'].class.should == 1.class
      @requester.auth_hash['oauth_version'].should == '1.0'
    end 
     
    it 'should build those params into an auth query string' do 
      @requester.build_auth_query_string
      @requester.query_string.should match(/oauth_consumer_key=my_big_key/)
      @requester.query_string.should match(/oauth_signature_method=HMAC-SHA1/)
      @requester.query_string.should match(/oauth_timestamp=/)
      @requester.query_string.should match(/oauth_nonce=/)
      @requester.query_string.should match(/oauth_version=1.0/)
    end
      
    it 'should package the auth query url' do
      @requester.add_to_query( 
        'pizza' => 'good',
        'beer' => 'plenty'
      ) 
      @requester.build_auth_query_string
      
      @requester.url.should match(/^http:\/\/api.netflix.com/) 
      @requester.url.should match(/base_path/) 
      @requester.url.should match(/pizza=good/)
      @requester.url.should match(/beer=plenty/)
      @requester.url.should match(/oauth_consumer_key=my_big_key/)
      @requester.url.should match(/oauth_signature_method=HMAC-SHA1/)
      @requester.url.should match(/oauth_timestamp=/)
      @requester.url.should match(/oauth_nonce=/)
      @requester.url.should match(/oauth_version=1.0/)
      @requester.url.should match(/oauth_signature/)
    end
      
    it 'should create a signature' do 
      @requester.add_to_query( 
        'pizza' => 'good',
        'beer' => 'plenty'
      ) 
      @requester.signature.should_not be_nil
    end
    
    # Sample parameters taken from flix4r, which builds this kind of auth!
    #
    # {
    #  "oauth_nonce"=>37137, 
    #  "term"=>"sneakers", 
    #  "max_result"=>2, 
    #  "oauth_signature_method"=>"HMAC-SHA1", 
    #  "oauth_timestamp"=>1241641821, 
    #  "oauth_consumer_key"=>"my_big_key", 
    #  "oauth_signature"=>"v21tQ73vXqNFlmQCCXW9wrPlHMs%3D", 
    #  "oauth_version"=>"1.0"
    # }    
      
    it 'should create the correct signature' do
      @requester.base_path = 'catalog/titles'
      @requester.queries = { 
        'max_result' => '2',
        'oauth_consumer_key' => 'my_big_key',
        'oauth_nonce' => '37137',
        'oauth_signature_method' => 'HMAC-SHA1',
        'oauth_timestamp' => '1241641821',
        'oauth_version' => '1.0',
        'term'=> 'sneakers'
      }
      @requester.signature_key.should == "uber_secret&"
      @requester.signature_base_string.should ==  "GET&http%3A%2F%2Fapi.netflix.com%2Fcatalog%2Ftitles&max_result%3D2%26oauth_consumer_key%3Dmy_big_key%26oauth_nonce%3D37137%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1241641821%26oauth_version%3D1.0%26term%3Dsneakers"
      @requester.signature.should == 'BaX9f5cXTu1B1pKA5b9md61axak%3D'
    end  
      
  end  

end