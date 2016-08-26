module Quip
  class Sheet
    class Cell < Quip::Document
      attr_reader :section_id, :text
      
      def initialize(options)
        @section_id = options[:section_id]
        @text = options[:text]
        super
      end
      
      def update(text)
        quip_spreadsheet.quip_document.edit_document(text, {
          location: Quip::Document::REPLACE_SECTION,
          section_id: section_id
        })
      end
    end
  end
end  