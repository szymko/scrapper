module Robots
  class Section

    def initialize(section_hash) # section_hash = {user_agent: , rule_list: []}
      section_hash = { rule_list: [] }.merge(section_hash)
      @user_agent = section_hash[:user_agent]
      @rule_list = section_hash[:rule_list]
    end

    def allowed?(url)
      @rule_list.reduce(true) { |score, rule| score &= rule.allowed?(url) }
    end

    def user_agent_similarity(agent_string)
      @user_agent.similarity(agent_string)
    end

    def add_rule(rule)
      @rule_list << rule
    end
  end
end