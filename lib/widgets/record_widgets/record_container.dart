import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/surya/Desktop/Projects/stocklot/lib/widgets/record_widgets/record_box.dart';

class RecordContainer extends StatefulWidget {
  final List<QueryDocumentSnapshot> messageList;
  final int index;
  RecordContainer(this.index, this.messageList);
  @override
  _RecordContainerState createState() => _RecordContainerState();
}

class _RecordContainerState extends State<RecordContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow, size: 30),
          onPressed: () {
            _showRecordBox();
          },
        ),
        Slider(
          value: 0,
          max: 100,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          onChanged: (value) {
            setState(() {
              value = value;
            });
          },
        ),
      ],
    );
  }

  void _showRecordBox() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Play"),
        content: Container(
          height: 150,
          width: 450,
          child: RecordBox(widget.index, widget.messageList),
        ),
      ),
    );
  }
}
