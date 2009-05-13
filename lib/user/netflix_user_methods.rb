module NetflixDogs
  module NetflixUserMethods
    
    def netflix_valid?
      valid = true
      required_netflix_attributes.each do |meth|
        valid = false unless self.respond_to?(meth) && !self.send(meth.to_sym).nil?
      end
      valid  
    end 
    
    def required_netflix_attributes
      ['netflix_id', 'access_token']
    end 
    
    def update_from_oauth( params )
      self.access_token = params[:oauth_token]
      self.netflix_id = params[:user_id]
      self.access_token_secret = params[:oauth_token_secret]
    end 
    
    def update_from_oauth!( params )
      update_from_oauth( params )
      save
    end   
    
  end # UserData  
end  # NetflixDogs    