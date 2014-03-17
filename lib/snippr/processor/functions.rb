# -*- encoding : utf-8 -*-
# = Snippr::Processor::Functions
#
# Processes several functions in {command:options} syntax.
module Snippr

  module Processor

    class Functions

      def process(content, opts = {})
        content.scan(/\{(.*?):(.*?)\}/) do |match|
          command, func_options = match
          options = opts.merge(hashify(func_options))
          command = "cmd_#{command}"
          content = send(command, content, options, func_options) if respond_to?(command, true)
        end
        content
      end

    private

      # expand another snip
      # {snip:path/to/snippet}
      def cmd_snip(unprocessed_content, opts, original_options)
        path = opts[:default].split("/")
        snip_content = Snippr::Snip.new(*path + [opts]).content
        unprocessed_content.gsub("{snip:#{original_options}}", snip_content)
      end

      # home
      # home,var=1
      # home,var1="1"
      # home,var1="1,2,3"
      def hashify(func_options="")
        options = {}

        # replace comma temporarily
        func_options.scan(/(["'])?(.*?)(\1){1}/).each do |delimiter, value, _|
          func_options.gsub!("#{delimiter}#{value}#{delimiter}", "#{delimiter}#{value.gsub(",", "@@comma@@")}#{delimiter}")
        end

        # Split on comma which is secure now
        func_options.split(",").each do |option|
          opt_key, opt_value = option.split("=")
          unless opt_value
            opt_value = opt_key
            opt_key = :default
          end
          options[opt_key.to_sym] = opt_value.match(/^["']?(.*?)["']?$/)[1].gsub("@@comma@@", ",")
        end
        options
      end

    end

  end

end
