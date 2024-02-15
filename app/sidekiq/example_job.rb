# [RailsNotes UI Addition]
# Simple Sidekiq job to make sure Sidekiq is running correctly.
#
# In most cases, I recommend Sidekiq jobs rather than ActiveJob jobs, for performance.
# See this article — https://andycroll.com/ruby/use-sidekiq-directly-not-through-active-job/
#
class ExampleJob
  include Sidekiq::Job

  def perform(*args)
    puts "\n>>> Hello from Sidekiq, and thanks from RailsNotes UI! <<<\n\n"
  end
end
