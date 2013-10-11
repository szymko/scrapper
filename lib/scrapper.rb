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

  # scrapping interface
  require_relative './scrapper/runner'
end