module CssParser
  class Parser
    def each_selector(all_media_types = :all, options = {})
      each_rule_set(all_media_types) do |rule_set, media_types|
        next if media_types.include?(:print)

        rule_set.each_selector(options) do |selectors, declarations, specificity|
          yield selectors, declarations, specificity, media_types
        end
      end
    end
  end
end
