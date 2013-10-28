require_relative '../test_helper'
require 'stringio'

class ParserTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @robots = open_file("small_robots.txt")
    @tokenizer = Robots::Tokenizer.new(StringIO.new(@robots))
    @parser = Robots::Parser.new(@tokenizer)
  end

  def test_it_passes_tokens_to_handler
    Robots::Handler.any_instance.expects(:add_agent).twice
    Robots::Handler.any_instance.expects(:add_rule).twice
    @parser.parse()
  end

  def test_it_returns_handler
    assert_instance_of Robots::Handler, @parser.parse()
  end

  def test_returned_handler_can_build_document
    assert_instance_of Robots::Document, @parser.parse().result()
  end
end
