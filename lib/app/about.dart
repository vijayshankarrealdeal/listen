import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen/services/navbar_logic.dart';
import 'package:provider/provider.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    String formatCurrency(double amount) {
      final formatCurrency = NumberFormat.currency(
        locale: 'en_IN', // Locale for Indian formatting
        symbol: '', // Indian Rupee symbol
        decimalDigits: 2, // Number of decimal places
      );
      return formatCurrency.format(amount);
    }

    return Consumer<NavbarLogic>(builder: (context, navBar, _) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          navBar.change(0);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Wallet"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Balance",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.green.shade200),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            formatCurrency(0.0),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: Colors.green.shade50),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Center(
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.green.shade600,
                                    child: const Icon(CupertinoIcons.add,
                                        size: 45, color: Colors.white))),
                            Text(
                              "Credit to app",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.green.shade300,
                                  ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Center(child: Text("No transactions to show"))],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
