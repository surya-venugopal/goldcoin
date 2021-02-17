import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../providers/user.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../constant.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Asset> images = List<Asset>();

  final _form = GlobalKey<FormState>();
  var editedProduct = Product(id: null, title: ' ', description: ' ');
  var initValues = {};
  var isLoading = false;

  int isAd = 0;
  int isOffer = 0;
  String whereToGo = "";

  List<String> imageUrls = <String>[];
  File _video;
  VideoPlayerController _videoPlayerController;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // final productId = ModalRoute.of(context).settings.arguments as String;
    //
    // if (productId != null) {
    //   editedProduct = Provider.of<Products>(context, listen: false)
    //       .findMyViewById(productId);
    //   initValues = {
    //     'title': editedProduct.title,
    //     'description': editedProduct.description,
    //     'quantity': editedProduct.quantity,
    //     // 'image_urls': editedProduct.imageUrl,
    //     'price': editedProduct.price.toString(),
    //   };
    // }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      Toast.show("Fill all the details", context);
      return;
    } else {
      if (images.length > 0) {
        setState(() {
          isLoading = true;
        });
        _form.currentState.save();
        await uploadImages();
        var videoUrl;
        final FirebaseStorage _storage = FirebaseStorage.instance;
        var date = DateTime.now().millisecondsSinceEpoch.toString();
        if (_video != null) {
          await _storage
              .ref()
              .child(
                  "videos/${Provider.of<Users>(context, listen: false).getUser.phone}_$date.mp4")
              .putFile(_video);

          videoUrl = await _storage
              .ref()
              .child(
                  "videos/${Provider.of<Users>(context, listen: false).getUser.phone}_$date.mp4")
              .getDownloadURL();
        }

        if (editedProduct.id != null) {
          editedProduct = Product(
              time: DateTime.now(),
              id: editedProduct.id,
              personName:
                  Provider.of<Users>(context, listen: false).getUser.name,
              personId:
                  Provider.of<Users>(context, listen: false).getUser.phone,
              isFavorite: editedProduct.isFavorite,
              title: editedProduct.title,
              description: editedProduct.description,
              price: editedProduct.price,
              imageUrl: imageUrls,
              quantity: editedProduct.quantity,
              videoUrl: videoUrl,
              isAd: editedProduct.isAd,
              isOffer: editedProduct.isOffer,
              category: whereToGo);

          await Provider.of<Products>(context, listen: false)
              .updateProduct(editedProduct.id, editedProduct);
        } else {
          editedProduct = Product(
              time: DateTime.now(),
              personId:
                  Provider.of<Users>(context, listen: false).getUser.phone,
              personName:
                  Provider.of<Users>(context, listen: false).getUser.name,
              title: editedProduct.title,
              description: editedProduct.description,
              price: editedProduct.price,
              videoUrl: videoUrl,
              imageUrl: imageUrls,
              isFavorite: editedProduct.isFavorite,
              quantity: editedProduct.quantity,
              isAd: isAd,
              isOffer: isOffer,
              category: whereToGo);
          try {
            await Provider.of<Products>(context, listen: false)
                .addProduct(editedProduct);
          } catch (e) {
            await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("An error occurred!"),
                      content: Text("Something Went Wrong!!"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Okay"),
                        )
                      ],
                    ));
          }
          setState(() {
            isLoading = false;
          });
        }
        Navigator.of(context).pop();
      } else {
        Toast.show('Please add some photos', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  Future<void> _pickVideo() async {
    // File video = await ImagePicker.pickVideo(
    //     source: ImageSource.gallery, maxDuration: Duration(seconds: 120));
    var video = await ImagePicker().getVideo(
        maxDuration: Duration(seconds: 120), source: ImageSource.gallery);
    _video = File(video.path);
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    whereToGo = ModalRoute.of(context).settings.arguments as String;
    print("\n\n\n\n\n\n\n\n" + whereToGo);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("Add item"),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Your product is being uploaded..Please wait.")
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Form(
                  key: _form,
                  child: Container(
                    height: size.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPaddin),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                  initialValue: initValues['title'],
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.white),
                                    errorStyle: TextStyle(color: Colors.white),
                                    labelText: 'Title *',
                                  ),
                                  // ignore: deprecated_member_use
                                  autovalidate: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'This is not a valid input';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    editedProduct = Product(
                                        id: editedProduct.id,
                                        isFavorite: editedProduct.isFavorite,
                                        title: newValue,
                                        description: editedProduct.description,
                                        price: editedProduct.price,
                                        quantity: editedProduct.quantity,
                                        isAd: editedProduct.isAd,
                                        isOffer: editedProduct.isOffer,
                                        category: editedProduct.category);
                                  },
                                ),
                                SizedBox(height: 10),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       width: 150,
                                //       child: TextFormField(
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .headline4
                                //             .copyWith(
                                //                 fontSize: 18,
                                //                 color: Colors.white,
                                //                 fontWeight: FontWeight.bold),
                                //         initialValue: initValues['quantity'],
                                //         cursorColor: Colors.white,
                                //         decoration: InputDecoration(
                                //           labelText: 'Quantity *',
                                //           labelStyle:
                                //               TextStyle(color: Colors.white),
                                //           errorStyle:
                                //               TextStyle(color: Colors.white),
                                //         ),
                                //
                                //         // ignore: deprecated_member_use
                                //         autovalidate: true,
                                //         validator: (value) {
                                //           if (value.isEmpty) {
                                //             return 'Please enter some units';
                                //           }
                                //           return null;
                                //         },
                                //         onSaved: (newValue) {
                                //           editedProduct = Product(
                                //               id: editedProduct.id,
                                //               isFavorite:
                                //                   editedProduct.isFavorite,
                                //               title: editedProduct.title,
                                //               description:
                                //                   editedProduct.description,
                                //               quantity: newValue,
                                //               price: editedProduct.price,
                                //               isAd: editedProduct.isAd,
                                //               isOffer: editedProduct.isOffer,
                                //               category: editedProduct.category);
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                TextFormField(
                                  style: TextStyle(height: 1.5,color: Colors.white),
                                  initialValue: initValues['description'],
                                  decoration: InputDecoration(
                                    labelText: 'Description *',
                                    labelStyle: TextStyle(color: Colors.white),
                                    errorStyle: TextStyle(color: Colors.white),

                                  ),

                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,

                                  // ignore: deprecated_member_use
                                  autovalidate: true,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    editedProduct = Product(
                                        id: editedProduct.id,
                                        isFavorite: editedProduct.isFavorite,
                                        title: editedProduct.title,
                                        description: newValue,
                                        price: editedProduct.price,
                                        quantity: editedProduct.quantity,
                                        imageUrl: editedProduct.imageUrl,
                                        isAd: editedProduct.isAd,
                                        isOffer: editedProduct.isOffer,
                                        category: editedProduct.category);
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // height: size.height*3/2,
                          margin: EdgeInsets.only(top: size.height * 0.3),
                          padding: EdgeInsets.only(
                              left: kDefaultPaddin,
                              right: kDefaultPaddin,
                              bottom: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                // height: images.length > 3
                                //     ? 300
                                //     : images.length > 6
                                //     ? 450
                                //     : images.length > 9
                                //     ? 600
                                //     : 150,
                                height: 200,
                                width:
                                    MediaQuery.of(context).size.width * 3 / 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FlatButton(
                                      color: Colors.black12,
                                      child: Text("Pick images"),
                                      textColor: Theme.of(context).accentColor,
                                      onPressed: loadAssets,
                                    ),
                                    Expanded(
                                      child: buildGridView(),
                                    )
                                  ],
                                ),
                              ),
                              FlatButton(
                                child: Text("Pick video"),
                                textColor: Theme.of(context).accentColor,
                                color: Colors.black12,
                                onPressed: _pickVideo,
                              ),
                              _video == null
                                  ? GestureDetector(
                                      onTap: () => _pickVideo(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 150,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            border: Border.all(
                                              width: _video == null ? 2 : 0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    )
                                  : _videoPlayerController.value.initialized
                                      ? AspectRatio(
                                          aspectRatio: _videoPlayerController
                                              .value.aspectRatio,
                                          child: GestureDetector(
                                              onTap: () => _pickVideo(),
                                              child: VideoPlayer(
                                                  _videoPlayerController)),
                                        )
                                      : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                if (!isLoading) {
                  if (images.length > 0) {
                    _showDialog(context);
                  } else {
                    Toast.show('Please add some photos', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                }
                //saveForm();
              },
              child: Icon(Icons.save),
            ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Container(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext ct) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("select type"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(children: [
                    RichText(
                      text: TextSpan(
                        text: 'Do you want your product to appear in the ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Advertisement Section',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("Yes"),
                        Radio(
                          value: 0,
                          groupValue: isAd,
                          onChanged: (value) {
                            print(isAd);
                            setState(() {
                              isAd = value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("No"),
                        Radio(
                          value: 1,
                          groupValue: isAd,
                          onChanged: (value) {
                            setState(() {
                              print(isAd);
                              isAd = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Do you want your product to appear in the ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Offer Section',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(children: [
                      Text("Yes"),
                      Radio(
                        value: 0,
                        groupValue: isOffer,
                        onChanged: (value) {
                          setState(() {
                            print(isOffer);
                            isOffer = value;
                          });
                          editedProduct = Product(
                              id: editedProduct.id,
                              isFavorite: editedProduct.isFavorite,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: editedProduct.price,
                              quantity: editedProduct.quantity,
                              imageUrl: editedProduct.imageUrl,
                              isAd: editedProduct.isAd,
                              isOffer: isOffer,
                              category: editedProduct.category);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("No"),
                      Radio(
                        value: 1,
                        groupValue: isOffer,
                        onChanged: (value) {
                          setState(() {
                            print(isOffer);
                            isOffer = value;
                          });
                          editedProduct = Product(
                              id: editedProduct.id,
                              isFavorite: editedProduct.isFavorite,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              price: editedProduct.price,
                              quantity: editedProduct.quantity,
                              imageUrl: editedProduct.imageUrl,
                              isAd: editedProduct.isAd,
                              isOffer: isOffer,
                              category: editedProduct.category);
                        },
                      ),
                    ]),
                  ]),
                ),
              );
            }),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  showDialog(
                      context: ct,
                      builder: (ctx2) {
                        return AlertDialog(
                          title: Text("Disclaimers"),
                          content: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text(
                                  "* I confirm that there is no objectionable material in this post.",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "* All responsibility for this post rests with me.",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "* I agree that Goldcoin may defer / delete / report post if found non relevant or objectionable.",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "*  I understand that any disagreeable activity by me can lead to me being banned from use of the Goldcoin platform.",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx2).pop();
                                saveForm();

                              },
                              child: Text(
                                "I agree",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        });
  }

  Widget buildGridView() {
    // return initValues['image_urls'] != null
    //     ? GridView.count(
    //         crossAxisCount: 3,
    //         children: List.generate(editedProduct.imageUrl.length, (index) {
    //           return Image.network(
    //             editedProduct.imageUrl[index],
    //             width: 300,
    //             height: 300,
    //             fit: BoxFit.cover,
    //           );
    //         }),
    //       )
    //     :
    return images.length == 0
        ? GestureDetector(
            onTap: () => loadAssets(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    width: images.length == 0 ? 2 : 0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Icon(Icons.add),
              ),
            ),
          )
        : GridView.count(
            crossAxisCount: 3,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              );
            }),
          );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#990011",
          actionBarTitle: "Choose photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future<void> uploadImages() async {
    for (var imageFile in images) {
      await postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          return;
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage db = FirebaseStorage.instance;

    var compressed = await FlutterImageCompress.compressWithList(
        (await imageFile.getByteData()).buffer.asUint8List(),
        quality: 65,
        minHeight: 500,
        minWidth: 500);
    await db
        .ref()
        .child("images")
        .child(
            "${Provider.of<Users>(context, listen: false).getUser.phone}_$fileName")
        .putData(compressed);
    return db
        .ref()
        .child("images")
        .child(
            "${Provider.of<Users>(context, listen: false).getUser.phone}_$fileName")
        .getDownloadURL();
  }
}
