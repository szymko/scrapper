module Robots
  class Index

    include Scrapper::UriHelper

    def initialize
      @robot_documents = {}
    end

    def add(host_hash) # host_hash { host1: file, host2: file ... }
      raise ArgumentError unless host_hash.kind_of?(Hash)

      host_hash.each do |host, file|
        parser = Robots::Parse::Document.new(file)
        @robot_documents[host] ||= parser.parse()
      end
    end

    def has?(host)
      @robot_documents && @robot_documents.has_key?(host)
    end

    def allowed?(opts) # { url : www.costam.cos, agent: Pszemek, empty: true }
      uri = uri_from_url(opts[:url])

      if @robot_documents[uri.host].nil?
        opts[:empty]
      else
        @robot_documents[uri.host].allowed?(opts[:agent], uri)
      end
    end

    # Hit the network and parse.
    def get(url_list)
      hosts = url_list.reduce([]) { |hosts, u| hosts << uri_from_url(u).host }.uniq

      new_documents = get_document(hosts - @robot_documents.keys) do |host|
        Robots::Parser::Document.new(host).parse()
      end

      @robot_documents.merge!(new_documents)
      self
    end

    private

    def get_document(hosts)
      robots = build_request(hosts)

      (robots[:response] + robots[:request_error]).inject({}) do |hosts, req|
        body = (req.is_a? RequestError || req.status_code != 200) ? "" : req.body
        h[req.uri.host] = (block_given? ? yield(body) : body)
        h
      end
    end

    def build_request(hosts)
      return {} if blank?(hosts)

      robots_paths = hosts.map { |h| "http://#{h}/robots.txt" }
      Scrapper::Request.new(robots_paths).perform()
    end
  end
end