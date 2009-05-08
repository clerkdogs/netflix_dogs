require 'rubygems'

# external dependencies
require 'activesupport'
require 'uri'
require 'net/http'
require 'oauth'
require 'nokogiri'
require 'ostruct'

$:.unshift(File.dirname(__FILE__)) 

# load library
require 'requester'
require 'searcher'
require 'catalog/catalog'
require 'catalog/title'
require 'catalog/person'
require 'parsers/set'
require 'parsers/member'

module NetflixDogs
  class AuthenticationError < SecurityError
  end   
end 

class OpenStruct 
  def attributes 
    reserved =  OpenStruct.new.methods 
    self.methods.select{ |method| !reserved.include?( method ) && !method.match('=') }.sort  
  end
end 