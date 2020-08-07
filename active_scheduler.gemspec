$:.push File.expand_path("../lib", __FILE__)
require "active_scheduler/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "active_scheduler"
  s.version     = ActiveScheduler::VERSION
  s.authors     = ["Justin Aiken"]
  s.email       = ["60tonangel@gmail.com"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/JustinAiken/active_scheduler"
  s.summary     = %q{Scheduling for ActiveJob}
  s.description = %q{A wrapper for scheduling jobs through ActiveJob}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency             'rake'
  s.add_dependency             'activejob', '>= 4.2.0'
  s.add_development_dependency 'rspec',     '~> 3.5'
  s.add_development_dependency 'coveralls'
end
