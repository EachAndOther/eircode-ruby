require_relative "eircode/version"
require 'faraday'
require 'json'


SEARCH_URL = "https://finder-api.eircode.ie/api/autocomplete/en?key=874d0fd8-d94a-418a-8089-5d901019f88c&addressline="

module Eircode

  class Address
  	def self.search(query)
  		response = Faraday.get("#{SEARCH_URL}#{query}")
      	result_hash = JSON.parse(response.body)
      	results = Results.new(result_hash)
      	return results
  	end
  end

  class Results

  	attr_accessor :total_matches
  	attr_accessor :addresses

  	def initialize(result_hash)
  		@total_matches = result_hash["totalMatches"]
  		addresses = result_hash["addresses"]
  		if addresses.nil?
  			@addresses = nil
  		else
  			@addresses = []
  			addresses.each do |a|
  				address = Address.new(a)
  				@addresses << address;
  			end
  		end
  	end
  end

  class Address
  	attr_accessor :id
  	attr_accessor :address
  	attr_accessor :unique
  	
  	def initialize(address_hash)
  		@id = address_hash['id']
  		@address = address_hash['address']
  		@unique = address_hash['unique']
  	end
  end

end
