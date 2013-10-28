require 'eventmachine'
require 'em-http-request'

module Scrapper
  class Request

    include StringHelper

    def initialize(*url_list, **opts)
      @urls = *url_list.flatten
      @parallel = opts[:parallel] || 10
    end

    def perform()
      result = get()
      responses = {}

      result.each do |klass, body|
        responses[klass] = body.inject([]) do |data, url_data|
          data << Scrapper.const_get(camel_case(klass.to_s)).new(url_data[0].to_s, url_data[1])
        end
      end

      responses
    end

    private

    def get()
      responses = { response: {}, request_error: {}}
      @urls.each_slice(@parallel) do |urls|
        responses.merge(get_async(urls)) { |key, oldval, newval| oldval.merge!(newval) }
      end

      responses
    end

    def get_async(urls)
      result = {}

      EventMachine.run do
        multi = EventMachine::MultiRequest.new

        urls.uniq.each_with_index { |u, id| multi.add "#{u}".to_sym, EventMachine::HttpRequest.new(u).get }

        multi.callback do
          result[:response] = multi.responses[:callback]
          result[:request_error] = multi.responses[:errback]
          EventMachine.stop
        end
      end

      result
    end
  end
end
