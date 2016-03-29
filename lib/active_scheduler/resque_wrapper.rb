module ActiveScheduler
  class ResqueWrapper

    def self.perform(job_data)
      klass = Object.const_get job_data['job_class']

      if job_data.has_key? 'arguments'
        klass.perform_later *job_data['arguments']
      else
        klass.perform_later
      end
    end

    def self.wrap(schedule)
      schedule = HashWithIndifferentAccess.new(schedule)

      schedule.each do |job, opts|
        class_name = opts[:class] || job
        next if class_name =~ /ActiveScheduler::ResqueWrapper/
        next unless class_name.constantize <= ActiveJob::Base

        queue = opts[:queue] || 'default'

        schedule[job] = {
          class:        'ActiveScheduler::ResqueWrapper',
          queue:        queue,
          args: [{
            job_class:  class_name,
            queue_name: queue,
            arguments:  opts[:arguments]
          }]
        }

        schedule[job][:description] = opts.fetch(:description, nil) if opts.fetch(:description, nil)
        schedule[job][:every]       = opts.fetch(:every, nil)       if opts.fetch(:every, nil)
        schedule[job][:cron]        = opts.fetch(:cron, nil)        if opts.fetch(:cron, nil)
      end
    end
  end
end
