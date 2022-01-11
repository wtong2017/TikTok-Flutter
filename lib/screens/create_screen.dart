import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tiktok_flutter/main.dart';
import 'package:tiktok_flutter/screens/video_screen.dart';

class CreateScreen extends StatefulWidget {
  CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool isRecording = false;
  late CameraController _cameraController;
  late Future<void> cameraValue;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Container(
            //     width: 64,
            //     decoration: BoxDecoration(
            //         color: Colors.black54,
            //         borderRadius: BorderRadius.all(Radius.circular(20))),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Icon(
            //             Icons.library_music,
            //             color: Colors.white,
            //             size: 12,
            //           ),
            //           Text(
            //             "Music",
            //             style: TextStyle(color: Colors.white, fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(color: Colors.black),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: isRecording
                          ? Icon(
                              Icons.radio_button_on,
                              color: Colors.redAccent,
                              size: 70,
                            )
                          : Icon(
                              Icons.panorama_fish_eye,
                              color: Colors.white,
                              size: 70,
                            ),
                      onTap: () {
                        // take photo
                      },
                      onLongPress: () async {
                        // take video
                        await _cameraController.startVideoRecording();
                        setState(() {
                          isRecording = true;
                        });
                      },
                      onLongPressUp: () async {
                        XFile videopath =
                            await _cameraController.stopVideoRecording();
                        setState(
                          () {
                            isRecording = false;
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => VideoScreen(
                              path: videopath.path,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
