import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'file:///C:/Users/surya/Desktop/Projects/stocklot/lib/widgets/record_widgets/show_record.dart';

class RecordButton extends StatefulWidget {
  final size;
  final personId;
  final LocalFileSystem localFileSystem;
  final ScrollController scrollController;

  RecordButton(
      {this.size, this.personId, localFileSystem, this.scrollController})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  void _showRecordDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Record and Send'),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *0.55,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 360,
                  child: ShowRecord(
                    size: widget.size,
                    personId: widget.personId,
                    localFileSystem: widget.localFileSystem,
                    ctx: ctx,
                    scrollController: widget.scrollController,
                  ),
                ),
                Text("Keep it polite, your conversation may be recorded for quality purposes.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.size.width) / 10,
      child: IconButton(
        icon: Icon(Icons.mic),
        onPressed: () {
          _showRecordDialog();
        },
      ),
    );
  }
}

