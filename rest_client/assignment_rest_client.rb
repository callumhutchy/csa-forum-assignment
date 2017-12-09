# A simple REST client for the CSA application. Note that this
# example will only support the user accounts feature. Clearly
# the passwords should not be sent in plain text, but rather HTTPS used.
# Also the password info should go in a config file and accessed as ebvironment
# variables.
# @author Chris Loftus
require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSARestClient

  #@@DOMAIN = 'https://csa-web-service-cloftus.c9users.io'
  @@DOMAIN = 'http://localhost:3000'

  def run_menu
    loop do
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'Display Threads (Raw)'
          display_threads_raw
        when '2'
          puts 'Display Threads (Formatted)'
          display_threads_formatted
        when '3'
          puts 'Create New Thread'
          create_thread
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  def display_menu
    puts 'Enter option: '
    puts '1. Display Threads (Raw)'
    puts '2. Display Threads (Formatted)'
    puts '3. Create New Thread'
    puts 'Q. Quit'
  end

  def display_threads_raw
    begin
      response = RestClient.get "#{@@DOMAIN}/api/forum_threads.json", authorization_hash

      puts "Response code: #{response.code}"
      puts "Response cookies:\n #{response.cookies}\n\n"
      puts "Response headers:\n #{response.headers}\n\n"
     puts "Response content:\n #{response.to_str}"

     js = JSON response.body
      js.each do |item_hash|
        item_hash.each do |k, v|
          puts "#{k}: #{v}"
        end
      end

    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def display_threads_formatted
    begin
      response = RestClient.get "#{@@DOMAIN}/api/forum_threads.json", authorization_hash

      puts "Response code: #{response.code}"
      puts "Response cookies:\n #{response.cookies}\n\n"
      puts "Response headers:\n #{response.headers}\n\n"
     puts "Response content:\n #{response.to_str}"

      title = []
      author = []
      unread_posts = []
      total_posts = []

     js = JSON response.body
      js.each do |item_hash|
        item_hash.each do |k, v|
          case k
            when 'title'
              title << v
            when 'user_id'
              begin
                id = v
                response = RestClient.get "#{@@DOMAIN}/api/users/#{id}.json", authorization_hash
                js = JSON response.body
                js.each do |k2, v2|
                  case k2
                    when 'email'
                      author << v2
                    else
                      ##
                  end

                end
              rescue => e
                puts STDERR, "Error accessing REST service. Error: #{e}"
              end
            when 'unread_posts'
              unread_posts << v
            when 'total_posts'
              total_posts << v
            else
              #########
          end
        end
      end

      i = 0
      limit = title.size
      #               20                      25                  15            13              
      puts "|       Title        |          Author         | Unread Posts  | Total Posts |"
      puts "|--------------------|-------------------------|---------------|-------------|"
      while i < limit do
        puts "|#{title[i].center(title[i].size + (20 - title[i].size))}|#{author[i].center(author[i].size + (25 - author[i].size))}|#{unread_posts[i].to_s.center(unread_posts[i].size + (15 - unread_posts[i].size))}|#{total_posts[i].to_s.center(total_posts[i].size + (13 - total_posts[i].size))}|"
        puts "|--------------------|-------------------------|---------------|-------------|"
        i = i + 1
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def create_thread 
    begin
      print "Title: "
      title = STDIN.gets.chomp
      print "Body: "
      body = STDIN.gets.chomp
      
      print "Anonymous (y/N): "
      anonymous = STDIN.gets.chomp
      
      while anonymous.downcase != 'y' && anonymous.downcase != 'n' do
        print "That was incorrect input!"
        print "Anonymous (y/N): "
        anonymous = STDIN.gets.chomp
      end

      anon = 2

      if anonymous.downcase == 'y' || anonymous.downcase == 'n'
        case anonymous.downcase
        when 'y'
          anon = 1
        when 'x'
          anon = 0
        end
      end


      # Rails will reject this unless you configure the cross_forgery_request check to
      # a null_session in the receiving controller. This is because we are not sending
      # an authenticity token. Rails by default will only send the token with forms /users/new and
      # /users/1/edit and REST clients don't get those.
      # We could perhaps arrange to send this on a previous
      # request but we would then have to have an initial call (a kind of login perhaps).
      # This will automatically send as a multi-part request because we are adding a
      # File object.
      #response = RestClient.post "#{@@DOMAIN}/api/forum_threads.json", 
      # { forum_thread: { title: title, body: body, anonymous: anon}}, 
      # authorization_hash

      #response = RestClient::Request.execute(method: :post, url: "#{@@DOMAIN}/api/forum_threads.json", user: "admin", password: "taliesin",  forum_thread: { title: title, body: body, anonymous: anon} )
      #response = RestClient.post("#{@@DOMAIN}/api/forum_threads.json", forum_thread: { title: title, body: body, anonymous: anon}.to_json, authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}")
     # response = RestClient::Request.execute(method: :post, url: "#{@@DOMAIN}/api/forum_threads.json", payload: { forum_thread: { title: title, body: body, anonymous: anon}} , authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}"  )
      
      response = RestClient.post "#{@@DOMAIN}/api/forum_threads.json",
      
                                       {
                                        forum_thread: { 
                                          title: title, 
                                          body: body, 
                                          anonymous: anon
                                        }
                                           
                                       }, authorization_hash

      if (response.code == 201)
        puts "Created successfully"
      end
      puts "URL for new resource: #{response.headers[:location]}"
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end


  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}"}
  end


end

client = CSARestClient.new
client.run_menu
