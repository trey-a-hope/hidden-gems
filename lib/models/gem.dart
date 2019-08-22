class Gem {
  //Required
  String name;
  String category;
  String subCategory;
  String bio;
  String photoUrl;
  String backgroundUrl;

  //Default value.
  String id;
  List<dynamic> likes = List<dynamic>();//List of user IDs

  //Can be null.
  String email;
  String phoneNumber;
  String spotifyID; 
  String iTunesID; 
  String youTubeID;
  String instagramName;
  String facebookName;
  String twitterName;
  String soundCloudName;
}
