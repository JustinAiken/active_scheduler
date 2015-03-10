guard :rspec, all_after_pass: false, all_on_start: false, failed_mode: :none, cmd: 'NO_COVERALLS=true rspec --color --no-profile --format progress' do

  # Run all tests if these change:
  watch('spec/spec_helper.rb')               { 'spec' }
  watch(%r{^spec/support/(.+)\.rb$})         { 'spec' }

  # Any spec runs itself:
  watch(%r{^spec/.+_spec\.rb$})

  # lib/foo.rb runs spec/foo.rb...
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
