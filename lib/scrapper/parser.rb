module Scrapper
  module Parser

    def self.parse(response)
      parsed = {}

      parsed[:body] = Nokogiri.parse(response.body)
      parsed[:urls] = extract_urls(response.url, parsed[:body])

      parsed
    end

    def self.extract_urls(url, body)
      base = body.css('base').first
      root_url = base.nil? ? url : base.attribute('href').to_s
      urls = body.css('a').map { |link| convert_to_absolute(root_url, link.attribute('href').to_s) }
      urls.reject { |u| u == "" }
    end

    def self.convert_to_absolute(page_url, href)
      URI.join(page_url, href).to_s
    rescue URI::InvalidURIError => e
      ""
    end

  end
end