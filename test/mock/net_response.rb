module Mock
  NetResponse = Struct.new(:response_header, :response) do
    def initialize(**opts)
      response == opts[:response] || "Hello!"
      super(NetResponseHeader.new(opts), response)
    end
  end
end