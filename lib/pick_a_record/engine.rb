module PickARecord
  class Engine < ::Rails::Engine
    isolate_namespace PickARecord

    initializer 'pick_a_record.time_stub' do
      Time.send(:include, PickARecord::TimeExtensions)
    end

    initializer 'pick_a_record.active_record_integration' do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, PickARecord::RandomFunction)

        include PickARecord::InRandomOrder
        include PickARecord::SelectorHelpers
      end
    end
  end
end
