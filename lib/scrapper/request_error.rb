require 'uri'

module Scrapper
  RequestError = Struct.new(:url, :details) do
    def uri
      URI.parse(url)
    end
  end
end