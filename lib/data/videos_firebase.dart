import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_flutter/data/demo_data.dart';
import 'package:tiktok_flutter/data/video.dart';
import 'package:tiktok_flutter/firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class VideosAPI {
  List<Video> listVideos = <Video>[];
  late Future _initDone;

  VideosAPI() {
    _initDone = load();
  }

  Future load() async {
    listVideos = await getVideoList();
    print(listVideos);
  }

  Future<List<Video>> getVideoList() async {
    var data = await FirebaseFirestore.instance.collection("Videos").get();

    var videoList = <Video>[];
    var videos;

    if (data.docs.length == 0) {
      // await addDemoData();
      videos = (await FirebaseFirestore.instance.collection("Videos").get());
    } else {
      videos = data;
    }

    videos.docs.forEach((element) {
      Video video = Video.fromJson(element.data());
      videoList.add(video);
    });

    return videoList;
  }

  Future<Null> addDemoData() async {
    for (var video in data) {
      await FirebaseFirestore.instance.collection("Videos").add(video);
    }
  }

  Future<bool> addData(Video video) async {
    File file = File(video.url);
    final fileName = basename(video.url);

    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);

      String url = await (await uploadTask).ref.getDownloadURL();
      video.url = url;
      await FirebaseFirestore.instance.collection("Videos").add(video.toJson());
      return true;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return false;
    }
  }

  Future get initDone => _initDone;
}
