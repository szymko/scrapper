require 'uri'

module Scrapper
  class RobotsParser

    GROUP_NAMES = ["Allow", "Disallow"]

    def initialize(robots_file)
      @robots_file = robots_file
      parse
    end

    def allowed?(user_agent, url)
      best_entry = @entries.max { |e1, e2| e1.user_agent_similarity(user_agent) <=> e2.user_agent_similarity(user_agent) }

      if best_entry.user_agent_similarity(user_agent) == 0
        true
      else
        best_entry.allowed?(url)
      end

    end

    private

    def parse
      @entries = []
      without_comments = @robots_file.gsub(/#.*\n|^\n|#.*$/, '')
      # the first element is just empty string
      without_comments.split(/User-agent:\s*/)[1..-1].each do |user_agent_str|
        @entries << RobotsEntry.new(user_agent_str)
      end
    end
  end
end