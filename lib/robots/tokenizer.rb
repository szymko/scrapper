require 'strscan'

module Robots
  class Tokenizer
    AGENT = /^(?!<^#)User-agent:[^\n]*\n?/
    RULE = /^(?!<^#)(Allow|Disallow):[^\n]*\n?/
    COMMENT_OR_BLANK = /\A\s*#.*\n|^\n|#.*$/

    def initialize(io)
      @ss = StringScanner.new(io.read)
    end

    def next_token
      return if @ss.eos?

      case
      when text = @ss.scan(AGENT) then [:AGENT, text]
      when text = @ss.scan(RULE)  then [:RULE, text]
      when text = @ss.scan(COMMENT_OR_BLANK) then next_token()
      else
        x = @ss.getch
        [x, x]
      end
    end

  end
end
