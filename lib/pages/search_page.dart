import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/common/search_bar_widget.dart';
import 'package:algolia/algolia.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/common/user_card.dart';
import 'package:hiddengems_flutter/main.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  bool _isSearchingGems = true;

  @override
  void initState() {
    super.initState();

    _searchAppBar = SearchBar(
        inBar: true,
        hintText: 'Enter name...',
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

    AlgoliaQuery query = algolia.instance.index('Users').search(value);
    query = query.setFacetFilter('isGem:$_isSearchingGems');

    _results = (await query.getObjects()).hits;

    setState(
      () {
        _searching = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _searchAppBar.build(context),
      floatingActionButton: _buildFAB(),
      body: _searching == true
          ? Spinner()
          : _results.length == 0
              ? Center(
                  child: Text("No results found."),
                )
              : Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        AlgoliaObjectSnapshot snap = _results[index];
                        User user = User.extractAlgoliaObjectSnapshot(snap);
                        return UserCard(user: user);
                      },
                    )
                  ],
                ),
    );
  }

  _buildFAB() {
    return FloatingActionButton(
      elevation: Theme.of(context).floatingActionButtonTheme.elevation,
      backgroundColor: _isSearchingGems ? Colors.green : Colors.white,
      child: Icon(MdiIcons.diamondStone,
          color: _isSearchingGems ? Colors.white : Colors.green),
      onPressed: () {
        setState(() {
          _isSearchingGems = !_isSearchingGems;
          getIt<Modal>().showInSnackBar(scaffoldKey: _scaffoldKey, message: 'Now searching ${_isSearchingGems ? 'Gems' : 'Users'}');
        });
      },
    );
  }
}
