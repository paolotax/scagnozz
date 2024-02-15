# [RailsNotes UI Addition]
# Custom OmniauthCallbacksController to handle OAuth for different providers.
# If you add a new provider, add a new method here too.
#
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # Example callback URL:
  # http://localhost:3000/users/auth/github/callback
  def github
    login_or_create_oauth_user_for(:github)
  end

  # Example callback URL:
  # http://localhost:3000/users/auth/google_oauth2/callback
  def google_oauth2
    login_or_create_oauth_user_for(:google_oauth2)
  end

  # Redirect User if OAuth fails for some reason
  def failure
    redirect_to root_path
  end

  private

  # Handles OAuth user login to your app (if they've logged in before).
  # If they're new to your app, creates a new User.
  # (The check for whether a User exists in your app happens in User.from_omniauth).
  #
  # args:
  # - provider: A :symbol matching the name of your omniauth provider.
  #             Should match the symbol passed to config.omniauth in config/initializers/devise.rb
  def login_or_create_oauth_user_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: omniauth_provider_name(provider)) if is_navigational_format?
    else
      session["devise.#{provider.to_s}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # "name" <- :symbol mapping function
  def omniauth_provider_name(provider)
    return "Google" if :google_oauth2
    return "Github" if :github
  end
end
