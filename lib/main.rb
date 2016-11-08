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

require 'scraperwiki'
require 'capybara'
# require 'capybara/poltergeist'
require 'selenium/webdriver'

# My own class files... 
# require './downloads'
require './filegrabber'

$debug = TRUE
$csvoutput = FALSE
$sqloutput = FALSE

class XML_download_helper

  def download_xml_files ( toc_xml_filename )

    browser = FileGrabber.new

    browser.download_file ( toc_xml_filename )

    # xmlReader = XMLHandler.new

    # xmlReader.getFragmentFilenames ( toc_xml_filename ) do 
    #  |fragmentName|
    #   browser.download ( fragmentName )
    # end

  end


end

downloader = XML_download_helper.new

downloader.download_xml_files("HANSARD-10-17452")

