module DistanceMatrix
  class DistancesFetcher
    include ActiveModel::Validations

    validates :language, :units, :key, :routes, presence: true

    def initialize(language: 'pt-BR', units: 'metric', key:, routes:)
      @language = language.harmonized
      @units = units.harmonized
      @key = key.harmonized
      @routes = routes if routes.valid?
    end
  end
end
