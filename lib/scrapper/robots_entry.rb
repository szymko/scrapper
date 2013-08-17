require 'uri'

module Scrapper
  class RobotsEntry

    include ArrayHelper

    def initialize(robots_section)
      @allow = []
      @disallow = []
      parse(robots_section)
    end

    def allowed?(url)
      uri_path = URI.parse(url).path

      if !@allow.empty?
        @allow.find { |u| uri_path =~ Regexp.compile(escape_regule(u)) } ? true : false
      else
        @disallow.find { |u| uri_path =~ Regexp.compile(escape_regule(u)) } ? false : true
      end
    end

    def user_agent_similarity(agent_string)
      regexp_agent = Regexp.compile(@user_agent.gsub('*', '.'))
      (agent_string =~ regexp_agent) ? @user_agent.length : 0
    end

    private

    def parse(section)
      raise ArgumentError unless section.is_a? String

      transformed_section = section.strip.split(/\n/).map(&:strip)
      @user_agent = transformed_section[0]
      transformed_section[1..-1].each { |r| parse_regule(r) }
    end

    def parse_regule(regule)
      split_regule = regule.split

      case split_regule.first.gsub(/\W+/, '')
      when "Allow"
        @allow << split_regule.last
      when "Disallow"
        @disallow << split_regule.last
      end
    end

    def escape_regule(u)
      parts = u.split('*')
      parts.map! { |p| Regexp.escape(p) }
      parts.join('.*')
    end
  end
end