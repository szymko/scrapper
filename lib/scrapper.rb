module Scrapper
  require_relative './scrapper/helpers/string_helper.rb'
  require_relative './scrapper/request.rb'
  require_relative './scrapper/response.rb'
  require_relative './scrapper/parser.rb'
  require_relative './scrapper/request_error.rb'
  require_relative './scrapper/scrappers/base_scrapper.rb'
  require_relative './scrapper/scrappers/wikipedia_scrapper.rb'
end