require_relative "setup_cli"

namespace :app do
  desc "Setup the application"
  task :setup do
    puts "*\n* Welcome to the RailsNotes UI setup script!\n*\n"

    SetupCLI.start(["rename_app"])
    SetupCLI.start(["setup_git_remotes"])
    SetupCLI.start(["choose_test_framework"])
    SetupCLI.start(["run_bundle"])
    SetupCLI.start(["run_rails_db_prepare"])
  end
end
