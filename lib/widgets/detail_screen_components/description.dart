import '../../providers/product.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class Description extends StatelessWidget {
  final Product product;

  const Description({
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // final product = Provider.of<Product>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: 5,
                ),
                child: Text(
                  "Category:",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(64),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 30,
                    left: getProportionateScreenWidth(20),
                    right: 5,
                    bottom: 20),
                child: Text(
                  "Seller Name:",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 30,
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    bottom: 20),
                child: Text(
                  product.personName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.only(
          //           left: getProportionateScreenWidth(20),
          //           right: 5,
          //           bottom: 20),
          //       child: Text(
          //         "Quantity:",
          //         style: TextStyle(color: Colors.white70, fontSize: 16),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(
          //           left: getProportionateScreenWidth(20),
          //           right: getProportionateScreenWidth(20),
          //           bottom: 20),
          //       child: Text(
          //         product.quantity,
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(20),
                bottom: 10),
            child: Text(
              "Description:",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
            ),
            child: Text(
              product.description,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
