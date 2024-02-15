module Payments
  class Stripe
    class << self
      # Generate new Stripe checkout session object.
      # Returns the entire session; you need to redirect_to the url —
      # @checkout_url = Payments::Stripe.checkout_session(current_user, options).url
      #
      # args:
      # - current_user: the User this checkout is for (almost always current_user)
      # - options: a hash of options to build up the checkout
      #   - Create a price for your line_items in your Stripe product cataloge: https://dashboard.stripe.com/test/products
      #
      # HIGHLY RECOMMEND reading the Pay docs - https://github.com/pay-rails/pay/blob/main/docs/stripe/8_stripe_checkout.md#how-to-use-stripe-checkout-with-pay
      #
      def checkout_session(current_user, options = {})
        return nil if current_user.nil?
        return nil unless current_user.payment_processor.stripe?

        current_user&.payment_processor&.checkout(**options)
      end

      # Generate Stripe billing portal object.
      # Returns the entire billing portal session; you need to redirect_to the url —
      # @billing_portal_url = Payments::Stripe.billing_portal_session(current_user).url
      #
      # args:
      # - current_user: the User this billing portal is for (almost always current_user)
      #
      # docs - https://github.com/pay-rails/pay/blob/main/docs/stripe/8_stripe_checkout.md#stripe-customer-billing-portal
      #
      def billing_portal_session(current_user)
        return nil if current_user.nil?
        return nil unless current_user.payment_processor.stripe?

        current_user&.payment_processor&.billing_portal
      end
    end
  end
end
