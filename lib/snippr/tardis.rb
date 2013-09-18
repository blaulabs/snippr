# -*- encoding : utf-8 -*-
module Snippr
  class Tardis
    def self.enabled=(bool_or_block)
      if bool_or_block.kind_of?(Proc)
        @enabled_condition = bool_or_block
      else
        @enabled_condition = -> { !!bool_or_block }
      end
    end

    def self.enabled
      @enabled_condition.call
    end
  end
end
