require File.expand_path(File.dirname(__FILE__) + '/spec_helper') 

describe NetflixDogs::Catalog do
  before(:each) do 
  end

  describe 'basics' do
    before(:each) do 
      @title = NetflixDogs::Title.new
    end  
    
    it 'should have a gateway authenticator' do 
      @title.gateway.class.should == OAuth::Consumer
    end
      
    it 'should be able to encode query string from a hash' do 
      @title.encode_query_string(
        'pizza' => 'good',
        'beer' => 'plenty'
      )
      @title.query_string.should match(/^\?/) 
      @title.query_string.should match(/(&)/)
      @title.query_string.should match(/pizza=good/)
      @title.query_string.should match(/beer=plenty/)
    end  
    
    it 'should make a request'
    
  end 
  
  describe 'Title' do
    before(:each) do 
      @title = NetflixDogs::Title.new 
    end  
    
    describe 'class method #search' do
      it 'should set the base path to \'catalog/titles\'' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.search('Blue Velvet')
        @title.base_path.should == 'catalog/titles'
      end
        
      it 'should set max_results option in query_string' do
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.search('Blue Velvet')
        @title.query_string.should match(/max_results=10/)
      end
        
      it 'should set start_index option in query_string' do
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.search('Blue Velvet')
        @title.query_string.should match(/start_index=0/)
      end
        
      it 'should set the escaped title to \'term\' in the query_string' do
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.search('Blue Velvet')
        @title.query_string.should match(/term=Blue%20Velvet/)
      end 
      
      it 'should customize the options' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.search('Blue Velvet', {'start_index' => '15', 'max_results' => 20})
        @title.query_string.should match(/start_index=15/)
        @title.query_string.should match(/max_results=20/)
      end   
    end 
    
    describe 'class method #autocomplete' do
      it 'should set the base path to \'catalog/titles/autocomplete\'' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.autocomplete('Blue Velv')
        @title.base_path.should == 'catalog/titles/autocomplete'
      end
        
      it 'should set the escaped title to \'term\' in the query_string' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.autocomplete('Blue Velv')
        @title.query_string.should match(/term=Blue%20Velv/)  
      end
        
    end
    
    describe 'class method #list' do  
      it 'should set the base path to \'catalog/titles/index\'' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.list
        @title.base_path.should == 'catalog/titles/index'
      end
        
      it 'should set the include_amg option in the query_string' do
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.list
        @title.query_string.should match(/include_amg=0/)  
      end
        
      it 'should set the include_tms option in the query_string' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.list
        @title.query_string.should match(/include_tms=0/)
      end
      
      it 'should allow customization of options' do 
        @title.gateway.stub!(:request) # to avoid sending a request out
    
        NetflixDogs::Title.should_receive(:new).and_return( @title )
        NetflixDogs::Title.list({'include_amg' => true, 'include_tms' => true})
        @title.query_string.should match(/include_tms=1/)
        @title.query_string.should match(/include_amg=1/)
      end
           
    end 
    
     
  end   

end