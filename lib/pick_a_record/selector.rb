# Module subclass for generating a cached random record.
class PickARecord::Selector < Module
  HOUR  = 1.hour
  DAY   = 1.day
  WEEK  = 1.week

  include Calculi::HasFunctionSet

  calculi_string    :name
  calculi_string    :prefix, default: 'random'
  calculi_int       :store_last, default: 5
  calculi_duration  :duration, default: 1.day

  # @!attribute [rw] source_scope
  #   The source to draw a random record from.
  #   @return [Proc, Symbol]
  calculi_procable  :source_scope

  calculi_computed :full_name do
    [prefix, name].compact.join('_').to_sym
  end

  options! :name, prefix: 'random', store_last: 5, duration: 1.day

  # @!group Duration attributes

  # @return {Boolean}
  def hourly?
    duration == HOUR
  end

  # @return [Boolean]
  def daily?
    duration == DAY
  end

  # @return [Boolean]
  def weekly?
    duration == WEEK
  end
  # @!endgroup

  calculi_functions do
    function :cache_key do
      name { "#{full_name}_cache_key" }

      body do |target, fn, args|
        [self, "#{target.full_name}"]
      end
    end

    function :last_records_cache_key do
      name { "last_#{full_name}_cache_key" }

      body do |target, fn, args|
        "#{self}.last_#{target.full_name}_ids"
      end
    end

    function :last_records_list, memoize: true do
      name { "last_#{full_name}_ids" }

      requires :last_records_cache_key

      body do |target, fn, args|
        ::Redis::List.new(fn[:last_records_cache_key], max_length: target.store_last)
      end
    end

    function :without_last_records do
      name { "without_last_#{full_name}_ids" }

      requires :last_records_list

      body do |target, fn, args|
        last_ids = Array(fn[:last_records_list])

        last_ids.present? ? where('id NOT IN (?)', last_ids) : scoped
      end
    end

    function :last_records_clear do
      name { "clear_last_#{full_name}_ids!" }

      requires :last_records_list

      body do |target, fn, args|
        fn[:last_records_list].clear
      end
    end

    function :expires_in do
      name { "#{full_name}_expires_in" }

      if target.daily?
        body { Time.now.seconds_until_end_of_day }
      elsif target.weekly?
        body { Time.now.seconds_until_end_of_week }
      else
        body do |target, fn, args|
          target.duration
        end
      end
    end

    function :scope do
      name { "scope_for_#{full_name}" }

      if procable? target.source_scope
        body do |target, fn, args|
          instance_eval(&target.source_scope)
        end
      else
        body { scoped }
      end
    end

    function :clear! do
      name { "clear_#{full_name}!" }

      requires :cache_key

      body do |target, fn, args|
        ::Rails.cache.delete fn[:cache_key]
      end
    end

    function :fetch_one do
      name { "fetch_one_#{full_name}" }

      requires :scope, :without_last_records

      body do |target, fn, args|
        fn.chain(:scope, :without_last_records).in_random_order.first
      end
    end

    function :get do
      name { "#{full_name}" }

      requires :fetch_one, :remember, :cache_key, :expires_in

      body do |target, fn, args|
        ::Rails.cache.fetch fn[:cache_key], expires_in: fn[:expires_in], race_condition_ttl: 20 do
          fn[:fetch_one].tap do |last_entry|
            fn[:remember, last_entry]
          end
        end
      end
    end

    function :remember do
      name { "remember_#{full_name}" }

      requires :last_records_list

      body do |target, fn, args|
        last_entry_id = args.first.try(:id)

        fn[:last_records_list] << last_entry_id if last_entry_id.present?
      end
    end
  end
end
