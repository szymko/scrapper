require_relative '../test_helper'

class SectionTest < MiniTest::Unit::TestCase

  def setup
    @rule1 = mock()
    @rule2 = mock()
    agent = Robots::UserAgent.new("User-agent: some_agent\n")

    @rule_hash = { user_agent: agent, rule_list: [@rule1, @rule2] }
    @section = Robots::Section.new(@rule_hash)
    @url = "http://www.example.com/"
  end

  def test_it_checks_rules
    @rule1.expects(:allowed?).with(@url)
    @rule2.expects(:allowed?).with(@url)
    @section.allowed?(@url)
  end

  def test_it_uses_rules
    @rule1.stubs(:allowed?).returns(true)
    @rule2.stubs(:allowed?).returns(true)
    assert @section.allowed?(@url)

    @rule2.stubs(:allowed?).returns(false)
    refute false, @section.allowed?(@url)
  end

  def test_it_computes_similarity
    agent_string = "some_agent"
    assert 10, @section.user_agent_similarity(agent_string)
  end

  def test_it_adds_new_rules
    rule3 = mock()
    @section.add_rule(rule3)

    @rule1.expects(:allowed?)
    @rule2.expects(:allowed?)
    rule3.expects(:allowed?)
    @section.allowed?(@url)
  end
end
