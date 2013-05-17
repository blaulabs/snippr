# -*- encoding : utf-8 -*-
module Snippr
  class SegmentParser

    SEGMENT_MARKER = /====\s(.*?):\s(.*?)\s====/

    def initialize(raw_content)
      @raw_content = insert_dummy_filter(raw_content.clone)
    end

    def content
      @cotennt ||= @raw_content.scan(/====$\n(.*?)\n?(?:\z|====)/m)[find_active_segment][0]
    end

    private

    def filters
      @filters ||= extract_filters
    end

    def find_active_segment
      active_segment = 0
      filters.each_with_index do |filter, filter_index|
        filter_class = Snippr::SegmentFilter::Base.filters.detect {|c| c.name == "Snippr::SegmentFilter::#{camel_case(filter[:name])}" }
        active_segment = filter_index and break if filter_class && filter_class.new(filter[:value]).active?
      end
      active_segment
    end

    def extract_filters
      @raw_content.scan(/^====\s(.*?):\s(.*?)\s====$/).map {|filter| { :name => filter[0], :value => filter[1] } }
    end

    def camel_case(str)
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split('_').map{|e| e.capitalize}.join
    end

    def insert_dummy_filter(content)
      if content !~ /\A#{SEGMENT_MARKER}$/
        content.prepend("==== dummy: filter ====\n")
      end
      content
    end
  end
end
