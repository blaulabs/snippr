# -*- encoding : utf-8 -*-
require 'active_support/core_ext'

require 'snippr/snippr'
require 'snippr/snip'
require 'snippr/i18n'
require 'snippr/links'
require 'snippr/meta_data'
require 'snippr/normalizer'
require 'snippr/path'
require 'snippr/processor'
require 'snippr/railtie' if defined?(Rails)
require 'snippr/view_helper'

require 'snippr/normalizer/camelizer'
require 'snippr/normalizer/de_rester'

require 'snippr/processor/dynamics'
require 'snippr/processor/functions'
require 'snippr/processor/links'
require 'snippr/processor/wikilinks'

Snippr::Normalizer.normalizers << Snippr::Normalizer::Camelizer.new
# don't use DeRester this for all apps, but configure it as needed
# Snippr::Normalizer.normalizers << Snippr::Normalizer::DeRester.new

Snippr::Processor.processors << Snippr::Processor::Functions.new
Snippr::Processor.processors << Snippr::Processor::Dynamics.new
Snippr::Processor.processors << Snippr::Processor::Links.new
Snippr::Processor.processors << Snippr::Processor::Wikilinks.new
