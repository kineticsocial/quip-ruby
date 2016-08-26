module Quip
  class Sheet < Quip::Document
    attr_reader :quip_sheet
    
    def initialize(options)
      @quip_sheet = options[:quip_sheet]
      super
    end
    
    # Returns the text of items in the given row `ElementTree`.
    def get_row_items(nodes)
      nodes.collect{|n| n.text.delete("\n")}
    end
    
    # Returns the header row in the given quip_spreadsheet
    def get_header_items
      get_row_items(quip_sheet.at_css("tr").children)
    end
    
    # Dehumanize
    def get_header_keys
      get_row_items(quip_sheet.at_css("tr").children).collect{|n|
        n.to_s.dup.downcase.gsub(/ +/,'_')
      }
    end
    
    def get_rows
      header_keys = get_header_keys
      [].tap{|a|
        quip_sheet.css("tr").each_with_index do |row, i|
          _row = Quip::Sheet::Row.new(is_header: (i == 0), thread_id: thread_id, client: client)
          
          row.children.each_with_index.each do |col, j|
            _row.columns[header_keys[i]] ||= [] 
            _row.columns[header_keys[i]] << Quip::Sheet::Cell.new({
              text: col.text.gsub(/ +/,'_'), 
              section_id: col.attribute('id').value,
              quip_document: _row,
              thread_id: thread_id, 
              client: client
            })
          end
          
          a << _row
        end
      }
    end
    
    def get_row_by_index(index)
      get_rows[index].children
    end
    
    def get_column_by_index(index, row)
      row[index]
    end
  end
end