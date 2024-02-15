require "test_helper"
require "sidekiq/testing"

# [RailsNotes UI Addition]
# Minitest test of ExampleJob to make sure everything works
#
Sidekiq::Testing.fake!

class ExampleJobTest < ActiveSupport::TestCase
  test "job is enqueued" do
    assert_difference "ExampleJob.jobs.size", 1 do
      ExampleJob.perform_async
    end
  end
end
