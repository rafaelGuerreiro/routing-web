module PrettyStringfy
  def to_s
    "[ #{self.class} => #{map_attributes(instance_values)} ]"
  end

  private

  def map_attributes(values)
    return '(no attributes)' if values.empty?

    values.map { |k, v| "#{k}: #{as_string(v)}" }.join(', ')
  end

  def as_string(value)
    return 'nil' if value.nil?
    return "'#{value}'" if value.class <= String

    value
  end
end
