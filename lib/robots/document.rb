module Robots
  class Document

    include Scrapper::ArrayHelper

    def initialize(section_list)
     @section_list = section_list
    end

    def allowed?(agent_string, url)
      return true if blank?(@section_list)

      relevant_section = find_relevant_section(agent_string)

      if relevant_section.user_agent_similarity(agent_string) == 0
        return true
      else
        return relevant_section.allowed?(url)
      end
    end

    private

    def find_relevant_section(agent_string)
      @section_list.max do |s1, s2|
        s1.user_agent_similarity(agent_string) <=> s2.user_agent_similarity(agent_string)
      end
    end
  end
end