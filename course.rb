require 'json'

class Course

	attr_accessor :book_name,:book_img,:author_translator,:isbn,:book_code,:money
	def initialize(h)
		@attributes = [:book_name,:book_img,:author_translator,:isbn,:book_code,:money]
    h.each {|k, v| send("#{k}=",v)}
	end

	def to_hash
		@data = Hash[ @attributes.map {|d| [d.to_s, self.instance_variable_get('@'+d.to_s)]} ]
	end

	def to_json
		JSON.pretty_generate @data
	end
end
