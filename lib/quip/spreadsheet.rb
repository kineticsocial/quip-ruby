module Quip
  class Spreadsheet < Quip::Document
    def initialize(options)
      super
    end
    
    def get_named_sheet(name)
      doc = parse_document_html
      element = doc.at_css("//*[@title='#{name}']")
      Quip::Sheet.new(
        spreadsheet: self,
        accessor_method: :get_named_sheet,
        accessor_value: name,
        quip_sheet: element, 
        thread_id: thread_id, 
        client: client
      )
    end
    
    # Returns the `ElementTree` of the first spreadsheet in the document.
    # If `thread_id` is given, we download the document. If you have
    # already downloaded the document, you can specify `document_html`
    # directly
    def get_first_sheet
      accessor_method = :get_first_sheet
      Quip::Sheet.new(
        spreadsheet: self,
        accessor_method: :get_first_sheet, 
        quip_sheet: get_container("table", 0), 
        thread_id: thread_id, 
        client: client
      )
    end
    
    # Like `get_first_spreadsheet`, but the last spreadsheet.
    def get_last_sheet
      accessor_method = :get_last_sheet
      Quip::Sheet.new(
        spreadsheet: self,
        accessor_method: :get_last_sheet, 
        quip_sheet: get_container("table", -1), 
        thread_id: thread_id, 
        client: client
      )
    end
    
    def get_container(container, index)
      doc = parse_document_html
      results = doc.css("//#{container}")
      results[index]
    end
  end
end