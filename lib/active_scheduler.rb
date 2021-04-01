require 'active_job'
require 'active_scheduler/errors'
require 'active_scheduler/version'
require 'active_scheduler/resque_wrapper'

module ActiveScheduler
  Config = Struct.new(:check_jobs_descend_from_active_job)

  class << self
    def config
      @config ||= Config.new
    end

    def configure(&block)
      yield(config)
    end
  end

  # Default config
  configure do |config|
    config.check_jobs_descend_from_active_job = true
  end
end
