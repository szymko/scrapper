require 'uri'

module Scrapper
  Error = Struct.new(:url, :details) do
    def uri
      URI.parse(url)
    end
  end
end