require_relative '../test_helper'

class RuleTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @rule1 = "Allow: /wiki/"
    @rule2 = "Disallow: /*home"
  end

  def test_it_recognizes_allow_rule_type
    rule = Robots::Rule.new(@rule1)
    assert rule.allowed?("/wiki/")
    refute rule.allowed?("/about/")
  end

  def test_it_recognizes_disallow_rule_type
    rule = Robots::Rule.new(@rule2)
    assert rule.allowed?("/about")
    refute rule.allowed?("/12home")
    refute rule.allowed?("/home")
  end
end
