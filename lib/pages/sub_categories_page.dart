import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/common/user_card.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';

class SubCategoriesPage extends StatefulWidget {
  final String mainCategory;
  final Color titleColor;
  final IconData titleIcon;
  final List<String> subCategories;

  SubCategoriesPage(
      this.mainCategory, this.subCategories, this.titleColor, this.titleIcon);

  @override
  State createState() => SubCategoriesPageState(
        this.mainCategory,
        this.subCategories,
        this.titleColor,
        this.titleIcon,
      );
}

class SubCategoriesPageState extends State<SubCategoriesPage> {
  final String mainCategory;
  final List<String> subCategories;
  final Color titleColor;
  final IconData titleIcon;
  final GetIt getIt = GetIt.I;
  List<User> gems = List<User>();
  bool _isLoading = true;

  SubCategoriesPageState(
      this.mainCategory, this.subCategories, this.titleColor, this.titleIcon);

  _buildGemListing(List<User> gems) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: gems.length,
      itemBuilder: (BuildContext context, int index) {
        return UserCard(user: gems[index]);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _load();
  }

  void _load() async {
    try {
      gems = await getIt<Auth>().getGems(category: mainCategory, limit: 100);

      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      setState(
        () {
          _isLoading = false;
          getIt<Modal>().showAlert(
            context: context,
            title: 'Error',
            message: e.toString(),
          );
        },
      );
    }
  }

  Widget _buildPage() {
    //Build data for Default Tab Controller.
    List<Tab> tabs = List<Tab>();
    List<ListView> listViewSubCategories = List<ListView>();

    //Create Tab for each sub category of the main category.
    for (String subCategory in subCategories) {
      //Create tab object.
      Tab tab = Tab(text: '${subCategory}s');
      tabs.add(tab);

      //Split gems into respective listings.
      List<User> subCategoryGems =
          gems.where((i) => i.subCategory == subCategory).toList();

      //Create page.
      listViewSubCategories.add(
        _buildGemListing(subCategoryGems),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: tabs,
            ),
            title: Row(
              children: <Widget>[
                Icon(titleIcon, color: titleColor),
                SizedBox(width: 10),
                Text(
                  mainCategory.toUpperCase(),
                  style: TextStyle(letterSpacing: 2.0, color: titleColor),
                ),
              ],
            )),
        body: TabBarView(
          children: listViewSubCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child:Spinner(),
            ),
          )
        : _buildPage();
  }
}
