#
#  Scraper to download Hansard transcript xml files
# 
# In order to facilitate automatically downloading each day's hansard
# without having to manually download and save each day
# 
# This version of code hacked together by Alison Keen Oct/Nov 2016
# 
# Credit where Credit is due: 
# Lots of help from OpenAustralia people, especially @henare and @wfdd
# How to use capybara/selenium to download attachments: 
# http://collectiveidea.com/blog/archives/2012/01/27/testing-file-downloads-with-capybara-and-chromedriver/
#

# Stuck. 
# 
# Sticking point #1, the collectiveidea.com example includes the helper
# class but doesn't show how to actually use it
# 
# Sticking point #2, I don't know enough Ruby to know if I have
# defined XMLFileGrabber as a static class or an instantiable one
# 
# Therefore I can't work out how to create a function that will
# do the work of loading a URL and catching the downloaded file. 
# 

require 'scraperwiki'
require 'capybara'
# require 'capybara/poltergeist'
require 'selenium/webdriver'
require './downloads'

# From own server it sends the file as content-type text/xml, 
# pipe_download_url = "http://sa.pipeproject.info/xmldata/upper/HANSARD-10-17452.xml"


$debug = TRUE
$csvoutput = FALSE
$sqloutput = FALSE


class FileGrabber 

# from Hansard server content-type is text/html, attachment is xml
#  @xml_download_url = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d=HANSARD-10-17452"


  def initialize 

  @xml_download_url = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d="

  @fragment_download_url = "https://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=fragment&d=HANSARD-11-24737"

  @user_agent_string = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36"

    Capybara.register_driver :chrome do |app|
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: DownloadHelpers::PATH.to_s
        }
      }

      profile = Selenium::WebDriver::Chrome::Profile.new
      profile["download.default_directory"] = DownloadHelpers::PATH.to_s
      @driver = Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)

#      Capybara.default_driver = Capybara.javascript_driver = :chrome

    end

 #   @session = Capybara::Session.new(:chrome)

#    Need to fake a 'browser' UA string not a 'bot' UA string
#    @session.driver.headers = { "User-Agent" => @user_agent_string }
  end

  def download_file ( toc_filename ) 

    # compile download link
    url = @xml_download_url + toc_filename
    # Read in the page
    puts "Attemted download: " + url

    @driver.navigate.to url

    DownloadHelpers::download_content
    DownloadHelpers::wait_for_download

    yield(@session)
  end


end

