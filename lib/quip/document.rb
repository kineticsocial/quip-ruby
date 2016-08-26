module Quip
  class Document
    attr_reader :thread_id, :client
    
    # Locations
    APPEND = 0           # - Append to the end of the document.
    PREPEND = 1          # - Prepend to the beginning of the document.
    AFTER_SECTION = 2    # - Insert after the section specified by section_id.
    BEFORE_SECTION = 3   # - Insert before the section specified by section_id.
    REPLACE_SECTION = 4  # - Delete the section specified by section_id and insert the new content at that location.
    DELETE_SECTION = 5   # - Delete the section specified by section_id (no content required).
    
    def initialize(options = {})
      @thread_id = options[:thread_id]
      @client = options[:client]
    end
    
    def name
      doc = parse_document_html
      element = doc.at_css("h1").text
    end
  
    def create_document(content, options = {})
      @client.post_json("threads/new-document", {
        content: content,
        format: options.fetch(:format, 'html'),
        title: options.fetch(:title, nil),
        member_ids: options.fetch(:member_ids, []).join(',')
      })
    end

    def edit_document(content = nil, options = {})
      @client.post_json("threads/edit-document", {
        thread_id: thread_id,
        content: content,
        location: options.fetch(:location, 0),
        section_id: options.fetch(:section_id, nil),
        format: options.fetch(:format, 'html')
      })
    end
  
    def document_html
      @document_html ||= @client.get_thread(thread_id)["html"]
      @document_html
    end
  
    def parse_document_html
      @parse_document_html ||= Nokogiri::HTML(document_html)
      @parse_document_html
    end
  end
end