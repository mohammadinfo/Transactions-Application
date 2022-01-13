// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_be_immutable
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionScreen extends StatefulWidget {
  //
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static String date = '';
  static int groupValue = 0;
  static bool isEdit = false;
  static int id = 0;
  //
  NewTransactionScreen({Key? key}) : super(key: key);

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    //
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget(screenHeight: screenHeight),
              const DescriptionWidget(),
              const PriceWidget(),
              const TypeAndDateWidget(),
              const SizedBox(height: 10.0),
              ButtonWidget(screenWidth: screenWidth)
            ],
          ),
        ),
      ),
    );
  }
}

//*
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    return SizedBox(
      width: screenWidth,
      height: 40.0,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: kPurpleColor,
        ),
        onPressed: () {
          //
          Money money = Money(
            id: NewTransactionScreen.id == 0
                ? Random().nextInt(99999999)
                : NewTransactionScreen.id,
            title: NewTransactionScreen.descriptionController.text,
            price: NewTransactionScreen.priceController.text,
            date: NewTransactionScreen.date,
            isReceived: NewTransactionScreen.groupValue == 1,
          );
          MyApp.refreshList();
          int finalIndex = 0000;
          for (int i = 0; i < hiveBox.values.length; i++) {
            if (hiveBox.values.elementAt(i).id == NewTransactionScreen.id) {
              finalIndex = i;
            }
          }
          //
          if (NewTransactionScreen.isEdit) {
            hiveBox.putAt(finalIndex, money);
          } else {
            hiveBox.add(money);
          }

          //
          Navigator.pop(context);
        },
        child: Text(NewTransactionScreen.isEdit ? 'ویرایش کردن' : 'اضافه کردن'),
      ),
    );
  }
}

//*
class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({Key? key}) : super(key: key);

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RadioListTile(
            activeColor: kPurpleColor,
            visualDensity: VisualDensity.comfortable,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'دریافتی',
              style: TextStyle(fontSize: 14.0),
            ),
            value: 1,
            groupValue: NewTransactionScreen.groupValue,
            onChanged: (int? value) {
              setState(() {
                NewTransactionScreen.groupValue = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            activeColor: kPurpleColor,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.comfortable,
            title: const Text(
              'پرداختی',
              style: TextStyle(fontSize: 14.0),
            ),
            value: 2,
            groupValue: NewTransactionScreen.groupValue,
            onChanged: (int? value) {
              setState(() {
                NewTransactionScreen.groupValue = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              var picked = await showPersianDatePicker(
                context: context,
                initialDate: Jalali.now(),
                firstDate: Jalali(1400),
                lastDate: Jalali(1499),
              );
              setState(() {
                String year = picked!.year.toString();

                String month = picked.month.toString().length == 1
                    ? '0${picked.month.toString()}'
                    : picked.month.toString();

                String day = picked.day.toString().length == 1
                    ? '0${picked.day.toString()}'
                    : picked.day.toString();

                NewTransactionScreen.date = year + '/' + month + '/' + day;
              });
            },
            child: Text(
              NewTransactionScreen.date == ''
                  ? 'تاریخ'
                  : NewTransactionScreen.date,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

//*
class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: NewTransactionScreen.priceController,
      hintText: 'مبلغ',
      type: TextInputType.number,
    );
  }
}

//*
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: NewTransactionScreen.descriptionController,
      hintText: 'توضیحات',
      type: TextInputType.text,
    );
  }
}

//*
class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      NewTransactionScreen.isEdit ? 'ویرایش تراکنش' : 'تراکنش جدید',
      style: TextStyle(fontSize: screenHeight * 0.025),
    );
  }
}

//*
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType type;
  MyTextField({
    required this.controller,
    required this.hintText,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: hintText,
      ),
    );
  }
}
