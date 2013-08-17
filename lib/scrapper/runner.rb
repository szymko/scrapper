module Scrapper
  class Runner

    attr_accessor :responses, :urls, :errors, :user_agent

    def initialize(**opts)
      @async_req_no = opts[:async_no] || 10
      @user_agent = "Scrapper aka Pszemek"
    end

    def scrap(*urls, &block)
      relevant_urls = select_relevant(urls.flatten, &block)
      request = Request.new(relevant_urls, parallel: @async_req_no)

      @result = request.perform
      @responses, @errors = @result[:response], @result[:request_error]

      parse_response(&block)

      self
    end

    def parse_response(&block)
      with_error = []
      @urls = []

      @responses.each do |res|
        begin
          parsed = Scrapper::Parser.parse(res)
          @urls += select_relevant(parsed[:urls], &block)
        rescue Nokogiri::SyntaxError => nokogiri_exception
          with_error << [res, nokogiri_exception]
        end
      end

      move_erroneous_responses(with_error.transpose[0])
    end

    def select_relevant(urls, &block)
      # @robots ||= Robots.new
      # @robots.get_robots(urls)
      # urls.select { |u| @robots.allowed?(@user_agent, u) && block.call(u) }
      urls.select { |u| block.call(u) }
    end

    def move_erroneous_responses(erroneous_responses)
      unless erroneous_responses.nil? || erroneous_responses.empty?
        err_res, @responses = @responses.partition { |r| erroneous_responses.member?(r) }
        @errors += err_res
      end
    end

  end
end