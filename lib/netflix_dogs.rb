require 'rubygems'

# external dependencies
require 'activesupport'
require 'uri'
require 'net/http'
require 'oauth'
require 'nokogiri'
require 'ostruct'

$:.unshift(File.dirname(__FILE__)) 

# this library
require 'requester'
require 'searcher'
require 'parsers/set'
require 'parsers/member'

require 'catalog/catalog_searcher'
require 'catalog/title'
require 'catalog/person'

require 'user/user_searcher'
require 'user/queue'
require 'user/user'
require 'user/netflix_user_methods'

module NetflixDogs
  class AuthenticationError < SecurityError; end 
  class InvalidUserCredentials < AuthenticationError; end 
end 

class OpenStruct 
  def attributes 
    reserved =  OpenStruct.new.methods 
    self.methods.select{ |method| !reserved.include?( method ) && !method.match('=') }.sort  
  end
end 