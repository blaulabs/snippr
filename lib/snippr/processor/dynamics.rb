# -*- encoding : utf-8 -*-
# = Snippr::Processor::Dynamics
#
# Replaces {placeholder} placeholders in the content with values taken from the given opts.
module Snippr

  module Processor

    class Dynamics

      def process(content, opts = {})
        opts.inject(content) do |c, pv|
          placeholder, value = pv
          c.gsub(regex(placeholder)) do |match|
            replacement = value.to_s
            # remember values since gsub will reset all regex $ matches
            default = $5
            method = $3
            safety = $6
            if $3 && (value.respond_to?($3) || $2 == "!")
              params = recursive_process(($4 || "").gsub(/[\t\r\n]/,""), opts).split("\",\"")
              replacement = value.send(method, *params).to_s
            elsif $3
              replacement = match
            end
            replacement = default if replacement.empty? && default
            replacement += safety.html_safe if safety
            replacement
          end
        end
      end

      private

      def regex(placeholder)
        %r{
        (              # $1: collect all but safety guard at the end
        \{             # start of dynamic value
        (!?)           # $2: use ! to call the method on an object even if :respond_to fails
        #{placeholder} # variable holding value or object
        (?:\.(.*?)     # $3: about to call an method on the 'placeholder'
        \(             # non-optional bracket to merk method call
        ["]?           # optional opening double quote
        (.*?)          # $4: parameters for method call
        ["]?           # optional closing double quote
        \))?           # mandatory closing bracket and group end
        (?:\|(.*?))?   # $5: optional default value when snippet content empty
        \}             # and thats it
        )              # end capture of variable area
        ((?!"[),])|$)  # $6: this allows he capture of method calls in method calls
        }xm
      end

      def recursive_process(parameter_string, opts)
        # simple check if there is something to do
        if parameter_string.include?("{")
          process(parameter_string, opts)
        else
          parameter_string
        end
      end

    end

  end

end
