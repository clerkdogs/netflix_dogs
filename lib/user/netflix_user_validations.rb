module NetflixDogs
  module NetflixUserValidations
    
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
    
  end # UserData  
end  # NetflixDogs    