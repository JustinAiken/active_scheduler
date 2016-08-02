[![Gem Version](http://img.shields.io/gem/v/active_scheduler.svg)](https://rubygems.org/gems/active_scheduler)[![Build Status](http://img.shields.io/travis/JustinAiken/active_scheduler/master.svg)](http://travis-ci.org/JustinAiken/active_scheduler) [![Coveralls branch](http://img.shields.io/coveralls/JustinAiken/active_scheduler/master.svg)](https://coveralls.io/r/JustinAiken/active_scheduler?branch=master)[![Code Climate](http://img.shields.io/codeclimate/github/JustinAiken/active_scheduler.svg)](https://codeclimate.com/github/JustinAiken/active_scheduler)

# active_scheduler

active_scheduler is a gem to take a standard schedule one would use with [resque scheduler](https://github.com/resque/resque-scheduler) and wraps it to work with [ActiveJob](https://github.com/rails/rails/tree/master/activejob).

Currently only Resque is supported, but pull requests to add other queues (sidekiq, etc) would be welcomed!

## Requirements/Support

- Ruby 2.0+
- Rails
  - ActiveJob 4.2+
- Resque
- Resque Scheduler

## Setup

#### Installation

Add `active_scheduler` to your Gemfile.

## Usage

In your Resque initializer:

```ruby
require 'resque/server'
require 'resque/scheduler/server'
require 'active_scheduler'

# ... Set up your Resque ...
...

yaml_schedule    = YAML.load_file("#{Rails.root}/config/resque_schedule.yaml") || {}
wrapped_schedule = ActiveScheduler::ResqueWrapper.wrap yaml_schedule
Resque.schedule  = wrapped_schedule
```


## Example Format

```yaml
simple_job:
  every: "30s"
  queue: "simple"
  class: "SimpleJob"
  args:
    -
  description: "It's a simple job."

ThisIsTheClass:
  cron: "* * * *"
  queue: 'cronny'
  description: "Will call the ThisIsTheClass class"
```

Only classes that are descended from `ActiveJob::Base` will be wrapped

## Credits

- Written by [@JustinAiken](https://www.github.com/JustinAiken)
- Wrapper class idea by [@ryanwjackson](https://www.github.com/ryanwjackson)
- Special thanks to [Rocketmade](http://www.rocketmade.com/) for development resources.

## License

MIT
