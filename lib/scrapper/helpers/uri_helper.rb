module Scrapper
  module UriHelper
    def uri_from_url(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end