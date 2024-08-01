import 'package:flutter/material.dart';

import '../models/language.dart';

class NotAvai extends StatelessWidget {
  const NotAvai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 212, 212),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 150,
              child: Image.asset('lib/client/assets/not_available.gif'),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 150,
              child: Text(
                  notAvai),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.zero,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  hintBack,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
