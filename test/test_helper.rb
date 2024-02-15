ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # [RailsNotes UI Addition]
  # Configure User fixtures to use Pay's :fake_processor for testing
  setup do
    users.each do |user|
      user.set_payment_processor :fake_processor, allow_fake: true
    end
  end
end
