import 'package:flutter/material.dart';
import 'package:khaikhai/model/burger_model.dart';
import 'package:khaikhai/model/category_model.dart';
import 'package:khaikhai/model/chinese_model.dart';
import 'package:khaikhai/model/mexican_model.dart';
import 'package:khaikhai/model/pizza_model.dart';
import 'package:khaikhai/pages/detail_page.dart';
import 'package:khaikhai/service/burger_data.dart';
import 'package:khaikhai/service/category_data.dart';
import 'package:khaikhai/service/chinese_data.dart';
import 'package:khaikhai/service/mexican_data.dart';
import 'package:khaikhai/service/pizza_data.dart';
import 'package:khaikhai/service/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<PizzaModel> pizza = [];
  List<BurgerModel> burger = [];
  List<ChineseModel> chinese = [];
  List<MexicanModel> mexican = [];
  List<dynamic> allFoodItems = [];
  List<dynamic> filteredItems = [];
  String track = "0";
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    pizza = getPizza();
    burger = getBurger();
    chinese = getChinese();
    mexican = getMexican();
    
    // Combine all items for searching
    allFoodItems.addAll(pizza);
    allFoodItems.addAll(burger);
    allFoodItems.addAll(chinese);
    allFoodItems.addAll(mexican);
    
    filteredItems = [];
  }

  void onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        filteredItems = [];
      } else {
        filteredItems = allFoodItems
            .where((item) =>
                item.name!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/logo.png",
                        height: 50,
                        width: 110,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "Order your favourite food!",
                        style: AppWidget.simpleTextFieldStyle(),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/boy.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFececf8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchTextChanged,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search food item...",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(Icons.search, color: Colors.white, size: 30.0),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              if (searchController.text.isEmpty)
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return categoryTile(
                        categories[index].name!,
                        categories[index].image!,
                        index.toString(),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10.0),
              _buildFoodGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodGrid() {
    List<dynamic> items;
    if (searchController.text.isNotEmpty) {
      items = filteredItems;
      if (items.isEmpty) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text("No food items found matching \"${searchController.text}\"",
                  style: AppWidget.simpleTextFieldStyle()),
            ],
          ),
        );
      }
    } else {
      if (track == "0") {
        items = pizza;
      } else if (track == "1") {
        items = burger;
      } else if (track == "2") {
        items = chinese;
      } else if (track == "3") {
        items = mexican;
      } else {
        return Container();
      }
    }

    return GridView.builder(
      padding: EdgeInsets.only(bottom: 100.0), // Add padding to avoid overlap with bottom nav
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.63,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 15.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return foodTile(
          items[index].name!,
          items[index].image!,
          items[index].price!,
        );
      },
    );
  }

  Widget foodTile(String name, String image, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(image: image, name: name, price: price),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.0, top: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                image,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 5),
            Text(name,
                style: AppWidget.boolTextFieldStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(price, style: AppWidget.priceTextFieldStyle()),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(String name, String image, String categoryindex) {
    return GestureDetector(
      onTap: () {
        track = categoryindex.toString();
        setState(() {});
      },
      child: track == categoryindex
          ? Container(
              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xffef2b39),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        image,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10.0),
                      Text(name, style: AppWidget.whiteTextFieldStyle()),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(image,
                      height: 40, width: 40, fit: BoxFit.cover),
                  SizedBox(width: 10.0),
                  Text(name, style: AppWidget.simpleTextFieldStyle()),
                ],
              ),
            ),
    );
  }
}
