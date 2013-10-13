# require_relative '../test_helper'

# class RobotsParserTest < MiniTest::Unit::TestCase

#   def setup
#     @robots_file = <<-ROBOTS
#       #comment
#       User-agent: Mariusz
#       #
#       Disallow: /hidden
#       #

#       User-agent: *
#       Allow: /
#     ROBOTS

#     @robots_parser = Scrapper::RobotsParser.new(@robots_file).parse
#   end

#   def test_it_allows_urls_according_to_robots_txt
#     agent1 = "Mariusz"
#     agent2 = "Pszemek"

#     assert @robots_parser.allowed?(agent1, "/")
#     refute @robots_parser.allowed?(agent1, "/hidden")
#     assert @robots_parser.allowed?(agent2, "/hidden")
#   end

#   def test_it_records_parsing
#     another_parser = Scrapper::RobotsParser.new(@robots_file)

#     assert @robots_parser.parsed?
#     refute another_parser.parsed?
#   end

# end