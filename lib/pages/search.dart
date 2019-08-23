import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/widgets/searchBar.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/models/gemCard.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBar _searchAppBar;
  String _searchText = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _searchAppBar = SearchBar(
        inBar: true,
        hintText: 'Enter name of Gem...',
        buildDefaultAppBar: (context) {
          return AppBar(
            automaticallyImplyLeading: true,
            title: Text('Search'),
            actions: [
              _searchAppBar.getSearchAction(context),
            ],
          );
        },
        setState: setState,
        onSubmitted: onSubmitted);
  }

  void onSubmitted(String value) {
    _searchText = value;
    print(_searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _searchAppBar.build(context),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Gems')
            .orderBy('name')
            .startAt([_searchText])
            .endAt([_searchText + '\u{f8ff}'])
            .limit(25)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Column(children: <Widget>[
              Text('Loading...',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0))
            ]);
          else if (_searchText.isEmpty)
            return Center(
              child: Text('Search for gems...'),
            );
          else if (snapshot.data.documents.length == 0)
            return Center(
              child: Text('No gems found...'),
            );
          else
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                Gem gem = Gem();

                gem.id = ds['id'];
                gem.name = ds['name'];
                gem.category = ds['category'];
                gem.subCategory = ds['subCategory'];
                gem.photoUrl = ds['photoUrl'];

                return GemCard(gem);
              },
            );
        },
      ),
    );
  }
}
