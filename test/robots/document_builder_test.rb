require_relative '../test_helper'

class DocumentBuilderTest < MiniTest::Unit::TestCase

  include TestHelper

  def test_it_builds_document
    document = open_file("small_robots.txt")
    builder = Robots::DocumentBuilder.new
    assert_instance_of Robots::Document, builder.build(document)
  end

  def test_it_uses_custom_parser
    mock_parser = mock()
    mock_parser_klass = mock()

    mock_parser_klass.stubs(:new).returns(mock_parser)
    mock_parser.stubs(:parse).returns(Robots::Handler.new)

    builder = Robots::DocumentBuilder.new(mock_parser_klass)
    builder.build("some string")
  end
end
