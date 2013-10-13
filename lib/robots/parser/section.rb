module Robots
  module Parser
    class Section

      attr_reader :user_agent

      def parse(robots_section: "", parser: Robots::Parser::Rule.new())
        @raw = robots_section
        parsed = {}

        clean = clean_section()
        user_agent = Robots::Parser::UserAgent.new(extract_user_agent(section))
        rule_list = extract_rules(section, parser)

        Robots::Section.new(user_agent, rule_list)
      end

      private

      def clean_section()
        @raw.strip.split(/\n/).map(&:strip)
      end

      def extract_user_agent(section)
        section.first.split.last.gsub(/\s+/, '')
      end

      def extract_rules(section, parser)
        section[1..-1].reduce([]) do |rule_list, raw_rule|
          rule_list << parser.parse(rule: raw_rule)
        end
      end
    end
  end
end