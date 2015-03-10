begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
end

desc "Run tests "
task :default do
  Rake::Task["spec"].invoke
end
