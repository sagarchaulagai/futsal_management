import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsal_management/authentication/auth.dart';
import 'package:futsal_management/database/baserow_api.dart';
import 'package:futsal_management/pages/payment_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<List<FutsalTimingData>> fetchData() async {
    return BaserowApi().getFutsalTimings(242765);
  }

  Widget _signOutLabel() {
    return GestureDetector(
      onTap: signOut,
      child: const Text(
        'Sign Out',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _userEmail() {
    return Text(user?.email ?? 'Not Logged In');
  }

  Widget _buildSlotCard({
    required String time,
    required bool isBooked,
    required VoidCallback onPressed,
    required DateTime date,
  }) {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: Card(
        color: isBooked ? Colors.red : Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: isBooked ? Colors.white : Colors.black,
                ),
              ),
              isBooked
                  ? const Text(
                      'Booked Already ...   ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                        backgroundColor: Colors.yellow,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(date: date),
                          ),
                        );
                      },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Futsal Management'),
        actions: [
          _signOutLabel(),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: FutureBuilder<List<FutsalTimingData>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                DateTime now = DateTime.now();
                int currentHour = now.hour;

                List<String> hourlyTimes =
                    List.generate(19 - currentHour, (index) {
                  return '${currentHour + 1 + index}:00';
                });

                List<DateTime> todayBookedSlots = snapshot.data!
                    .where((item) => item.date!.toLocal().day == now.day)
                    .map((item) => item.date!.toLocal())
                    .toList();

                bool isTimeMoreThan5AndLessThan19 =
                    DateTime.now().hour > 5 && DateTime.now().hour < 19;

                return Column(
                  children: [
                    if (isTimeMoreThan5AndLessThan19) ...[
                      const Text(
                        "Today's Slots",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: hourlyTimes.length,
                        itemBuilder: (context, index) {
                          DateTime currentDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            currentHour + 1 + index,
                          );

                          bool isBooked = todayBookedSlots.any(
                            (slot) => slot.isAtSameMomentAs(currentDateTime),
                          );

                          return _buildSlotCard(
                            time: hourlyTimes[index],
                            isBooked: isBooked,
                            onPressed: () {},
                            date: currentDateTime,
                          );
                        },
                      ),
                    ],
                    const Text(
                      "Tomorrow's Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        DateTime tomorrowDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day + 1,
                          5 + index,
                        );

                        bool isBooked = snapshot.data!
                            .where((item) =>
                                item.date!.toLocal().day == now.day + 1)
                            .map((item) => item.date!.toLocal())
                            .any((slot) =>
                                slot.isAtSameMomentAs(tomorrowDateTime));

                        return _buildSlotCard(
                          time: tomorrowDateTime.toString().substring(11, 16),
                          isBooked: isBooked,
                          onPressed: () {},
                          date: tomorrowDateTime,
                        );
                      },
                    ),
                    const Text(
                      "Day After Tomorrow's Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        DateTime dayAfterTomorrowDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day + 2,
                          5 + index,
                        );

                        bool isBooked = snapshot.data!
                            .where((item) =>
                                item.date!.toLocal().day == now.day + 2)
                            .map((item) => item.date!.toLocal())
                            .any((slot) => slot
                                .isAtSameMomentAs(dayAfterTomorrowDateTime));

                        return _buildSlotCard(
                          time: dayAfterTomorrowDateTime
                              .toString()
                              .substring(11, 16),
                          isBooked: isBooked,
                          onPressed: () {},
                          date: dayAfterTomorrowDateTime,
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
