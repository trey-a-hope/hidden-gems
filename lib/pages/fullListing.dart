import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class FullListing extends StatelessWidget {
  final String main_category;
  final List<String> sub_categories;
  final List<Gem> gems;

  FullListing(this.main_category, this.sub_categories, this.gems);

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs =  List<Tab>();
    List<ListView> list_view_sub_categories =  List<ListView>();

    //For each sub category...
    for (String sub_category in this.sub_categories) {

      //Create tab object.
      Tab tab = Tab(text: sub_category);
      tabs.add(tab);

      //Split gems into respective listings.
      List<Gem> sub_category_gems = this.gems.where((i) => i.sub_category == sub_category).toList();

      //Create list tile for Gem.
      List<ListTile> gem_list_tiles =  List<ListTile>();
      for(Gem sub_category_gem in sub_category_gems){
        ListTile lt = ListTile(
          title: Text(sub_category_gem.name),
        );
        gem_list_tiles.add(lt);
      }

      //Create page.
      list_view_sub_categories.add( ListView(
        children: gem_list_tiles
      ));
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: tabs,
            ),
            title: Text(this.main_category,
                style:  TextStyle(letterSpacing: 2.0))),
        body: TabBarView(
          children: list_view_sub_categories,
        ),
      ),
    );
  }
}
