require_relative '../test_helper'

class RobotsTest < MiniTest::Unit::TestCase

  def setup
    @robots = Scrapper::Robots.new
    @host1 = "en.wikipedia.org"
    @host2 = "nooooooooooooooo.com"

    @file1 =
<<-ROBOTS1
#comment
User-agent: Mariusz
#
Disallow: /hidden
#

User-agent: *
Allow: /
ROBOTS1

    @file2 =
<<-ROBOTS2
#comment
User-agent: Pszemek*
#
Disallow: /hidden/
#

User-agent: *
Allow: /
ROBOTS2

    stub_request(:any, "http://#{@host1}/robots.txt")
      .to_return(:body => @file1, :status => 200)
  end

  def test_it_builds_robots_from_hash
    host_hash = { @host1 => @file1, @host2 => @file2 }
    @robots.build(host_hash)

    # uses methods from RobotsCore to avoid messing with class internals
    assert @robots.has?(@host1)
    assert @robots.has?(@host2)

    refute @robots.has?("www.youtube.com")

    assert_equal host_hash, @robots.raw
  end

  def test_it_adds_robots_from_hash
    @robots.build(@host1 => @file1)
    @robots.add(@host2 => @file2)

    assert @robots.has?(@host2)
  end

  def test_it_gets_robots_via_web
    @robots.get(["http://#{@host1}/wiki"])
    assert @robots.has?(@host1)
  end

  def test_it_omits_parsing_on_get_with_flag_raw
    Scrapper::RobotsParser.any_instance.expects(:parse).never
    @robots.get(["http://#{@host1}/wiki"], raw: true)
  end


  def get_robots
    robots = Scrapper::Robots.new
    robots.get(["http://#{@host1}/wiki"])
  end
end