import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futsal_management/database/baserow_api.dart';
import 'package:futsal_management/pages/home_page.dart';

class BookedSuccess extends StatefulWidget {
  final DateTime date;
  const BookedSuccess({
    super.key,
    required this.date,
  });

  @override
  State<BookedSuccess> createState() => _BookedSuccessState();
}

class _BookedSuccessState extends State<BookedSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Booking Successful"),
                // Go to homepage
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("Go to homepage"),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
        future: BaserowApi().postFutsalTimings(
          242765,
          widget.date,
          true,
          "Sagar",
          9865511375,
        ),
      ),
    );
  }
}
