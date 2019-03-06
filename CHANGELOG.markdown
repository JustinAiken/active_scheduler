# Next

- Add `persist` option [#15](https://github.com/JustinAiken/active_scheduler/pull/15) (Thanks @SpiffyStores)

# 0.5.0
- Expand Travis matrix to include Rails 5 and more ruby versions
- Allow `rails_env` option since [resque-scheduler](https://github.com/resque/resque-scheduler) does [#10](https://github.com/JustinAiken/active_scheduler/pull/10) (Thanks @blahutka)

# 0.4.0
- Use job's queue instead of hardcoded `default` [#9](https://github.com/JustinAiken/active_scheduler/pull/9) (Thanks @r3trofitted)

# 0.3.0

- Remove explicit active_support dependency (it's pulled in by activejob)
- Updated testing matrix for more rubies 💎💎💎
- Support named args [#6](https://github.com/JustinAiken/active_scheduler/pull/6) (Thanks @jdguzman)

# 0.2.0

- Deprecate `arguments` in favor of `args` [#5](https://github.com/JustinAiken/active_scheduler/pull/5) (Thanks @ximus)

# 0.1.0

- Only wrap jobs that are descendants of `ActiveJob::Base` [#3](https://github.com/JustinAiken/active_scheduler/pull/3) (Thanks @ximus)

# 0.0.3

- Use schedule name as class name if unspecified [#1](https://github.com/JustinAiken/active_scheduler/pull/1) (Thanks @jeremycrosbie)
