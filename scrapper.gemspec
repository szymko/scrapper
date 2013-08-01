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
end