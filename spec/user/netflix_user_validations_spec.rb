require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::NetflixUserMethods do
  def user( hash={} )
    u = OpenStruct.new( hash.merge( :save => true ) )
    u.class_eval { include NetflixDogs::NetflixUserMethods }
    u 
  end  
    
  describe "validation" do
    it 'required methods should be netflix_id, and access_token' do 
      user.required_netflix_attributes.should == ['netflix_id', 'access_token']
    end  
    
    it 'should be valid if all the required data is not nil'  do 
      @user = user( :netflix_id => '1', :access_token => '2' )
      @user.netflix_valid?.should == true
    end  
  
    it 'should not be valid if data is missing' do
      @user = user( :netflix_id => '1'  ) 
      @user.should_not be_netflix_valid
    end  
  
    it 'should not be valid if data is nil' do 
      @user = user( :netflix_id => '1', :access_token => nil )
      @user.should_not be_netflix_valid 
    end   
  end
  
  describe 'information storage' do  
    it 'should update the model from oauth returned params' do
      @user = user 
      params = {
        :oauth_token => 'T1B04dSxqDGwX6j99CV5CJHDQt1SzSPBCdlj1cqjzJ.BMlPLwg8reHkeMdF9jSYiPbu0tXvlhat7Ev41mNe0upFg--',
        :user_id => 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-',
        :oauth_token_secret => 'eGXQFmb92zWA'
      }
      @user.should_not_receive(:save)
      @user.update_from_oauth( params )
      @user.access_token.should == 'T1B04dSxqDGwX6j99CV5CJHDQt1SzSPBCdlj1cqjzJ.BMlPLwg8reHkeMdF9jSYiPbu0tXvlhat7Ev41mNe0upFg--'
      @user.access_token_secret.should == 'eGXQFmb92zWA'
      @user.netflix_id.should == 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-'
    end 
    
    it 'should update and save the model from oauth returned params' do
      @user = user 
      params = {
        :oauth_token => 'T1B04dSxqDGwX6j99CV5CJHDQt1SzSPBCdlj1cqjzJ.BMlPLwg8reHkeMdF9jSYiPbu0tXvlhat7Ev41mNe0upFg--',
        :user_id => 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-',
        :oauth_token_secret => 'eGXQFmb92zWA'
      }
      @user.should_receive(:save)
      @user.update_from_oauth!( params )
      @user.access_token.should == 'T1B04dSxqDGwX6j99CV5CJHDQt1SzSPBCdlj1cqjzJ.BMlPLwg8reHkeMdF9jSYiPbu0tXvlhat7Ev41mNe0upFg--'
      @user.access_token_secret.should == 'eGXQFmb92zWA'
      @user.netflix_id.should == 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-'
    end  
  end    
end
  
