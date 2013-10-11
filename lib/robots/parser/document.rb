module Robots
  module Parser
    class Document
      include ArrayHelper

      def initialize(robots_file)
        @raw = robots_file
      end

      def parse
        # shift, because first el is an empty string
        section_list = clean_document().split(/User-agent:\s*/).shift()
        parsed_list = []

        unless blank?(section_list)
          section_list.each do |raw_section|
            section_parser = Robots::Parser::Section.new(raw_section)
            parsed_list << section_parser.parse()
          end
        end

        Robots::Rulebook.new(parsed_list)
      end

      private

      def clean_document()
        # remove comments and blank lines
        @raw.gsub(/#.*\n|^\n|#.*$/, '')
      end

    end
  end
end