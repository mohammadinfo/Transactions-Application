import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/main.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import '../constant.dart';
import '../models/money.dart';
import 'new_transactions_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  //
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static List<Money> moneys = [];
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTyped = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    //
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    //
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: fabWidget(),
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              headerWidget(hiveBox, searchController, screenHeight),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5.0, top: 20.0),
                  child: HomeScreen.moneys.isEmpty
                      ? const EmptyWidget()
                      : ListView.builder(
                          itemCount: HomeScreen.moneys.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'آیا از حذف این تراکنش مطمئن هستید؟',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'خیر',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              hiveBox.deleteAt(index);
                                              Navigator.pop(context);
                                              MyApp.refreshList();
                                            });
                                          },
                                          child: const Text(
                                            'بله',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onTap: () {
                                //
                                NewTransactionScreen.isEdit = true;
                                //
                                NewTransactionScreen.id = 0;
                                NewTransactionScreen.id =
                                    HomeScreen.moneys[index].id;
                                //
                                NewTransactionScreen.descriptionController
                                    .text = HomeScreen.moneys[index].title;
                                //
                                NewTransactionScreen.priceController.text =
                                    HomeScreen.moneys[index].price;
                                //
                                NewTransactionScreen.groupValue =
                                    HomeScreen.moneys[index].isReceived ? 1 : 2;
                                //
                                NewTransactionScreen.date =
                                    HomeScreen.moneys[index].date;
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewTransactionScreen(),
                                  ),
                                ).then((value) {
                                  setState(() {
                                    MyApp.refreshList();
                                  });
                                });
                                //
                              },
                              child: ListTileWidget(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                index: index,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//*
  FloatingActionButton fabWidget() {
    return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        NewTransactionScreen.id == 0;
        //
        NewTransactionScreen.isEdit = false;
        //
        NewTransactionScreen.descriptionController.text = '';
        //
        NewTransactionScreen.priceController.text = '';
        //
        NewTransactionScreen.groupValue = 0;
        //
        NewTransactionScreen.date = '';
        //
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewTransactionScreen(),
          ),
        ).then((value) {
          setState(() {
            MyApp.refreshList();
          });
        });
        //
      },
      child: const Icon(Icons.add),
    );
  }

//*
  Container headerWidget(Box<Money> hiveBox,
      TextEditingController searchController, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0, top: 20.0, left: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isTyped == false
              ? Expanded(
                  child: SearchBarAnimation(
                    buttonElevation: 0,
                    buttonShadowColour: Colors.black26,
                    isOriginalAnimation: false,
                    buttonBorderColour: Colors.black26,
                    buttonIcon: Icons.search,
                    onFieldSubmitted: (String text) {
                      List<Money> result = hiveBox.values
                          .where(
                            (value) =>
                                value.title.contains(text) ||
                                value.date.contains(text),
                          )
                          .toList();
                      //
                      HomeScreen.moneys.clear();
                      //
                      setState(
                        () {
                          for (var value in result) {
                            HomeScreen.moneys.add(value);
                          }
                          isTyped = true;
                        },
                      );
                    },
                    textEditingController: searchController,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      MyApp.refreshList();
                      isTyped = false;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
          const SizedBox(width: 10.0),
          Text(
            'تراکنش ها',
            style: TextStyle(fontSize: screenHeight * 0.025),
          ),
        ],
      ),
    );
  }
}

//*
class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.index,
  }) : super(key: key);

  final double screenWidth;
  final double screenHeight;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Container(
            margin: const EdgeInsets.only(top: 10.0, left: 15.0),
            child: Text(
              HomeScreen.moneys[index].title,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5.0, right: 5.0),
                child: Row(
                  children: [
                    Text(
                      'تومان',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: HomeScreen.moneys[index].isReceived
                            ? kGreenColor
                            : kRedColor,
                      ),
                    ),
                    Text(
                      HomeScreen.moneys[index].price,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: HomeScreen.moneys[index].isReceived
                            ? kGreenColor
                            : kRedColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, right: 5.0),
                child: Text(HomeScreen.moneys[index].date),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//*
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/images/empty.svg'),
        ),
        const SizedBox(height: 10),
        const Text(' ! تراکنشی موجود نیست'),
        const Spacer(),
      ],
    );
  }
}
