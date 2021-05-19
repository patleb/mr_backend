module LogLines
  class Host < LogLine
    json_attribute(
      ip: :string,
      boot_time: :datetime,
      pids: :integer,
      usage: :float,
      steal: :float,
      load_avg: :float,
      disk_used: :integer,
      disk_reads: :integer,
      disk_writes: :integer,
      disk_inodes: :float,
      storage_used: :integer,
      storage_read: :integer,
      storage_writes: :integer,
      storage_inodes: :float,
      ram: :integer,
      swap: :integer,
      bytes_in: :integer,
      bytes_out: :integer,
      postgres_pids: :integer,
      postgres_ram: :integer,
      ruby_pids: :integer,
      ruby_ram: :integer,
      sockets: :integer,
      issues: :json,
      warnings: :json,
    )

    def self.rollups
      %i(week day).each_with_object({}) do |period, result|
        groups = group_by_period(period).calculate(LogRollups::Host::OPERATIONS)
        result[[period, :period]] = groups.transform_values! do |group|
          group.transform_values! do |row|
            row.map!.with_index do |value, i|
              next value.ceil(3) if rollups_keys[i] == :load_avg
              next value.ceil(2) if rollups_type(i) == :float
              value
            end
          end
        end
      end
    end

    def self.push(log, row)
      level = :info
      level = :warn if row.warning?
      level = :error if row.issue?
      storage = if row.storage
        {
          **row.storage.slice(:used, :reads, :writes).transform_keys{ |k| "storage_#{k}" },
          storage_inodes: row.storage.inodes_usage
        }
      else
        {}
      end
      json_data = {
        **row.cpu.slice(:boot_time, :pids, :load_avg),
        usage: row.cpu.usage, steal: row.cpu.steal,
        **row.disk.slice(:used, :reads, :writes).transform_keys{ |k| "disk_#{k}" },
        disk_inodes: row.disk.inodes_usage,
        **storage,
        ram: row.memory.ram_used, swap: row.memory.swap_used,
        **row.network.slice(:bytes_in, :bytes_out),
        postgres_pids: row.postgres.pids, postgres_ram: row.postgres.ram,
        ruby_pids: row.ruby.pids, ruby_ram: row.ruby.ram,
        sockets: row.sockets.size,
        issues: row.issue_names(false),
        warnings: row.warning_names(false),
      }
      message = { text: row.ip, text_tiny: row.ip, level: level }
      super(log, message: message, json_data: json_data)
    end
  end
end