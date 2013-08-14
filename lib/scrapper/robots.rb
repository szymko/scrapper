require 'pry'
require 'uri'
require 'open-uri'

module Scrapper
  class Robots
    def initialize(*urls)
      @robots_files = {}
      get_robots(urls.flatten) unless urls.empty?
    end

    def allowed?(user_agent, url)
      # binding.pry
      uri = URI.parse(url.to_s)
      get_robots_for(uri) if @robots_files[uri.host].nil?

      @robots_files[uri.host].allowed?(user_agent, url)
    end

    def get_robots(urls)
      urls.each do |u|
        uri = URI.parse(u.to_s)
        get_robots_for(uri) unless @robots_files.has_key?(uri.host)
      end
    end

    private

    def get_robots_for(uri)
      host_url = "#{uri.scheme}://#{uri.host}/robots.txt"
      robots_file = open(host_url).read
      @robots_files[uri.host] = RobotsParser.new(robots_file)
    rescue OpenURI::HTTPError => e
      # no robots, everything allowed
      @robots_files[uri.host] = ""
    end
  end
end