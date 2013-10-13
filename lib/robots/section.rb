module Robots
  class Section

    def initialize(user_agent, rule_list)
      @user_agent = user_agnet
      @rule_list = rule_list
    end

    def allowed?(url)
      @rule_list.reduce(false) { |score, rule| score &= rule.allowed?(url) }
    end

    def user_agent_similarity(agent_string)
      @user_agent.similarity(agent_string)
    end
  end
end