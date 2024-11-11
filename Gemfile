source "https://rubygems.org"

gem "rails", "~> 8.0"

# Infrastructure
gem "puma", ">= 5.0" # Server
gem "pg" # Postgres Database
gem "solid_cache" # Database backed caching
gem "solid_queue" # Database backed background worker
gem "solid_cable" # Database backed websocket notification
gem "kamal" # Deployment tool
gem "thruster"
gem "mission_control-jobs" # UI for solid queue

# Frontend
gem "propshaft"
gem "importmap-rails" # Javascript with ESM import maps
gem "turbo-rails" # SPA
gem "stimulus-rails" # Frontend framework
gem "slim"

# 3rd party integrations
gem "newrelic_rpm" # APM and error tracker

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false # Analysis for security vulnerabilities
  gem "rubocop-rails-omakase", require: false # Code lint
  gem "rspec-rails"
  gem "dotenv-rails"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "bootsnap", require: false # Faster application bootup
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle tzinfo-data gem
gem "psych", "~> 5.2" # https://bugs.ruby-lang.org/issues/17866

# Engines
gem "authentication", path: "engines/authentication"
