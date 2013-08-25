module Scrapper
  class RobotsParser

    include ArrayHelper

    GROUP_NAMES = ["Allow", "Disallow"]

    attr_reader :raw

    def initialize(robots_file)
      @raw = robots_file
      # parse
    end

    def allowed?(user_agent, url)
      return true if blank?(@entries)
      
      best_entry = @entries.max { |e1, e2| e1.user_agent_similarity(user_agent) <=> e2.user_agent_similarity(user_agent) }

      if best_entry.user_agent_similarity(user_agent) == 0
        return true
      else
        return best_entry.allowed?(url)
      end
    end

    def parsed?
      ! @parsed.nil?
    end

    def parse
      @entries = []
      user_agents = @raw.gsub(/#.*\n|^\n|#.*$/, '').split(/User-agent:\s*/)
      # the first element is just empty string
      unless blank?(user_agents) && blank?(user_agents[1..-1])
        user_agents[1..-1].each { |u_a| @entries << RobotsEntry.new(u_a) }
      end
      @parsed = true

      self
    end
  end
end