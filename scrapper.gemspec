gemspec = Gem::Specification.new do |s|
  s.name              = 'scrapper'
  s.version           = '0.0.1'
  s.summary           = 'Simple scrapper'
  s.description       = 'Simple scrapper making web requests, parsing them and extracting urls.'
  s.files             = Dir.glob("{lib, spec}/**/*")
  s.require_path      = 'lib'
  s.homepage          = 'https://github.com/szymko/scrapper'
  s.authors           = ['Szymon Sobański']
  s.email             = "sobanski.s@gmail.com"

  s.add_dependency    'nokogiri', '1.6.0'
  s.add_dependency    'eventmachine', '1.0.3'
  s.add_dependency    'em-http-request', '1.1.0'
end