require 'pry'
require 'eventmachine'
require 'em-http-request'

module Scrapper
  class Request
    class RequestError < StandardError; end

    def initialize(url_list, **opts)
      @_urls_to_visit = url_list if url_list.is_a? Array
      @_parallel = opts[:parallel] || 10
    end

    def perform
      raw_responses = raw_request
      raise RequestError, raw_responses[:errors] unless response_errors_empty?(raw_responses)
      @responses = raw_responses[:responses].inject([]) do |responses, url_response|
        responses << Response.new(url_response[0].to_s, url_response[1])
      end
    end

    def raw_request
      raw_responses = { responses: {}, errors: {}}
      @_urls_to_visit.each_slice(@_parallel) do |urls|
        raw_responses.merge(async_request(urls)) { |key, oldval, newval| oldval.merge!(newval) }
      end

      raw_responses
    end


    def async_request(urls)
      result = {}

      EventMachine.run do
        multi = EventMachine::MultiRequest.new

        urls.each_with_index { |u, id| multi.add "#{u}".to_sym, EventMachine::HttpRequest.new(u).get }

        multi.callback do
          result[:responses] = multi.responses[:callback]
          result[:errors] = multi.responses[:errback]
          EventMachine.stop
        end
      end

      result
    end

    def response_errors_empty?(response)
      response[:errors].map(&:to_a).flatten.empty?
    end

  end
end