// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/chart_widget.dart';
import 'package:money_app/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  //
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  //
  double pTodayMoneys = 0;
  double dTodayMoneys = 0;
  double pCurrentMonthMoneys = 0;
  double dCurrentMonthMoneys = 0;
  double pCurrentYear = 0;
  double dCurrentYear = 0;

  //
  @override
  Widget build(BuildContext context) {
    //
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //
    pTodayMoneys = 0;
    dTodayMoneys = 0;
    pCurrentMonthMoneys = 0;
    dCurrentMonthMoneys = 0;
    pCurrentYear = 0;
    dCurrentYear = 0;

    //! Today
    String today = Jalali.now().year.toString() +
        '/' +
        Jalali.now().month.toString() +
        '/' +
        Jalali.now().day.toString();
    // P
    for (var value in hiveBox.values) {
      if (value.date == today && value.isReceived == false) {
        setState(() {
          pTodayMoneys += double.parse(value.price);
        });
      }
    }
    // D
    for (var value in hiveBox.values) {
      if (value.date == today && value.isReceived) {
        setState(() {
          dTodayMoneys += double.parse(value.price);
        });
      }
    }
    //! This Month
    String month = Jalali.now().month.toString();
    // P
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isReceived == false) {
        setState(() {
          pCurrentMonthMoneys += double.parse(value.price);
        });
      }
    }
    //D
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isReceived) {
        setState(() {
          dCurrentMonthMoneys += double.parse(value.price);
        });
      }
    }

    //! This Year
    String year = Jalali.now().year.toString();
    // P
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived == false) {
        setState(() {
          pCurrentYear += double.parse(value.price);
        });
      }
    }
    //D
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived) {
        setState(() {
          dCurrentYear += double.parse(value.price);
        });
      }
    }

    //
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin:
                    const EdgeInsets.only(right: 20.0, top: 20.0, left: 5.0),
                child: Text(
                  'مدیریت تراکنش ها به تومان',
                  style: TextStyle(fontSize: screenHeight * 0.023),
                ),
              ),
              Column(
                children: [
                  //! Today
                  Container(
                    margin: const EdgeInsets.only(
                        right: 15.0, top: 20.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(pTodayMoneys.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : پرداختی امروز',
                          textAlign: TextAlign.right,
                        ),
                        Text(dTodayMoneys.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : دریافتی امروز',
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  //! This Month
                  Container(
                    margin: const EdgeInsets.only(
                        right: 15.0, top: 20.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(pCurrentMonthMoneys.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : پرداختی این ماه',
                          textAlign: TextAlign.right,
                        ),
                        Text(dCurrentMonthMoneys.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : دریافتی این ماه',
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  //! This Year
                  Container(
                    margin: const EdgeInsets.only(
                        right: 15.0, top: 20.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(pCurrentYear.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : پرداختی این سال',
                          textAlign: TextAlign.right,
                        ),
                        Text(dCurrentYear.toString(),
                            textAlign: TextAlign.left),
                        const Text(
                          ' : دریافتی این سال',
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  //! Chart
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    height: 200,
                    child: BarChartWidget(
                      dYear: dCurrentYear,
                      pYear: pCurrentYear,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
