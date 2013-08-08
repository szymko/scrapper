module Scrapper
  class WikipediaScrapper < BaseScrapper

    attr_reader :responses, :urls, :errors

    def is_relevant?(u)
      u.to_s =~ /http:\/\/en.wikipedia.org\/wiki\/.*/ || u.to_s =~ /\A\/wiki.*/
    end

    def normalize_urls
      @host ||= "http://en.wikipedia.org"
      urls.map! do |url|
        url.match(@host) ? url.to_s : @host.to_s + url.to_s
      end
    end

    def urls
      @urls
    end

  end
end