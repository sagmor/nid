class NID # :nodoc:
  # Wraps NID objects into a namespace filter enforcing every NID that goes
  # throug is of the expected namespace
  class Namespace
    def initialize(klass, namespace)
      @klass = klass
      @namespace = namespace
    end

    def new(value = nil)
      nid = case(value)
            when String, NID
              @klass.new(value)
            else
              @klass.new(@namespace, value)
            end

      unless nid.namespace == @namespace
        fail ArgumentError, "Invalid Namespace (#{nid.namespace.inspect})"
      end

      nid
    end
  end

  def self.[](namespace)
    Namespace.new(self,namespace)
  end
end
