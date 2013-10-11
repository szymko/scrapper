module Robots
  class UserAgent

    def initialize(name)
      @name = name
    end

    def silmilarity(another_name)
      agent_pattern = name_to_regexp()
      (agent_string =~ agent_pattern) ? similarity_score : 0
    end

    private

    def name_to_regexp
      Regexp.compile("\\A#{@name.gsub('*', '.*')}\\z")
    end

    def similarity_score
      @user_agent.gsub(/\*/, '').length
    end

  end
end