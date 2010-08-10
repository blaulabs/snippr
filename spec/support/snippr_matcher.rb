def define_snippr_matcher(name, custom_wrapper = false)
  Rspec::Matchers.define name do |expected, *args|

    base_name = expected.gsub /(\..+)?$/, ''
    path      = File.expand_path "../../fixtures/#{expected}", __FILE__
    wrapper   = "<!-- starting snippr: #{base_name} -->\n%s\n<!-- closing snippr: #{base_name} -->"
    wrapper   = args.shift % wrapper if custom_wrapper
    content   = yield *([path] + args)
    wrapped   = wrapper % content

    match do |actual|
      wrapped == actual
    end

    failure_message_for_should do |actual|
      "expected to load snippr '#{base_name}' from file '#{path}' with content:\n#{wrapped}\nbut got:\n#{actual}"
    end

  end
end

define_snippr_matcher :load_snippr do |path|
  IO.read path rescue nil
end
define_snippr_matcher :load_snippr_with_content do |path, content|
  content
end
define_snippr_matcher :load_snippr_with_wrapper, true  do |path|
  IO.read path rescue nil
end
