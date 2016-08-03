module DistanceMatrix
  class RootStatus < Status
    status :OK
    status :INVALID_REQUEST, 'The provided request was invalid.'
    status :MAX_ELEMENTS_EXCEEDED, 'The amount of routes exceeded the maximum per request. (100 routes per request)'
    status :OVER_QUERY_LIMIT, 'The service has received too many requests from your application ' \
                              'within the allowed time period. (100 routes per 10 seconds or 2500 routes per 24 hours)'
    status :REQUEST_DENIED, 'The service denied use of the Distance Matrix service by your application.'
    status :UNKNOWN_ERROR, 'Distance Matrix request could not be processed due to a server error. ' \
                           'The request may succeed if you try again.'
  end
end
