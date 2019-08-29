import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/common/search_bar_widget.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/common/gem_card.dart';
import 'package:algolia/algolia.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBar _searchAppBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  final String ALGOLIA_APP_ID = 'ZWB00DM8S2';
  final String ALGOLIA_SEARCH_API_KEY = 'c769ba8629b5635bf600cd5fb6dee47c';

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
    _search(value);
  }

  _search(String value) async {
    setState(
      () {
        _searching = true;
      },
    );

    Algolia algolia = Algolia.init(
      applicationId: ALGOLIA_APP_ID,
      apiKey: ALGOLIA_SEARCH_API_KEY,
    );

    AlgoliaQuery query = algolia.instance.index('Gems');
    query = query.search(value);

    _results = (await query.getObjects()).hits;

    setState(
      () {
        _searching = false;
      },
    );
  }

  Widget _buildListTile(AlgoliaObjectSnapshot snap) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GemProfilePage(snap.data['id']),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(snap.data["photoUrl"]),
            ),
            title: Text(snap.data["name"]),
            subtitle: Text('${snap.data['category']} / ${snap.data['subCategory']}' ),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _searchAppBar.build(context),
      body: _searching == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _results.length == 0
              ? Center(
                  child: Text("No results found."),
                )
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    AlgoliaObjectSnapshot snap = _results[index];
                    return _buildListTile(snap);
                  },
                ),
    );
  }
}
