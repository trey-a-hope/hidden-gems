import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/common/gem_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class SubCategoriesPageState extends State<SubCategoriesPage>
    with SingleTickerProviderStateMixin {
  final String mainCategory;
  final List<String> subCategories;
  final Color titleColor;
  final IconData titleIcon;
  final _db = Firestore.instance;
  
  List<Gem> gems = List<Gem>();
  bool _isLoading = true;

  SubCategoriesPageState(
      this.mainCategory, this.subCategories, this.titleColor, this.titleIcon);

  _buildGemListing(List<Gem> gems) {
    return ListView.builder(
      padding: EdgeInsets.all(6),
      itemCount: gems.length,
      itemBuilder: (BuildContext context, int index) {
        return GemCard(gem: gems[index]);
      },
    );
  }

  Future<List<Gem>> _getGems() async {
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('category', isEqualTo: mainCategory)
        .getDocuments();
    List<DocumentSnapshot> docSnapshots = qs.documents;
    List<Gem> gems = List<Gem>();
    for (DocumentSnapshot docSnapshot in docSnapshots) {
      Gem gem = Gem();

      gem.id = docSnapshot['id'];
      gem.name = docSnapshot['name'];
      gem.category = docSnapshot['category'];
      gem.subCategory = docSnapshot['subCategory'];
      gem.photoUrl = docSnapshot['photoUrl'];
      gem.likes = docSnapshot['likes'];

      gems.add(gem);
    }
    return gems;
  }

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  void loadPage() async {
    gems = await _getGems();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Widget _buildPage() {
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
              child: CircularProgressIndicator(),
            ),
          )
        : _buildPage();
  }
}
