module GlobalKey
  extend ActiveSupport::Concern

  SEPARATOR = ':'.freeze # ':' makes regexes clearer

  def self.start_with(fragments)
    /^#{fragments.compact.join(SEPARATOR)}#{SEPARATOR}/
  end

  def self.end_with(fragment)
    /#{SEPARATOR}#{fragment}$/
  end

  included do
    delegate :global_key_matcher, to: :class
  end

  class_methods do
    def global_key(*fragments)
      [name.underscore, *fragments]
    end

    def global_key_matcher(*fragments)
      GlobalKey.start_with(global_key(*fragments))
    end
  end

  def global_key(*fragments)
    if fragments.empty?
      fragments = self.class.method_args(__method__).map{ |name| send(name) }
    end
    self.class.global_key(*fragments)
  end
end
