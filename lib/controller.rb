module NetflixDogs
  module Controller  
    
    def request_token
      # clear Netflix user information
      # create new Requester, with user and ?? path
      # redirect for request_token, with callback url as access_token, below
      
      api          = Netflix::API.new @current_user
      callback_url = url_for :action => 'netflix_access_token'
      @oauth_url   = api.fetch_request_token callback_url
      redirect_to @oauth_url
    end     

    def access_token
      
      if @current_user.netflix_access_token.blank?
        api = Netflix::API.new @current_user
        api.fetch_access_token

        unless session[:add_to_queue].nil? or session[:add_to_queue][:movie_id].nil?
          movie = Movie.find_by_id session[:add_to_queue][:movie_id]
          NetflixMovie.add_to_queue @current_user, movie
          previous_page          = session[:add_to_queue][:previous_page]
          session[:add_to_queue] = nil
          redirect_to previous_page
        else
          redirect_to "/"
        end
      else
        redirect_to "/"
      end 
    end        

  end # Controller
end # NetflixDogs    