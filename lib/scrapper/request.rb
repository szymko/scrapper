require 'eventmachine'
require 'em-http-request'

module Scrapper
  class Request

    include Scrapper::StringHelper

    def initialize(url_list, **opts)
      @urls_to_visit = url_list if url_list.is_a? Array
      @parallel = opts[:parallel] || 10
    end

    def perform
      raw_responses = raw_request

      response = {}
      raw_responses.each do |key, value|
        response[key] = value.inject([]) do |data, url_data|
          data << Scrapper.const_get(camel_case(key.to_s)).new(url_data[0].to_s, url_data[1])
        end
      end

      response
    end

    def raw_request
      raw_responses = { response: {}, request_error: {}}
      @urls_to_visit.each_slice(@parallel) do |urls|
        raw_responses.merge(async_request(urls)) { |key, oldval, newval| oldval.merge!(newval) }
      end

      raw_responses
    end

    def async_request(urls)
      result = {}

      EventMachine.run do
        multi = EventMachine::MultiRequest.new

        urls.uniq.each_with_index { |u, id| multi.add "#{u}".to_sym, EventMachine::HttpRequest.new(u).get }

        multi.callback do
          result[:response] = multi.responses[:callback]
          result[:error] = multi.responses[:errback]
          EventMachine.stop
        end
      end

      result
    end
  end
end