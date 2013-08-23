module Scrapper
  Response = Struct.new(:url, :status_code, :headers, :body) do

    include UriHelper

    def initialize(url, response)
      super(url, response.response_header.status, response.response_header, response.response)
      @optional = {}
    end

    def uri
      @uri ||= uri_from_url(url)
      @uri
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