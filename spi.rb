require 'rest_client'
require 'nokogiri'
require 'json'
require 'iconv'
require 'uri'
require_relative 'course.rb'
# 難得寫註解，總該碎碎念。
class Spider
  attr_reader :semester_list, :courses_list, :query_url, :result_url

  def initialize
  	@query_url = "http://www.yehyeh.com.tw/books.aspx"
  	@result_url = "https://sea.cc.ntpu.edu.tw/pls/dev_stud/course_query_all.queryByKeyword"
  end

  def prepare_post_data
    r = RestClient.get @query_url
    query_page = Nokogiri::HTML(r.to_s)

    puts "post data preparing......."
    # 撈第一次資料，拿到 hidden 的表單驗證。 
    @__VIEWSTATE = query_page.css('#__VIEWSTATE')[0]['value']
    @__EVENTVALIDATION = query_page.css('#__EVENTVALIDATION')[0]['value']
    @ctl00_HiddenMenuSysID = 'books'
    @a = '120504'
    @PageNow = 1
    @SysMainID = 'books'
    @mode = 'dblist'
    puts "Post data get from yeh yeh:\n"
    puts @ctl00_HiddenMenuSysID 

    nil
  end

  def get_courses(sem = 0)
  	# 初始 courses 陣列
    @courses = []
    puts "getting courses\n"
    # 把表單驗證，還有要送出的資料弄成一包 hash
    post_data = {
      # 看是第幾學年度，預設用最新的
      :__VIEWSTATE => @__VIEWSTATE,
      :__EVENTVALIDATION => @__EVENTVALIDATION,
      :'ctl00$HiddenMenuSysID' => @ctl00_HiddenMenuSysID,
      :a => @a,
      :PageNow => @PageNow,
      :SysMainID => @SysMainID,
      :mode => @mode
    }

		# 先 post 一下，讓 server 知道你送出查詢(以及一些用不到 Google 來的 exception handling)
    puts "posting data...."
    # 回圈這邊進去 1 => post, else get
    puts "loading Courses List..."
    92.times {
      r = RestClient.post( query_url, post_data)

      puts "page #{post_data[:PageNow]}"
      # r = RestClient.get( "https://sea.cc.ntpu.edu.tw/pls/dev_stud/course_query_all.queryByKeyword", :cookies => @cookies )
      ic = Iconv.new("utf-8//translit//IGNORE","utf-8")
      @courses_list = Nokogiri::HTML(ic.iconv(r.to_s))

      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks18').css('td')[10].text
      
      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash

      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks20').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks22').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash

      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks29').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks31').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks33').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash

      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks40').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks42').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks44').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash

      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks51').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53')
      book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('a').first.text
      book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('a').last.css('img')
      author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('td')[4].text
      isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('td')[6].text
      book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('td')[8].text
      money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks53').css('td')[10].text

      @courses << Course.new({
        "book_name" => book_name,
        "book_img" => book_img,
        "author_translator" => author_translator,
        "isbn" => isbn,
        "book_code" => book_code, 
        "money" => money
        }).to_hash
      if post_data[:PageNow] != 92
        # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55')
        book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('a').first.text
        book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('a').last.css('img')
        author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('td')[4].text
        isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('td')[6].text
        book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('td')[8].text
        money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks55').css('td')[10].text

        @courses << Course.new({
          "book_name" => book_name,
          "book_img" => book_img,
          "author_translator" => author_translator,
          "isbn" => isbn,
          "book_code" => book_code, 
          "money" => money
          }).to_hash

        # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62')
        book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('a').first.text
        book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('a').last.css('img')
        author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('td')[4].text
        isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('td')[6].text
        book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('td')[8].text
        money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks62').css('td')[10].text

        @courses << Course.new({
          "book_name" => book_name,
          "book_img" => book_img,
          "author_translator" => author_translator,
          "isbn" => isbn,
          "book_code" => book_code, 
          "money" => money
          }).to_hash
        # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64')
        book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('a').first.text
        book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('a').last.css('img')
        author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('td')[4].text
        isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('td')[6].text
        book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('td')[8].text
        money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks64').css('td')[10].text

        @courses << Course.new({
          "book_name" => book_name,
          "book_img" => book_img,
          "author_translator" => author_translator,
          "isbn" => isbn,
          "book_code" => book_code, 
          "money" => money
          }).to_hash
        # puts @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66')
        book_name = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('a').first.text
        book_img = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('a').last.css('img')
        author_translator = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('td')[4].text
        isbn = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('td')[6].text
        book_code = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('td')[8].text
        money = @courses_list.css('#ctl00_ContentPlaceHolder1_MSTableCellbooks66').css('td')[10].text

        @courses << Course.new({
          "book_name" => book_name,
          "book_img" => book_img,
          "author_translator" => author_translator,
          "isbn" => isbn,
          "book_code" => book_code, 
          "money" => money
          }).to_hash
        # get next page
        post_data[:PageNow] += 1
      end
    }

    def save_to(filename='courses.json')
	    File.open(filename, 'w') {|f| f.write(JSON.pretty_generate(@courses))}
	  end
    
  end




end

spider = Spider.new
spider.prepare_post_data
spider.get_courses
spider.save_to
