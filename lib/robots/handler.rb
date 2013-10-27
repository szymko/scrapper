module Robots
  class Handler
    attr_reader :sections

    def initialize
      @sections = []
    end

    def add_agent(agent_line)
      agent = Robots::UserAgent.new(agent_line)
      @sections << Section.new(user_agent: agent)
    end

    def add_rule(rule_line)
      rule = Robots::Rule.new(rule_line)
      @sections.last.add_rule(rule)
    end

    def result
      Robots::Document.new(@sections)
    end
  end
end
