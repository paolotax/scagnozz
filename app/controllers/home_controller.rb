class HomeController < ApplicationController
  def index
    # Construct options for new Stripe checkout session.
    # Docs for creating Stripe checkout sessions (Pay docs):
    # — https://github.com/pay-rails/pay/blob/main/docs/stripe/8_stripe_checkout.md#how-to-use-stripe-checkout-with-pay
    #
    checkout_options = {
      mode: "subscription",
      line_items: [{
        price: "price_1OkVTHLYvpKXFQXaUwBPpeF3",
        quantity: 1,
      }],
      subscription_data: {
        trial_period_days: 7,
      },
      success_url: root_url,
      cancel_url: root_url,
    }

    # Create checkout and billing_portal URLs using the Payments::Stripe class.
    # These URLs will expire (if a user is spending a long time on the page), it's usually
    # fine, but you could move them into their own controller action if needed.
    @checkout_url = Payments::Stripe.checkout_session(current_user, checkout_options)&.url
    @billing_portal_url = Payments::Stripe.billing_portal_session(current_user)&.url
  end

  # Custom POST action for testing example Sidekiq job
  def enqeue_job
    puts "\n>>>Queued an ExampleJob to run in 1 second!<<<\n"
    ExampleJob.perform_in(1.seconds)
    redirect_to root_path
  end
end
