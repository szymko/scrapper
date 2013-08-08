require 'uri'

module Scrapper
  Response = Struct.new(:url, :status_code, :headers, :body) do
    def initialize(url, response)
      super(url, response.response_header.status, response.response_header, response.response)
      @optional = {}
    end

    def uri
      URI.parse(url)
    end

    def ==(o)
      self.url == o.url
    end

    def optional(key)
      @optional [key]
    end

    def add_optional(key, value)
      @optional[key] = value
    end
  end
end