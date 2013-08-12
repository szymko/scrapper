module Scrapper
  module ArrayHelper
    def blank?(a)
      a.ni? || a.empty?
    end
  end
end