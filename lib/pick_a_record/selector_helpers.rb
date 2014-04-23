module PickARecord::SelectorHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    def pick_a_record(options = {}, &scope)
      options.reverse_merge! name: model_name.singular, source_scope: scope

      extend PickARecord::Selector.new options
    end

    def pick_a_daily(selector_name = nil, &scope)
      options = { duration: 1.day, prefix: 'daily' }

      options[:name] = selector_name if selector_name.present?

      pick_a_record(options, &scope)
    end

    def pick_a_weekly(selector_name = nil, &scope)
      options = { duration: 1.week, prefix: 'weekly' }

      options[:name] = selector_name if selector_name.present?

      pick_a_record(options, &scope)
    end
  end
end
