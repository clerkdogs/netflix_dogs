module NetflixDogs
  class Authenticator 
    
    # C R E D E N T I A L S -----------------------------
    # ---------------------------------------------------
    # APPLICATION LEVEL CREDENTIALS ======================
    cattr_accessor :key, :secret, :access_token
    cattr_writer :config_location 
    
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
     
    # instance methods
    def valid?
      (self.class.key && self.class.secret) != nil
    end
  
    def require_credentials
      raise( ArgumentError, "You must configure your NetFlix API application key and secret before using NetflixDogs.") unless valid?
    end  
    
    def key
      self.class.load_credentials unless self.class.key
      self.class.key
    end
    
    def secret
      self.class.load_credentials unless self.class.secret
      self.class.secret
    end      
    
    
    # G A T E W A Y -------------------------------------
    # ---------------------------------------------------
    # CONFIGURATIONS =========================
    def self.api_url 
      @api_url ||= "http://api.netflix.com" 
    end

    def self.signature_method
      @signature_method ||= "HMAC-SHA1"
    end 

    def self.request_token_url
      @request_token_url ||= "https://api-user.netflix.com/oauth/request_token"
    end

    def self.access_token_url
      @access_token_url ||= "http://api.netflix.com/oauth/access_token"
    end

    def self.authorization_url
      @authorization_url ||=  "https://api-user.netflix.com/oauth/login" 
    end                 
  
    # AUTHORIZATION PROTOCOLS ============
    def gateway( key=self.key, secret=self.secret)
      OAuth::Consumer.new(
        key,
        secret,
        {
          :site => self.class.api_url,
          :signature_method => self.class.signature_method,
          :request_token_url => self.class.request_token_url,
          :access_token_url => self.class.access_token_url,
          :authorize_url => self.class.authorization_url  
         }
      )  
    end
    
    # For accessing protected user data
    # 1) first get a request_token from netflix
    # 2) receive/parse the request_token
    # 3) give enduser request token through session
    # 4) redirect user to netflix for signin and permission
    # 5) request access_token from netflix
    # 6) receive/pares the access_token 
    # 7) use the access_token to access the protected information 
    # 
    # After the initial authentication exchange, the access token can be reused, 
    # and is stored in the database with request token information and access secret.
    # All of this is handled by the oauth gem. But it is nice to know what is going
    # on behind the scenes.
               
     
  end # Authenticator
end # NetflixDogs   