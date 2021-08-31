# frozen_string_literal: true

module HTTP
  class Response
    def response
      @response ||= OpenStruct.new(body: to_s, code: code)
    end

    def success?
      @success ||= code.between?(200, 300)
    end

    def parsed_response
      @parsed_response ||= if content_type.mime_type.to_s.include?('json')
                             JSON.parse(to_s)
                           else
                             to_s
                           end
    end
  end
end
