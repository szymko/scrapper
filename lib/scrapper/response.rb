require 'uri'

module Scrapper
  Response = Struct.new(:url, :status_code, :body) do
    def initialize(url, response)
      super(url, response.response_header.status, response.response)
    end

    def uri
      URI.parse(url)
    end
  end
end