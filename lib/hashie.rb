require 'digest/sha1'
require 'byebug'

module Hashie
  def hash
    instance_values.reduce(1) do |result, (_var, val)|
      31 * result + (val.nil? ? 0 : digest(val))
    end
  end

  def ==(other)
    instance_values.reduce(true) do |result, (var, val)|
      break false unless result && other.respond_to?(var)
      val == other.__send__(var)
    end
  end

  def eql?(other)
    return false unless other.is_a?(self.class)
    self == other
  end

  private

  def digest(value)
    Digest::MD5.hexdigest(value.to_s).to_i(16)
  end
end
