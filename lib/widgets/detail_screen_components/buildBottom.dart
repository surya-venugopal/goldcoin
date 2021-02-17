import '../../providers/chats.dart';
import '../../providers/product.dart';
import '../../providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class BuildBottom extends StatefulWidget {
  final Product product;

  const BuildBottom(this.product);

  @override
  _BuildBottomState createState() => _BuildBottomState();
}

class _BuildBottomState extends State<BuildBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      height: 500,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  widget.product.isFavorite ? Icons.favorite : Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: ()  {
                  widget.product.toggleFavorites(
                      Provider.of<Users>(context, listen: false).getUser.phone);
                  widget.product.isFavorite
                      ? Toast.show(
                          '${widget.product.title} is added to favorites', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM)
                      : Toast.show(
                          '${widget.product.title} is removed from favorites', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                },
              ),

            GestureDetector(
              onTap: () async {
                Toast.show("Notification sent successfully!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                await Provider.of<Chats>(context,listen: false).wantToTalk(
                    widget.product.personId,
                    Provider.of<Users>(context, listen: false).getUser.phone,
                    context,widget.product.title);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notify Seller",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      //textAlign: TextAlign.left,
                    ),
                    // Icon(
                    //   Icons.shopping_cart,
                    //   color: Colors.white,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
