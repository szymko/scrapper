module Robots
  class UserAgent

    def initialize(user_agent_line)
      @name = extract(user_agent_line)
    end

    def similarity(another_name)
      agent_pattern = name_to_regexp()
      (another_name =~ agent_pattern) ? similarity_score : 0
    end

    private

    def name_to_regexp
      Regexp.compile("\\A#{@name.gsub('*', '.*')}\\z")
    end

    def similarity_score
      @name.length
    end

    def extract(user_agent_line)
      user_agent_line.gsub(/User-agent:\s+/, '').strip
    end

  end
end
