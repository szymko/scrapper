# Scrapper

Hi,
Scrapper is a gem created as a part of my bachelor thesis. It's intended as a simple Web crawler
and Page scrapper with minimal and easy to use API. It also supports Robots.txt.

Examples:
```Ruby
@scrapper = Scrapper::Runner.new(ascync_no: 10) # set maximum async connections to 10
@scrapper.scrap("http://www.onet.pl") { |u| u =~ /www.onet\.pl/ } # scrap urls matching a pattern
@scrapper.responses.first
#=> #<struct Scrapper::Response url="http://www.onet.pl/", status_code=200, headers...>
@scrapper.errors.first
#=> #<struct Scrapper::RequestError ...>
```
