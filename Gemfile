source 'https://rubygems.org'

rails_version = ENV['RAILS_VERSION'] || '4.2.0'
rails         = "~> #{rails_version}"

gem "activejob",     rails
gem "activesupport", rails

gem "guard-rspec", '~> 4.2' unless ENV['CI']

gemspec
