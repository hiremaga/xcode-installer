#!/usr/bin/env ruby

require 'security'
require 'mechanize'

adc_login_url = 'https://daw.apple.com/cgi-bin/WebObjects/DSAuthWeb.woa/wa/login?appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2F%2Fdownloads%2Findex.action'
downloads_url = 'https://developer.apple.com/downloads/index.action'
#xcode_url = 'http://adcdownload.apple.com/Developer_Tools/xcode_4.6.2/xcode4620419895a.dmg'
xcode_url = 'https://developer.apple.com/downloads/download.action?path=Developer_Tools/xcode_4.6.2/xcode4620419895a.dmg'

HOST = "developer.apple.com"
pw = Security::InternetPassword.find(:server => HOST)
username, password = pw.attributes['acct'], pw.password if pw

begin
  agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari'}

  # Request login response
  puts "\n>>> Login response >>>"
  response = agent.get(adc_login_url)
  puts "status code: #{response.code}\n"
  pp response
  puts agent.cookie_jar.jar

  # Submit login form
  puts "\n>>> Submit Login Form >>>"
  form = response.form_with(:name => 'appleConnectForm')
  form.theAccountName = username
  form.theAccountPW = password
  response = form.submit
  puts "status code: #{response.code}\n"
  pp response
  puts agent.cookie_jar.jar

  # Request downloads response
  puts "\n>>> Downloads >>>"
  response = agent.get(downloads_url)
  puts "status code: #{response.code}\n"
  pp response
  puts agent.cookie_jar.jar

  # Download
  puts "\n>>> Xcode >>>"

  # HEAD request for testing
  response = agent.head(xcode_url)
  puts "status code: #{response.code}\n"
  pp response

  # GET request for actual download
  # agent.pluggable_parser.default = Mechanize::Download
  # file = agent.get(xcode_url)
  # file.save
  # puts file.filename

rescue Mechanize::ResponseCodeError => exception
  if exception.response_code == '403'
    response = exception.page
    puts "status code: #{response.code}\n"
    pp response
    puts agent.cookie_jar.jar
  else
    raise # Some other error, re-raise
  end
end
