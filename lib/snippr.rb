require 'active_support/core_ext'

Dir[File.expand_path '../snippr/*.rb', __FILE__].each {|f| require f}
Dir[File.expand_path '../snippr/normalizer/*.rb', __FILE__].each {|f| require f}
Dir[File.expand_path '../snippr/processor/*.rb', __FILE__].each {|f| require f}

Snippr::Normalizer.normalizers << Snippr::Normalizer::Camelizer.new
# don't use DeRester this for all apps, but configure it as needed
# Snippr::Normalizer.normalizers << Snippr::Normalizer::DeRester.new

Snippr::Processor.processors << Snippr::Processor::Functions.new
Snippr::Processor.processors << Snippr::Processor::Dynamics.new
Snippr::Processor.processors << Snippr::Processor::Links.new
Snippr::Processor.processors << Snippr::Processor::Wikilinks.new
