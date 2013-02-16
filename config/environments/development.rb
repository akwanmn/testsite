Phoenix::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # active merchant configuration
  config.after_initialize do
    # seller - 361049113
    # buyer - 361045023
    # 361048907
    ActiveMerchant::Billing::Base.mode = :test
    # ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    #     login: '2d4l_1361049140_biz_api1.conspyre.com',
    #     password: '8C3PYEP55UMW8R6E',
    #     signature: 'AFcWxV21C7fd0v3bYYYRCpSSRl31AwWgobwkUfYsnQXYvHgbx.-PXBPP'
    #   )

    ::GATEWAY = ActiveMerchant::Billing::BraintreeGateway.new(
      merchant_id: 'bfy9mfzc334g248f',
      public_key: '5zy5bnvfzvyhvsbx',
      private_key: '4346da8ae8cb3216b1be975e6d7f1059'
    )
    # Access as GATEWAY
  end
end
