// import 'dart:async';
//
// import 'package:connectycube_sdk/connectycube_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:stocklot/providers/user.dart';
//
// class CallScreen extends StatefulWidget {
//   final P2PSession callSession;
//   final bool isIncoming;
//   final String personId;
//   final String personName;
//   final String personDp;
//
//   CallScreen(this.callSession, this.isIncoming, this.personId, this.personName,
//       this.personDp);
//
//   @override
//   _CallScreenState createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen>
//     implements RTCSessionStateCallback<P2PSession> {
//   static const String TAG = "_ConversationCallScreenState";
//   bool _isCameraEnabled = true;
//   bool _isSpeakerEnabled = true;
//   bool _isMicMute = false;
//   bool _switchCamara = false;
//
//   Map<int, RTCVideoRenderer> streams = {};
//
//   @override
//   void initState() {
//     widget.callSession.onLocalStreamReceived = _addLocalMediaStream;
//     widget.callSession.onRemoteStreamReceived = _addRemoteMediaStream;
//     widget.callSession.onSessionClosed = _onSessionClosed;
//     widget.callSession.setSessionCallbacksListener(this);
//     if (widget.isIncoming) {
//       widget.callSession.acceptCall();
//     } else {
//       widget.callSession.startCall();
//     }
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     streams.forEach((opponentId, stream) async {
//       log("[dispose] dispose renderer for $opponentId", TAG);
//       await stream.dispose();
//     });
//   }
//
//   void _addLocalMediaStream(MediaStream stream) {
//     log("_addLocalMediaStream", TAG);
//     print(
//         "------${CubeChatConnection.instance.currentUser.id}-----------------");
//     _onStreamAdd(CubeChatConnection.instance.currentUser.id, stream);
//   }
//
//   void _addRemoteMediaStream(session, int userId, MediaStream stream) {
//     log("_addRemoteMediaStream for user $userId", TAG);
//     _onStreamAdd(userId, stream);
//   }
//
//   void _removeMediaStream(callSession, int userId) {
//     log("_removeMediaStream for user $userId", TAG);
//     RTCVideoRenderer videoRenderer = streams[userId];
//     if (videoRenderer == null) return;
//
//     videoRenderer.srcObject = null;
//     videoRenderer.dispose();
//
//     setState(() {
//       streams.remove(userId);
//     });
//   }
//
//   void _onSessionClosed(session) {
//     log("_onSessionClosed", TAG);
//     widget.callSession.removeSessionCallbacksListener();
//
//     Navigator.pop(context);
//   }
//
//   void _onStreamAdd(int opponentId, MediaStream stream) async {
//     log("_onStreamAdd for user $opponentId", TAG);
//
//     RTCVideoRenderer streamRender = RTCVideoRenderer();
//     await streamRender.initialize();
//     streamRender.srcObject = stream;
//     setState(() => streams[opponentId] = streamRender);
//   }
//
//   List<Widget> renderStreamsGrid(Orientation orientation) {
//     var size = MediaQuery.of(context).size;
//     List<Widget> streamsExpanded = streams.entries
//         .map(
//           (entry) => Container(
//             width: orientation == Orientation.portrait
//                 ? size.width
//                 : size.height / 2,
//             height: orientation == Orientation.portrait
//                 ? size.height / 2
//                 : size.width,
//             child: RTCVideoView(
//               entry.value,
//               objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//               mirror: _switchCamara ? false : true,
//             ),
//           ),
//         )
//         .toList();
//     if (streams.length > 2) {
//       List<Widget> rows = [];
//
//       for (var i = 0; i < streamsExpanded.length; i += 2) {
//         var chunkEndIndex = i + 2;
//
//         if (streamsExpanded.length < chunkEndIndex) {
//           chunkEndIndex = streamsExpanded.length;
//         }
//
//         var chunk = streamsExpanded.sublist(i, chunkEndIndex);
//
//         rows.add(
//           Expanded(
//             child: orientation == Orientation.portrait
//                 ? Row(children: chunk)
//                 : Column(children: chunk),
//           ),
//         );
//       }
//       return rows;
//     }
//
//     return streamsExpanded;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onBackPressed(context),
//       child: Stack(
//         children: [
//           Scaffold(
//               body: _isVideoCall()
//                   ? OrientationBuilder(
//                       builder: (context, orientation) {
//                         return Center(
//                           child: Container(
//                             child: orientation == Orientation.portrait
//                                 ? Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: renderStreamsGrid(orientation))
//                                 : Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: renderStreamsGrid(orientation)),
//                           ),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 24),
//                             child: Text(
//                               "Audio call",
//                               style: TextStyle(fontSize: 28),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 12),
//                             child: Text(
//                               "Members:",
//                               style: TextStyle(
//                                   fontSize: 20, fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                           Text(
//                             widget.personName,
//                             style: TextStyle(fontSize: 20),
//                           ),
//                         ],
//                       ),
//                     )),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: _getActionsPanel(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _getActionsPanel() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(32),
//             bottomRight: Radius.circular(32),
//             topLeft: Radius.circular(32),
//             topRight: Radius.circular(32)),
//         child: Container(
//           padding: EdgeInsets.all(4),
//           color: Colors.black26,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(right: 4),
//                 child: FloatingActionButton(
//                   elevation: 0,
//                   heroTag: "Mute",
//                   child: Icon(
//                     Icons.mic,
//                     color: _isMicMute ? Colors.grey : Colors.white,
//                   ),
//                   onPressed: () => _muteMic(),
//                   backgroundColor: Colors.black38,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 4),
//                 child: FloatingActionButton(
//                   elevation: 0,
//                   heroTag: "Speacker",
//                   child: Icon(
//                     Icons.volume_up,
//                     color: _isSpeakerEnabled ? Colors.white : Colors.grey,
//                   ),
//                   onPressed: () => _switchSpeaker(),
//                   backgroundColor: Colors.black38,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 4),
//                 child: FloatingActionButton(
//                   elevation: 0,
//                   heroTag: "SwitchCamera",
//                   child: Icon(
//                     Icons.switch_video,
//                     color: _isVideoEnabled() ? Colors.white : Colors.grey,
//                   ),
//                   onPressed: () {
//                     _switchCamera();
//                   },
//                   backgroundColor: Colors.black38,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 4),
//                 child: FloatingActionButton(
//                   elevation: 0,
//                   heroTag: "ToggleCamera",
//                   child: Icon(
//                     Icons.videocam,
//                     color: _isVideoEnabled() ? Colors.white : Colors.grey,
//                   ),
//                   onPressed: () => _toggleCamera(),
//                   backgroundColor: Colors.black38,
//                 ),
//               ),
//               Expanded(
//                 child: SizedBox(),
//                 flex: 1,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: 0),
//                 child: FloatingActionButton(
//                   child: Icon(
//                     Icons.call_end,
//                     color: Colors.white,
//                   ),
//                   backgroundColor: Colors.red,
//                   onPressed: () => _endCall(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _endCall() {
//     var db = FirebaseFirestore.instance;
//     db
//         .collection("User")
//         .doc(Provider.of<Users>(context, listen: false).getUser.phone)
//         .get()
//         .then((doc) {
//       if (doc.data()['whoCalled'] == "" || doc.data()['whoCalled'] == null) {
//         widget.callSession.hungUp();
//       } else {
//         db
//             .collection("User")
//             .doc(Provider.of<Users>(context, listen: false).getUser.phone)
//             .update({"whoCalled": ""}).then((value) {
//           widget.callSession.hungUp();
//         });
//       }
//     });
//   }
//
//   Future<bool> _onBackPressed(BuildContext context) {
//     return Future.value(false);
//   }
//
//   _muteMic() {
//     setState(() {
//       _isMicMute = !_isMicMute;
//       widget.callSession.setMicrophoneMute(_isMicMute);
//     });
//   }
//
//   _switchCamera() {
//     setState(() {
//       _switchCamara = !_switchCamara;
//     });
//     if (!_isVideoEnabled()) return;
//
//     widget.callSession.switchCamera();
//   }
//
//   _toggleCamera() {
//     if (!_isVideoCall()) return;
//
//     setState(() {
//       _isCameraEnabled = !_isCameraEnabled;
//       widget.callSession.setVideoEnabled(_isCameraEnabled);
//     });
//   }
//
//   bool _isVideoEnabled() {
//     return _isVideoCall() && _isCameraEnabled;
//   }
//
//   bool _isVideoCall() {
//     return CallType.VIDEO_CALL == widget.callSession.callType;
//   }
//
//   _switchSpeaker() {
//     setState(() {
//       _isSpeakerEnabled = !_isSpeakerEnabled;
//       widget.callSession.enableSpeakerphone(_isSpeakerEnabled);
//     });
//   }
//
//   @override
//   void onConnectedToUser(P2PSession session, int userId) {
//     log("onConnectedToUser userId= $userId");
//   }
//
//   @override
//   void onConnectionClosedForUser(P2PSession session, int userId) {
//     log("onConnectionClosedForUser userId= $userId");
//     _removeMediaStream(session, userId);
//   }
//
//   @override
//   void onDisconnectedFromUser(P2PSession session, int userId) {
//     log("onDisconnectedFromUser userId= $userId");
//   }
//
// // bool loading = true;
// // bool _showControls = false;
// // bool _showVideo = true;
// // bool _showMic = true;
// // bool _toggleView = false;
// // bool isFrontCamera = true;
// // Timer timer;
// // var id;
//
// // _showAndHideControls() {
// //   setState(() => _showControls = true);
// //   timer = Timer(Duration(seconds: 5), () {
// //     setState(() => _showControls = false);
// //   });
// // }
//
// // @override
// // Widget build(BuildContext context) {
// //   return Scaffold(
// //     body: SafeArea(
// //       child: GestureDetector(
// //         onTap: _showAndHideControls,
// //         onDoubleTap: () {
// //           setState(() {
// //             _toggleView = !_toggleView;
// //           });
// //         },
// //         child: Container(
// //           height: MediaQuery.of(context).size.height,
// //           width: MediaQuery.of(context).size.width,
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //           ),
// //           child: Stack(
// //             children: [
// //               Container(
// //                 height: MediaQuery.of(context).size.height,
// //                 width: MediaQuery.of(context).size.width,
// //                 child: RTCVideoView(
// //                   _localRenderer,
// //                   objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
// //                   mirror: _toggleView || !isFrontCamera ? false : true,
// //                 ),
// //               ),
// //               Positioned(
// //                 bottom: _showControls ? 80 : 10,
// //                 right: 7,
// //                 child: Container(
// //                   height: MediaQuery.of(context).size.height * 1 / 4,
// //                   width: MediaQuery.of(context).size.width * 0.36,
// //                   decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(
// //                         10,
// //                       ),
// //                       border: Border.all(
// //                         color: Colors.white,
// //                         width: 5,
// //                       )),
// //                   child: RTCVideoView(
// //                     _remoteRenderer,
// //                     objectFit:
// //                         RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
// //                     mirror: _toggleView ? true : false,
// //                   ),
// //                 ),
// //               ),
// //               _showControls
// //                   ? Positioned(
// //                       bottom: 3,
// //                       child: Container(
// //                         width: MediaQuery.of(context).size.width,
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisSize: MainAxisSize.max,
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             RawMaterialButton(
// //                               onPressed: () {
// //                                 _localRenderer.srcObject = null;
// //                                 callMethod.endCall(call: widget.call);
// //                                 Navigator.of(context).pop();
// //                               },
// //                               splashColor: Colors.red,
// //                               fillColor: Colors.red,
// //                               elevation: 10.0,
// //                               shape: CircleBorder(),
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(15.0),
// //                                 child: Icon(
// //                                   Icons.call_end,
// //                                   size: 30.0,
// //                                   color: Colors.white,
// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(
// //                               height: 20,
// //                             ),
// //                             Row(
// //                               mainAxisSize: MainAxisSize.max,
// //                               mainAxisAlignment:
// //                                   MainAxisAlignment.spaceBetween,
// //                               crossAxisAlignment: CrossAxisAlignment.center,
// //                               children: [
// //                                 RawMaterialButton(
// //                                   onPressed: () {
// //                                     switchCamera();
// //                                   },
// //                                   splashColor: Colors.deepPurpleAccent,
// //                                   fillColor: Colors.white,
// //                                   elevation: 10.0,
// //                                   shape: CircleBorder(),
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(15.0),
// //                                     child: Icon(
// //                                       Icons.switch_camera,
// //                                       size: 30.0,
// //                                       color: Colors.deepPurpleAccent,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 RawMaterialButton(
// //                                   onPressed: () {
// //                                     setState(() {
// //                                       _showVideo = !_showVideo;
// //                                     });
// //                                     controlVideo();
// //                                   },
// //                                   splashColor: Colors.deepPurpleAccent,
// //                                   fillColor: Colors.white,
// //                                   elevation: 10.0,
// //                                   shape: CircleBorder(),
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(15.0),
// //                                     child: Icon(
// //                                       _showVideo
// //                                           ? Icons.videocam_off
// //                                           : Icons.videocam,
// //                                       size: 30.0,
// //                                       color: Colors.deepPurpleAccent,
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 RawMaterialButton(
// //                                   onPressed: () {
// //                                     setState(() {
// //                                       _showMic = !_showMic;
// //                                     });
// //                                     muteUnmuteAudio();
// //                                   },
// //                                   splashColor: Colors.deepPurpleAccent,
// //                                   fillColor: Colors.white,
// //                                   elevation: 10.0,
// //                                   shape: CircleBorder(),
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(15.0),
// //                                     child: Icon(
// //                                       _showMic ? Icons.mic_off : Icons.mic,
// //                                       size: 30.0,
// //                                       color: Colors.deepPurpleAccent,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     )
// //                   : Container(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     ),
//
// // Container(
// //   alignment: Alignment.center,
// //   child: Column(
// //     mainAxisSize: MainAxisSize.min,
// //     children: [
// //       Container(
// //         height: 200,
// //         child: RTCVideoView(
// //           _localRenderer,
// //           mirror: false,
// //         ),
// //       ),
// //       Text("Call has been made"),
// //       MaterialButton(
// //         color: Colors.red,
// //         child: Icon(Icons.call),
// //         onPressed: () {
// //           callMethod.endCall(call: widget.call);
// //           Navigator.of(context).pop();
// //         },
// //       ),
// //     ],
// //   ),
// // ),
// // );
// }
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/providers/call.dart';
import 'package:stocklot/providers/call_methods.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/providers/util.dart';


class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({this.call});
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  CallMethods callMethods = CallMethods();
  StreamSubscription callStreamSubscription;
  CollectionReference callSnapshot =
  FirebaseFirestore.instance.collection("Calls");

  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  String roomId;

  @override
  void initState() {
    if (int.parse(widget.call.callerId.substring(3)) < int.parse(widget.call.receiverId.substring(3))) {
      roomId = widget.call.callerId.substring(3) + widget.call.receiverId.substring(3);
    } else {
      roomId = widget.call.receiverId.substring(3) + widget.call.callerId.substring(3);
    }
    addPostFrameCallback();
    initializeAgora();
    super.initState();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    print("--------------------initializeAgora called----------------------");

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    print("----------yes---------------");
    await AgoraRtcEngine.joinChannel(null, roomId, null, 0);
    print(roomId);
    print("============no=========");
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callStreamSubscription = callSnapshot
          .doc(roomId)
          .collection("Members")
          .doc(Provider.of<Users>(context, listen: false).getUser.phone)
          .snapshots()
          .listen((event) {
        switch (event.data()) {
          case null:
            Navigator.of(context).pop();
            break;
          default:
            break;
        }
      });
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    print("-------------initAgoraRtcEngine called--------------------");
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
        String channel,
        int uid,
        int elapsed,
        ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'onUserJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      setState(() {
        final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      setState(() {
        final info = 'onRejoinChannelSuccess: $string';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) {
      callMethods.endCall(call: widget.call);
      setState(() {
        final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      setState(() {
        final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onConnectionLost = () {
      setState(() {
        final info = 'onConnectionLost';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // if call was picked

      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
        int uid,
        int width,
        int height,
        int elapsed,
        ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () async{
              var db = FirebaseFirestore.instance;
              db.collection("User").doc(widget.call.callerId).update({
                "whoCalled":
                ""
              });
              db.collection("User").doc(widget.call.receiverId).update({
                "whoCalled":
                ""
              });
              await callMethods.endCall(
                call: widget.call,
              );

            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              // _panel(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
