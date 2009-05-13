module NetflixDogs
  # This class *could* be broken into Authentication stuff and Request stuff, but
  # the two classes would be calling each other in very spaghetti ways, so ...
  class Requester 
    attr_accessor :base_path, :queries, :user, :request_token, :access_token, :http_method
    attr_writer   :signature
    cattr_accessor :key, :secret, :application_name, :authorize_callback_url
    
    # I N I T I A L I Z E -------------------------------
    def initialize( path, user_object=nil, method=nil )
      self.base_path = path
      self.queries = HashWithIndifferentAccess.new
      if user_object
        self.user = user_object
        self.user.class.class_eval do 
          include NetflixUserMethods
        end
      end 
      self.http_method = method || :get 
    end 
    
    # G O -----------------------------------------------
    def go( type=:catalog )
      if type == :user    
        send_auth_request
      else 
        send_non_auth_request
      end    
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
      @request_token_url ||= "http://api.netflix.com/oauth/request_token"
    end

    def self.access_token_url
      @access_token_url ||= "http://api.netflix.com/oauth/access_token"
    end

    def self.authorization_url
      @authorization_url ||=  "https://api-user.netflix.com/oauth/login" 
    end
    
    # COMMON PARAMS/QUERY PARSING METHODS
    def url # includes the api_url
      "#{self.class.api_url}/#{query_path}"
    end
    
    def query_path # does not include the api_url
      base_path + '?' + query_string
    end
    
    def query_string(include_oauth_signature=true)
      arr = []
      query_order.each do |key|
        # add oauth_signature, except when that flag is false
        unless include_oauth_signature == false &&  key == 'oauth_signature'  
          arr << "#{key}=#{queries[key]}"
        end   
      end
      string = ""
      string << arr.join('&')
      string  
    end 
    
    def add_to_query( query_hash )
      query_hash.each do |key, value|
        self.queries[key] = URI.escape(value.to_s, escape_these)
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
    
    def send_auth_request
      if access_token
        puts 'netflix user is valid'
        access_token.send( http_method, base_path )
      elsif request_token
        # request an access_token
        puts 'no access token, but there is a request token'
        @access_token = request_token.get_access_token
        set_token_in_user( access_token, 'access' ) 
        access_token.send( http_method, base_path )
      else
        puts 'no request token'
        # request a request_token 
        # save the request_token in the user model with the request_token_secret  
        @request_token = oauth_gateway.get_request_token
        set_token_in_user( request_token, 'request' ) 
        # return url for redirection 
        return oauth_authorization_url
      end    
    end 
    
    def set_token_in_user( token, token_type )
      unless token.nil?
        user.send( "#{token_type}_token=", token.token )
        user.send( "#{token_type}_token_secret=", token.secret ) 
        if token_type == 'access'
          user.netflix_id = token.response[:user_id]
          user.request_token = nil
          user.request_token_secret = nil
        end  
        user.save 
      end  
    end  
    
    def request_token
      @request_token ||= OAuth::RequestToken.new( 
        oauth_gateway , 
        user.request_token, 
        user.request_secret
      ) if user && user.request_token 
      @request_token
    end
    
    def access_token
      @access_token ||= OAuth::AccessToken.new( 
        oauth_gateway , 
        user.request_token, 
        user.request_secret
      ) if user && user.access_token 
      @access_token
    end  
    
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
    
    def oauth_authorization_url
      if request_token
        request_token.authorize_url(
          :oauth_token => request_token.token,
          :oauth_consumer_key => key,
          :application_name => self.class.application_name,
          :oauth_callback => self.class.authorize_callback_url
        ) 
      end  
    end
     
    
    # Userless-OAuth -------------------------------
    # NETFLIX accesses non-protected data without the need for 
    # an access token, which makes it not really oauth. The request
    # still needs all the oauth type packaging. So below are the 
    # methods for constructing the oauth security, less the token 
    
    def send_non_auth_request 
      sign 
      Net::HTTP.get( URI.parse( url ) )
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
    
    def sign 
      build_auth_query_string 
      signature
    end  
    
    def signature
      @signature = Base64.encode64(
          HMAC::SHA1.digest( signature_key, signature_base_string )
        ).chomp.gsub(/\n/,'')
      add_to_query({'oauth_signature' => @signature})  
      @signature
    end
    
    def signature_key(access_token=nil) 
      "#{secret}&#{access_token}"
    end
    
    def signature_base_string
      encoded_url = URI.escape( "#{self.class.api_url}/#{base_path}", escape_these )
      encoded_params = URI.escape( query_string, escape_these )
      "GET&#{encoded_url}&#{encoded_params}"
    end     
    
    private
      def escape_these
        /[^A-Za-z0-9\-\._~]/
      end
      
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