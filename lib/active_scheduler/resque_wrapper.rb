module ActiveScheduler
  class ResqueWrapper

    def self.perform(job_data)
      klass = Object.const_get job_data['job_class']
      method = get_method(klass)

      if job_data.has_key? 'arguments'
        klass.public_send(method, *job_data['arguments'])
      else
        klass.public_send(method)
      end
    end

    def self.get_method(klass)
      klass.superclass == ActiveJob::Base ? :perform_later : :perform
    end

    def self.wrap(schedule)
      schedule = HashWithIndifferentAccess.new(schedule)

      schedule.each do |job, opts|
        next if opts[:class] =~ /ActiveScheduler::ResqueWrapper/

        queue = opts[:queue] || 'default'

        schedule[job] = {
          class:        'ActiveScheduler::ResqueWrapper',
          queue:        queue,
          args: [{
            job_class:  opts[:class] || job,
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
