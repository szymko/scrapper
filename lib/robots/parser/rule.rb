module Robots
  module Parser
    class Rule

      attr_accessor :raw

      def parse(rule: "")
        @raw = rule

        rule_list = @raw.split()
        return if !rule_list || rule_list.compact.empty?

        permission_type = extract_permission_type(rule_list)
        body = rule_list[1]

        Robots::Rule.new(permission_type, body)
      end

      private

      def extract_permission_type(rule_list)
        rule_list[0].gsub(/\W+/, '')
      end
    end
  end
end