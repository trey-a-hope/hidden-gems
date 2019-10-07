import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditGemProfilePage extends StatefulWidget {
  @override
  State createState() => EditGemProfilePageState();
}

class EditGemProfilePageState extends State<EditGemProfilePage> {
  final CollectionReference _miscellaneousDB =
      Firestore.instance.collection('Miscellaneous');
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  User _gem;
  bool _isLoading = true;
  bool _autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _musicSubCatDrop,
      _mediaSubCatDrop,
      _entertainmentSubCatDrop,
      _foodSubCatDrop,
      _technologySubCatDrop,
      _artSubCatDrop,
      _tradeSubCatDrop,
      _beautySubCatDrop;

  String _categoryController;
  String _subCategoryController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _spotifyController = TextEditingController();
  final TextEditingController _iTunesController = TextEditingController();
  final TextEditingController _soundCloudController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _youTubeController = TextEditingController();

  File _profileImage;
  File _backgroundImage;
  ImageProvider _profileImageProvider;
  ImageProvider _backgroundImageProvider;

  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await _fetchSubCategories();

    _gem = await getIt<Auth>().getCurrentUser();

    _profileImageProvider = NetworkImage(_gem.photoUrl);
    _backgroundImageProvider = NetworkImage(_gem.backgroundUrl);

    _nameController.text = _gem.name;
    _bioController.text = _gem.bio;
    _categoryController = _gem.category;
    _subCategoryController = _gem.subCategory;
    _phoneController.text = _gem.phoneNumber;
    _spotifyController.text = _gem.spotifyUrl;
    _iTunesController.text = _gem.iTunesUrl;
    _soundCloudController.text = _gem.soundCloudUrl;
    _instagramController.text = _gem.instagramUrl;
    _facebookController.text = _gem.facebookUrl;
    _twitterController.text = _gem.twitterUrl;
    _youTubeController.text = _gem.youTubeUrl;

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  //Convert SubCategories into DropdownMenuItem lists.
  List<DropdownMenuItem<String>> _fetchSubCategoriesHelper(
      {@required dynamic data}) {
    List<String> list = List.from(data['subCategories']);
    return list.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }

  Future<void> _fetchSubCategories() async {
    DocumentSnapshot ds = await _miscellaneousDB.document('HomePage').get();

    dynamic data = ds.data;

    _musicSubCatDrop = _fetchSubCategoriesHelper(data: data['music']);
    _mediaSubCatDrop = _fetchSubCategoriesHelper(data: data['media']);
    _entertainmentSubCatDrop =
        _fetchSubCategoriesHelper(data: data['entertainment']);
    _foodSubCatDrop = _fetchSubCategoriesHelper(data: data['food']);
    _technologySubCatDrop = _fetchSubCategoriesHelper(data: data['technology']);
    _artSubCatDrop = _fetchSubCategoriesHelper(data: data['art']);
    _tradeSubCatDrop = _fetchSubCategoriesHelper(data: data['trade']);
    _beautySubCatDrop = _fetchSubCategoriesHelper(data: data['beauty']);
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

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Update Profile', message: 'Are you sure?');

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
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, message: 'Profile updated.');
            },
          );
        } catch (e) {
          setState(
            () {
              _isLoading = false;
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, message: e.message());
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
      String newPhotoUrl = await getIt<Storage>().uploadImage(
          file: _profileImage, path: 'Images/Users/${_gem.id}/Profile');
      await _usersDB.document(_gem.id).updateData({'photoUrl': newPhotoUrl});
    }

    if (_backgroundImage != null) {
      String newBackgroundUrl = await getIt<Storage>().uploadImage(
          file: _backgroundImage, path: 'Images/Users/${_gem.id}/Background');
      await _usersDB
          .document(_gem.id)
          .updateData({'backgroundUrl': newBackgroundUrl});
    }
  }

  // Future<String> _uploadProfileImage() async {
  //   final StorageReference ref =
  //       FirebaseStorage().ref().child('Images/Users/${_gem.id}/Profile');
  //   final StorageUploadTask uploadTask = ref.putFile(_profileImage);
  //   StorageReference sr = (await uploadTask.onComplete).ref;
  //   return (await sr.getDownloadURL()).toString();
  // }

  // Future<String> _uploadBackgroundImage() async {
  //   final StorageReference ref =
  //       FirebaseStorage().ref().child('Images/Users/${_gem.id}/Background');
  //   final StorageUploadTask uploadTask = ref.putFile(_backgroundImage);
  //   StorageReference sr = (await uploadTask.onComplete).ref;
  //   return (await sr.getDownloadURL()).toString();
  // }

  Future<void> _submitFormData() async {
    var data = {
      'bio': _bioController.text,
      'category': _categoryController,
      'facebookUrl': _facebookController.text,
      'iTunesUrl': _iTunesController.text,
      'instagramUrl': _instagramController.text,
      'name': _nameController.text,
      'phoneNumber': _phoneController.text,
      'soundCloudUrl': _soundCloudController.text,
      'spotifyUrl': _spotifyController.text,
      'subCategory': _subCategoryController,
      'twitterUrl': _twitterController.text,
      'youTubeUrl': _youTubeController.text
    };

    await _usersDB.document(_gem.id).updateData(data);
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
      case 'Technology':
        return _technologySubCatDrop;
      case 'Art':
        return _artSubCatDrop;
      case 'Trade':
        return _tradeSubCatDrop;
      case 'Beauty':
        return _beautySubCatDrop;
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
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person, color: Colors.red),
        fillColor: Colors.white,
      ),
    );
  }

  Widget bioFormField() {
    return TextFormField(
      controller: _bioController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      maxLength: MyFormData.bioCharLimit,
      maxLines: 10,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Bio',
        icon: Icon(Icons.info, color: Colors.amber),
        fillColor: Colors.white,
      ),
    );
  }

  Widget phoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone Number',
        icon: Icon(MdiIcons.phone, color: Colors.blue),
        fillColor: Colors.white,
      ),
    );
  }

  Widget spotifyFormField() {
    return TextFormField(
      controller: _spotifyController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.spotify, color: Colors.green),
        fillColor: Colors.white,
        hintText: 'https://open.spotify.com/artist/4AeeMMRvpOKMeWAcgQ8O6p?si=boRhW5JkRW2T9tp3Xob74Q'
      ),
    );
  }

  Widget iTunesFormField() {
    return TextFormField(
      controller: _iTunesController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.itunes, color: Colors.grey),
        fillColor: Colors.white,
        hintText: 'https://music.apple.com/us/artist/travisty/1469723679'
      ),
    );
  }

  Widget soundCloudFormField() {
    return TextFormField(
      controller: _soundCloudController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.soundcloud, color: Colors.orange),
        fillColor: Colors.white,
        hintText: 'https://soundcloud.com/trey-hope'
      ),
    );
  }

  Widget instagramFormField() {
    return TextFormField(
      controller: _instagramController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.instagram,
      
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.instagram, color: Colors.pink),
        fillColor: Colors.white,
        hintText: 'https://www.instagram.com/trey.a.hope'
      ),
    );
  }

  Widget facebookFormField() {
    return TextFormField(
      controller: _facebookController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.facebook, color: Colors.blue),
        fillColor: Colors.white,
        hintText: 'https://www.facebook.com/trey.a.hope'
      ),
    );
  }

  Widget twitterFormField() {
    return TextFormField(
      controller: _twitterController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.twitter,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.twitter, color: Colors.lightBlue),
        fillColor: Colors.white,
        hintText: 'https://twitter.com/travisty92'
      ),
    );
  }

  Widget youTubeFormField() {
    return TextFormField(
      controller: _youTubeController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      // validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        icon: Icon(MdiIcons.youtube, color: Colors.red),
        fillColor: Colors.white,
        hintText: 'https://www.youtube.com/channel/UCjcR0stkmPmeYkf9JDEq_ZQ'
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
            subCategoryDropdownField(),
            Container()
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Social',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          //INSTAGRAM
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter your Instagram URL'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: instagramFormField(),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          //FACEBOOK
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter your Facebook URL'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: facebookFormField(),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          //TWITTER
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter your Twitter URL'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: twitterFormField(),
          ),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          //YOUTUBE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Enter your YouTube URL'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: youTubeFormField(),
          ),
          SizedBox(height: 20),
          _categoryController == 'Music' ? Divider() : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
          //SPOTIFY
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Enter your Spotify URL'),
                )
              : Container(),
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: spotifyFormField(),
                )
              : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
          _categoryController == 'Music' ? Divider() : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
          //iTunes
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Enter your iTunes URL'),
                )
              : Container(),
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: iTunesFormField(),
                )
              : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
          _categoryController == 'Music' ? Divider() : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container(),
          //SOUNDCLOUD
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Enter your SoundCloud URL'),
                )
              : Container(),
          _categoryController == 'Music'
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: soundCloudFormField(),
                )
              : Container(),
          _categoryController == 'Music' ? SizedBox(height: 20) : Container()
        ],
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
