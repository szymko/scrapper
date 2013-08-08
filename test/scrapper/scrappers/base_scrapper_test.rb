require_relative '../../test_helper'

class BaseScrapperTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @base_scrapper = Scrapper::BaseScrapper.new
    @base_scrapper.stubs(:is_relevant?).returns(true)
    setup_net_stubs

    @mock_resp = { response: mock_responses, request_error: [] }
    @mock_parsed = { urls: ["http://www.foo.bar/", "https://bar.baz/snafu"], body: "Hello kids!" }
    
    Scrapper::Request.any_instance.stubs(:perform).returns(@mock_resp)
    Scrapper::Parser.stubs(:parse).returns(@mock_parsed).raises(Nokogiri::XML::SyntaxError)
  end

  def test_it_tells_successful_from_erroneous_responses
    @base_scrapper.scrap(@urls)

    assert_equal @base_scrapper.instance_variable_get(:@responses).first, mock_responses.first
    assert_equal @base_scrapper.instance_variable_get(:@errors).first, mock_responses.last
  end

  def test_it_extracts_urls
    @base_scrapper.scrap(@urls)
    assert_equal @base_scrapper.instance_variable_get(:@urls), @mock_parsed[:urls]
  end
end