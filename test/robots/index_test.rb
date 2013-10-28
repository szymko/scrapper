require_relative '../test_helper'

class IndexTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @document = open_file("small_robots.txt")
    @host = "en.wikipedia.org"
    @index = Robots::Index.new
  end

  def test_it_adds_document
    refute @index.has?(@host)
    @index.add(@host => @document)
    assert @index.has?(@host)
  end

  def test_it_falls_back_when_information_does_not_exist
    assert @index.allowed?(agent: "A", url: "http://www.example.com", empty: true)
    refute @index.allowed?(agent: "A", url: "http://www.example.com", empty: false)
  end


  def test_it_checks_existing_rules
    @index.add(@host => @document)
    assert @index.allowed?(agent: "Orthogaffe", url: "http://en.wikipedia.org/wiki")
  end

  def test_it_hits_the_network_for_missing_information
    @index.stubs(:get).returns({})
    @index.allowed?(url: "http://www.example.com/", agent: "A")
  end

  def test_it_performs_a_request
    setup_net_stubs()
    Robots::DocumentBuilder.any_instance.expects(:build).with("hello")
    Robots::DocumentBuilder.any_instance.expects(:build).with("")
    @index.get("http://www.google.pl/", "http://foo.bar.com")

    assert @index.has?("www.google.pl")
    assert @index.has?("foo.bar.com")
  end
end
