require_relative '../test_helper'
require 'stringio'

class TokenizerTest < MiniTest::Unit::TestCase

  def setup
    comment1 = "#Allow: D\n"
    user_agent = "User-agent: GogleBot\n"
    comment2 = "# User-agent: IsraBot\n"
    rule1 = "Allow: /\n"
    rule2 = "Disallow: /wiki\n"
    blank = "\n"
    comment3 = "#Disallow: /\n"

    @document = [comment1, user_agent, comment2, rule1, blank, rule2, comment3].join('')
    @tokens = [[:AGENT, user_agent], [:RULE, rule1], [:RULE, rule2]]
  end

  def test_it_returns_tokens_correctly
    tokenizer = Robots::Tokenizer.new(StringIO.new(@document))
    token_array = []
    6.times { token_array << tokenizer.next_token() }
    assert_equal @tokens, token_array.compact
  end

end
