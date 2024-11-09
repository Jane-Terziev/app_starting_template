require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AppName
  class Application < Rails::Application
    config.hosts << /.*/
    config.load_defaults 8.0
    Rails.autoloaders.main.ignore(Rails.root.join("lib/generators/engines/engine_generator.rb"))
    config.autoload_lib(ignore: %w[assets tasks])
    config.eager_load_paths << "#{config.root}/lib/utils"
  end
end
