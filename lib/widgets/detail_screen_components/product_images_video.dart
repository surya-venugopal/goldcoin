import 'package:cached_network_image/cached_network_image.dart';
import 'package:stocklot/providers/product.dart';

import 'package:flutter/material.dart';
import '../image_viewer.dart';
import 'package:video_player/video_player.dart';

import '../../constant.dart';
import '../../size_config.dart';
import 'dart:async';

class ProductImages extends StatefulWidget {
  final String id;

  ProductImages(this.id);

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  bool isVideo = false;
  bool isOnce = false;
  List<String> getUrls(BuildContext context) {
    final loadedProduct =
    ModalRoute.of(context).settings.arguments as Product;
    List<String> urls = [];
    if (loadedProduct.videoUrl != null) {
      urls.insert(0, loadedProduct.videoUrl);
      setState(() {
        isVideo = true;
      });
    }
    for (String imgUrl in loadedProduct.imageUrl) {
      urls.add(imgUrl);
    }
    return urls;
  }

  List<String> checkUrl(List<String> images) {
    List<String> newUrls = [];
    images.removeAt(0);
    newUrls = images;
    setState(() {
      isOnce = true;
    });
    return newUrls;
  }

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  int selectedImage = 0;

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      final videoUrl =
      ModalRoute.of(context).settings.arguments as Product;
      _controller = VideoPlayerController.network(
        videoUrl.videoUrl,
      );
      _controller.setVolume(1.0);
      _initializeVideoPlayerFuture = _controller.initialize();
    }

    // _controller.setLooping(true);
    // _controller.addListener(() {
    //   final bool isPlaying = _controller.value.isPlaying;
    //   if (isPlaying != _isPlaying) {
    //     setState(() {
    //       _isPlaying = isPlaying;
    //     });
    //   }
    //   Timer.run(() {
    //     this.setState(() {
    //       _position = _controller.value.position;
    //     });
    //   });
    //   setState(() {
    //     _duration = _controller.value.duration;
    //   });
    //   _duration?.compareTo(_position) == 0 ||
    //           _duration?.compareTo(_position) == -1
    //       ? this.setState(() {
    //           _controller.pause();
    //           _isEnd = true;
    //         })
    //       : this.setState(() {
    //           _isEnd = false;
    //         });
    // });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loadedProduct =
    ModalRoute.of(context).settings.arguments as Product;
    final url = getUrls(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          margin: EdgeInsets.all(15),
          child: AspectRatio(
            aspectRatio: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isVideo && selectedImage == 0
                  ? FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoPlayer(_controller),
                                Align(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_controller.value.isPlaying) {
                                          _controller.pause();
                                        } else {
                                          _controller.play();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                                VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        List<String> imageUrl;
                        if (isVideo) {
                          imageUrl = checkUrl(url);
                          Navigator.push(context,
                              _createImageViewer(selectedImage - 1, imageUrl));
                        }
                        else
                        {
                          Navigator.push(context,
                              _createImageViewer(selectedImage, url));
                        }
                      },
                      child: Hero(
                        tag: loadedProduct.id,
                        child: CachedNetworkImage(
                          imageUrl: url[selectedImage],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
        ),

        //SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              itemBuilder: (ctx, i) =>
                  buildSmallProductPreview(i, url, _controller, isVideo),
              itemCount: url.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index, List<String> imageUrl,
      VideoPlayerController controller, bool isVideo) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: isVideo && index == 0
            ? VideoPlayer(controller)
            : CachedNetworkImage(
                imageUrl: imageUrl[index],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
      ),
    );
  }

  MaterialPageRoute _createImageViewer(
    int selectedImage,
    List<String> url,
  ) {
    return MaterialPageRoute(
      builder: (context) => ImageViewer(
        selectedImage,
        url,
      ),
    );
  }
}
