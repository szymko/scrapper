module Scrapper
  class Robots

    include RobotsCore
    include ArrayHelper
    include UriHelper

    def initialize
      @files = {}
    end

    # Parse robots from hash without hitting the network.
    def build(host_file_hash)
      @files = {}
      add(host_file_hash)
    end

    def add(host_file_hash)
      raise ArgumentError unless host_file_hash.is_a?(Hash)
      add_from_hash(host_file_hash)
      self
    end

    # Hit the network and parse.
    def get(*urls)
      get_robots(urls.flatten.uniq)
      self
    end

    def get_raw(*urls)
      get_robots_for(urls.flatten.uniq)
      self
    end

    def get_robots(urls)
      urls = [urls] unless urls.is_a? Array
      hosts = urls.inject([]) { |hosts, u| hosts << uri_from_url(u).host }
      new_robots = get_robots_for(hosts.uniq - @files.keys) { |b| RobotsParser.new(b).parse }

      @files.merge!(new_robots)
    end

    private

    def add_from_hash(host_file_hash)
      (host_file_hash.keys - @files.keys).each do |host|
        next if blank?(host)
        @files[host] = RobotsParser.new(host_file_hash[host]).parse
      end
    end

    def get_robots_for(hosts)
      robots = build_robots_request(hosts)

      (robots[:response] + robots[:request_error]).inject ({}) do |h, r|
        body = (r.is_a? RequestError || r.status_code != 200) ? "" : r.body
        h[r.uri.host] = (block_given? ? yield(body) : body)
        h
      end
    end

    def build_robots_request(hosts)
      return {} if blank?(hosts)

      # well, for now it's only http
      robots_paths = hosts.map { |h| "http://#{h}/robots.txt" }
      Request.new(robots_paths).perform
    end
  end
end