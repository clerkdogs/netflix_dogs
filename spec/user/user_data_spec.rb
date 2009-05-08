require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::UserData do
  it 'should initialize with a hash of attributes' do
    user = NetflixDogs::UserData.new( 
      :netflix_id => '1',
      :whatever => 'whichever'
    ) 
    user.netflix_id.should == '1'
    user.whatever.should == 'whichever'
  end  
  
  it 'should initialize with any object that responds to attributes' do 
    user_model = mock('User ORM')
    user_model.should_receive(:attributes).and_return({
      :netflix_id => '1',
      :whatever => 'whichever'
    })
    user = NetflixDogs::UserData.new( user_model ) 
    user.netflix_id.should == '1'
    user.whatever.should == 'whichever'
  end  
  
  describe "validation" do
    before(:each) do 
      NetflixDogs::UserData.stub!(:required_methods).and_return( ['netflix_id', 'access_token'] )
    end  
    
    it 'should be valid if all the required data is not nil'  do 
      user = NetflixDogs::UserData.new( :netflix_id => '1', :access_token => '2' )
      user.should be_valid
    end  
  
    it 'should not be valid if data is missing' do
      user = NetflixDogs::UserData.new( :netflix_id => '1'  ) 
      user.should_not be_valid
    end  
  
    it 'should not be valid if data is nil' do 
      user = NetflixDogs::UserData.new( :netflix_id => '1', :access_token => nil )
      user.should_not be_valid 
    end   
  end  
end
  
