module DistanceMatrix
  module Validator
    class LocationValidator < ActiveModel::Validator
      def validate(record)
        record.errors[:location] << 'The origin is invalid' unless valid_location?(record.origin)
        record.errors[:location] << 'The destination is invalid' unless valid_location?(record.destination)
      end

      private

      def valid_location?(location)
        location.is_a?(DistanceMatrix::Location) && location.valid?
      end
    end
  end
end
