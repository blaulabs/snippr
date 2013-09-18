# -*- encoding : utf-8 -*-
module Snippr
  module Rails
    module ControllerExtension

      private

      def activate_snippr_tardis
        if params[:snippr_tardis].present?
          session[:snippr_tardis_interval] = params[:snippr_tardis]
          Snippr::Clock.interval = session[:snippr_tardis_interval]
        end
      end

    end
  end
end
