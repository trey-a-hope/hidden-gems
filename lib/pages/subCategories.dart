import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/widgets/gemCard.dart';

class SubCategories extends StatelessWidget {
  final String mainCategory;
  final List<String> subCategories;
  final List<Gem> gems;
  final Color titleColor;
  final IconData titleIcon;

  SubCategories(this.mainCategory, this.subCategories, this.gems, this.titleColor, this.titleIcon);

  _buildGemListing(List<Gem> gems) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: gems.length,
      itemBuilder: (BuildContext context, int index) {
        return GemCard(gems[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = List<Tab>();
    List<ListView> listViewSubCategories = List<ListView>();

    //Create Tab for each sub category of the main category.
    for (String subCategory in subCategories) {
      //Create tab object.
      Tab tab = Tab(text: '${subCategory}s');
      tabs.add(tab);

      //Split gems into respective listings.
      List<Gem> subCategoryGems =
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
                  mainCategory,
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
}
