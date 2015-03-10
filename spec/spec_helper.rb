require 'active_scheduler'

unless ENV["NO_COVERALLS"]
  require 'coveralls'
  Coveralls.wear!
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
