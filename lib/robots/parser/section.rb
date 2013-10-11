module Robots
  module Parser
    class Section

      attr_reader :user_agent, :rules

      def initialize(raw_section)
        @raw = raw_section
      end

      def parse()
        parsed = {}

        section = clean_section()
        user_agent = Robots::Parser::UserAgent.new(extract_user_agent(section))
        rule_list = extract_rules(section)

        Robots::Section.new(user_agent, rule_list)
      end

      private

      def clean_section()
        @raw.strip.split(/\n/).map(&:strip)
      end

      def extract_user_agent(section)
        section.first.split.last.gsub(/\s+/, '')
      end

      def extract_rules(section)
        section[1..-1].reduce([]) do |rule_list, raw_rule|
          rule_parser = Parser::Rule.new(raw_rule)
          rule_list << rule_parser.parse()
        end
      end
    end
  end
end