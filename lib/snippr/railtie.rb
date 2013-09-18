# -*- encoding : utf-8 -*-
module Snippr
  class Railtie < Rails::Railtie

    config.snippr = ActiveSupport::OrderedOptions.new

    config.before_configuration do |app|
      app.config.paths["app/helpers"] << File.expand_path("../../app/helpers", __FILE__)
      app.config.paths["app/views"] << File.expand_path("../../app/views", __FILE__)
    end

    initializer :setup_snippr, :group => :all do |app|
      Snippr.i18n = app.config.snippr.i18n
      Snippr.path = app.config.snippr.path
      Snippr.tardis_enabled = app.config.snippr.tardis_enabled

      Snippr::Normalizer.add app.config.snippr.normalizers if app.config.snippr.normalizers
      Snippr.adjust_urls_except += Array(app.config.snippr.adjust_urls_except) if app.config.snippr.adjust_urls_except

      if Snippr.tardis_enabled
        require "snippr/rails/controller_extension"

        app.config.paths["app/assets"] << File.expand_path("../../app/assets", __FILE__)
        app.config.assets.precompile << "snippr_tardis/snippr_tardis.css"
        app.config.assets.precompile << "snippr_tardis/snippr_tardis.js"

        ActionController::Base.send(:include, Snippr::Rails::ControllerExtension)
        ActionController::Base.send(:prepend_before_filter, :activate_snippr_tardis)
      end
    end

  end
end
