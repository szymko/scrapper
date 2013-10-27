require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "./test/**/**/*_test.rb"
end

rule '.rb' => '.y' do |t|
  sh "rm ./lib/robots/parser.rb 2> /dev/null"
  sh "racc -l -o #{t.name} #{t.source}"
end

task :compile => 'lib/robots/parser.rb'