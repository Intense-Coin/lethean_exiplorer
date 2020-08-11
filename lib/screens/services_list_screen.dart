/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

import '../models/exit_node_provider.dart';
import '../models/exit_node_service.dart';
import '../widgets/vpn_badge.dart';
import '../widgets/proxy_badge.dart';
import '../widgets/service_tile_header.dart';
import '../widgets/service_tile_body.dart';
import '../widgets/lethean_drawer.dart';

class ServicesListScreen extends StatefulWidget {
  static const routeName = '/services-list';

  @override
  _ServicesListScreenState createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  @override
  Widget build(BuildContext context) {
    final ExitNodeProvider _exitNode =
        ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('${_exitNode.name} services'),
        ),
        drawer: LetheanDrawer(),
        body: Column(
          children: <Widget>[
            SizedBox(height: 6.0),
            Card(
              key: Key(_exitNode.id),
              child: ListTile(
                // Country is not required so better check if set
                leading: _exitNode.country == null
                    ? const SizedBox(
                        width: 60,
                        height: 40,
                        child: const Icon(
                          Icons.help_outline,
                          size: 40,
                        ),
                      )
                    : Flag(
                        _exitNode.country.code,
                        width: 60.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                title: Text(
                  _exitNode.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                // Country is not required so better check if set
                subtitle: _exitNode.country == null
                    ? Text(
                        'Unknown Country',
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    : Text(
                        '${_exitNode.country.name} ' +
                            '${_exitNode.country.code}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                // trailing: const Icon(Icons.arrow_forward_ios),
                // onTap: () {
                //   Navigator.pushNamed(
                //     context,
                //     ServicesListScreen.routeName,
                //     arguments: _currentNode,
                //   );
                // },
              ),
              elevation: 4,
              margin: const EdgeInsets.all(6),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: ExpansionPanelList.radio(
                      children: _buildExpansionPanelRadioList(_exitNode),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExpansionPanel> _buildExpansionPanelRadioList(
      ExitNodeProvider _exitNode) {
    return [
      ...(_exitNode.vpnServices != null && _exitNode.vpnServices.isNotEmpty
          ? _exitNode.vpnServices
              .map<ExpansionPanelRadio>(
                (vpnService) => _expansionPanelRadioServiceDescription(
                  vpnService,
                  VpnBadge(),
                ),
              )
              .toList()
          : []),
      ...(_exitNode.proxyServices != null && _exitNode.proxyServices.isNotEmpty
          ? _exitNode.proxyServices
              .map<ExpansionPanelRadio>(
                (proxyService) => _expansionPanelRadioServiceDescription(
                  proxyService,
                  ProxyBadge(),
                ),
              )
              .toList()
          : [])
    ];
  }

  ExpansionPanelRadio _expansionPanelRadioServiceDescription(
    ExitNodeService service,
    Widget badge,
  ) {
    return ExpansionPanelRadio(
      value: service.id,
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => ServiceTileHeader(
        service: service,
        badge: badge,
      ),
      body: ServiceTileBody(
        service: service,
      ),
    );
  }
}
