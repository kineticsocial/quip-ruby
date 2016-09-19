module Quip
  class Sheet
    class Row < Quip::Document
      attr_reader :is_header, :columns, :section_id, :index
      
      def initialize(options)
        @section_id = options[:section_id]
        @is_header = options[:is_header] || false
        @index = options[:index]
        @columns = {}
        super
      end
      
      def delete()
        edit_document('', {
          location: Quip::Document::REPLACE_SECTION,
          section_id: section_id
        })
      end
      
      def insert_before(values = {})
        insert_row(values, Quip::Document::BEFORE_SECTION)
      end
      
      def insert_after(values = {})
        insert_row(values, Quip::Document::AFTER_SECTION)
      end
      
      def insert_row(values, location)
        _row = %{
          <tr>#{columns.keys.collect{|k| "<td>#{values[k]}</td>"}.join('')}</tr>
        }
        
        edit_document(_row, {
          location: location,
          section_id: section_id
        })
      end
    end
  end
end