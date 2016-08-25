module Quip
  class Sheet
    attr_reader :quip_sheet, :quip_spreadsheet
    
    def initialize(options)
      @quip_sheet = options[:quip_sheet]
      @quip_spreadsheet = options[:quip_spreadsheet]
    end
    
    # Returns the text of items in the given row `ElementTree`.
    def get_row_items(nodes)
      nodes.collect{|n| n.text.delete("\n")}
    end
    
    # Returns the header row in the given quip_spreadsheet
    def get_sheet_header_items
      get_row_items(quip_sheet.at_css("tr").children)
    end
    
    def get_rows
      quip_sheet.css("tr")
    end
    
    def get_row_by_index(index)
      get_rows[index].children
    end
    
    def get_column_by_index(index, row)
      row[index]
    end
    
    def update_spreadsheet_row(row_index, column_index, value)
      row = get_row_by_index(row_index)
      column = get_column_by_index(3, row)
      section_id = column.attribute('id').value
      
      quip_spreadsheet.quip_document.edit_document('Barfed', {
        location: Quip::Document::REPLACE_SECTION,
        section_id: section_id
      })
    end
  end
end