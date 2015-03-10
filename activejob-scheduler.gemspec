$:.push File.expand_path("../lib", __FILE__)
require "active_job/scheduler/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "activejob-scheduler"
  s.version     = ActiveJob::Scheduler::VERSION
  s.authors     = ["Justin Aiken"]
  s.email       = ["jaiken@rocketmade.com"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/JustinAiken/activejob-scheduler"
  s.summary     = %q{Scheduling for ActiveJob}
  s.description = %q{A wrapper for scheduling jobs through ActiveJob}

  s.rubyforge_project = "activejob-scheduler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency             'activejob',     '>= 4.2.0'
  s.add_dependency             'activesupport', '>= 4.2.0'

  s.add_development_dependency 'rspec-rails',   '~> 3.1'
  s.add_development_dependency 'guard-rspec',   '~> 4.2'
  s.add_development_dependency 'coveralls'
end
