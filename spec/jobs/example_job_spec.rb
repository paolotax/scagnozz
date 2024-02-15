require "rails_helper"

# [RailsNotes UI Addition]
# RSpec test of ExampleJob to make sure everything works
#
RSpec.describe ExampleJob, type: :job do
  before do
    Sidekiq::Testing.fake!
  end

  it "can be enqueued" do
    expect { ExampleJob.perform_async }.to change { ExampleJob.jobs.size }.by(1)
  end
end
