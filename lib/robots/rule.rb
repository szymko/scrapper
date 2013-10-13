module Robots
  class Rule

    include Scrapper::UriHelper

    attr_reader :permission_type, :body

    def initialize(permission_type, body)
      @permission_type = extract_type(permission_type)
      @body = body
    end

    def allowed?(url)
      uri_path = uri_from_url(url).path

      return true if @body.nil?
      regex_rule = Regexp.compile(escape(@body))

      if @permission_type == :allow
        uri_path =~ regex_rule
      else
        ! uri_path =~ regex_rule
      end
    end

    private

    def extract_type(permission_type)
      PERMISSION_TYPE[permission_type]
    end

    def escape(body)
      literal_list = body.split('*')
      literal_list.map! { |el| Regexp.escape(el) }

      preprocessed_body = parts.join('[^\/]+')
      template(preprocessed_body)
    end

    def template(preprocessed_body)
      "\\A#{preprocessed_body}#{(preprocessed_body[-1] == "/") ? "" : "\\z"}"
    end
  end
end