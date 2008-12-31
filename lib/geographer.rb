require File.dirname(__FILE__) + '/geographer/header'
require File.dirname(__FILE__) + '/geographer/icon'
require File.dirname(__FILE__) + '/geographer/map'
require File.dirname(__FILE__) + '/geographer/marker'
require File.dirname(__FILE__) + '/geographer/polyline'
require File.dirname(__FILE__) + '/geographer/geographer_helper'

ActionView::Base.send :include, GeographerHelper