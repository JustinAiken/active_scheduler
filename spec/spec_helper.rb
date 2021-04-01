require 'active_scheduler'

unless ENV["NO_COVERALLS"]
  require 'coveralls'
  Coveralls.wear!
end

module Helpers
  def stub_jobs(*names, base_class: ActiveJob::Base)
    names.each do |name|
      stub_const(name, Class.new(base_class))
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
