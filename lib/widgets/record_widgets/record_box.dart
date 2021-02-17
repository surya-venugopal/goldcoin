import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecordBox extends StatefulWidget {
  final List<QueryDocumentSnapshot> messageList;
  final int index;

  RecordBox(this.index, this.messageList);

  @override
  _RecordBoxState createState() => _RecordBoxState();
}

class _RecordBoxState extends State<RecordBox> {
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioPlayerState state;
  var audioUrl;

  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool isRecordPlaying = false;

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => _duration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() => _position = p);
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration.zero;
        isRecordPlaying = false;
        //Navigator.of(context).pop();
      });
    });
  }

  Future<bool> _onBackPressed() async
  {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Do you want to exit playing"),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          FlatButton(
            onPressed: () async {
              await audioPlayer.pause();
              Navigator.pop(context, true);
            },
            child: Text("yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: _onBackPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: isRecordPlaying
                ? Icon(Icons.pause, size: 30)
                : Icon(Icons.play_arrow, size: 30),
            onPressed: () {
              if (isRecordPlaying == false) {
                _play(widget.messageList[widget.index]['res']);
                setState(() {
                  isRecordPlaying = true;
                });
              } else {
                _pause(widget.messageList[widget.index]['res']);
                setState(() {
                  isRecordPlaying = false;
                });
              }
            },
          ),
          Slider(
            value: _position?.inSeconds?.toDouble() ?? 0,
            max: _duration.inSeconds.toDouble(),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              setState(() {
                value = value;
                seekToSeconds(value.toInt());
              });
            },
          ),
          Text(
              "${_position.inSeconds.toDouble()}/${_duration.inSeconds.toDouble()}"),
        ],
      ),
    );
  }

  Future<dynamic> _play(String url) async {
    await audioPlayer.play(url);
  }

  Future<dynamic> _pause(String url) async {
    await audioPlayer.pause();
  }
}
