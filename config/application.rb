require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Cbcl4
  class Application < Rails::Application

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '/api_login/open', :headers => :any, :methods => [:get, :post, :options]
        resource '/api_login/*', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/start', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/login', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/start/*', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/login/*', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/answer_reports/show', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/answer_reports/*', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/export/*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.encoding = "utf-8"
    config.assets.enabled = true

    config.i18n.default_locale = :'da-DK'
    # config.i18n.default_locale = :'en'
    # I18n.locale = config.i18n.locale = config.i18n.default_locale

    config.exceptions_app = self.routes

    config.autoload_paths += %W(#{config.root}/lib)

    config.middleware.use "PDFKit::Middleware"


    config.secrets = YAML::load_file('config/secrets.yml')
  end
end
