require 'spec_helper'
require 'yaml'

describe ActiveScheduler::ResqueWrapper do
  describe ".wrap" do
    let(:wrapped) { described_class.wrap schedule }

    context "with a simple job yaml" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.yaml' }

      it "queues up a simple job" do
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => nil,
            "active_job" => true
          }],
        )
      end
    end

    context "with a simple non AJ job yaml" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job_non_aj.yaml' }

      it "queues up a simple job" do
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => nil,
            "active_job" => false
          }],
        )
      end
    end

    context "with a simple job json" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.json' }

      it "queues up a simple job" do
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => nil,
            "active_job" => true
          }]
        )
      end
    end

    context "with a multiple jobs in the schedule" do
      let(:schedule) { YAML.load_file 'spec/fixtures/two_jobs.yaml' }

      it "queues them all up simple job" do
        expect(wrapped['job_1']['args'][0]['job_class']).to eq 'JobOne'
        expect(wrapped['job_2']['args'][0]['job_class']).to eq 'JobTwo'
      end
    end

    context "with a cron instead of an every" do
      let(:schedule) { YAML.load_file 'spec/fixtures/cron_job.yaml' }

      it "uses that instead" do
        expect(wrapped['cron_job']['cron']).to eq '* * * *'
        expect(wrapped['cron_job']['every']).to be_nil
      end
    end

    context "when the queue is blank" do
      let(:schedule) { YAML.load_file 'spec/fixtures/no_queue.yaml' }

      it "uses 'default'" do
        expect(wrapped['no_queue_job']['queue']).to eq 'default'
      end
    end

    context "when the schedule name is the class name" do
      let(:schedule) { YAML.load_file 'spec/fixtures/schedule_name_is_class_name.yaml' }

      it "queues up a job, using the schedule name for the class name" do
        expect(wrapped['MyScheduleNameIsClassNameJob']).to eq(
          "class"       => "ActiveScheduler::ResqueWrapper",
          "queue"       => "myscheduledjobqueue",
          "description" => "It's a self-named job.",
          "cron"       => "* * * * *",
          "args"        => [{
            "job_class"  => "MyScheduleNameIsClassNameJob",
            "queue_name" => "myscheduledjobqueue",
            "arguments"  => nil,
            "active_job" => true
          }]
        )
      end

    end
  end

  describe ".perform" do
    context 'with active job' do
      class TestKlass
      end

      let(:job_data) { {'job_class' => 'TestKlass', 'active_job' => true} }

      after { described_class.perform job_data }

      it "gets the true job class and ActiveJob's it up" do
        expect(TestKlass).to receive :perform_later
      end

      context "with arguments" do
        let(:job_data) { {'job_class' => 'TestKlass', 'arguments' => [1, 2], 'active_job' => true} }

        it "passes the arguments" do
          expect(TestKlass).to receive(:perform_later).with 1, 2
        end
      end
    end

    context 'with non active job' do
      class TestKlass
      end

      let(:job_data) { {'job_class' => 'TestKlass', 'active_job' => false} }

      after { described_class.perform job_data }

      it "gets the true job class and ActiveJob's it up" do
        expect(TestKlass).to receive :perform
      end

      context "with arguments" do
        let(:job_data) { {'job_class' => 'TestKlass', 'arguments' => [1, 2], 'active_job' => false} }

        it "passes the arguments" do
          expect(TestKlass).to receive(:perform).with 1, 2
        end
      end
    end
  end
end
