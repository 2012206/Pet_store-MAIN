import 'package:cloud_firestore/cloud_firestore.dart';

///<-------------------------------User Model--------------------------------->
class User {
  String? uid;
  String? username;
  String? email;
  String? age;
  String? address;
  String? mobileno;
  bool? likedPost;

  User(
      {this.uid,
      this.username,
      this.email,
      this.age,
      this.address,
      this.mobileno,
      this.likedPost});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot["uid"],
      username: snapshot["username"],
      email: snapshot["email"],
      age: snapshot["age"],
      address: snapshot["address"],
      mobileno: snapshot["mobileno"],
      likedPost: snapshot["likedPost"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "age": age,
        "address": address,
        "mobileno": mobileno,
        "likedPost": likedPost,
      };
}

///<-------------------------------Cart Model--------------------------------->

class Cart {
  final String? userUid;
  final String? cartId;
  final String? productImage;
  final String? productTitle;
  final String? quantity;
  final String? productPrice;
  final String? productId;

  Cart(
      {this.userUid,
      this.cartId,
      this.productImage,
      this.productTitle,
      this.quantity,
      this.productPrice,
      this.productId
      });

  static Cart fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Cart(
        userUid: snapshot['userUid'],
        cartId: snapshot['cartId'],
        productImage: snapshot['productImage'],
        productTitle: snapshot['productTitle'],
        quantity: snapshot['quantity'],
        productPrice: snapshot['productPrice'],
        productId: snapshot['productId'],

    );
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "cartId": cartId,
        "productImage": productImage,
        "productTitle": productTitle,
        "quantity": quantity,
        "productPrice": productPrice,
        "productId": productId,
      };
}

///<-------------------------------Feeds Model--------------------------------->

class Feeds {
  final String? userUid;
  final String? postId;
  final String? ownerName;
  final String? image;
  final String? title;
  final String? timeStamp;
  List<dynamic>? likes;
  List<dynamic>? comments;

  Feeds(
      {this.userUid,
      this.postId,
      this.ownerName,
      this.image,
      this.title,
      this.timeStamp,
      this.likes,
      this.comments});

  static Feeds fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Feeds(
        userUid: snapshot['userUid'],
        postId: snapshot['postId'],
        ownerName: snapshot['ownerName'],
        image: snapshot['image'],
        title: snapshot['title'],
        timeStamp: snapshot['timeStamp'],
        likes: snapshot['likes'],
        comments: snapshot['comments']);
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "postId": postId,
        "ownerName": ownerName,
        "image": image,
        "title": title,
        "timeStamp": timeStamp,
        "likes": likes,
        "comments": comments,
      };
}

///<-------------------------------LikesOnFeed Model--------------------------------->

class LikesOnFeed {
  final String? name;

  LikesOnFeed({
    this.name,
  });

  static LikesOnFeed fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return LikesOnFeed(
      name: snapshot['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

///<-------------------------------CommentsOnFeed Model--------------------------------->

class CommentsOnFeed {
  final String? name;
  final String? comment;
  List<dynamic>? replies;

  CommentsOnFeed({this.name, this.comment, this.replies});

  factory CommentsOnFeed.fromJson(Map<String, dynamic> json) {
    return CommentsOnFeed(
      name: json['name'] ?? '',
      comment: json['comment'] ?? '',
      replies: json['replies'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "comment": comment, "replies": replies};
}

///<-------------------------------RepliesOnFeed Model--------------------------------->

class RepliesOnFeed {
  final String? name;
  final String? reply;

  RepliesOnFeed({this.name, this.reply});

  factory RepliesOnFeed.fromJson(Map<String, dynamic> json) {
    return RepliesOnFeed(
      name: json['name'] ?? '',
      reply: json['reply'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "reply": reply,
      };
}

///<-------------------------------Videos Model--------------------------------->

class Videos {
  final String? userUid;
  final String? postId;
  final String? ownerName;
  final String? video;
  final String? thumbnail;
  final String? title;
  final String? timeStamp;
  List<dynamic>? likes;
  List<dynamic>? comments;

  Videos(
      {this.userUid,
      this.postId,
      this.ownerName,
      this.video,
      this.thumbnail,
      this.title,
      this.timeStamp,
      this.likes,
      this.comments});

  static Videos fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Videos(
        userUid: snapshot['userUid'],
        postId: snapshot['postId'],
        ownerName: snapshot['ownerName'],
        video: snapshot['video'],
        thumbnail: snapshot['thumbnail'],
        title: snapshot['title'],
        timeStamp: snapshot['timeStamp'],
        likes: snapshot['likes'],
        comments: snapshot['comments']);
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "postId": postId,
        "ownerName": ownerName,
        "video": video,
        "thumbnail": thumbnail,
        "title": title,
        "timeStamp": timeStamp,
        "likes": likes,
        "comments": comments,
      };
}

///<-------------------------------LikesOnVideo Model--------------------------------->

class LikesOnVideo {
  final String? name;

  LikesOnVideo({
    this.name,
  });

  static LikesOnVideo fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return LikesOnVideo(
      name: snapshot['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

///<-------------------------------CommentsOnVideo Model--------------------------------->

class CommentsOnVideo {
  final String? name;
  final String? comment;

  CommentsOnVideo({this.name, this.comment});

  factory CommentsOnVideo.fromJson(Map<String, dynamic> json) {
    return CommentsOnVideo(
      name: json['name'] ?? '',
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "comment": comment};
}

///<-------------------------------Shelter Model--------------------------------->

class Shelter {
  final String? userUid;
  final String? shelterId;
  final String? shelterName;
  final String? email;
  final String? contactNo;
  final String? address;
  final String? postCode;

  Shelter(
      {this.userUid,
      this.shelterId,
      this.shelterName,
      this.email,
      this.contactNo,
      this.address,
      this.postCode});

  static Shelter fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Shelter(
        userUid: snapshot['userUid'],
        shelterId: snapshot['shelterId'],
        shelterName: snapshot['shelterName'],
        email: snapshot['email'],
        contactNo: snapshot['contactNo'],
        address: snapshot['address'],
        postCode: snapshot['postCode']);
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "shelterId": shelterId,
        "shelterName": shelterName,
        "email": email,
        "contactNo": contactNo,
        "address": address,
        "postCode": postCode,
      };
}
