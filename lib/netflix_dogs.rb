require 'rubygems'
require 'activesupport'
require 'uri'
require 'net/http'
require 'oauth'
require 'nokogiri'
require 'ostruct'

$:.unshift(File.dirname(__FILE__)) 

# load library
require 'requester'
require 'catalog'
require 'parsers/set'
require 'parsers/member'

module NetflixDogs
  class AuthenticationError < SecurityError
  end   
end 

class OpenStruct 
  def attributes 
    reserved =  OpenStruct.new.methods 
    self.methods.select{ |method| !reserved.include?( method ) && !method.match('=') }  
  end
 
end   
 
