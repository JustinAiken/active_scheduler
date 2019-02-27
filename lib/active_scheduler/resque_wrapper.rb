module ActiveScheduler
  class ResqueWrapper

    def self.perform(job_data)
      klass = Object.const_get job_data['job_class']
      named_args = job_data.delete('named_args') || false

      if job_data.has_key? 'arguments'
        if named_args
          args = job_data['arguments'].first.symbolize_keys
        else
          args = job_data['arguments']
        end

        named_args ? klass.perform_later(**args) : klass.perform_later(*args)
      else
        klass.perform_later
      end
    end

    def self.wrap(schedule)
      schedule = HashWithIndifferentAccess.new(schedule)

      schedule.each do |job, opts|
        class_name = opts[:class] || job
        next if class_name =~ /#{self.to_s}/

        klass = class_name.constantize
        next unless klass <= ActiveJob::Base

        queue = opts[:queue] || klass.queue_name
        args = opts[:args]
        named_args = opts[:named_args] || false

        if !args && opts.has_key?(:arguments)
          warn 'active_scheduler: [DEPRECATION] using the `arguments` key in ' \
            'your resque schedule will soon be deprecated. Please revert to ' \
            'the resque standard `args` key.'
          args = opts[:arguments]
        end

        schedule[job] = {
          class:        self.to_s,
          queue:        queue,
          args: [{
                   job_class:  class_name,
                   queue_name: queue,
                   arguments:  args,
                 }]
        }

        schedule[job][:args].first.merge!({ named_args: named_args }) if named_args

        schedule[job][:description] = opts.fetch(:description, nil) if opts.fetch(:description, nil)
        schedule[job][:every]       = opts.fetch(:every, nil)       if opts.fetch(:every, nil)
        schedule[job][:cron]        = opts.fetch(:cron, nil)        if opts.fetch(:cron, nil)
        schedule[job][:rails_env]   = opts.fetch(:rails_env, nil)   if opts.fetch(:rails_env, nil)
      end
    end
  end
end
