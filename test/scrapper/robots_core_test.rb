# require_relative '../test_helper'

# class RobotsCoreTest < MiniTest::Unit::TestCase

#   include Scrapper::RobotsCore

#   def setup
#     @files = {
#       "en.wikipedia.org" => Scrapper::RobotsParser.new("know"),
#       "www.google.pl" => Scrapper::RobotsParser.new("ledge")
#     }

#     Scrapper::RobotsParser.any_instance.stubs(:allowed?).returns(true, false)
#   end

#   def test_it_checks_for_hosts_presence
#     assert has?("www.google.pl")
#     refute has?("my.little.pony")
#   end

#   def test_it_checks_if_url_is_allowed
#     assert allowed?(url: "http://en.wikipedia.org/wiki/Main_Page/", agent: "Mariusz")
#     refute allowed?(url: "https://www.google.pl/", agent: "Pszemek")

#     # Check for nonexistent entries.
#     assert allowed?(url: "http://www.stronapszemka.pl/", agent: "Marian", empty: true)
#     refute allowed?(url: "http://www.growthrepublic.com", agent: "Artur", empty: false)

#     # default
#     refute allowed?(url: "https://nsa.spying.programme/", agent: "Max")
#   end

#   def test_it_retrieves_raw_files
#     assert_equal ["en.wikipedia.org", "www.google.pl"], raw.keys
#     assert_equal ["know", "ledge"], raw.values
#   end

#   def test_it_parses_raw_files
#     Scrapper::RobotsParser.any_instance.stubs(:parsed?).returns(true, false)
#     @files["en.wikipedia.org"].expects(:parse).never
#     @files["www.google.pl"].expects(:parse)

#     parse
#   end
# end