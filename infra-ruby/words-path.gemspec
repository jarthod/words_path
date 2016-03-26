Gem::Specification.new do |s|
	s.name = "words-path"
	s.version = "0.0.0"
	s.author = "author" # FIXME
	s.summary = "summary" # FIXME
	s.executables = ["words-path-main"]
	s.files = Dir["**/*"]
	s.add_runtime_dependency "infraruby-base", "~> 4.0"
	s.add_development_dependency "infraruby-task", "~> 4.0"
	s.add_development_dependency "rspec", "~> 3.0"
end
