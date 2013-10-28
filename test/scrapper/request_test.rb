require_relative '../test_helper'

class RequestTest < MiniTest::Unit::TestCase

  include TestHelper

  def test_it_performs_request()
    setup_net_stubs()
    req = Scrapper::Request.new(@urls)
    responses = req.perform()

    assert_kind_of Scrapper::Response, responses[:response].first
    assert_equal responses[:response], mock_responses
  end

  def test_it_recognizes_error_respones
    setup_timeout_request()
    req = Scrapper::Request.new(@timeout_url)
    responses = req.perform()

    assert_kind_of Scrapper::RequestError, responses[:request_error].first
  end
end
