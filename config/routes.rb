# [RailsNotes UI Addition]
# Include Sidekiq web dashboard by default, and enable username/password login.
# - username: admin
# - password: password
#
require "sidekiq/web"
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "admin" && password == "password"
end
#
# You could encode your username & password in credentials if you'd prefer:
# username == Rails.application.credentials.dig(:sidekiq, :admin_username) && password == Rails.application.credentials.dig(:sidekiq, :admin_password)

# [RailsNotes UI Addition]
# Setup some simple routes for the starter kit.
#
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  root "home#index"
  post "enqeue_job", to: "home#enqeue_job"

  # [RailsNotes UI Addition]
  # Setup Devise routes for User, including custom omniauth_callbacks controller.
  # This _must_ come before any other User routes.
  #
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
