module Scrapper
  RequestError = Struct.new(:url, :details) do

    include UriHelper

    def uri
      @uri ||= uri_from_url(url)
      @uri
    end
  end
end