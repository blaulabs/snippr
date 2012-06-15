# -*- encoding : utf-8 -*-
module Snippr

  class Railtie < Rails::Railtie

    config.snippr = ActiveSupport::OrderedOptions.new

    initializer :setup_snippr, :group => :all do |app|
      Snippr.i18n = app.config.snippr.i18n
      Snippr.path = app.config.snippr.path
      Snippr::Normalizer.add app.config.snippr.normalizers if app.config.snippr.normalizers
    end

  end
end
