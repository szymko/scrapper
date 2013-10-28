module Scrapper
  class Crawler

    include Scrapper::ArrayHelper

    attr_accessor :responses, :urls, :errors, :user_agent

    def initialize(async: 10, user_agent: "Scrapper aka Pszemek")
      @async = async
      @user_agent = user_agent
    end

    def get(*urls)
      request = Request.new(urls, parallel: @async)
      result = request.perform()
      @responses, @errors = result[:response], result[:request_error]
    end

    def scrap(&block)
      result = { urls: [], errors: [] }

      @responses.each do |r|
        result.merge!(parse(r, &block)) { |key, oldv, newv| oldv.concat(newv) }
      end

      move_errors(result[:errors])
      @urls = result[:urls].flatten
    end

    private

    def parse(response, &block)
      parsed = Scrapper::Parser.parse(response)
      { urls: select_urls(parsed[:urls], &block), errors: []  }
    rescue Nokogiri::SyntaxError => error
      { urls: [], errors: [response] }
    end

    def select_urls(urls, &block)
      urls.select { |u| block.call(u) }
    end

    def move_errors(errors)
      return if blank?(errors)
      err_res, @responses = @responses.partition { |r| errors.member?(r) }
      @errors += err_res
    end
  end
end
