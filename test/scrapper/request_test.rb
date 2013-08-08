require_relative '../test_helper'

class RequestTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    setup_net_stubs
  end

  def test_it_performs_request
    req = Scrapper::Request.new(@urls)
    responses = req.perform

    assert_kind_of Scrapper::Response, responses[:response].first
    assert_equal responses[:response], mock_responses
  end
end