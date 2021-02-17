import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stocklot/widgets/record_widgets/record_container.dart';



class MessageContainer extends StatelessWidget {
  final message;
  final time;
  final side;
  final type;
  final int index;
  final List<QueryDocumentSnapshot> messageList;
  final ScrollController scrollController;

  const MessageContainer(this.message, this.time, this.side, this.type,
      this.index, this.messageList, this.scrollController);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var dateTime = (time as Timestamp).toDate();
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.black12,
      ),
      width: type == 0 ? size.width * 3 / 4 : (size.width * 3 / 4) + 21,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: type == 0
                ? EdgeInsets.all(5)
                : EdgeInsets.only(top: 5, right: 5, left: 5),
            alignment: Alignment.centerLeft,
            child:
                type == 0 ? Text(message) : RecordContainer(index, messageList),
          ),
          Container(
            padding: type == 0
                ? EdgeInsets.all(5)
                : EdgeInsets.only(bottom: 5, right: 5, left: 5),
            alignment:
                side == "right" ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              "${dateTime.hour}:${dateTime.minute} - ${dateTime.day}/${dateTime.month}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}


