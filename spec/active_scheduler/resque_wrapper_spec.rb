require 'spec_helper'
require 'yaml'

describe ActiveScheduler::ResqueWrapper do
  describe ".wrap" do
    let(:wrapped) { described_class.wrap schedule }

    context "with a simple job yaml" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.yaml' }

      it "queues up a simple job" do
        stub_jobs("SimpleJob")
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "rails_env"   => "test",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => ['foo-arg-1', 'foo-arg-2'],
          }]
        )
      end

      context "job is not an active job descendant" do
        it "doesn't wrap" do
          stub_const("SimpleJob", Class.new)
          expect(wrapped['simple_job']).to eq(
            "class"       => "SimpleJob",
            "queue"       => "simple",
            "description" => "It's a simple job.",
            "every"       => "30s",
            "rails_env"   => "test",
            "args"        => ['foo-arg-1', 'foo-arg-2'],
          )
        end
      end

      context 'with a custom wrapper class' do
        class CustomWrapper < ActiveScheduler::ResqueWrapper
        end

        let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.yaml' }

        it "queues up a simple job" do
          stub_jobs("SimpleJob")
          expect(CustomWrapper.wrap(schedule)['simple_job']).to eq(
            "class"       => "CustomWrapper",
            "queue"       => "simple",
            "description" => "It's a simple job.",
            "every"       => "30s",
            "rails_env"   => "test",
            "args"        => [{
               "job_class"  => "SimpleJob",
               "queue_name" => "simple",
               "arguments"  => ['foo-arg-1', 'foo-arg-2'],
              }]
           )
        end
      end
    end

    context "with a simple job json" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.json' }

      it "queues up a simple job" do
        stub_jobs("SimpleJob")
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => "foo-argument",
          }]
        )
      end
    end

    context "with a multiple jobs in the schedule" do
      let(:schedule) { YAML.load_file 'spec/fixtures/two_jobs.yaml' }

      it "queues them all up simple job" do
        stub_jobs("JobOne", "JobTwo")
        expect(wrapped['job_1']['args'][0]['job_class']).to eq 'JobOne'
        expect(wrapped['job_2']['args'][0]['job_class']).to eq 'JobTwo'
      end
    end

    context "with a cron instead of an every" do
      let(:schedule) { YAML.load_file 'spec/fixtures/cron_job.yaml' }

      it "uses that instead" do
        stub_jobs("CronJob")
        expect(wrapped['cron_job']['cron']).to eq '* * * *'
        expect(wrapped['cron_job']['every']).to be_nil
      end
    end

    context "when the queue is blank" do
      let(:schedule) { YAML.load_file 'spec/fixtures/no_queue.yaml' }

      it "uses the job's queue" do
        simple_job = Class.new(ActiveJob::Base) do
          queue_as :myscheduledjobqueue
        end
        
        stub_const("SimpleJob", simple_job)
        
        expect(wrapped['no_queue_job']['queue']).to eq 'myscheduledjobqueue'
      end
    end

    context "when the schedule name is the class name" do
      let(:schedule) { YAML.load_file 'spec/fixtures/schedule_name_is_class_name.yaml' }

      it "queues up a job, using the schedule name for the class name" do
        stub_jobs("MyScheduleNameIsClassNameJob")
        expect(wrapped['MyScheduleNameIsClassNameJob']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "myscheduledjobqueue",
          "description" => "It's a self-named job.",
          "cron"       => "* * * * *",
          "args"        => [{
            "job_class"  => "MyScheduleNameIsClassNameJob",
            "queue_name" => "myscheduledjobqueue",
            "arguments"  => [nil]
          }]
        )
      end
    end

    context "when the schedule is for a job with named arguments" do
      let(:schedule) { YAML.load_file 'spec/fixtures/named_args_job.yaml' }

      it "queues up a job, specifing that there are named args in the job" do
        stub_jobs("NamedArgsJob")
        expect(wrapped['named_args_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a named args job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "NamedArgsJob",
            "queue_name" => "simple",
            "arguments"  => [{'foo' => 1, 'bar' => 2}],
            "named_args" => true
          }]
        )
      end
    end
  end

  describe ".perform" do
    class TestKlass
    end

    let(:job_data) { {'job_class' => 'TestKlass'} }

    after { described_class.perform job_data }

    it "gets the true job class and ActiveJob's it up" do
      expect(TestKlass).to receive :perform_later
    end

    context "with arguments" do
      let(:job_data) { {'job_class' => 'TestKlass', 'arguments' => [1, 2]} }

      it "passes the arguments" do
        expect(TestKlass).to receive(:perform_later).with 1, 2
      end
    end

    context "with named_arguments specified" do
      let(:job_data) do
        {
          'job_class' => 'TestKlass',
          'arguments' => [{ 'foo' => 1, 'bar' => 2 }],
          'named_args' => true
        }
      end

      it "passed the arguments as Named args" do
        expect(TestKlass).to receive(:perform_later).with(foo: 1, bar: 2)
      end
    end
  end
end
