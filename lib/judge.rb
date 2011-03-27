require 'rubygems'
require 'active_support'  

#unless defined?(ActiveSupport)
#  begin
#    $:.unshift(File.dirname(__FILE__) + "/../../activesupport/lib")  
#    require 'active_support'  
#  rescue LoadError
#    require 'rubygems'
#    gem 'activesupport'
#    require 'active_support'  
#  end
#end

require 'set'

require 'judge/errors'
require 'judge/immutable_wrapper'
require 'judge/units'
require 'judge/location/stringlist'
require 'judge/location/terrains'
require 'judge/locations'
require 'judge/location'
require 'judge/power'
require 'judge/province'
require 'judge/province_coast'
require 'judge/map'
require 'judge/map_reader'
require 'judge/movement_edge'
require 'judge/extensions'
require 'judge/game'
# vim: sts=4:sw=4:ts=4:et