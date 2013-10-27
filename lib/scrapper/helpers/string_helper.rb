module Scrapper
  module StringHelper
    def camel_case(s)
      return s if s !~ /_/ && s =~ /[A-Z]+.*/
      s.split('_').map{|e| e.capitalize}.join
    end

    def blank?(s)
      s.nil? || s.empty?
    end
  end
end