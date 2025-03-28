import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/models/node_data/branched_video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/node_data.dart';
import 'package:nutria_fmv_maker/utilities/simplify_node_tree.dart';

class ProjectVersionProvider extends ChangeNotifier {
  void saveFile() {}

  Future<void> exportFile(List<NodeData> nodes, List<VideoData> videos) async {
    try {
      List<BaseNodeData> nodesTraversed = traverseNodes(nodes);
      List<String> videosUsed = [];

      for (int i = 0; i < nodesTraversed.length; i++) {
        if (nodesTraversed[i] is BranchedVideoNodeData) {
          BranchedVideoNodeData node = nodesTraversed[i] as BranchedVideoNodeData;
          nodesTraversed[i] = node.copyWith(
              videoDataId: videos
                  .firstWhere((video) => video.id == node.videoDataId)
                  .videoPath);
        }
      }

      // Map<String, String> jsonVideoData = {
      //   for (var video in videos)
      //     if (videosUsed.contains(video.id)) video.id: video.videoPath,
      // };

      var jsonNodeData =
          nodesTraversed.map((node) => node.toJsonExport()).toList();

      String jsonString = jsonEncode(jsonNodeData);

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save JSON File',
        fileName: 'nodes_data.json',
      );

      if (outputPath != null) {
        File file = File(outputPath);
        await file.writeAsString(jsonString);
        print('File saved at: $outputPath');
      } else {
        print('File save cancelled.');
      }
    } catch (e) {
      print('Error exporting file: $e');
    }
  }

  List<NodeData> simplifyNodeTree(List<NodeData> nodes) {
    List<NodeData> filteredNodes = nodes;
    return filteredNodes;
  }
}
