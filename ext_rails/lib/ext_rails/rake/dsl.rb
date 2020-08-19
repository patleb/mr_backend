module Rake
  module DSL
    def run_ftp_list(match, **options)
      `#{Sh.ftp_list(match, **options)}`.lines.map(&:strip).map(&:split).map do |columns|
        if columns.size == 3
          { size: columns[0].to_i, time: DateTime.parse(columns[1]), name: columns[2] }.with_indifferent_access
        else
          { time: DateTime.parse(columns[0]), name: columns[1].delete_suffix('/') }.with_indifferent_access
        end
      end
    end

    def run_ftp_cat(match, **options)
      `#{Sh.ftp_cat(match, **options)}`.strip
    end
  end
end