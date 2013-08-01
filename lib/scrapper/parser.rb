require 'nokogiri'

module Scrapper
  class Parser

    attr_accessor :parsed_body, :urls, :relevant_url_pattern

    def parse(body, &block)
      @parsed_body = Nokogiri.parse(body)
      @urls = extract_urls
      delete_irrelevant(&block)

      self
    end

    def extract_urls
      @parsed_body.css('a').map do |link|
        link.attribute('href').to_s
      end
    end

    def delete_irrelevant
      @urls.select! { |u| yield(u) }
    end

  end
end