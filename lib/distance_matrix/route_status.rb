module DistanceMatrix
  class RouteStatus < Status
    status :OK
    status :NOT_FOUND, 'The origin and/or destination of this pairing could not be geocoded.'
    status :ZERO_RESULTS, 'No route could be found between the origin and destination.'
  end
end
