require_relative '../test_helper'

class UserAgentTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @user_agent_line = "User-agent: SomeAgent*\n"
    @user_agent = Robots::UserAgent.new(@user_agent_line)
  end

  def test_it_computes_the_similarity_of_name
    name1 = "SomeAgent421"
    name2 = "SomeAgent2"
    name3 = "Some"

    assert_equal 10, @user_agent.similarity(name1)
    assert_equal 10, @user_agent.similarity(name2)
    assert_equal 0, @user_agent.similarity(name3)
  end
end
