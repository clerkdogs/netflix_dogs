require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe NetflixDogs::Queue do
  before(:each) do
    @user = {}
    @queue = NetflixDogs::Queue.new( 'base_path', @user ) 
  end
end                            