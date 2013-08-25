require_relative '../test_helper'

class RobotsTest < MiniTest::Unit::TestCase

  def setup
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
  end

  def test_it_builds_robots_from_hash
    host_hash = { @host1 => @file1, @host2 => @file2 }
    robots = Scrapper::Robots.new
    robots.build(host_hash)

    # uses methods from RobotsCore to avoid messing with class internals
    assert robots.has?(@host1)
    assert robots.has?(@host2)

    refute robots.has?("www.youtube.com")

    assert_equal host_hash, robots.raw
  end
end