module Robots
  module Parser
    class Document
      include Scrapper::ArrayHelper

      attr_accessor :raw

      def parse(file: "", parser: Robots::Parser::Section.new())
        @raw = file

        # shift, because first el is an empty string
        section_list = clean_document().split(/User-agent:\s*/).shift()
        parsed_list = parse_each(section_list, parser)

        Robots::Document.new(parsed_list)
      end

      private

      def clean_document()
        # remove comments and blank lines
        @raw.gsub(/#.*\n|^\n|#.*$/, '')
      end

      def parse_each(section_list, parser)
        if blank?(section_list)
          []
        else
          section_list.reduce([]) do |parsed_list, raw_section|
            parsed_list << parser.parse(section: raw_section)
          end
        end
      end

    end
  end
end