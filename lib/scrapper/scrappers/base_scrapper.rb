module Scrapper
  class BaseScrapper

    def initialize(async_req_no = 10)
      @async_req_no = async_req_no
    end

    def scrap(*urls)
      request = Request.new(select_relevant(urls.flatten), parallel: @async_req_no)
      result = request.perform

      @responses = result[:response]
      @errors = result[:request_error]
      @urls = []

      parse_response
      normalize_urls

      self
    end

    def parse_response
      with_error = []

      @responses.each do |res|
        begin
          parsed = Scrapper::Parser.parse(res.body) { |u| is_relevant?(u) }
          @urls += parsed[:urls]
        rescue Nokogiri::SyntaxError => nokogiri_exception
          with_error << [res, nokogiri_exception]
        end
      end

      move_erroneous_responses(with_error.transpose[0])
    end

    def select_relevant(urls)
      urls.select { |u| is_relevant?(u) }
    end

    def is_relevant?(u)
      raise NotImplementedError
    end

    def move_erroneous_responses(erroneous_responses)
      unless erroneous_responses.nil? || erroneous_responses.empty?
        err_res, @responses = @responses.partition { |r| erroneous_responses.member?(r) }
        @errors += err_res
      end
    end

    def normalize_urls
    end

  end
end