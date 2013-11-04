require_relative '../test_helper'

class SectionTest < MiniTest::Unit::TestCase

  def setup
    @rule1 = stub(allowed?: true, type: :disallow)
    @rule2 = stub(allowed?: false, type: :disallow)
    @rule3 = stub(allowed?: true, type: :allow)
    @rule4 = stub(allowed?: false, type: :allow)
    @url = "http://www.example.com/"
  end

  def test_it_checks_rules
    section = create_section([@rule1, @rule2])

    @rule1.expects(:allowed?).with(@url)
    @rule1.expects(:type)
    @rule2.expects(:type)
    @rule2.expects(:allowed?).with(@url)
    section.allowed?(@url)
  end

  def test_it_uses_rules
    section1 = create_section([@rule1, @rule1])
    assert section1.allowed?(@url)

    section2 = create_section([@rule1, @rule2])
    refute section2.allowed?(@url)
  end

  def test_it_computes_similarity
    section = create_section([])
    agent_string = "some_agent"
    assert 10, section.user_agent_similarity(agent_string)
  end

  def test_it_adds_new_rules
    section = create_section([@rule1, @rule2])
    section.add_rule(@rule3)

    @rule1.expects(:allowed?)
    @rule2.expects(:allowed?)
    @rule3.expects(:allowed?)
    section.allowed?(@url)
  end

  def test_it_understands_mixed_rules
    section = create_section([@rule1, @rule4])
    assert section.allowed?(@url)
  end

  def create_section(rules)
    agent = Robots::UserAgent.new("User-agent: some_agent\n")

    rule_hash = { user_agent: agent, rule_list: rules }
    Robots::Section.new(rule_hash)
  end
end
