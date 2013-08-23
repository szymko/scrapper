module Scrapper
  module RobotsCore

    include UriHelper

    def has?(host)
      @files.has_key?(host)
    end

    def allowed?(opts)
      uri = uri_from_url(opts[:url])

      if @files[uri.host].nil?
        # if appropriate file is lacking it returns false by default
        opts.has_key?(:empty) ? opts[:empty] : false
      else
        @files[uri.host].allowed?(opts[:agent], uri)
      end
    end

    def raw
      raw_files = {}
      @files.each { |host, file|  raw_files[host] = file.raw }

      raw_files
    end
  end
end