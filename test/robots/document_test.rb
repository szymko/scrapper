require_relative '../test_helper'

class DocumentTest < MiniTest::Unit::TestCase

  def setup
    @section1 = mock()
    @section2 = mock()
  end

  def test_it_finds_most_relevant_section
    opts = { agent: "Some agent", url: "http://www.example.com/" }
    @section1.stubs(:user_agent_similarity).returns(12)
    @section2.stubs(:user_agent_similarity).returns(10)

    @section1.expects(:allowed?).with(opts[:url])
    Robots::Document.new([@section1, @section2]).allowed?(opts)
  end

  def test_it_returns_true_for_no_matching_section
    opts = { agent: "Some agent", url: "http://www.example.com/" }
    @section1.stubs(:user_agent_similarity).returns(0)
    @section2.stubs(:user_agent_similarity).returns(0)

    @section1.expects(:allowed?).never
    @section2.expects(:allowed?).never
    assert Robots::Document.new([@section1, @section2]).allowed?(opts)
  end
end
