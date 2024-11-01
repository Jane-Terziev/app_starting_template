source "https://rubygems.org"

gem "rails", "~> 8.0.0.beta1"

# Infrastructure
gem "puma", ">= 5.0" # Server
gem "pg" # Postgres Database
gem "solid_cache" # Database backed caching
gem "solid_queue" # Database backed background worker
gem "solid_cable" # Database backed websocket notification

# Frontend
gem "sprockets-rails"
gem "importmap-rails" # Javascript with ESM import maps
gem "turbo-rails" # SPA
gem "stimulus-rails" # Frontend framework
gem "slim"

# Architecture
gem "dry-validation"
gem "dry-system", "~> 1"
gem "rails_event_store", "~> 2.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false # Analysis for security vulnerabilities
  gem "rubocop-rails-omakase", require: false # Code lint
  gem "rspec-rails"
  gem "dotenv-rails"
end

gem "bootsnap", require: false # Faster application bootup
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle tzinfo-data gem
gem "psych", "~> 3.3" # https://bugs.ruby-lang.org/issues/17866

# Engines
gem "authentication", path: "engines/authentication"
