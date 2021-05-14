module Checks
  module Linux
    class WorkerGroup < Base
      alias_attribute :name, :id
      attribute       :pids, :integer
      attribute       :threads, :integer
      attribute       :start_time, :datetime
      attribute       :memory_size, :integer
      attribute       :inodes_count, :integer

      def self.list
        Worker.all.group_by(&:name).map do |id, workers|
          {
            id: id, pids: workers.size, start_time: workers.min{ |w1, w2| w1.start_time <=> w2.start_time }.start_time,
            **%i(threads memory_size inodes_count).map{ |name| [name, workers.sum(&name.to_sym)] }.to_h
          }
        end
      end

      def self.inherited_group
        superclass.find(name.demodulize.underscore).attributes
      end
    end
  end
end
