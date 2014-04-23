module PickARecord::InRandomOrder
  extend ActiveSupport::Concern

  module ClassMethods
    # Return the first `n` record(s) in random order.
    # @param [Integer] n
    # @return [ActiveRecord::Relation]
    def first_random(n = 1)
      n = n.to_i.nonzero? || 1

      limit(n).in_random_order
    end

    # @return [ActiveRecord::Relation]
    def in_random_order
      reorder(connection.random_function)
    end
  end
end
