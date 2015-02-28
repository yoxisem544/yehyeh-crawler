require 'capybara'
require 'nokogiri'
require 'json'
require 'iconv'
require 'uri'
require 'pry'
require 'rest_client'

class Spider
	include Capybara::DSL
	def initialize
		Capybara.default_driver = :selenium
		@query_url = 'http://www.yehyeh.com.tw/books.aspx?a=194940&pgenow=0&sysmainid=books&x=&mode=dblist'
		@front_url = 'http://www.yehyeh.com.tw'
		@books = []
	end

	def link
		92.times do |times|
			if times == 0
				visit @query_url
			elsif times == 1
				page.find(:xpath, '//*[@id="ctl00_ContentPlaceHolder1_MSTableCellbooks72"]/p/input[3]').click
			else
				page.find(:xpath, '//*[@id="ctl00_ContentPlaceHolder1_MSTableCellbooks72"]/p/input[4]').click
			end
					
			n = Nokogiri::HTML(html)

			hey = n.css('div.dbimg_list_title a').map {|a| a['href']}

			hey.each do |link|
				r = RestClient.get @front_url + link
				ic = Iconv.new("utf-8//translit//IGNORE","utf-8")
				detail = Nokogiri::HTML(ic.iconv(r.to_s))

				book_name = detail.css('h1').text
				author = detail.css('h2').text.split('：').last
				isbn = detail.css('li nobr').text.split('：').last
				year = detail.css('div.db_view td:nth-of-type(1) li:nth-of-type(2)').text.split('：').last
				book_code = detail.css('div.db_view li:nth-of-type(3)').text.split('：').last
				pages = detail.css('div.db_view li:nth-of-type(5)').text.split('：').last
				price = detail.css('div.db_view li:nth-of-type(6)').text.split('：').last

				@books << {
					book_name: book_name,
					author: author,
					isbn: isbn,
					year: year,
					book_code: book_code,
					pages: pages,
					price: price
				}
				puts book_name
			end
		end

		def save
			File.open('books_hi.json', 'w'){|f| f.write(JSON.pretty_generate(@books))}
		end
	end

end

s = Spider.new
s.link
s.save