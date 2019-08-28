import 'package:hiddengems_flutter/services/modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  Gem _gem;
  bool _isLoading = true;
  bool _autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _musicSubCatDrop,
      _mediaSubCatDrop,
      _entertainmentSubCatDrop,
      _foodSubCatDrop,
      _techSubCatDrop,
      _artSubCatDrop;

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

  File _profileImage, _backgroundImage;
  ImageProvider _profileImageProvider, _backgroundImageProvider;

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
    _musicSubCatDrop = musicSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> mediaSubCatList = List.from(data['media']['subCategories']);
    _mediaSubCatDrop = mediaSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> entertainmentSubCatList =
        List.from(data['entertainment']['subCategories']);
    _entertainmentSubCatDrop =
        entertainmentSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> foodSubCatList = List.from(data['food']['subCategories']);
    _foodSubCatDrop = foodSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> techSubCatList = List.from(data['tech']['subCategories']);
    _techSubCatDrop = techSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> artSubCatList = List.from(data['art']['subCategories']);
    _artSubCatDrop = artSubCatList.map<DropdownMenuItem<String>>(
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

    _gem = Gem.extractDocument(ds);

    _profileImageProvider = NetworkImage(_gem.photoUrl);
    _backgroundImageProvider = NetworkImage(_gem.backgroundUrl);
  }

  Future<void> _setFields() async {
    _nameController.text = _gem.name;
    _bioController.text = _gem.bio;
    _categoryController = _gem.category;
    _subCategoryController = _gem.subCategory;
    _phoneController.text = _gem.phoneNumber;
    _spotifyController.text = _gem.spotifyID;
    _iTunesController.text = _gem.iTunesID;
    _soundCloudController.text = _gem.soundCloudName;
    _instagramController.text = _gem.instagramName;
    _facebookController.text = _gem.facebookName;
    _twitterController.text = _gem.twitterName;
    _youTubeController.text = _gem.youTubeID;
  }

  Future _pickProfileImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImageProvider = FileImage(image);
      _profileImage = image;
    });
  }

  Future _pickBackgroundImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _backgroundImageProvider = FileImage(image);
      _backgroundImage = image;
    });
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await Modal.showConfirmation(
          context, 'Update Profile', 'Are you sure?');

      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          await _submitFormData();
          await _submitImages();

          setState(
            () {
              _isLoading = false;
              Modal.showInSnackBar(_scaffoldKey, 'Profile updated.');
            },
          );
        } catch (e) {
          setState(
            () {
              _isLoading = false;
              Modal.showInSnackBar(_scaffoldKey, e.message);
            },
          );
        }
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  Future<void> _submitImages() async {
    if (_profileImage != null) {
      String newPhotoUrl = await _uploadProfileImage();
      await _db
          .collection('Gems')
          .document(_gem.id)
          .updateData({'photoUrl': newPhotoUrl});
    }

    if (_backgroundImage != null) {
      String newBackgroundUrl = await _uploadBackgroundImage();
      await _db
          .collection('Gems')
          .document(_gem.id)
          .updateData({'backgroundUrl': newBackgroundUrl});
    }
  }

  Future<String> _uploadProfileImage() async {
    final StorageReference ref =
        FirebaseStorage().ref().child('Images/Users/${_gem.id}/Profile');
    final StorageUploadTask uploadTask = ref.putFile(_profileImage);
    StorageReference sr = (await uploadTask.onComplete).ref;
    return (await sr.getDownloadURL()).toString();
  }

  Future<String> _uploadBackgroundImage() async {
    final StorageReference ref =
        FirebaseStorage().ref().child('Images/Users/${_gem.id}/Background');
    final StorageUploadTask uploadTask = ref.putFile(_backgroundImage);
    StorageReference sr = (await uploadTask.onComplete).ref;
    return (await sr.getDownloadURL()).toString();
  }

  Future<void> _submitFormData() async {
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

    await _db.collection('Gems').document(_gem.id).updateData(data);
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'EDIT PROFILE',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [],
    );
  }

  List<DropdownMenuItem<String>> _getSubCatOptions() {
    switch (_categoryController) {
      case 'Music':
        return _musicSubCatDrop;
      case 'Media':
        return _mediaSubCatDrop;
      case 'Entertainment':
        return _entertainmentSubCatDrop;
      case 'Food':
        return _foodSubCatDrop;
      case 'Tech':
        return _techSubCatDrop;
      case 'Art':
        return _artSubCatDrop;
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
        onPressed: () => _submit(),
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              _pickBackgroundImage();
                            },
                            child: CachedNetworkImage(
                              imageUrl: "http://via.placeholder.com/200x150",
                              fit: BoxFit.cover,
                              fadeInCurve: Curves.easeIn,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: _backgroundImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              _buildInfoBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildBasic(),
                          SizedBox(height: 20),
                          _buildTalent(),
                          SizedBox(height: 20),
                          _buildSocial()
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBasic() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Basic',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            SizedBox(height: 20),
            nameFormField(),
            bioFormField(),
            phoneFormField(),
          ],
        ),
      ),
    );
  }

  _buildTalent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Talent',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 20),
            Text('Category'),
            SizedBox(height: 20),
            categoryDropdownField(),
            SizedBox(height: 20),
            Text('Sub Category'),
            SizedBox(height: 20),
            subCategoryDropdownField()
          ],
        ),
      ),
    );
  }

  _buildSocial() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            _categoryController == 'Music' ? spotifyFormField() : Container(),
            _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
            _categoryController == 'Music' ? iTunesFormField() : Container(),
            _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
            _categoryController == 'Music' ? soundCloudFormField() : Container()
          ],
        ),
      ),
    );
  }

  _buildInfoBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 110.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _nameController.text,
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(_categoryController),
                      subtitle: Text(_subCategoryController),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0)
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: _profileImageProvider, fit: BoxFit.cover),
          ),
          margin: EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () {
              _pickProfileImage();
            },
          ),
        ),
      ],
    );
  }
}
