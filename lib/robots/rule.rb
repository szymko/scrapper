module Robots
  class Rule

    PERMISSION_TYPE = { "Allow" => :allow, "Disallow" => :disallow }

    include Scrapper::UriHelper
    include Scrapper::StringHelper

    attr_reader :type, :body

    def initialize(rule_line)
      type, body = extract(rule_line)

      @type = PERMISSION_TYPE[type]
      @body = body
    end

    def allowed?(url)
      uri_path = uri_from_url(url).path

      return true if blank?(@body)
      regex_rule = Regexp.compile(escape(@body))

      if @type == :allow
        uri_path =~ regex_rule
      else
        ! uri_path =~ regex_rule
      end
    end

    private

    def escape(body)
      literal_list = body.split('*')
      literal_list.map! { |el| Regexp.escape(el) }

      preprocessed_body = literal_list.join('[^\/]+')
      template(preprocessed_body)
    end

    def template(preprocessed_body)
      "\\A#{preprocessed_body}#{(preprocessed_body[-1] == "/") ? "" : "\\z"}"
    end

    def extract(rule_line)
      type = rule_line[/Allow|Disallow/]
      body = rule_line[/(?<=Allow:|Disallow:).*$/].strip
      [type, body]
    end
  end
end