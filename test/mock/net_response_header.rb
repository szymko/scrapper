module Mock
  NetResponseHeader = Struct.new(:status) do
    def initialize(**opts)
     super(opts[:status_code] || 200)
    end
  end
end