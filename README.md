# map-list-view
Display a list of locations over a map with a similar experience to Apple Maps.

<img src="/screenshots/mapView.png?raw=true" width="300px"> <img src="/screenshots/listView.png?raw=true" width="300px">

## Details
This app takes in a list of locations represented as JSON and displays them as a UITableView with a UISearchBar over a MKMapView.
* At app launch, the JSON file is parsed and converted into LocationDataModel objects.
* The LocationDataModel objects are then put into a LocationCache and a radix tree is constructed for prefixing.
    * The input list is sorted alphabetically and is stored in the cache as a list so that it may be indexed later.
    * The head of the radix tree and each node is represented by a PrefixNode object.
* Upon construction of the tree, the map view is shown with the list of locations over it.
* Typing in the search bar will do the following:
    * Traverse the radix tree by each letter in the search string.
    * Retrieve a range of indeces from the radix tree that corresponds to a range of indeces in the location list.
    * Set the filtered locations to the locations within that range of indices.

## Run
### App
1. [Clone the repo](https://github.com/wescarlan/map-list-view)
2. Open map-list-view/MapListView/MapListView.xcodeproj in Xcode
3. Run the MapListView scheme
### Unit tests
1. [Clone the repo](https://github.com/wescarlan/map-list-view)
2. Open map-list-view/MapListView/MapListView.xcodeproj in Xcode
3. Run the Unit Tests scheme
