// Copyright 2021 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import GooglePlaces

enum LocationOption: Int {
  case unspecified = 100
  case canada = 101
  case kansas = 102

  var northEast: CLLocationCoordinate2D {
    switch self {
    case .canada:
      return CLLocationCoordinate2D(latitude: 70.0, longitude: -60.0)
    case .kansas:
      return CLLocationCoordinate2D(latitude: 39.0, longitude: -95.0)
    default:
      return CLLocationCoordinate2D()
    }
  }

  var southWest: CLLocationCoordinate2D {
    switch self {
    case .canada:
      return CLLocationCoordinate2D(latitude: 50.0, longitude: -140.0)
    case .kansas:
      return CLLocationCoordinate2D(latitude: 37.5, longitude: -100.0)
    default:
      return CLLocationCoordinate2D()
    }
  }
}

/// The configurations for an autocomplete search.
class AutocompleteConfiguration {
  let autocompleteFilter: GMSAutocompleteFilter
  var placeFields: GMSPlaceField
  var location: LocationOption?

  init(autocompleteFilter: GMSAutocompleteFilter, placeFields: GMSPlaceField) {
    self.autocompleteFilter = autocompleteFilter
    self.placeFields = placeFields
  }
}

