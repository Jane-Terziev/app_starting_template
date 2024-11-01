require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AppName
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths << "#{config.root}/lib/utils"
    config.eager_load_paths << "#{config.root}/lib/utils"
  end
end
