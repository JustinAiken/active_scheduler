require 'active_job'
require 'active_scheduler/version'
require 'active_scheduler/resque_wrapper'

module ActiveScheduler
  Config = Struct.new(:guard_with, :queue_name_resolver)

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
    config.guard_with = ->(class_name) { class_name.constantize <= ActiveJob::Base }
    config.queue_name_resolver = ->(class_name) { class_name.constantize.queue_name }
  end
end
