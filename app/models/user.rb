# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  billing_state          :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  image_url              :string
#  name                   :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord

  # [RailsNotes UI Addition]
  # Include Pay helpers for payments with Stripe/Paddle.
  # You should read the Pay gem documentation!
  # - https://github.com/pay-rails/pay/blob/main/docs/1_installation.md
  #
  # Set the default payment processor for a new User:
  # pay_customer default_payment_processor: :stripe # if using [Stripe]
  pay_customer default_payment_processor: :paddle_billing # if using [Paddle]

  # [RailsNotes UI Addition]
  # Tiny helper to grab a User's billing state.
  #
  def billing_state(options = {})
    if payment_processor.on_trial_or_subscribed?(**options)
      :subscribed
    else
      :unsubscribed
    end
  end

  # [RailsNotes UI Addition]
  # Add Devise helpers to the User model.
  # Others available — :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 github]

  # [RailsNotes UI Addition]
  # If a new User has no image_url, assign it the default avatar image.
  # OAuthed logins usually include an avatar image_url, but username+password login does not.
  #
  before_create -> { self.image_url = "/default_avatar.png" unless image_url.present? }

  # [RailsNotes UI Addition]
  # Some payment processors (ie: paddle_billing) only generate a Pay::Customer after we call #payment_processor.customer.
  # We call it here, immediately after creating the user, so a Pay::Customer record always exists.
  #
  after_create_commit -> { puts self.payment_processor.customer }

  # [RailsNotes UI Addition]
  #
  # Handles grabbing data from an Omniauth response (for OAuth/Social login).
  # If you're adding Omniauth to more models, I would extract this logic into a PORO or concern.
  # I've left it here for now for simpler code.
  #
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image_url = auth.info.image

      # user.skip_confirmation! # Uncomment if using Devise Confirmable
    end
  end
end
