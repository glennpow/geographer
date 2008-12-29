require 'xmlrpc/client'

module Geographer
  class Geocoder
    def self.geocode(query)
      server = XMLRPC::Client.new2('http://rpc.geocoder.us/service/xmlrpc') 
      result = server.call2('geocode', query)
      return (result && result[0]) ? result[1].map(&:symbolize_keys) : []
    end
  end
end