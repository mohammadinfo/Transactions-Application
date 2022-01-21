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

    String year = Jalali.now().year.toString();

    String month = Jalali.now().month.toString().length == 1
        ? '0${Jalali.now().month.toString()}'
        : Jalali.now().month.toString();

    String day = Jalali.now().day.toString().length == 1
        ? '0${Jalali.now().day.toString()}'
        : Jalali.now().day.toString();

    String today = year + '/' + month + '/' + day;

    //! Today
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
                  MoneyInfoWidget(
                    firstText: ':دریافتی امروز',
                    firstPrice: dTodayMoneys,
                    secondText: ':پرداختی امروز',
                    secondPrice: pTodayMoneys,
                  ),
                  MoneyInfoWidget(
                    firstText: ':دریافتی این ماه',
                    firstPrice: dCurrentMonthMoneys,
                    secondText: ':پرداختی این ماه',
                    secondPrice: pCurrentMonthMoneys,
                  ),
                  MoneyInfoWidget(
                    firstText: ':دریافتی این سال',
                    firstPrice: dCurrentYear,
                    secondText: ':پرداختی این سال',
                    secondPrice: pCurrentYear,
                  ),
                  //! Chart
                  pCurrentYear == 0 || dCurrentYear == 0
                      ? Container()
                      : Container(
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

class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final double firstPrice;
  final double secondPrice;

  const MoneyInfoWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15.0, top: 20.0, left: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              secondPrice.toString(),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              secondText,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              firstPrice.toString(),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              firstText,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
