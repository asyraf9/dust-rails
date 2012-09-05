require 'rails'

module Dust
  module Rails
    class Railtie < ::Rails::Railtie
      config.dust = ActiveSupport::OrderedOptions.new

      initializer "dust.configure" do |app|
        Dust.configure do |config|
          config.template_root = app.config.dust[:template_root] || 'app/assets/javascripts/templates/'
          config.naming_convention = app.config.dust[:naming_convention] || 'template_root'
        end
      end
    end
  end
end
