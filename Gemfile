source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.1.3"
gem "pg", "~> 1.5"
gem "puma", "~> 6.0"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # [RailsNotes UI Addition]
  # Include RSpec for testing alongside Minitest (pick one, delete the other)
  gem "rspec-rails", "~> 6.1"
end

group :development do
  gem "web-console"             # Use console on exceptions pages [https://github.com/rails/web-console]

  # [RailsNotes UI Addition]
  # - include annotate since it's incredibly useful
  # - include letter_opener for testing emails in development
  #
  gem "annotate", "~> 3.2"      # annotate models, specs etc
  gem "letter_opener", "~> 1.8" # preview emails in development
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# [RailsNotes UI Addition]
# Include main gems here —
# - Sidekiq + Redis for background jobs
# - Devise gems for login + OAuth
#
## Background Jobs
#
# This template uses Sidekiq for background jobs (and Redis for a job queue).
# Sidekiq docs — https://github.com/sidekiq/sidekiq#readme
#
gem "redis", "~> 5.1"
gem "sidekiq", "~> 7.2"

## Authentication
#
# This template uses Devise for authentication and social logins (OAuth)
# Devise docs - https://github.com/heartcombo/devise#readme
#
gem "devise", "~> 4.9"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "omniauth-google-oauth2", "~> 1.1"
gem "omniauth-github", "~> 2.0"

## Payments
#
# This template uses the Pay gem to handle payments across multiple payment providers
# Pay docs - https://github.com/pay-rails/pay#readme
#
gem "pay", "~> 7.0"
gem "stripe", "~> 10.0"
gem "paddle", "~> 2.1"

## Extras
#
# ViewComponents:
# A better version of partials (included for RailsNotes UI email templates/components)
# (optional, you never have to use them if you don't want to!)
gem "view_component", "~> 3.7"
