module Quip
  class Sheet
    class Cell < Quip::Document
      attr_reader :section_id, :text, :node
      
      def initialize(options)
        @section_id = options[:section_id]
        @text = options[:text]
        @node = options[:node]
        super
      end
      
      def update(_text)
        @text = _text
        edit_document(text, {
          location: Quip::Document::REPLACE_SECTION,
          section_id: section_id
        })
      end
    end
  end
end  