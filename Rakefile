require 'rubygems'
require 'rake/clean'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
	s.name              = "rmarshal"
	s.version           = "0.1"
	s.author            = "Cody Brocious"
	s.email             = "cody.brocious@gmail.com"
	s.homepage          = "http://github.com/daeken/RMarshal"
	s.platform          = Gem::Platform::RUBY
	s.summary           = "Ruby gem to support the Python marshal format"
	s.files             = FileList["{lib,doc,test}/**/*"].to_a
	s.require_path      = "lib"
end

CLEAN.include("pkg")

task :default => [:clean, :package]

Rake::GemPackageTask.new(spec) do |pkg|
	#pkg.need_tar = true
end