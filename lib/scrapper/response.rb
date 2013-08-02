require 'uri'

module Scrapper
  Response = Struct.new(:url, :status_code, :headers, :body) do
    def initialize(url, response)
      super(url, response.response_header.status, response.response_header, response.response)
    end

    def uri
      URI.parse(url)
    end
  end
end