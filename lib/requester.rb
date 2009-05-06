module NetflixDogs
  # This class could be broken into Authentication stuff and Request stuff, but
  # they would be calling each other in very spaghetti ways
  class Requester 
    attr_accessor :base_path, :queries 
    attr_writer   :signature
    cattr_accessor :key, :secret
    
    # I N I T I A L I Z E -------------------------------
    def initialize( path )
      self.base_path = path
      self.queries = {}
    end  
    
    # C R E D E N T I A L S -----------------------------
    # ---------------------------------------------------
    # APPLICATION LEVEL CREDENTIALS ======================
    def self.config_location
      @config_location ||= RAILS_ROOT + '/config/netflix.yml' 
    end 
    
    # this will clear existing credentials and load from the new location
    def self.config_location=( location)
      reset_credentials
      @config_location = location
      load_credentials
      @config_location
    end  
    
    def self.reset_credentials 
      @credentials = nil
      self.key = nil
      self.secret = nil
    end     
    
    def self.load_credentials
      credentials.each do |key, value|
        send("#{key.to_sym}=", value )
      end
      raise ArgumentError, 'Netflix credentials not found. Please request API credentials from Netflix and add them to the YAML configuration file.' if key.nil? || secret.nil?
    end
    
    def self.credentials 
      raise ArgumentError, 'Netflix YAML configuration not found at ' + config_location unless File.exists?( config_location )
      @credentials ||= YAML.load( File.open( config_location ) ) || {}
    end 
     
    def key
      self.class.load_credentials unless self.class.key
      self.class.key
    end
    
    def secret
      self.class.load_credentials unless self.class.secret
      self.class.secret
    end      
    
    
    # R E Q U E S T -------------------------------------
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
    
    # COMMON PARAMS/QUERY PARSING METHODS
    def url # includes the api_url
      self.class.api_url + query_path
    end
    
    def query_path # does not include the api_url
      base_path + query_string
    end
    
    def query_string
      arr = []
      query_order.each do |key|
        arr << "#{key}=#{queries[key]}"
      end
      string = "?"
      string << arr.join('&')
      string  
    end 
    
    def add_to_query( query_hash )
      query_hash.each do |key, value|
        self.queries[key] = URI.escape(value.to_s)
      end
    end
    
    def query_order # alphabetical key order
      queries.keys.sort
    end   
     
       
    
    # AUTHORIZATION PROTOCOLS ============
    # OAuth ------------------------------
    # mostly handled by the Oauth gem, used only when accessing protected data 
    # 
    # Overview:
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
    
    def oauth_gateway( key=self.key, secret=self.secret)
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
    
    # Userless-OAuth -------------------------------
    # NETFLIX accesses non-protected data without the need for 
    # an access token, which makes it not really oauth. The request
    # still needs all the oauth type packaging. So below are the 
    # methods for constructing the oauth security, less the token 
    
    def send_request 
      # do something ... 
    end
    
    def auth_hash
      {
        'oauth_consumer_key' => key,
        'oauth_signature_method' => self.class.signature_method,
        'oauth_timestamp' => timestamp,
        'oauth_nonce' => nonce,
        'oauth_version' => '1.0'
      } 
    end
    
    # assumes that it goes on the end of query string
    def build_auth_query_string
      add_to_query( auth_hash ) 
    end
    
    def signature
      build_auth_query_string 
      unless @signature
        signature_key = URI.escape( "#{secret}&" )
        signature_base_string = "GET&#{self.class.api_url}#{base_path}&#{query_path}"
        @signature ||= Base64.encode64(
          HMAC::SHA1.digest( signature_key, signature_base_string )
        ).chomp.gsub(/\n/,'')  
      end
      @signature
    end
    
    private
      def timestamp
        Time.now.to_i 
      end
    
      def nonce  
        rand(1_000_000)
      end   
    public  
               
     
  end # Requester
end # NetflixDogs  

# load credentials from file on class load
NetflixDogs::Requester.load_credentials 