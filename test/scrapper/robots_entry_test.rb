class RobotsEntryTest < MiniTest::Unit::TestCase
  def setup
    @agent = "\tUser-agent: Mariusz\n"
    @allow = "Allow:  /wiki/*/abc\n"
    @disallow_site = "  Disallow: /*/discussion\n"
    @disallow_directory = "  Disallow: /*/discussion/\n"
  end

  def test_it_tells_allowed_from_dissallowed
    allowed_entry = Scrapper::RobotsEntry.new(@agent + @allow)
    disallowed_entry = Scrapper::RobotsEntry.new(@agent + @disallow_site)
    disallowed_dir_entry = Scrapper::RobotsEntry.new(@agent + @disallow_directory)

    assert allowed_entry.allowed?("http://www.wiki/wiki/something/abc")
    refute allowed_entry.allowed?("http://www.wiki/wiki/something/def")
    refute allowed_entry.allowed?("http://www.wiki/wiki/something/something/abc")

    assert disallowed_entry.allowed?("http://fr.wiki/wiki/something/discussion")
    assert disallowed_entry.allowed?("http://fr.wiki/article/discussions")    
    refute disallowed_entry.allowed?("http://fr.wiki/article/discussion")

    refute disallowed_dir_entry.allowed?("http://fr.wiki/article/discussion/a")
  end
end