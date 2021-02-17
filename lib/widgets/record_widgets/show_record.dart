import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:stocklot/providers/chats.dart';
import 'package:stocklot/providers/message.dart';
import 'package:stocklot/providers/user.dart';
import 'package:toast/toast.dart';

class ShowRecord extends StatefulWidget {
  final size;
  final personId;
  final ctx;
  final LocalFileSystem localFileSystem;
  final ScrollController scrollController;



  ShowRecord(
      {this.size,
      this.personId,
      localFileSystem,
      this.ctx,
      this.scrollController})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ShowRecordState createState() => _ShowRecordState();
}

class _ShowRecordState extends State<ShowRecord> {
  FlutterAudioRecorder _recorder;
  Recording current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState;
  var audioUrl;
  var result;
  bool isRecording = false;
  var isStopped = false;
  bool isOnce = false;
  bool isMessage = false;

  Duration duration = new Duration();
  Duration position = new Duration();

  bool isRecordPlaying = false;

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initPlayer() {
    audioPlayer = new AudioPlayer();

    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() => position = p);
    });

    audioPlayer.onPlayerError.listen((event) {
      print("-----------$event------------");
      Toast.show("$event:Try Saving again", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        isRecordPlaying = false;
        audioPlayerState = AudioPlayerState.STOPPED;
        duration = Duration.zero;
        position = Duration.zero;
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        position = Duration.zero;
        isRecordPlaying = false;
        duration = Duration.zero;
      });
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Do you want to exit recording"),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("NO"),
          ),
          FlatButton(
            onPressed: () async {
              if (isRecording == true) {
                result = await _recorder.stop();
              }
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
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(bottom: 3),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(35),
              //         color: Colors.grey,
              //       ),
              //       child: IconButton(
              //         icon: Icon(Icons.restore_outlined),
              //         onPressed: () {
              //           switch (_currentStatus) {
              //             case RecordingStatus.Stopped:
              //               {
              //                 _init();
              //                 break;
              //               }
              //             default:
              //               break;
              //           }
              //         },
              //       ),
              //     ),
              //     Text('Reset')
              //   ],
              // ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: isRecording ? Colors.grey : Colors.greenAccent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        setState(() {
                          isRecording = true;
                        });
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              if (!isRecordPlaying) {
                                _startRec();
                              } else {
                                Toast.show("Stop recording first", context,
                                    gravity: Toast.BOTTOM,
                                    duration: Toast.LENGTH_SHORT);
                              }
                              break;
                            }
                          default:
                            break;
                        }
                      },
                    ),
                  ),
                  Text('Record'),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: isRecording ? Colors.red : Colors.grey,
                    ),
                    child: IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: () {
                          setState(() {
                            isRecording = false;
                          });
                          if (_currentStatus != RecordingStatus.Unset) {
                            _stopRec();
                            initPlayer();
                          }
                        }),
                  ),
                  Text('Stop'),
                ],
              ),
            ],
          ),
          Slider(
            value: position?.inSeconds?.toDouble() ?? 0,
            max: duration.inSeconds.toDouble(),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              setState(() {
                value = value;
                seekToSeconds(value.toInt());
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
                "${position.inSeconds.toDouble()}/${duration.inSeconds.toDouble()}"),
          ),
          Center(
            child: IconButton(
              icon:
                  isRecordPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                if (current != null) {
                  if (isRecordPlaying == false && isRecording == false) {
                    _play();
                    setState(() {
                      isRecordPlaying = true;
                    });
                  } else {
                    _pause();
                    setState(() {
                      isRecordPlaying = false;
                    });
                  }
                } else {
                  Toast.show("Record First", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  print("-------no-------");
                }
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          isOnce
              ? Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 5,
                    ),
                    _showMessage("wait till recording is saved"),
                  ],
                )
              : isMessage
                  ? _showMessage("Recording ready to send")
                  : Container(),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () async {
                if (audioUrl != null) {
                  await audioPlayer.pause();

                  await sendMessage(
                      Provider.of<Users>(context, listen: false).getUser.phone,
                      Provider.of<Users>(context, listen: false).getUser.name,
                      widget.personId,
                      context);
                  print("\n\n\n\n surya \n\n\n\n");
                  widget.scrollController.animateTo(
                    widget.scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                  );

                  Navigator.of(context).pop();
                  print("yes");
                } else {
                  Toast.show("Record first", context,
                      gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                }
              },
              child: Text("send"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(
      String myId, String myName, String friendId, BuildContext context) async {
    if (audioUrl != null) {
      var db = FirebaseFirestore.instance;
      String fcmToken;

      var value = await db.collection("User").doc(friendId).get();
      fcmToken = value.data()['fcmToken'];
      var dp = Provider.of<Users>(context, listen: false).getUser.dp;

      var data = MessageModel(
              message: "Audio",
              res: audioUrl,
              personId: myId,
              fcmToken: fcmToken,
              time: DateTime.now(),
              type: 1)
          .getMap;
      Map<String, dynamic> frndData = {
        "personId": myId,
        "personName": myName,
        "personDp": dp,
        "isNew": false,
        "time": DateTime.now(),
      };
      try {
        await db
            .collection("User")
            .doc(friendId)
            .collection("friends")
            .doc(myId)
            .update(frndData);
      } catch (e) {
        frndData['isStarred'] = false;
        await db
            .collection("User")
            .doc(friendId)
            .collection("friends")
            .doc(myId)
            .set(frndData);
      }

      await db
          .collection("Message")
          .doc(Chats.getMessageId(myId, friendId))
          .collection("messages")
          .add(data)
          .catchError((e) {});
    } else {
      Toast.show("wait till message is saved", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;

        appDocDirectory = await getExternalStorageDirectory();

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        print(current);
        setState(() {
          current = current;
          _currentStatus = current.status;
          print(_currentStatus);
          //duration = Duration.zero;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _startRec() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var _current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          current = _current;
          _currentStatus = current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _showMessage(String message) {
    return Text(message);
  }

  _stopRec() async {
    isStopped = true;
    try {
      result = await _recorder.stop();
    } catch (error) {
      print(error);
    }
    if (result.path == null) {
      print("-------Try recording again-----------");
    }
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    final FirebaseStorage _storage = FirebaseStorage.instance;
    var date = DateTime.now();
    setState(() {
      current = result;
      _currentStatus = current.status;
      isOnce = true;
      _init();
    });
    Toast.show("wait till recording is saved", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    await _storage
        .ref()
        .child(
            "audio/${Provider.of<Users>(context, listen: false).getUser.phone}_$date.wav")
        .putFile(io.File(current.path));
    audioUrl = await _storage
        .ref()
        .child(
            "audio/${Provider.of<Users>(context, listen: false).getUser.phone}_$date.wav")
        .getDownloadURL();
    setState(() {
      isOnce = false;
      isMessage = true;
    });
    Toast.show("Recording ready to be sent", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  Future<dynamic> _play() async {
    await audioPlayer.play(audioUrl);
  }

  Future<dynamic> _pause() async {
    await audioPlayer.pause();
  }
}
