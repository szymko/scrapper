require_relative '../../test_helper'

class DocumentTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @parser = Mock::Parser.new()
    @file = open_robots_file()
  end

  def test_it_parses_robots_file
    doc_parser = Robots::Parser::Document.new()
    Robots::Document.stubs(:new).once
    doc_parser.parse(file: @file, parser: @parser)
  end

end