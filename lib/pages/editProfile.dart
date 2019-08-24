import 'package:hiddengems_flutter/services/modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/pages/editImages.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/validater.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  Gem gem;
  bool _isLoading = true;
  bool _autoValidate = false;

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> musicSubCatDrop,
      mediaSubCatDrop,
      entertainmentSubCatDrop,
      foodSubCatDrop,
      techSubCatDrop,
      artSubCatDrop;

  String _categoryController, _subCategoryController;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _spotifyController = TextEditingController();
  TextEditingController _iTunesController = TextEditingController();
  TextEditingController _soundCloudController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _youTubeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await _fetchSubCategories();
    await _fetchUserProfile();
    await _setFields();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  //Convert SubCategories into DropdownMenuItem lists.
  Future<void> _fetchSubCategories() async {
    DocumentSnapshot ds =
        await _db.collection('Miscellaneous').document('HomePage').get();

    dynamic data = ds.data;

    List<String> musicSubCatList = List.from(data['music']['subCategories']);
    musicSubCatDrop = musicSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> mediaSubCatList = List.from(data['media']['subCategories']);
    mediaSubCatDrop = mediaSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> entertainmentSubCatList =
        List.from(data['entertainment']['subCategories']);
    entertainmentSubCatDrop =
        entertainmentSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> foodSubCatList = List.from(data['food']['subCategories']);
    foodSubCatDrop = foodSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> techSubCatList = List.from(data['tech']['subCategories']);
    techSubCatDrop = techSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> artSubCatList = List.from(data['art']['subCategories']);
    artSubCatDrop = artSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }

  Future<void> _fetchUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents[0];

    gem = Gem.extractDocument(ds);
  }

  Future<void> _setFields() async {
    _nameController.text = gem.name;
    _bioController.text = gem.bio;
    _categoryController = gem.category;
    _subCategoryController = gem.subCategory;
    _phoneController.text = gem.phoneNumber;
    _spotifyController.text = gem.spotifyID;
    _iTunesController.text = gem.iTunesID;
    _soundCloudController.text = gem.soundCloudName;
    _instagramController.text = gem.instagramName;
    _facebookController.text = gem.facebookName;
    _twitterController.text = gem.twitterName;
    _youTubeController.text = gem.youTubeID;
  }

  void submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await Modal.showConfirmation(
          context, 'Update Profile', 'Are you sure?');
      if (confirm) {
        var data = {
          'bio': _bioController.text,
          'category': _categoryController,
          'facebookName': _facebookController.text,
          'iTunesID': _iTunesController.text,
          'instagramName': _instagramController.text,
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'soundCloudName': _soundCloudController.text,
          'spotifyID': _spotifyController.text,
          'subCategory': _subCategoryController,
          'twitterName': _twitterController.text,
          'youTubeID': _youTubeController.text
        };

        _db.collection('Gems').document(gem.id).updateData(data).then(
          (res) {
            Modal.showAlert(context, 'Profile Updated',
                'Be sure to refresh the home page.');
          },
        ).catchError(
          (e) {
            Modal.showAlert(
              context,
              'Error',
              e.toString(),
            );
          },
        );
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'EDIT PROFILE',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [
        IconButton(
          icon: Icon(MdiIcons.image),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditImagePage(),
              ),
            );
          },
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> _getSubCatOptions() {
    switch (_categoryController) {
      case 'Music':
        return musicSubCatDrop;
      case 'Media':
        return mediaSubCatDrop;
      case 'Entertainment':
        return entertainmentSubCatDrop;
      case 'Food':
        return foodSubCatDrop;
      case 'Tech':
        return techSubCatDrop;
      case 'Art':
        return artSubCatDrop;
      default:
        return null;
    }
  }

  void _clearMusicRelatedFields() {
    _spotifyController.clear();
    _iTunesController.clear();
    _soundCloudController.clear();
  }

  Widget nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
      ),
    );
  }

  Widget bioFormField() {
    return TextFormField(
      controller: _bioController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.bioCharLimit,
      maxLines: 10,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Bio',
        icon: Icon(Icons.info),
        fillColor: Colors.white,
      ),
    );
  }

  Widget phoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone Number',
        icon: Icon(MdiIcons.phone),
        fillColor: Colors.white,
      ),
    );
  }

  Widget spotifyFormField() {
    return TextFormField(
      controller: _spotifyController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'Spotify Artist ID, (\"4AeeMMRvpOKMeWAcgQ8O6p\")',
        icon: Icon(MdiIcons.spotify),
        fillColor: Colors.white,
      ),
    );
  }

  Widget iTunesFormField() {
    return TextFormField(
      controller: _iTunesController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'iTunes Artist ID, (\"travisty/1469723679\")',
        icon: Icon(MdiIcons.itunes),
        fillColor: Colors.white,
      ),
    );
  }

  Widget soundCloudFormField() {
    return TextFormField(
      controller: _soundCloudController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'SoundCloud name, (\"trey-hope\")',
        icon: Icon(MdiIcons.soundcloud),
        fillColor: Colors.white,
      ),
    );
  }

  Widget instagramFormField() {
    return TextFormField(
      controller: _instagramController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'Instagram, (\"tr3.designs\")',
        icon: Icon(MdiIcons.instagram),
        fillColor: Colors.white,
      ),
    );
  }

  Widget facebookFormField() {
    return TextFormField(
      controller: _facebookController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'Facebook, (\"tr3designs\")',
        icon: Icon(MdiIcons.facebook),
        fillColor: Colors.white,
      ),
    );
  }

  Widget twitterFormField() {
    return TextFormField(
      controller: _twitterController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'Twitter, (\"tr3Designs\")',
        icon: Icon(MdiIcons.twitter),
        fillColor: Colors.white,
      ),
    );
  }

  Widget youTubeFormField() {
    return TextFormField(
      controller: _youTubeController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintMaxLines: 2,
        hintText: 'YouTube Channel ID, (\"UCyMTUp7B-lFoRbDfLr3QuJw\")',
        icon: Icon(MdiIcons.youtube),
        fillColor: Colors.white,
      ),
    );
  }

  Widget categoryDropdownField() {
    return Container(
      width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _categoryController,
            onChanged: (String value) {
              setState(
                () {
                  _categoryController = value;
                  //Set the sub category to the first option available.
                  _subCategoryController = _getSubCatOptions()[0].value;
                  //Clear music field values of Music not selected.
                  if (_categoryController != 'Music') {
                    _clearMusicRelatedFields();
                  }
                },
              );
            },
            items: MyFormData.categories.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget subCategoryDropdownField() {
    return Container(
      width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _subCategoryController,
            onChanged: (String value) {
              setState(
                () {
                  _subCategoryController = value;
                },
              );
            },
            items: _getSubCatOptions(),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => submit(),
        color: Colors.blue,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.save,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'SAVE',
                style: TextStyle(color: Colors.white, letterSpacing: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      Text('Basic',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      SizedBox(height: 20),
                      nameFormField(),
                      bioFormField(),
                      phoneFormField(),
                      Divider(),
                      SizedBox(height: 20),
                      Text('Talent',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      SizedBox(height: 20),
                      Text('Category'),
                      categoryDropdownField(),
                      SizedBox(height: 20),
                      Text('Sub Category'),
                      subCategoryDropdownField(),
                      Divider(),
                      SizedBox(height: 20),
                      Text('Social',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                      SizedBox(height: 20),
                      instagramFormField(),
                      SizedBox(height: 20),
                      facebookFormField(),
                      SizedBox(height: 20),
                      twitterFormField(),
                      SizedBox(height: 20),
                      youTubeFormField(),
                      SizedBox(height: 20),
                      _categoryController == 'Music'
                          ? spotifyFormField()
                          : Container(),
                      SizedBox(height: 20),
                      _categoryController == 'Music'
                          ? iTunesFormField()
                          : Container(),
                      SizedBox(height: 20),
                      _categoryController == 'Music'
                          ? soundCloudFormField()
                          : Container()
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
