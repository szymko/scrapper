module Robots
  class Document

    include Scrapper::ArrayHelper

    def initialize(section_list)
      @section_list = section_list
    end

    def allowed?(opts) # opts = {agent: 'agent', url: '/'}
      return true if blank?(@section_list)

      relevant_section = find_relevant_section(opts[:agent])
      if relevant_section.user_agent_similarity(opts[:agent]) == 0
        return true
      else
        return relevant_section.allowed?(opts[:url])
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
