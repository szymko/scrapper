# helpers
require_relative './scrapper/helpers/string_helper'
require_relative './scrapper/helpers/array_helper'
require_relative './scrapper/helpers/uri_helper'

# robots
require_relative './robots/user_agent'
require_relative './robots/rule'
require_relative './robots/section'
require_relative './robots/document'
require_relative './robots/index'

# parser
require_relative './robots/parser'
require_relative './robots/parser/section'
require_relative './robots/parser/document'

# scrapper
require_relative './scrapper'

module Robots
  PERMISSION_TYPE = { "Allow" => :allow, "Disallow" => :disallow }
end