# -*- encoding : utf-8 -*-
module Snippr

  class Railtie < Rails::Railtie

    config.snippr = ActiveSupport::OrderedOptions.new

    initializer :setup_snippr, :group => :all do |app|
      Snippr.i18n = app.config.snippr.i18n
      Snippr.path = app.config.snippr.path
      Snippr::Normalizer.add app.config.snippr.normalizers if app.config.snippr.normalizers
      Snippr.adjust_urls_except += Array(app.config.snippr.adjust_urls_except) if app.config.snippr.adjust_urls_except
    end

  end
end
