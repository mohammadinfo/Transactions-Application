// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/main_screen.dart';
import 'package:money_app/screens/new_transactions_screen.dart';
import 'package:money_app/utils/extension.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static List<Money> moneys = [];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              headerWidget(),
              //const Expanded(child: EmptyWidget()),
              Expanded(
                child: HomeScreen.moneys.isEmpty
                    ? const EmptyWidget()
                    : ListView.builder(
                        itemCount: HomeScreen.moneys.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              //* Edit
                              onTap: () {
                                //
                                NewTransactionsScreen.date =
                                    HomeScreen.moneys[index].date;
                                //
                                NewTransactionsScreen.descriptionController
                                    .text = HomeScreen.moneys[index].title;
                                //
                                NewTransactionsScreen.priceController.text =
                                    HomeScreen.moneys[index].price;
                                //
                                NewTransactionsScreen.groupId =
                                    HomeScreen.moneys[index].isReceived ? 1 : 2;
                                //
                                NewTransactionsScreen.isEditing = true;
                                //
                                NewTransactionsScreen.id =
                                    HomeScreen.moneys[index].id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NewTransactionsScreen(),
                                  ),
                                ).then((value) {
                                  MyApp.getData();
                                  setState(() {});
                                });
                              },
                              //! Delete
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'آیا از حذف این آیتم مطمئن هستید؟',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('خیر',
                                            style: TextStyle(
                                                color: Colors.black87)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          hiveBox.deleteAt(index);
                                          MyApp.getData();
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'بله',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: MyListTileWidget(index: index));
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //! FAB Widget
  Widget fabWidget() {
    return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        NewTransactionsScreen.date = 'تاریخ';
        NewTransactionsScreen.descriptionController.text = '';
        NewTransactionsScreen.priceController.text = '';
        NewTransactionsScreen.groupId = 0;
        NewTransactionsScreen.isEditing = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewTransactionsScreen(),
          ),
        ).then((value) {
          MyApp.getData();
          setState(() {});
        });
      },
      child: const Icon(Icons.add),
    );
  }

  //! Header Widget
  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              hintText: '...جستجو کنید',
              buttonElevation: 0,
              buttonShadowColour: Colors.black26,
              isOriginalAnimation: false,
              buttonBorderColour: Colors.black26,
              buttonIcon: Icons.search,
              onCollapseComplete: () {
                MyApp.getData();
                searchController.text = '';
                setState(() {});
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where(
                      (value) =>
                          value.title.contains(text) ||
                          value.date.contains(text),
                    )
                    .toList();
                HomeScreen.moneys.clear();

                setState(() {
                  for (var value in result) {
                    HomeScreen.moneys.add(value);
                  }
                });
              },
              textEditingController: searchController,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'تراکنش ها',
            style: TextStyle(
                fontSize: ScreenSize(context).screenWidth < 1004
                    ? 18
                    : ScreenSize(context).screenWidth * 0.015),
          ),
        ],
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;
  const MyListTileWidget({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  HomeScreen.moneys[index].isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Icon(
                HomeScreen.moneys[index].isReceived ? Icons.add : Icons.remove,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              HomeScreen.moneys[index].title,
              style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.015),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'تومان',
                    style: TextStyle(
                      fontSize: ScreenSize(context).screenWidth < 1004
                          ? 14
                          : ScreenSize(context).screenWidth * 0.015,
                      color: kRedColor,
                    ),
                  ),
                  Text(
                    HomeScreen.moneys[index].price,
                    style: TextStyle(
                        fontSize: ScreenSize(context).screenWidth < 1004
                            ? 14
                            : ScreenSize(context).screenWidth * 0.015,
                        color: kRedColor),
                  ),
                ],
              ),
              Text(
                HomeScreen.moneys[index].date,
                style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 12
                      : ScreenSize(context).screenWidth * 0.01,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

//! Empty Widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/images/empty.svg',
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 10),
        const Text(' ! تراکنشی موجود نیست'),
        const Spacer(),
      ],
    );
  }
}
