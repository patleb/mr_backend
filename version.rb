unless defined? MrBackend::VERSION::STRING
  module MrBackend
    def self.gem_version
      Gem::Version.new VERSION::STRING
    end

    module RAILS_VERSION
      MAJOR = 5
      MINOR = 2
      PATCH = 0

      STRING = [MAJOR, MINOR, PATCH].compact.join(".")
    end

    module VERSION
      MAJOR = 0
      MINOR = 1
      PATCH = 0

      STRING = [MAJOR, MINOR, PATCH].compact.join(".")
    end
  end
end
