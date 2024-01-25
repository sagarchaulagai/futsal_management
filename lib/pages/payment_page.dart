import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fonepay_flutter/fonepay_flutter.dart';
import 'package:futsal_management/database/baserow_api.dart';
import 'package:futsal_management/pages/booked_success.dart';
import 'package:futsal_management/pages/home_page.dart';

class PaymentPage extends StatefulWidget {
  final DateTime date;
  const PaymentPage({
    super.key,
    required this.date,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final config = ESewaConfig.dev(
                    amt: 1000,
                    serverUrl:
                        'https://rc-epay.esewa.com.np/api/epay/main/v2/form?',
                    txAmt: 0,
                    pid: 'product_id',
                    su: 'https://success.com.np',
                    fu: 'https://failure.com.np',
                  );
                  final result = await Esewa.i.init(
                    context: context,
                    eSewaConfig: config,
                  );
                  if (result.hasData) {
                    // Payment successful
                    final response = result.data!;
                    //Navigating to home page
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookedSuccess(date: widget.date),
                        ),
                      );
                    }
                    print('Payment successful. Ref ID: ${response.refId}');
                  } else {
                    // Payment failed or cancelled
                    final error = result.error!;
                    print('Payment failed or cancelled. Error: $error');
                  }
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 200,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pay Rs.1000 with eSewa',
                        ),
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Esewa_logo.webp/1200px-Esewa_logo.webp.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //For phonepay
              GestureDetector(
                onTap: () async {
                  final config = FonePayConfig.dev(
                    ru: 'https://example.com/fonepay/return',
                    prn: '123456',
                    amt: 100.0,
                    r1: 'Payment for order #123',
                    r2: 'Additional info',
                  );

                  final result = await FonePay.i.init(
                      context: context,
                      fonePayConfig: FonePayConfig.dev(
                        amt: 1000.0,
                        r2: 'https://www.marvel.com/hello',
                        ru: 'https://www.marvel.com/hello',
                        r1: 'qwq',
                        prn:
                            'PD-2-${FonePayUtils.generateRandomString(len: 2)}',
                      ));
                  if (result.hasData) {
                    // Payment successful
                    final response = result.data!;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookedSuccess(
                          date: widget.date,
                        ),
                      ),
                    );

                    print('Payment successful. Ref ID: ${response}');
                  } else {
                    // Payment failed or cancelled
                    final error = result.error!;
                    print('Payment failed or cancelled. Error: $error');
                  }
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 200,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Pay Rs.1000 with PhonePay',
                        ),
                        Image.network(
                          'https://women-lead.org/wp-content/uploads/2020/04/fonepay-logo.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
