require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AppName
  class Application < Rails::Application
    config.hosts << /.*/
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths += %W[#{config.root}/lib/utils]
    config.autoload_paths += %W[#{config.root}/lib/generators]
  end
end
