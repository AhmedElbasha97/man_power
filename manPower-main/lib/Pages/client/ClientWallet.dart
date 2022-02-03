import 'package:flutter/material.dart';
import 'package:manpower/models/client/walletItem.dart';
import 'package:manpower/services/ClientService.dart';
import 'package:manpower/widgets/loader.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<WalletItem> transctions = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    transctions = await ClientService().getTransations();
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isloading
          ? Loader()
          : ListView.builder(
              itemCount: transctions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${transctions[index].created}"),
                    subtitle: Text("${transctions[index].amount}"),
                    trailing: Text("${transctions[index].id}"),
                  ),
                );
              },
            ),
    );
  }
}
