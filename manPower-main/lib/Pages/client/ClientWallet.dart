import 'package:flutter/material.dart';
import 'package:manpower/models/client/walletItem.dart';
import 'package:manpower/services/ClientService.dart';
import 'package:manpower/services/notification/notification_services.dart';
import 'package:manpower/widgets/loader.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<WalletItem> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    NotificationServices.checkNotificationAppInForeground(context);

    getData();
  }

  getData() async {
    transactions = await ClientService().getTransations();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${transactions[index].created}"),
                    subtitle: Text("${transactions[index].amount}"),
                    trailing: Text("${transactions[index].id}"),
                  ),
                );
              },
            ),
    );
  }
}
