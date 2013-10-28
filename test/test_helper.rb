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

    stub_request(:get, "#{@urls[0]}robots.txt")
      .to_return(:status => 200, :body => "hello")

    stub_request(:get, "#{@urls[1]}/robots.txt")
      .to_return(:status => 404, :body => "")

    WebMock.disable_net_connect!
  end

  def open_file(file_name = 'robots.txt')
    File.new("./test/files/#{file_name}", "r").read
  end

  def mock_responses
    r1 =  Mock::NetResponse.new(status_code: 200, response: "hello")
    r2 =  Mock::NetResponse.new(status_code: 404, response: "Not Found")
    [Scrapper::Response.new(@urls[0], r1), Scrapper::Response.new(@urls[1], r2)]
  end
end
