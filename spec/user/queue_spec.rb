require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
require File.expand_path(File.dirname(__FILE__) + '/../user_spec_helper') 

describe NetflixDogs::Queue do
  include UserSpecHelper
  
  before(:each) do
    @user = user_with_access
  end 
  
  it 'should make a successful request' do 
    response =  NetflixDogs::Queue.get( @user )
    puts response.class
    puts response.body
    puts (response.methods - Object.new.methods).sort.inspect
  end
    
end                            