require 'rubygems'
require 'activesupport'
require 'uri'
require 'net/http'
require 'oauth'
require 'nokogiri'

$:.unshift(File.dirname(__FILE__)) 

# load library
require 'requester'
require 'catalog'
require 'parsers/set'

module NetflixDogs
  class AuthenticationError < SecurityError
  end   
end   
 
