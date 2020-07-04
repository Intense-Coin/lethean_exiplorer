/* Copyright (c) 2020, Lethean Community developers
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exit_node_providers.dart';
import '../models/exit_node_service.dart';
import '../widgets/vpn_instruction_header.dart';
import '../widgets/save_ovpn_file_buton.dart';

class VpnInstructionScreen extends StatelessWidget {
  static const routeName = '/vpn-instruction';

  @override
  Widget build(BuildContext context) {
    final ExitNodeService _service = ModalRoute.of(context).settings.arguments;

    return Consumer<ExitNodeProviders>(builder: (ctx, provider, child) {
      final _country = provider.providers
          .firstWhere((p) => p.id == _service.providerId)
          .country;
      return Scaffold(
        appBar: AppBar(
          title: Text('${_service.name}'),
        ),
        body: Column(
          children: <Widget>[
            VpnInstructionHeader(
              country: _country,
              service: _service,
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(6.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                        top: 16.0,
                        right: 20.0,
                        left: 20.0,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Save OpenVPN Configuration File',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              SaveOvpnFileButton(service: _service),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text('Press save icon to save the OpenVPN configuration file' +
                              ' to Download directory. Then import this file to your OpenVPN app.' +
                              ' Verified to work with OpenVPN Connect and OpenVPN for Android.'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Payment Id',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              SelectableText(
                                '${_service.paymentId}',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      final newPaymentId =
                                          ExitNodeService.generatePaymentId(
                                              _service.id);
                                      Provider.of<ExitNodeProviders>(context,
                                              listen: false)
                                          .setPaymentId(
                                        _service.providerId,
                                        _service.id,
                                        newPaymentId,
                                      );
                                    }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                              'For privacy reasons it is recommended to refresh Payment Id' +
                                  ' before making a new VPN connection.'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Text(
                            'First Payment',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          Text('First payment of ${_service.cost * _service.firstPrePaidMinutes} LTHN' +
                              ' gets you ${_service.firstPrePaidMinutes}' +
                              ' minutes of VPN subscription. Payment is made by using Lethean' +
                              ' cryptocurrency LTHN. Payments are not yet implemented in this app.' +
                              ' You can use any official Lethean wallet to pay e.g. desktop GUI or CLI.'),
                          const SizedBox(height: 14),
                          const Text(
                              'Lethean command line wallet or Discord tipbot command format :\n' +
                                  'transfer <Address> <Amount> <Payment Id>'),
                          const SizedBox(height: 14),
                          SelectableText('transfer ${_service.providerWallet} ' +
                              '${_service.cost * _service.firstPrePaidMinutes} ' +
                              '${_service.paymentId}'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Text(
                            'Connect to VPN',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                              'Use the VPN profile that was created in the OpenVPN app ' +
                                  'when importing the file.' +
                                  ' You need to login with Payment Id :'),
                          const SizedBox(height: 14),
                          SelectableText('Username : ${_service.paymentId}'),
                          SelectableText('Password : ${_service.paymentId}'),
                          const SizedBox(height: 14),
                          const Divider(thickness: 2.0),
                          const SizedBox(height: 14),
                          Text(
                            'Additional Payments',
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                          const SizedBox(height: 14),
                          Text('Additional payment of ${_service.cost * _service.subsequentPrePaidMinutes}' +
                              ' LTHN adds ${_service.subsequentPrePaidMinutes}' +
                              ' minutes to your VPN subscription.' +
                              ' Pay before previous subscription period ends. ' +
                              'Use the same Payment Id as used on first payment.'),
                          const SizedBox(height: 14),
                          SelectableText('transfer ${_service.providerWallet} ' +
                              '${_service.cost * _service.subsequentPrePaidMinutes} ' +
                              '${_service.paymentId}'),
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
