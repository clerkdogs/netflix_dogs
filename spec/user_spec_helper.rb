module UserSpecHelper
  def user( hash={} )
    u = OpenStruct.new( hash.merge( :save => true ) )
    u.class_eval { include NetflixDogs::NetflixUserMethods }
    u 
  end
  
  def user_with_access 
    user(
      :netflix_id => 'T1KFIhPAUa7WymWE8IZhgOm8kxKttk7FQZVqyikQL2hF4-',   
      :request_token =>  'h6bp7pr9y7ebkjhhz2dudzyr',
      :request_secret =>  'HsXHdwWG5r9T', 
      :access_token =>  'T1R4P6TR_XLeuTPhC8mjQOCZOhWbv40elPQdiQ2kCm.LLqRRZhRS.DbcJTZvJbiJxcF0ozLM50jE0V.XEffuhFmQ--',
      :access_secret =>  'cPCHhMjvhJTp'
    )
  end   
end  