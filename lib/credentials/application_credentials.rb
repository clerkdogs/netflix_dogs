module NetflixDogs
  class ApplicationCredentials < NetflixDogs::Credentials
    cattr_accessor :key, :secret, :access_token
    cattr_writer :config_location 
  
    attr_writer :timestamp, :nonce 
  
    def nonce 
      @nonce ||= rand(1_000_000)
    end 
  
    def timestamp 
      @timestamp ||= Time.now.to_i
    end   
  
    # APPLICATION LEVEL CREDENTIALS ======================
    def self.config_location 
      @file_location ||= RAILS_ROOT + '/config/netflix.yml' 
    end  
    
    def self.load_credentials
      credentials.each do |key, value|
        send("#{key.to_sym}=", value )
      end  
    end
  
    def self.credentials
      @credentials ||= YAML.load( File.open( config_location ) ) || {} if File.exists?( config_location )
    end  
  
    def valid?
      (self.class.key && self.class.secret) != nil
    end
  
    def require_credentials
      raise( ArgumentError, "You must configure your NetFlix API application key and secret before using NetflixDogs.") unless valid?
    end  
  end # ApplicationCredentials     
end # NetflixDogs      