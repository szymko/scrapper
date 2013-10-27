class Robots::Parser
token AGENT RULE
rule

  document
    : document agent
    | agent
    ;

  rules
    : rules rule
    | rule
    ;

  agent
    : base_agent rules
    | base_agent
    | base_agent
    ;

  base_agent
    : AGENT { @handler.add_agent(val[0]) }

  rule
    : RULE {  @handler.add_rule(val[0]) }

end

---- inner

  def initialize(tokenizer, handler = Robots::Handler.new)
    @tokenizer = tokenizer
    @handler = handler
    super()
  end

  def next_token()
    @tokenizer.next_token
  end

  def parse()
    do_parse
    @handler
  end