# lib/tasks/my_cli.rb
require "thor"
require "active_support/inflector"

class SetupCLI < Thor
  include Thor::Actions

  desc "run_bundle", "Run bundle install"

  def run_bundle
    title ">>> Step 4: Running 'bundle install'"
    run("bundle install")
  end

  desc "run_rails_db_prepare", "Run rails db:prepare"

  def run_rails_db_prepare
    title ">>> Step 5: Running 'rails db:prepare'"
    run("rails db:prepare")
  end

  desc "setup_git_remotes", "Set correct git remotes for app"

  def setup_git_remotes
    title ">>> Step 2: Setting correct git remotes for the template"

    if git_remote_exists?("railsnotesui")
      warn("'railsnotesui' remote already exists, skipping rename")
      return
    end

    # Renaming existing 'origin' to 'railsnotesui'
    say "Renaming existing 'origin' remote to 'railsnotesui'..."
    run("git remote rename origin railsnotesui")

    say "Making 'railsnotesui' remote fetch-only"
    run("git remote set-url --push railsnotesui DISABLED")

    # Prompting for new Git URL
    say "Enter new GitHub repo reference (leave blank to skip). This will add the GitHub repository as the new 'origin' and push to it."
    new_git_url = ask "GitHub repo reference (git@...):"

    unless new_git_url.empty?
      # Adding new 'origin' remote
      say "Adding new 'origin' remote: #{new_git_url}"
      run("git remote add origin #{new_git_url}")

      # Pushing to new 'origin' main branch
      say "Pushing to 'origin' main branch..."
      run("git push -u origin main")
    else
      say "No new Git URL provided, skipping addition of new 'origin' remote."
      say "You should add one yourself later with:"
      say "git remote add origin https://github.com/YOUR_GITHUB_REPO_URL && git push -u origin main"
    end
  end

  desc "rename_app", "Rename the Rails application"

  def rename_app
    title ">>> Step 1: Renaming your app"
    new_name = ask "New name for your Rails app (TitleCase):"

    if new_name.blank?
      say "Setup aborted: No name provided."
      return
    end

    camel_cased_name = new_name.underscore.camelize
    underscore_cased_name = new_name.underscore

    # Update application.html.erb
    file_path = "app/views/layouts/application.html.erb"
    replace_in_file(file_path, /<title>.*<\/title>/, "<title>#{camel_cased_name}</title>")

    # Update application.rb
    file_path = "config/application.rb"
    replace_in_file(file_path, /module \w+/, "module #{camel_cased_name}")

    # Update cable.yml
    file_path = "config/cable.yml"
    replace_in_file(file_path, /channel_prefix: \w+_production/, "channel_prefix: #{underscore_cased_name}_production")

    # Update database.yml
    file_path = "config/database.yml"
    text = File.read(file_path)
    new_contents = text.gsub(/database: \w+_(development|test|production)/) do |match|
      "database: #{underscore_cased_name}_#{match.split("_").last}"
    end
    new_contents.gsub!(/username: \w+/, "username: #{underscore_cased_name}")
    new_contents.gsub!(/password: <%= ENV\["\w+_DATABASE_PASSWORD"\] %>/, "password: <%= ENV[\"#{underscore_cased_name.upcase}_DATABASE_PASSWORD\"] %>")
    File.open(file_path, "w") { |file| file.puts new_contents }

    say "Application renamed to #{camel_cased_name}"
  end

  desc "choose_test_framework", "Choose a test framework"

  def choose_test_framework
    options = ["minitest", "rspec", "skip"]
    selected_option = nil

    title ">>> Step 3: Choose your test framework"
    say "This template includes both Minitest and RSpec."
    say "You should decide which one you want to use, and remove the other."
    say "This script _won't_ remove them for you —"
    say "check the docs for more instructions (under '[Tests] Testing your app')"
  end

  no_commands do
    def replace_in_file(file_path, pattern, replacement)
      text = File.read(file_path)
      new_contents = text.gsub(pattern, replacement)
      File.open(file_path, "w") { |file| file.puts new_contents }
    end

    def rm_directory(dirpath)
      if File.directory?(dirpath)
        FileUtils.rm_rf(dirpath)
        say "#{dirpath} has been deleted."
      else
        say "#{dirpath} does not exist or has already been deleted."
      end
    end

    def rm_file(filepath)
      if File.exist?(filepath)
        FileUtils.rm(filepath)
        say "#{filepath} has been deleted."
      else
        say "#{filepath} file does not exist or has already been deleted."
      end
    end

    def git_remote_exists?(name)
      remotes = `git remote`.split("\n")
      remotes.include?(name)
    end

    # Helper method to execute shell commands and print the outcome
    def run(command)
      if system(command)
        success("Successfully executed: #{command}")
      else
        fail("Failed to exectute: #{command}")
      end
    end

    def success(message)
      say message, :green
    end

    def warn(message)
      say message, :yellow
    end

    def fail(message)
      say message, :red
    end

    def title(message)
      say "\n"
      say message, :blue
    end
  end
end
