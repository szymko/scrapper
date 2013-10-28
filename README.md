# Scrapper

Hi,
Scrapper is a gem created as a part of my bachelor thesis. It's intended as a simple Web crawler
and Page scrapper with minimal and easy to use API. It also supports Robots.txt.

Examples:
```Ruby
## Crawler

crawler = Scrapper::Crawler.new(async: 10) # set maximum async connections to 10
# get HTML document from a url
crawler.get("http://www.onet.pl")

# scrap urls matching a pattern
urls = crawler.scrap { |u| u.to_s =~ /(http|https):\/\/.*/ }
#=> ["http://www.foo.bar/", "https://bar.baz/snafu"]

crawler.responses.first
#=> #<struct Scrapper::Response url="http://www.onet.pl/", status_code=200, headers...>

crawler.errors.first
#=> #<struct Scrapper::RequestError ...>

## Robots

index = Robots::Index.new
index.has?("http://www.google.pl/")
#=> false

# try get http://wwww.foo.bar/robots.txt
index.get("http://www.foo.bar/")

index.has?("www.foo.bar")
#=> true

# check for allowance
index.allowed?(url: "http://www.foo.bar/baz", agent: "MyAgent")
#=> true/false

# check and return true if there's no entry for the host
index.allowed?(url: "http://www.example.com/", agent: "MyAgent", empty: true)
#=> true

# check and try to download robots.txt if there's no entry
index.allowed?(url: "http://www.example.com/", agent: "MyAgent", download: true)
```
