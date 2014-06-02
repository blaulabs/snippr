# -*- encoding : utf-8 -*-
# = Snippr::Processor::Dynamics
#
# Replaces {placeholder} placeholders in the content with values taken from the given opts.
module Snippr

  module Processor

    class Dynamics

      def process(content, opts = {})
        matches = []
        # convert array of arrays to array of matchdata
        content.scan(regex) { matches << $~ }

        matches.each do |match_data|
          replacement = match_data[:all]
          value = opts[match_data[:placeholder].to_sym]
          if match_data[:method] && (value.respond_to?(match_data[:method]) || match_data[:respond_to_check] == "!")
            params = (match_data[:parameters] || "").gsub(/[\t\r\n]/,"").split("\",\"")
            replacement = value.send(match_data[:method], *params).to_s
          elsif match_data[:method]
            replacement = match_data[:all]
          else
            replacement = value.to_s
          end

          # default set?
          replacement = match_data[:default_when_empty].strip if replacement.empty? && match_data[:default_when_empty]

          content.gsub!(match_data[:all], replacement)
        end
        content
      end

      private

      def regex
        %r{
        (?<all>                           # group caputing all
        \{                                # start of dynamic value
        (?<respond_to_check>!?)           # use ! to call the method on an object even if :respond_to fails
        (?<placeholder>.*?)               # variable holding value or object
        (?:\.(?<method>.*?)               # about to call an method on the 'placeholder'
        \(                                # non-optional bracket to merk method call
        ["]?                              # optional opening double quote
        (?<parameters>.*?)                # paramters for method call
        ["]?                              # optional closing double quote
        \))?                              # mandatory closing bracket and group end
        (\|(?<default_when_empty>.*?))?   # optional default value when snippet content empty
        \}                                # and thats it
        )                                 # end all group
        }xm
      end

    end

  end

end
