module Rake
  module DSL
    def run_ftp_list(match)
      `#{Sh.ftp_list(match)}`.lines.map(&:strip).map(&:split).map do |columns|
        { size: columns[0].to_i, time: DateTime.parse(columns[1]), name: columns[2] }.with_indifferent_access
      end
    end

    def run_ftp_cat(match)
      `#{Sh.ftp_cat(match)}`.strip
    end
  end
end