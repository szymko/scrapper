module Scrapper
  class BaseScrapper

    def scrap(*urls)
      request = Request.new(select_relevant(urls.flatten))
      @parser = Parser.new

      result = request.perform
      @responses = result[:response]
      @errors = result[:request_error]
      @urls = scrap_urls
      normalize_urls

      self
    end

    def scrap_urls
      @responses.inject([]) do |urls, res|
        urls << @parser.parse(res.body) { |u| is_relevant?(u) }.urls
        urls.flatten!
      end
    end

    def select_relevant(urls)
      urls.select { |u| is_relevant?(u) }
    end

    def is_relevant?(u)
      raise NotImplementedError
    end

    def normalize_urls
    end

  end
end