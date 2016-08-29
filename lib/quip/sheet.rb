module Quip
  class Sheet < Quip::Document
    attr_reader :quip_sheet
    
    def initialize(options)
      @quip_sheet = options[:quip_sheet]
      super
    end
    
    # Returns the header row in the given quip_spreadsheet
    def header_items
      get_row_items(quip_sheet.at_css("tr").children)
    end
    
    # Dehumanize
    def header_keys
      get_row_items(quip_sheet.at_css("tr").children).collect{|n|
        n.to_s.dup.downcase.gsub(/ +/,'_')
      }
    end
    
    # Return rows
    def rows(options = {})
      [].tap{|a|
        quip_sheet.css("tr").each_with_index do |row, i|
          _is_header = (i == 0)
          _row = Quip::Sheet::Row.new(is_header: _is_header, thread_id: thread_id, client: client)
          
          row.children.each_with_index.each do |_col, j|
            col = _col.at_css("span")
            text_node = col.child
            text_node.css("br").each{ |br| br.replace "\n" }
            text = (text_node.to_s.bytes == [226, 128, 139]) ? '' : text_node.to_s
            _row.columns[header_keys[j].to_sym] = Quip::Sheet::Cell.new({
              text: text, 
              section_id: col.attribute('id').value,
              thread_id: thread_id, 
              client: client
            })
          end
          
          a << _row unless (options[:no_header] && i == 0)
        end
      }
    end
    
    # Return row with value
    # key header key
    # value 
    # sheet.find_row_by_value('fb_ad_campaign_id', '1122333')
    def find_row_by_value(key, value)
      rows.each do |r|
        if r.columns[key] && r.columns[key].text == value
          return r
        end
      end
      
      return nil
    end
    
    # Get row by index
    def get_row_by_index(index)
      rows[index]
    end
    
    private
    
    # Returns the text of items in the given row `ElementTree`.
    def get_row_items(nodes)
      nodes.collect{|n| n.text.delete("\n")}
    end
  end
end