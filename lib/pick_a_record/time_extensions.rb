# Extra methods for the {Time} class.
module PickARecord::TimeExtensions
  extend ActiveSupport::Concern

  included do
    alias_method :seconds_until_end_of_day, :as4_seconds_until_end_of_day unless method_defined?(:seconds_until_end_of_day)
  end

  # @note Backport of Time#seconds_until_end_of_day from ActiveSupport 4
  # @return [Integer] number of the seconds until the end of the day
  def as4_seconds_until_end_of_day
    end_of_day.to_i - to_i
  end

  # @return [Integer] number of seconds until the end of the week
  def seconds_until_end_of_week
    end_of_week.to_i - to_i
  end
end
