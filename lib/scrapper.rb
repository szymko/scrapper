module Scrapper
  require 'uri'
  require 'nokogiri'

  # helpers
  require_relative './scrapper/helpers/string_helper'
  require_relative './scrapper/helpers/array_helper'
  require_relative './scrapper/helpers/uri_helper'

  # net interface
  require_relative './scrapper/request'
  require_relative './scrapper/response'
  require_relative './scrapper/parser'
  require_relative './scrapper/request_error'

  # robots
  require_relative './scrapper/robots_parser'
  require_relative './scrapper/robots_entry'
  require_relative './scrapper/robots_core'

  # robots interface
  require_relative './scrapper/robots'

  # scrapping interface
  require_relative './scrapper/runner'
end