require 'rest-client'
require 'JSON'

module Quip
  class QuipClient
    attr_reader :access_token, :client_id, :client_secret,
                :base_url, :request_timeout, :thread_id

    def initialize(options)
      @access_token = options.fetch(:access_token)
      @client_id = options.fetch(:client_id, nil)
      @client_secret = options.fetch(:client_secret, nil)
      @base_url = options.fetch(:base_url, 'https://platform.quip.com/1')
      @request_timeout = options.fetch(:request_timeout, 10)
    end

    def get_authenticated_user
      get_json('users/current')
    end

    def get_folder(folder_id)
      get_json("folders/#{folder_id}")
    end
    
    def get_thread(thread_id)
      get_json("threads/#{thread_id}")
    end

    def get_threads(thread_ids)
      get_json("threads/?ids=#{thread_ids.join(',')}")
    end
    
    def get_recent_threads(count = 10, max_usec = nil)
      get_json("threads/recent?count=#{count}&max_updated_usec=#{max_usec}")
    end
    
    def spreadsheet(thread_id)
      Quip::Spreadsheet.new(thread_id: thread_id, client: self)
    end

    def add_thread_members(thread_id, member_ids)
      post_json("threads/add-members", {
        thread_id: thread_id,
        member_ids: member_ids.join(',')
      })
    end

    def remove_thread_members(thread_id, member_ids)
      post_json("threads/remove-members", {
        thread_id: thread_id,
        member_ids: member_ids.join(',')
      })
    end

    def get_blob(thread_id, blob_id)
      get_json("blob/#{thread_id}/#{blob_id}")
    end

    def get_messages(thread_id)
      get_json("messages/#{thread_id}")
    end

    def post_message(thread_id, message)
      post_json("messages/new", {thread_id: thread_id, content: message})
    end
    
    def get_section(section_id, thread_id = nil)
      doc = parse_document_html(thread_id)
      element = doc.xpath(".//*[@id='#{section_id}']")
      return element[0]
    end

    def get_json(path)
      response = RestClient.get "#{base_url}/#{path}", {Authorization: "Bearer  #{access_token}"}
      JSON.parse(response.body)
    end

    def post_json(path, data)
      response = RestClient.post "#{base_url}/#{path}", data, {Authorization: "Bearer  #{access_token}"}
      JSON.parse(response.body)
    end
  end
end