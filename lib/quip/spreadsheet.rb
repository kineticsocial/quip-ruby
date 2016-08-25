module Quip
  class Spreadsheet
    attr_reader :quip_document
  
    def initialize(options)
      @quip_document = Quip::Document.new(options)
    end
  
    def get_named_sheet(name)
      doc = quip_document.parse_document_html
      element = doc.at_css(".//*[@title='#{name}']")
      Quip::Sheet.new(quip_sheet: element, quip_spreadsheet: self)
    end
    
    # Returns the `ElementTree` of the first spreadsheet in the document.
    # If `thread_id` is given, we download the document. If you have
    # already downloaded the document, you can specify `document_html`
    # directly
    def get_first_sheet
      quip_document.document_html
      Quip::Sheet.new(quip_sheet: get_container("table", 0), quip_spreadsheet: self)
    end
    
    # Like `get_first_spreadsheet`, but the last spreadsheet.
    def get_last_sheet
      Quip::Sheet.new(quip_sheet: get_container("table", -1), quip_spreadsheet: self)
    end
    
    def get_container(container, index)
      doc = quip_document.parse_document_html
      results = doc.css("//#{container}")
      results[index]
    end
  end
end