import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class SubCategories extends StatelessWidget {
  final String mainCategory;
  final List<String> subCategories;
  final List<Gem> gems;

  SubCategories(this.mainCategory, this.subCategories, this.gems);

  _buildGemListing(List<Gem> gems) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: gems.length,
      itemBuilder: (BuildContext context, int index) {
        Gem gem = gems[index];
        return Card(
          elevation: 3,
          child: InkWell(
            child: Row(
              children: <Widget>[
                Container(
                  height: 125,
                  width: 110,
                  padding:
                      EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(gem.photoUrl), fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        gem.name,
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                      Text(
                        gem.category,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        gem.subCategory,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GemProfilePage(gem.id),
                ),
              );
            },
          ),
        );
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
          backgroundColor: Colors.black,
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
          title: Text(
            mainCategory,
            style: TextStyle(letterSpacing: 2.0),
          ),
        ),
        body: TabBarView(
          children: listViewSubCategories,
        ),
      ),
    );
  }
}
