require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../lib')

RAILS_ROOT = File.join( File.dirname(__FILE__), '..' )
DATA =  File.join( File.dirname(__FILE__), '/data' )

require 'netflix_dogs'

require File.dirname(__FILE__) + '/user_spec_helper'
include UserSpecHelper 

def safari( url )
  `open -a /Applications/Safari.app "#{url}"`
end  
