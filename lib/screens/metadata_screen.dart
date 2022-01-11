import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tiktok_flutter/data/video.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tiktok_flutter/screens/auth_viewmodel.dart';
import 'package:tiktok_flutter/screens/feed_viewmodel.dart';

class MetadataScreen extends StatelessWidget {
  MetadataScreen({Key? key, required this.path}) : super(key: key);

  final String path;

  late Video videoData;
  final _formKey = GlobalKey<FormBuilderState>();
  final feedViewModel = GetIt.instance<FeedViewModel>();
  final authViewModel = GetIt.instance<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            name: 'video_title',
                            decoration: InputDecoration(
                              labelText: 'Video Title',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _formKey.currentState?.save();
                              // if (_formKey.currentState!.validate()) {
                              //   print(_formKey.currentState?.value);
                              // } else {
                              //   print("validation failed");
                              // }
                              Map<String, dynamic> data =
                                  Map.from(_formKey.currentState!.value);
                              data["id"] = "0";
                              data["user"] =
                                  authViewModel.getCurrentUser()?.displayName ??
                                      authViewModel.getCurrentUser()?.email;
                              data["user_pic"] = "";
                              data["song_name"] = "Song name";
                              data["likes"] = "0";
                              data["comments"] = "0";
                              data["url"] = path;
                              feedViewModel
                                  .uploadVideo(Video.fromJson(data))
                                  .then((success) {
                                // move to the first page
                                if (success)
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
