import 'package:stocklot/providers/product.dart';

import '../../main.dart';
import 'product_images_video.dart';
import 'top_rounded_container.dart';
import 'package:flutter/material.dart';

import 'description.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final product = ModalRoute.of(context).settings.arguments as Product;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ProductImages(product.id),
          Container(
            height: size.height * 3 / 4,
            decoration: BoxDecoration(
                gradient: MyApp.getGradient(),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Description(
                    product: product,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
