module NetflixDogs
  class UserData < OpenStruct
    
    def initialize( data )
      if data.respond_to?( :attributes )
        super( data.attributes )
      else
        super( data )
      end    
    end  
    
    def valid?
      valid = true
      self.class.required_methods.each do |meth|
        valid = false unless self.respond_to?(meth) && !self.send(meth.to_sym).nil?
      end
      valid  
    end 
    
    def self.required_methods
      []
    end              
    
  end # UserData  
end  # NetflixDogs    