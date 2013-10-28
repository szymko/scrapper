require 'stringio'

module Robots
  class DocumentBuilder
    def initialize(parser_klass = Robots::Parser)
      @parser_klass = parser_klass
    end

    def build(document)
      raise ArgumentError unless document.kind_of?(String)

      t = Robots::Tokenizer.new(StringIO.new(document))
      p = @parser_klass.new(t)
      p.parse().result()
    end
  end
end
