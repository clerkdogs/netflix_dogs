require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::UserSearcher do
  describe 'initialization ' do
    before(:each) do
      @xml = File.open("#{DATA}/user/user_current.xml").read
      @user_data = OpenStruct.new(  :save => true, :netflix_id => '1'  )
      @user_data.class.class_eval { include NetflixDogs::NetflixUserMethods } 
      @requester = NetflixDogs::Requester.new( 'users/current', @user_data )
      NetflixDogs::Requester.stub!(:initialize).with('users/current').and_return(@requester)
      @user = NetflixDogs::User.new( 'users/current', @user_data ) 
    end

    it 'should have a requester' do
      @requester.stub!(:go).and_return( @xml )
      @user.requester.class.should == NetflixDogs::Requester
    end 
  
    it 'requester should have a user' do 
      @user.requester.user.should_not be_nil 
      @user.requester.user.netflix_id.should == '1'
      @user.requester.user.save.should == true
    end
  end    
  
  describe 'requests' do
    # for these tests you need to have a Netflix API key and add that data to the 
    # real_netflix.yml file 
    before(:each) do
      NetflixDogs::Requester.config_location = RAILS_ROOT + '/config/real_netflix.yml'
    end  
    
    it 'should raise an error if the user credentials are bad' do 
      lambda { 
        NetflixDogs::Queue.get( 
          user(
            :netflix_id => 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-', 
            :request_token =>  'h6bp7pr9y7ebkjhhz2dudzyr',
            :request_secret =>  'HsXHdwWG5r9T', 
            :access_token =>  'T1R4P6TR_XLeuTPhC8mjQOCZOhWbv40elPQdiQ2kCm.LLqRRZhRS.DbcJTZvJbiJxcF0ozLM50jE0V.XEffuhFmQ--',
            :access_secret =>  'cPCHhMjvhJTx'
        ) ) 
      }.should raise_error( NetflixDogs::InvalidUserCredentials )
    end
    
    it 'should raise error if tokens are missing' do 
      lambda { 
        NetflixDogs::Queue.get( 
          user(
            :netflix_id => 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-', 
            :access_token =>  'T1R4P6TR_XLeuTPhC8mjQOCZOhWbv40elPQdiQ2kCm.LLqRRZhRS.DbcJTZvJbiJxcF0ozLM50jE0V.XEffuhFmQ--',
            :access_secret =>  'cPCHhMjvhJTx'
        ) ) 
      }.should raise_error( NetflixDogs::AuthenticationError ) 
    end
      
  end 
     
end                            