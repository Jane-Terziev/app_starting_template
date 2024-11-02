require "devise"
require "importmap-rails"

module Authentication
  class Engine < ::Rails::Engine
    isolate_namespace Authentication

    initializer "authentication.devise" do
      ::Devise.setup do |config|
        config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"
        require "devise/orm/active_record"
        config.case_insensitive_keys = [ :email ]
        config.strip_whitespace_keys = [ :email ]
        config.skip_session_storage = [ :http_auth ]
        config.stretches = Rails.env.test? ? 1 : 12
        config.reconfirmable = true
        config.expire_all_remember_me_on_sign_out = true
        config.password_length = 6..128
        config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
        config.reset_password_within = 6.hours
        config.sign_out_via = :delete
        config.responder.error_status = :unprocessable_entity
        config.responder.redirect_status = :see_other
      end
    end

    initializer "authentication.assets" do |app|
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.paths << root.join("app/assets/images")
      app.config.assets.paths << root.join("app/javascript")
    end

    initializer "authentication.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end

    initializer "authentication.migrations" do |app|
      app.config.paths["db/migrate"] << root.join("db/migrate")
    end

    config.after_initialize do
      Dry::System.register_provider_source(:authentication, group: :authentication) do
        prepare do
          register("authentication.user_repository") { Authentication::User }
        end

        start do
          event_publisher = App::Container["events.publisher"]
        end
      end

      App::Container.register_provider(:authentication, from: :authentication)
      App::Container.start(:authentication) unless Rails.env.test?
    end
  end
end
