import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final int currentIndex;
  final List<String> url;

  ImageViewer(this.currentIndex, this.url);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int _currentIndex;
  PageController _pageController;
  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        _buildPhotoViewGallery(),
        _buildIndicator(),
      ],
    );
  }

  PhotoViewGallery _buildPhotoViewGallery() {
    return PhotoViewGallery.builder(
      itemCount: widget.url.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(widget.url[index]),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.contained * 1.8,
          initialScale: PhotoViewComputedScale.contained * 0.8,
        );
      },
      enableRotation: false,
      scrollPhysics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      pageController: _pageController,
      loadingBuilder: (context, event) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            widget.url.map((String imageUrl) => _buildDot(imageUrl)).toList(),
      ),
    );
  }

  Widget _buildDot(String imageUrl) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == widget.url.indexOf(imageUrl)
            ? Colors.white
            : Colors.grey.shade700,
      ),
    );
  }
}
