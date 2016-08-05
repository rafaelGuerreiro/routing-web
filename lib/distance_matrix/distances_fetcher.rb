require 'net/http'
require 'json'
require 'uri'

module DistanceMatrix
  class DistancesFetcher
    include ActiveModel::Validations

    BASE_URI = Figaro.env.distance_fetcher_base_uri.harmonized
    LANGUAGE = Figaro.env.distance_fetcher_language.harmonized
    UNITS = Figaro.env.distance_fetcher_units.harmonized

    attr_reader :base_uri
    validates :base_uri, presence: true

    def initialize(base_uri: nil, language: nil, units: nil, key:)
      @base_uri = build_base_uri(base_uri, language, units, key)
    end

    def fetch_distances(clusters)
      return unless valid?

      requested_routes = 0

      clusters.each do |cluster|
        next unless cluster.valid?

        cluster.each do |_origin, routes, query_parameter|
          requested_routes = request_routes(requested_routes, routes, query_parameter)
        end
      end
    end

    private

    def build_base_uri(base_uri, language, units, key)
      key = key.harmonized
      return if key.blank?

      base_uri = base_uri.harmonized || BASE_URI
      language = language.harmonized || LANGUAGE
      units = units.harmonized || UNITS

      "#{base_uri}?language=#{language}&units=#{units}&key=#{key}&"
    end

    def request_routes(requested_routes, routes, query_parameter)
      requested_routes += routes.length

      if requested_routes > 100
        sleep(10.seconds)
        requested_routes = routes.length
      end

      json = get_json(query_parameter)
      set_routes(routes, json)

      requested_routes
    end

    def get_json(query_parameter)
      uri = URI.parse(@base_uri + query_parameter)
      http = build_http(uri)

      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      JSON.parse(response.body, symbolize_names: true) if response.message == 'OK'
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)

      return http unless uri.scheme == 'https'

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      http
    end

    def set_routes(routes, json)
      root_status = RootStatus.parse(json[:status])

      if root_status.error?
        set_error(routes, root_status)
      else
        set_distances(routes, json)
      end
    end

    def set_errors(routes, root_status)
      error_message = root_status.to_s

      routes.each do |route|
        route.error_message = error_message
      end
    end

    def set_distances(routes, json)
      elements = json[:rows].first[:elements]
      elements.each_with_index do |element, index|
        route = routes[index]
        route_status = RouteStatus.parse(element[:status])

        set_route(route, route_status, element)
      end
    end

    def set_route(route, route_status, element)
      p route_status

      if route_status.ok?
        route.distance = distance_in_kilometers(element[:distance][:value])
      else
        route.error_message = route_status.to_s
      end
    end

    def distance_in_kilometers(distance)
      (distance / 1000.00).round(2)
    end
  end
end
