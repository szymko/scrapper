module Robots
  class Index

    include Scrapper::UriHelper

    def initialize(builder = Robots::DocumentBuilder.new)
      @documents = {}
      @document_builder = builder
    end

    def add(host_hash)# host_hash = { host1: string1, host2: string2 ... }
      raise ArgumentError unless host_hash.kind_of?(Hash)

      host_hash.each do |host, string|
        h = guess_host(host)
        @documents[h] ||= @document_builder.build(string)
      end
    end

    def has?(host)
      @documents && @documents.has_key?(host)
    end

    def allowed?(opts) # { url : www.costam.cos, agent: Pszemek, empty: true }
      uri = uri_from_url(opts[:url])
      if @documents[uri.host].nil?
        opts[:empty]
      else
        @documents[uri.host].allowed?(agent: opts[:agent], url: uri)
      end
    end

    # Hit the network and parse.
    def get(url_list)
      hosts = url_list.reduce([]) { |hosts, u| hosts << uri_from_url(u).host }.uniq

      new_documents = get_robots(hosts - @documents.keys) do |host|
        @document_builder.build(host)
      end

      @documents.merge!(new_documents)
    end

    private

    def get_robots(hosts)
      document_body = build_request(hosts)

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

    def guess_host(host)
      uri = uri_from_url(host)
      uri.host.nil? ? host : uri.host
    end
  end
end