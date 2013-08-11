require 'uri'

module Scrapper
  class RobotsParser

    GROUP_NAMES = ["Allow", "Disallow"]

    def initialize(robots_file)
      @robots_file = robots_file
      parse
    end

    def allowed?(user_agent, url)
      uri_path = URI.parse(url).path

      agents_url = @user_agents.select do |key, value|
        regexp_key = Regexp.compile(key.gsub('*', '.'))
        user_agent =~ regexp_key
      end

      best_match_groups = choose_longest_match(agents_url)
      # check if given path is allowed
      best_match_groups.nil? ? true : allowed_url?(url, best_match_groups)
    end

    private

    def extract_commands(commands_ary)
      @user_agents ||= {}
      groups = { "Allow" => [], "Disallow" => [] }

      commands_ary[1..-1].each do |commands|
        split_commands = commands.split
        group_name = split_commands.first.gsub(/\W+/, '')

        next unless GROUP_NAMES.member?(group_name)
        groups[group_name] << split_commands.last
      end

      @user_agents[commands_ary[0]] = groups
    end

    def parse
      without_comments = @robots_file.gsub(/#.*\n|^\n|#.*$/, '')
      # the first element is just empty string
      without_comments.split(/User-agent:\s*/)[1..-1].each do |user_agent_str|
        extract_commands(user_agent_str.strip.split(/\n/).map(&:strip))
      end
    end

    def allowed_url?(url, groups)
      allowed = false

      if groups["Allow"].empty?
        allowed = true unless groups["Disallow"].find { |u| url =~ Regexp.compile(u) }
      else
        allowed = true if groups["Allow"].find { |u| url =~ Regexp.compile(u) }
      end

      allowed
    end

    def choose_longest_match(agents_url)
      return nil if agents_url.nil?
      best_key = agents_url.keys.max { |k1, k2| k1.length <=> k2.length }
      agents_url[best_key]
    end

  end
end