require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::NetflixUserValidations do
  def user( hash={} )
    u = OpenStruct.new( hash.merge( :save => true ) )
    u.class_eval { include NetflixDogs::NetflixUserValidations }
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
end
  
