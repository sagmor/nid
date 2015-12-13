require "securerandom"
require "nid/version"

class NID
  # NID binary representation
  attr_reader :bytes
  include Comparable

  # Initialize a new NID
  #
  # @overload initialize(namespace)
  #     @param namespace [Symbol] The namespace for the NID
  #     @return Random NID based on the current time
  #
  # @overload initialize(data)
  #     @param data [String] NID string representation.
  #     @return NID object equivalent to the passed string
  #
  # @overload initialize(namespace, time)
  #     @param namespace [Symbol] The namespace for the NID
  #     @param time [Time] Reference time.
  #     @return Random NID using the given generation time.
  def initialize(data, time=nil)
    @bytes = case data
    when NID
      data.bytes
    when String
      bytes_from_string(data)
    when Symbol
      random_bytes_with_time(data, time || Time.now)
    else
      raise type_error(data, "invalid type")
    end.freeze
  end

  # Compares two NIDs.
  #
  # @return [-1,0,1] the compare result.
  def <=>(other)
    self.bytes <=> other.bytes
  end

  # Console friendly representation
  def inspect
    "#<#{self.class.name} #{to_s}>"
  end

  # Get the NID in UUID string format.
  #
  # @return [String] formatted as XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
  def to_s
    [bytes].pack("m0").tr("+/=", "-_ ").strip
  end
  alias :to_str :to_s

  def to_uuid
    "%08x-%04x-%04x-%04x-%04x%08x" % bytes.unpack("NnnnnN")
  end

  def namespace
    self.to_s.split('_').first.to_sym
  end

  # Extract the time at which the NID was generated.
  #
  # @return [Time] the generation time.
  def time
    spread = "#{namespace}//".unpack("m").first.length
    Time.at(*bytes[spread,4].unpack("N"))
  end

  # Compare two NID objects
  def eql?(other)
    other.instance_of?(self.class) && self == other
  end

  private

    # Parse bytes from String
    def bytes_from_string(string)
      case string.length
      when 16
        string.frozen? ? string : string.dup
      when 36
        elements = string.split("-")
        raise type_error(string, "malformed UUID representation") if elements.size != 5
        [elements.join].pack('H32')
      else
        string = (string + "=").tr("-_", "+/").unpack("m").first
        if string.length == 16
          string
        else
          raise type_error(string, "invalid bytecount")
        end
      end
    end

    # Generate bytes string with the given time
    def random_bytes_with_time(namespace, time)
      bytes = "#{namespace}//=".unpack("m")[0]
      bytes << [time.to_i].pack('N')
      bytes << SecureRandom.random_bytes(16-bytes.length)

      bytes
    end

    # Create a formatted type error.
    def type_error(source,error)
      TypeError.new("Expected #{source.inspect} to cast to a #{self.class} (#{error})")
    end

end
