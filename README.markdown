[![Build Status](http://img.shields.io/travis/JustinAiken/activejob-scheduler/master.svg)](http://travis-ci.org/JustinAiken/activejob-scheduler) [![Coveralls branch](http://img.shields.io/coveralls/JustinAiken/activejob-scheduler/master.svg)](https://coveralls.io/r/JustinAiken/activejob-scheduler?branch=master)[![Code Climate](http://img.shields.io/codeclimate/github/JustinAiken/activejob-scheduler.svg)](https://codeclimate.com/github/JustinAiken/activejob-scheduler)

# activejob-scheduler

activejob-scheduler is a gem to take a standard schedule one would use with [resque scheduler](https://github.com/resque/resque-scheduler) and wraps it to work with [ActiveJob](https://github.com/rails/rails/tree/master/activejob).

Currently only Resque is supported, but pull requests to add other queues (sidekiq, etc) would be welcomed!

## Requirements/Support

- Rails 4.2+
- Resque
- Resque Scheduler

## Setup

#### Installation

Add `activejob-scheduler` to your Gemfile.

## Usage

In your Resque initializer:

```ruby
require 'resque/server'
require 'resque/scheduler/server'
require 'active_job/scheduler'

# ... Set up your Resque ...
...

yaml_schedule    = YAML.load_file("#{Rails.root}/config/resque_schedule.yaml") || {}
wrapped_schedule = ActiveJob::Scheduler::ResqueWrapper.wrap yaml_schedule
Resque.schedule  = wrapped_schedule
```

## Credits

- Written by [@JustinAiken](https://www.github.com/JustinAiken)
- Wrapper class idea by [@ryanwjackson](https://www.github.com/ryanwjackson)
- Special thanks to [Rocketmade](http://www.rocketmade.com/) for development resources.

## License

MIT
