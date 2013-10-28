require_relative '../test_helper'

class CrawlerTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    setup_net_stubs()
    @mock_resp = { response: mock_responses, request_error: [] }
    @mock_parsed = { urls: ["http://www.foo.bar/", "https://bar.baz/snafu"], body: "Hello kids!" }

    Scrapper::Request.any_instance.stubs(:perform).returns(@mock_resp)
    Scrapper::Parser.stubs(:parse).returns(@mock_parsed).raises(Nokogiri::XML::SyntaxError)

    @crawler = Scrapper::Crawler.new
    @crawler.get(@urls) { |u| u.to_s =~ /http.*:\/\/.*/ }
  end

  def test_it_tells_successful_from_erroneous_responses
    assert_equal mock_responses.first, @crawler.responses.first

    @crawler.scrap() { true }
    assert_equal mock_responses.last, @crawler.errors.first
  end

  def test_it_extracts_urls
    @crawler.scrap() { |u| u.to_s =~ /http.*:\/\/.*/ }
    assert_equal @crawler.urls, @mock_parsed[:urls]
  end
end
