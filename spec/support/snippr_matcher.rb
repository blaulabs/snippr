def define_snippr_matcher(name)
  Rspec::Matchers.define name do |expected, *args|

    base_name = expected.gsub /(\..+)?$/, ''
    path      = File.expand_path "../../fixtures/#{expected}", __FILE__
    content   = "<!-- starting snippr: #{base_name} -->\n#{yield *([path] + args)}\n<!-- closing snippr: #{base_name} -->"

    match do |actual|
      content == actual
    end

    failure_message_for_should do |actual|
      "expected to load snippr '#{base_name}' from file '#{path}' with content:\n#{content}\nbut got:\n#{actual}"
    end

  end
end

define_snippr_matcher :load_snippr do |path|
  IO.read(path).strip rescue nil
end
define_snippr_matcher :load_snippr_with_content do |path, content|
  content
end
