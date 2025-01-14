# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../lib/middleware/jwt_middleware'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Convection
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.paths.add 'app', glob: '**/*.rb'

    config.eager_load_paths += %W(
      #{config.root}/lib
      #{Rails.root.join('app', 'events')}
      #{Rails.root.join('app', 'services')}
      #{Rails.root.join('app', 'graph')}
      #{Rails.root.join('app', 'controllers', 'concerns')}
    )

    # include JWT middleware
    config.middleware.use ::JwtMiddleware

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :options]
      end
    end
  end
end
