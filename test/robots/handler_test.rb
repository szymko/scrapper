require_relative '../test_helper'

class HandlerTest < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @agent_line = "User-agent: Hal"
    @rule_line = "Allow: /"
    @handler = Robots::Handler.new
  end

  def test_it_adds_new_section_on_agent_line
    section_count = @handler.sections.length
    @handler.add_agent(@agent_line)
    assert_equal(section_count + 1, @handler.sections.count)
  end

  def test_it_adds_rule_to_existing_section
    @handler.add_agent(@agent_line)
    sections = @handler.sections
    sections.last.expects(:add_rule).once
    @handler.add_rule(@rule_line)
  end

  def test_it_returns_document_as_a_result
    Robots::Document.expects(:new).with([])
    @handler.result()
  end
end
