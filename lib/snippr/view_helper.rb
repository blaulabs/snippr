# -*- encoding : utf-8 -*-
# = Snippr::ViewHelper
#
# This module is automatically included into +ActionView::Base+ when using the Snippr
# component with Rails. It provides a +snippr+ helper method for loading snippr files.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
#   %h1 Conditional output
#   - snippr :topup, :conditional_snippr do |snip|
#     #cond= snip
module Snippr
  module ViewHelper

    # Returns a snippr specified via +args+.
    def snippr(*args)
      snip = Snip.new *add_view_to_snippr_args(args)
      content = snip.content.html_safe

      if block_given?
        if snip.missing? || snip.blank?
          concat content
        elsif content.strip.present?
          yield content
        end
        0
      else
        extend_snip_content(content, snip)
      end
    end

    def snippr_with_path(*args, &block)
      path = if controller_name == "pages"
        params[:id].split('/')
      else
        [controller_name, params[:action]]
      end.compact.map { |e| e.to_s.camelize(:lower).to_sym }
      snippr(*(path + args), &block)
    end

  private

    def add_view_to_snippr_args(args)
      variables = args.last.kind_of?(Hash) ? args.pop : {}
      variables[:view] = self
      args << variables
      args
    end

    def extend_snip_content(content, snip)
      content.class_eval %(
        def missing?
          #{snip.missing?}
        end
        def exists?
          #{!snip.missing?}
        end
        def meta(key = nil)
          meta = #{snip.meta.inspect}
          key ? meta[key] : meta
        end
      )
      content
    end

  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, Snippr::ViewHelper
end
