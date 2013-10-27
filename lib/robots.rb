# helpers
require_relative './scrapper/helpers/string_helper'
require_relative './scrapper/helpers/array_helper'
require_relative './scrapper/helpers/uri_helper'

# scrapper
require_relative './scrapper'

# document structure
require_relative './robots/user_agent'
require_relative './robots/rule'
require_relative './robots/section'
require_relative './robots/document'
require_relative './robots/document_builder'
require_relative './robots/index'

# parser
require_relative './robots/tokenizer'
require_relative './robots/parser'
require_relative './robots/handler'

module Robots; end