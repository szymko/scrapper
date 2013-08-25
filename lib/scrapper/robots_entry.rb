module Scrapper
  class RobotsEntry

    include ArrayHelper
    include UriHelper

    def initialize(robots_section)
      @allow = []
      @disallow = []
      parse(robots_section)
    end

    def allowed?(url)
      uri_path = uri_from_url(url).path

      if !@allow.empty?
      # binding.pry
        @allow.find { |u| uri_path =~ Regexp.compile(escape_regule(u)) } ? true : false
      else
        @disallow.find { |u| uri_path =~ Regexp.compile(escape_regule(u)) } ? false : true
      end
    end

    def user_agent_similarity(agent_string)
      regexp_agent = Regexp.compile("\\A#{@user_agent.gsub('*', '.*')}\\z")
      (agent_string =~ regexp_agent) ? @user_agent.gsub(/\*/, '').length : 0
    end

    private

    def parse(section)
      raise ArgumentError unless section.is_a? String

      transformed_section = section.strip.split(/\n/).map(&:strip)
      @user_agent = transformed_section[0].split.last.gsub(/\s+/, '')
      transformed_section[1..-1].each { |r| parse_regule(r) }
    end

    def parse_regule(regule)
      split_regule = regule.split

      return if !split_regule || split_regule.compact.empty?

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

      rule = parts.join('[^\/]+')
      regex_template(rule)
    end

    def regex_template(rule)
      if rule[-1,1] == "/"
        "\\A#{rule}"
      else
        "\\A#{rule}\\z"
      end
    end
  end
end