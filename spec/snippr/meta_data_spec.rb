# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::MetaData do
  include Snippr::ViewHelper

  TEST_CONTENT = 'Hier ist jede Menge Content.'
  TEST_CONTENT_WITH_METABLOCK = "---\nyml_key: yml_value\n---\n#{TEST_CONTENT}"

  describe '.extract' do
    it 'returns an array with 2 elements [contentstring, metahash]' do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT)
      expect(result).to be_a Array
      expect(result.size).to eq(2)
      expect(result.first).to be_a String
      expect(result.second).to be_a Hash
    end

    it 'returns raw content for non existing metablock' do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT)
      expect(result.first).to eq TEST_CONTENT
    end

    it 'returns empty hash for non existing metablock' do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT)
      expect(result.second).to eq({})
    end

    it 'returns a hash from given metablock' do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_METABLOCK)
      expect(result.second).to eq({'yml_key' => 'yml_value'})
    end

    it 'returns content as content without metablock' do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_METABLOCK)
      expect(result.first).to eq TEST_CONTENT
    end
  end

end
