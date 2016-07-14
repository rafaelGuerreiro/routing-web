class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid_location?(value)

    record.errors[attribute] << "The #{attribute} is not a valid location"
  end

  private

  def valid_location?(location)
    location.is_a?(DistanceMatrix::Location) && location.valid?
  end
end
