require 'nokogiri'

module Scrapper
  module Parser

    def self.parse(body, &block)
      parsed = {}

      parsed[:body] = Nokogiri.parse(body)
      parsed[:urls] = extract_urls(parsed[:body])
      delete_irrelevant(parsed[:urls], &block)

      parsed
    end

    def self.extract_urls(body)
      body.css('a').map do |link|
        link.attribute('href').to_s
      end
    end

    def self.delete_irrelevant(urls)
      urls.select! { |u| yield(u) }
    end

  end
end