require_relative '../test_helper'

class ResponseTest < MiniTest::Unit::TestCase

  def setup
    @net_res = Mock::NetResponse.new
    @url = "http://google.pl/?q=Justin%20Bieber"
  end

  def test_it_initializes_correctly
    response = Scrapper::Response.new(@url, @net_res)

    assert_equal response.url, @url
    assert_equal response.status_code, @net_res.response_header.status
    assert_equal response.headers, @net_res.response_header
    assert_equal response.body, @net_res.response
  end

  def test_it_tests_equality
    other_net_res = Mock::NetResponse.new(status_code: 302)
    url2 = "http://www.onet.pl/"

    r1 = Scrapper::Response.new(@url, @net_res)
    r2 = Scrapper::Response.new(@url, other_net_res)
    r3 = Scrapper::Response.new(url2, @net_res)

    assert_equal r1, r2
    assert !(r1 == r3)
  end

end