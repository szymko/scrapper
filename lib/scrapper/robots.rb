require 'pry'
require 'uri'

module Scrapper
  class Robots

    include ArrayHelper

    def initialize(*urls)
      @robots_files = {}
      get_robots(urls.flatten) unless urls.empty?
    end

    def allowed?(user_agent, url)
      uri = uri_from_url(url)
      get_robots(uri) if @robots_files[uri.host].nil?

      @robots_files[uri.host].allowed?(user_agent, url)
    end

    def get_robots(urls)
      urls = [urls] unless urls.is_a? Array
      hosts = urls.inject([]) { |hosts, u| hosts << uri_from_url(u).host }
      new_robots = get_robots_for(hosts.uniq - @robots_files.keys)

      @robots_files.merge!(new_robots)
    end

    private

    def get_robots_for(hosts)
      return {} if blank?(hosts)

      # well, for now it's only http
      robots_paths = hosts.map { |h| "http://#{h}/robots.txt" }
      robots = Request.new(robots_paths).perform

      (robots[:response] + robots[:request_error]).inject ({}) do |h, r|
        body = (r.is_a? RequestError || r.status_code != 200) ? "" : r.body
        h[r.uri.host] = RobotsParser.new(body)
        h
      end
    end

    def uri_from_url(url)
      (url.is_a? URI) ? url : URI.parse(url)
    end
  end
end