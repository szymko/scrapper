require_relative '../../test_helper'

class WikipediaScrapperTest < MiniTest::Unit::TestCase

  def setup
    @wiki_scrapper = Scrapper::WikipediaScrapper.new
    urls = %w{ http://en.wikipedia.org/wiki/Main_Page /wiki/names/Pszemek }

    @wiki_scrapper.stubs(:urls).returns(urls)
  end

  def test_it_normalizes_urls
    assert_equal @wiki_scrapper.normalize_urls, %w{ http://en.wikipedia.org/wiki/Main_Page http://en.wikipedia.org/wiki/names/Pszemek }
  end

  def test_it_acknowledges_relevant_urls
    irrelevant = %w{ http://www.google.pl http://pl.wikipedia.org http://en.wikipedia.org/Random en.wikipedia.org }
    relevant = %w{ http://en.wikipedia.org/wiki/Main_Page http://en.wikipedia.org/wiki/names/Pszemek }

    irrelevant.each { |i| refute @wiki_scrapper.is_relevant?(i) }
    relevant.each { |r| assert @wiki_scrapper.is_relevant?(r) }
  end

end