# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::MetaData do
  include Snippr::ViewHelper

  TEST_CONTENT = 'Hier ist jede Menge Content.'
  TEST_CONTENT_WITH_METABLOCK = "---\nyml_key: yml_value\n---\n#{TEST_CONTENT}"
  TEST_CONTENT_WITH_EMPTY_METABLOCK = "---\n#nothing here but comments\n#{TEST_CONTENT}"
  TEST_CONTENT_WITH_INCLUDE = "---\n_include:\n  - include/test\n  - include/test2\ntest: main\n---"
  TEST_CONTENT_WITH_RELATIVE_INCLUDE = "---\n_include:\n  - ./test\n  - ./test2\ntest: main\n---"

  TEST_CONTENT_WITH_MERGE = "---\n_include:\n  - merge/array1\n  - merge/array2\n---"

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

    it "returns nil if the metadata is empty" do
      result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_EMPTY_METABLOCK)
      expect(result.second).to eq({})
    end

    context "_include" do
      it "includes other front matter via the _include key" do
        result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_INCLUDE)
        expect(result.second).to eq({"this_is_also"=>"included_from_include_test2_snippet", "test"=>"main", "this_is"=>"included_from_include_test_snippet", "_include"=>["include/test", "include/test2"]})
      end

      it "includes metadata from relative include paths" do
        snippet = Snippr.load("include/main")
        result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_RELATIVE_INCLUDE, snippet)
        expect(result.second).to eq({"this_is_also"=>"included_from_include_test2_snippet", "test"=>"main", "this_is"=>"included_from_include_test_snippet", "_include"=>["./test", "./test2"]})
      end

      it "includes other front matter blocks but lets the main block win" do
        result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_INCLUDE)
        expect(result.second).to eq({"this_is_also"=>"included_from_include_test2_snippet", "test"=>"main", "this_is"=>"included_from_include_test_snippet", "_include"=>["include/test", "include/test2"]})
      end

      it "combines a hash containing an array into one" do
        # this merges/adds an array to another array when the included hashes contain the same key:
        # promotion:
        #   - a: 1
        #
        # and
        #
        # promotion:
        #   - b: 2
        #
        # will result in
        # promotion:
        #   - a: 1
        #   - b: 2
        #
        # instead of letting the later argument win:
        #
        # promotion:
        #   - b: 2
        result = Snippr::MetaData.extract([:content], TEST_CONTENT_WITH_MERGE)
        expect(result.second).to eq({"tracking"=>{"promotion"=>[{"b"=>2}, {"a"=>1}]}, "_include"=>["merge/array1", "merge/array2"]})
      end
    end

  end

end
