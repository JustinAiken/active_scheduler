require 'spec_helper'
require 'active_job/scheduler'

describe ActiveJob::Scheduler::ResqueWrapper do
  describe ".wrap" do
    let(:wrapped) { described_class.wrap schedule }

    context "with a simple job yaml" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.yaml' }

      it "queues up a simple job" do
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveJob::Scheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => nil
          }]
        )
      end
    end

    context "with a simple job json" do
      let(:schedule) { YAML.load_file 'spec/fixtures/simple_job.json' }

      it "queues up a simple job" do
        expect(wrapped['simple_job']).to eq(
          "class"       => "ActiveJob::Scheduler::ResqueWrapper",
          "queue"       => "simple",
          "description" => "It's a simple job.",
          "every"       => "30s",
          "args"        => [{
            "job_class"  => "SimpleJob",
            "queue_name" => "simple",
            "arguments"  => nil
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
  end
end
