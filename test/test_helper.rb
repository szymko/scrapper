require 'minitest/spec'
require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/setup'

require_relative '../lib/scrapper'
require_relative '../lib/robots'
require_relative './mock'

module TestHelper
  def setup_net_stubs
    @urls = ["http://www.google.pl/", "http://foo.bar.com"]
    stub_request(:any, @urls[0])
      .to_return(:body => "hello", :status => 200)

    stub_request(:any, @urls[1])
      .to_return(:body => "Not Found", :status => 404)

    WebMock.disable_net_connect!
  end

  def open_robots_file(file_path = './test/files/robots.txt')
    File.new(file_path, 'r').to_s
  end

  def mock_responses
    r1 =  Mock::NetResponse.new(status_code: 200, response: "hello")
    r2 =  Mock::NetResponse.new(status_code: 404, response: "Not Found")
    [Scrapper::Response.new(@urls[0], r1), Scrapper::Response.new(@urls[1], r2)]
  end
end