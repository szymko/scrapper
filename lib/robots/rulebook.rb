module Robots
  class Rulebook

    include ArrayHelper
    include UriHelper

    def initialize(robots_section)
      @allow = []
      @disallow = []
      parse(robots_section)
    end

    def allowed?(url)
      uri_path = uri_from_url(url).path

      if @allow.empty?
        !any_path?(@dissalow, uri_path)
      else
        any_path?(@allow, uri_path)
      end
    end

    def user_agent_similarity(agent_string)
      agent_pattern = Regexp.compile("\\A#{@user_agent.gsub('*', '.*')}\\z")
      (agent_string =~ agent_pattern) ?  : 0
    end

    private

    def parse(section)
      raise ArgumentError unless section.is_a? String

      transformed_section = section.strip.split(/\n/).map(&:strip)
      @user_agent = transformed_section[0].split.last.gsub(/\s+/, '')
      transformed_section[1..-1].each { |r| parse_regule(r) }
    end

    def parse_regule(regule)
      split_regule = regule.split

      return if !split_regule || split_regule.compact.empty?

      case split_regule.first.gsub(/\W+/, '')
      when "Allow"
        @allow << split_regule.last
      when "Disallow"
        @disallow << split_regule.last
      end
    end

    def escape_regule(u)
      parts = u.split('*')
      parts.map! { |p| Regexp.escape(p) }

      rule = parts.join('[^\/]+')
      regex_template(rule)
    end

    def regex_template(rule)
      if rule[-1,1] == "/"
        "\\A#{rule}"
      else
        "\\A#{rule}\\z"
      end
    end

    def any_path?(permission_list, uri_path)
      permission_lists.any? { |u| uri_path =~ Regexp.compile(escape_regule(u)) }
    end

    def agent_score
      @user_agent.gsub(/\*/, '').length
    end

    def allowed?(entries, user_agent, url)
      return true if blank?(@entries)

      best_entry = @entries.max { |e1, e2| e1.user_agent_similarity(user_agent) <=> e2.user_agent_similarity(user_agent) }

      if best_entry.user_agent_similarity(user_agent) == 0
        return true
      else
        return best_entry.allowed?(url)
      end
    end
  end
end

      # def allowed?(user_agent, url)
      #   return true if blank?(@entries)

      #   best_entry = @entries.max { |e1, e2| e1.user_agent_similarity(user_agent) <=> e2.user_agent_similarity(user_agent) }

      #   if best_entry.user_agent_similarity(user_agent) == 0
      #     return true
      #   else
      #     return best_entry.allowed?(url)
      #   end
      # end