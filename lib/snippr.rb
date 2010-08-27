Dir[File.expand_path '../snippr/*.rb', __FILE__].each {|f| require f}
Dir[File.expand_path '../snippr/processor/*.rb', __FILE__].each {|f| require f}

Snippr::Processor.processors << Snippr::Processor::Dynamics.new
Snippr::Processor.processors << Snippr::Processor::Links.new
Snippr::Processor.processors << Snippr::Processor::Wikilinks.new
