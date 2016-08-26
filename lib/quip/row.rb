module Quip
  class Sheet
    class Row < Quip::Document
      attr_reader :is_header, :columns
      
      def initialize(options)
        @is_header = options[:is_header] || false
        @columns = {}
        super
      end
    end
  end
end