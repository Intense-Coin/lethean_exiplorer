/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../providers/exit_node_providers.dart';
import '../widgets/exit_node_provider_tile.dart';
import '../widgets/world_map.dart';
import '../models/exit_node_provider.dart';
import '../widgets/lethean_drawer.dart';

// These were used for testing detection of device external IP address
// When pressing floatingactionbutton
// import '../helpers/api_helpers.dart';
// import '../models/country.dart';

class ProviderListScreen extends StatefulWidget {
  static const routeName = '/providers-list';

  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  Future<void> _refresh;
  List<ExitNodeProvider> _currentNodeList = [];
  List<Marker> _markers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh = Provider.of<ExitNodeProviders>(
      context,
      listen: false,
    ).fetchAndSetProviders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // primary: false,
        appBar: AppBar(
          // backgroundColor: Colors.red,
          // brightness: Brightness.light,
          title: const Text('Lethean Exiplorer'),
        ),
        drawer: LetheanDrawer(),
        body: Consumer<ExitNodeProviders>(
          builder: (ctx, exitNode, _) => FutureBuilder<void>(
            future: _refresh,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('An error has occured: ${snapshot.error}'),
                );
              } else {
                _currentNodeList = exitNode.providers;
                _markers = []; // Make sure the list is empty before building it
                exitNode.countries.forEach((country) {
                  _markers.add(
                    Marker(
                      point: LatLng(country.latitude, country.longitude),
                      height: 28.00,
                      width: 28.00,
                      builder: (context) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.lightBlue,
                          size: 28,
                        ),
                      ),
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                    ),
                  );
                });
                return _currentNodeList.isEmpty
                    ? Center(
                        child: const Text('No exit node available.'),
                      )
                    : Column(
                        children: <Widget>[
                          SizedBox(height: 6.0),
                          WorldMap(
                            mapMarkers: _markers,
                          ),
                          Expanded(
                            // Was necessary to wrap this in Expanded
                            // to avoid error in Column
                            child: Scrollbar(
                              child: RefreshIndicator(
                                onRefresh: () {
                                  _refresh = Provider.of<ExitNodeProviders>(
                                    context,
                                    listen: false,
                                  ).fetchAndSetProviders();
                                  return _refresh;
                                },
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _currentNodeList.length,
                                  itemBuilder: (context, index) =>
                                      ExitNodeProviderTile(
                                          currentNode: _currentNodeList[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.refresh),
        //   onPressed: () async {
        //     setState(() {
        //       _refresh = Provider.of<ExitNodeProviders>(
        //         context,
        //         listen: false,
        //       ).fetchAndSetProviders();
        //     });

        // Some code for testing detecting internet location of the device
        // final myIp = await ApiHelpers.fetchMyIp();
        // final myCountryMap = await ApiHelpers.fetchCountryFromIp(myIp);
        // final myCountry = Country.fromJson(myCountryMap);
        // print('Country: ' + myCountry.name + ' ' + myCountry.code);
        // print('Latitude: ' + myCountry.latitude.toString());
        // print('Longitude: ' + myCountry.longitude.toString());
        //   },
        // ),
      ),
    );
  }
}
