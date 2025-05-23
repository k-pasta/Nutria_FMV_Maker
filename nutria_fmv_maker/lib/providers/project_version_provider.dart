import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nutria_fmv_maker/models/node_data/branched_video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/origin_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/simple_video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_data.dart';
import 'package:nutria_fmv_maker/utilities/simplify_node_tree.dart';
import 'package:uuid/uuid.dart';

class ProjectVersionProvider extends ChangeNotifier {
  var uuid = Uuid(); // Create a new instance of Uuid
  Map<String, dynamic> get emptyScene {
    return {
      'nodes': [
        OriginNodeData(
          id: uuid.v1(),
          nodeName: 'Origin Node',
          position: const Offset(0, 0),
        )
      ],
      'videos': []
    };
  }

  String? _lastProjectVersionSerializedData;
  bool hasFileChanged(String newSerializedData) {
    return (_lastProjectVersionSerializedData != newSerializedData);
  }

  String? _currentSavePath;
  String? get currentSavePath => _currentSavePath;
  String get currentFileName {
    if (_currentSavePath == null || _currentSavePath!.isEmpty) {
      return 'Unsaved File';
    }
    return p.basename(_currentSavePath!);
  }

  Future<Map<String, dynamic>> loadFile() async {
    try {
      // Prompt the user to select a file to load with the .nfmvm extension
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Open Project File',
        type: FileType.custom,
        allowedExtensions: ['nfmv'],
      );

      if (result != null && result.files.single.path != null) {
        // Read the selected file
        File file = File(result.files.single.path!);
        String fileContents = await file.readAsString();
        _lastProjectVersionSerializedData = fileContents;
        // Decode the JSON string
        Map<String, dynamic> jsonData;

        try {
          final decoded = jsonDecode(fileContents);
          if (decoded is Map<String, dynamic>) {
            jsonData = decoded;
          } else {
            return {'error': LoadErrors.invalidData};
          }
        } catch (e) {
          return {'error': LoadErrors.invalidData};
        }

        // // Basic validation: Ensure required keys exist
        // if (!(jsonData.containsKey('nodes') &&
        //     jsonData.containsKey('videos'))) {
        //   notifyError("File format is invalid: missing required keys.");
        //   return emptyScene;
        // }

        // Parse nodes from the JSON data
        List<NodeData> nodes = (jsonData['nodes'] as List).map((nodeJson) {
          // Now make sure we treat each node as a map
          switch (nodeJson['type']) {
            case 'BranchedVideoNodeData':
              return BranchedVideoNodeData.fromJson(nodeJson);
            case 'SimpleVideoNodeData':
              return SimpleVideoNodeData.fromJson(nodeJson);
            case 'OriginNodeData':
              return OriginNodeData.fromJson(nodeJson);
            default:
              throw Exception('Unknown node type: ${nodeJson['type']}');
          }
        }).toList();

        // Parse videos from the JSON data
        List<VideoData> videos = (jsonData['videos'] as List)
            .map((videoJson) => VideoData.fromJson(videoJson))
            .toList();

        // Set the current save path to the selected file path
        _currentSavePath = result.files.single.path;
        notifyListeners();
        return {'nodes': nodes, 'videos': videos};
      } else {
        return ({'error': LoadErrors.userCancelled});
      }
    } catch (e) {
      return {'error': LoadErrors.unknownError};
    }
  }

  String makeSaveFile(List<NodeData> nodes, List<VideoData> videos) {
    List<Map<String, dynamic>> jsonNodes = nodes.map((node) {
      if (node is BranchedVideoNodeData) {
        return {
          'type': 'BranchedVideoNodeData',
          ...node.toJson(),
        };
      }
      if (node is SimpleVideoNodeData) {
        return {
          'type': 'SimpleVideoNodeData',
          ...node.toJson(),
        };
      }
      if (node is OriginNodeData) {
        return {
          'type': 'OriginNodeData',
          ...node.toJson(),
        };
      } else {
        return {
          'type': 'Unknown',
          'data': {},
        };
      }
    }).toList();

    // Videos
    List<Map<String, dynamic>> jsonVideos =
        videos.map((video) => video.toJson()).toList();

    // Combine nodes and videos into a single JSON object
    Map<String, dynamic> jsonData = {
      'nodes': jsonNodes,
      'videos': jsonVideos,
    };

    // Convert the JSON object to a string
    String jsonString = jsonEncode(jsonData);

    return jsonString;
  }

  Future<void> saveFile(String SerializedData) async {
    if (_currentSavePath == null) {
      await saveFileAs(SerializedData);
    } else {
      String jsonString = SerializedData;

      try {
        // Write the JSON string to the current save path
        File file = File(_currentSavePath!);
        await file.writeAsString(jsonString);
        _lastProjectVersionSerializedData = jsonString;
        print('File saved at: $_currentSavePath');
      } catch (e) {
        print('Error saving file: $e');
      }
    }
  }

  Future<void> saveFileAs(String SerializedData) async {
    try {
      // Serialize nodes and videos to JSON
      String jsonString = SerializedData;

      // Prompt the user to select a file path to save the JSON
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Project File',
        fileName: 'my_fmv_project.nfmv', // Default name with required extension
        type: FileType.custom,
        allowedExtensions: ['nfmv'], // Only allow .nfmv extension
      );

      if (outputPath != null) {
        // Enforce .nfmv extension in case the user removes or changes it
        if (!outputPath.endsWith('.nfmv')) {
          outputPath += '.nfmv';
        }

        // Write the JSON string to the selected file
        File file = File(outputPath);
        await file.writeAsString(jsonString);
        _lastProjectVersionSerializedData = jsonString;
        _currentSavePath = outputPath; // Update the current save path
        notifyListeners();

        print('File saved at: $outputPath');
      } else {
        print('File save cancelled.');
      }
    } catch (e) {
      print('Error saving file: $e');
    }
  }

  // Future<void> exportFile(List<NodeData> nodes, List<VideoData> videos) async {
  //   try {
  //     List<BaseNodeData> nodesTraversed = traverseNodes(nodes);
  //     List<BaseNodeData> simplifiedNodes = simplifyNodeIds(nodesTraversed);

  //     for (int i = 0; i < simplifiedNodes.length; i++) {
  //       if (simplifiedNodes[i] is VideoNodeData) {
  //         VideoNodeData node =
  //             simplifiedNodes[i] as VideoNodeData;
  //         simplifiedNodes[i] = node.copyWith(
  //             videoDataId: videos
  //                 .firstWhere((video) => video.id == node.videoDataId)
  //                 .videoPath);
  //       }
  //     }

  //     var jsonNodeData =
  //         simplifiedNodes.map((node) => node.toJsonExport()).toList();

  //     Map<String, dynamic> mergedNodes = {};
  //     for (var node in jsonNodeData) {
  //       mergedNodes.addAll(node ?? {});
  //     }

  //     String jsonString = jsonEncode(mergedNodes);

  //     String? outputPath = await FilePicker.platform.saveFile(
  //       dialogTitle: 'Save JSON File',
  //       fileName: 'nodes_data.json',
  //     );

  //     if (outputPath != null) {
  //       File file = File(outputPath);
  //       await file.writeAsString(jsonString);
  //       print('File saved at: $outputPath');
  //     } else {
  //       print('File save cancelled.');
  //     }
  //   } catch (e) {
  //     print('Error exporting file: $e');
  //   }
  // }

  Future<void> exportFile(
      {required List<NodeData> nodes,
      required List<VideoData> videos,
      required Map<VideoOverrides, dynamic>
          projectSettings // Accept ProjectSettings as a parameter
      }) async {
    try {
      // Traverse and simplify node data
      List<BaseNodeData> nodesTraversed = traverseNodes(nodes);
      List<BaseNodeData> simplifiedNodes = simplifyNodeIds(nodesTraversed);

      // Separate OriginNodeData (first node in the list)
      BaseNodeData? originNode =
          simplifiedNodes.isNotEmpty ? simplifiedNodes[0] : null;
      List<BaseNodeData> nodesWithoutOrigin = simplifiedNodes.sublist(1);

      // Process nodes with videoDataId
      for (int i = 0; i < nodesWithoutOrigin.length; i++) {
        if (nodesWithoutOrigin[i] is VideoNodeData) {
          VideoNodeData node = nodesWithoutOrigin[i] as VideoNodeData;
          nodesWithoutOrigin[i] = node.copyWith(
            videoDataId: videos
                .firstWhere((video) => video.id == node.videoDataId)
                .videoPath,
          );
        }
      }

      // Export ProjectInfo (OriginNodeData)
      var originNodeData = originNode?.toJsonExport() ?? {};

      // Export Nodes (other nodes excluding OriginNodeData)
      var jsonNodeData =
          nodesWithoutOrigin.map((node) => node.toJsonExport()).toList();

      // Merge all nodes under 'Nodes'
      Map<String, dynamic> mergedNodes = {};
      for (var node in jsonNodeData) {
        mergedNodes.addAll(node ?? {});
      }

      // Convert the VideoOverrides map to strings using the provided method
      Map<String, dynamic> convertedSettings = {};
      projectSettings.forEach((key, value) {
        convertedSettings[key.name] = getOverrideForJson(key.name, value);
      });

      // Final JSON structure
      Map<String, dynamic> finalJson = {
        'ProjectInfo': originNodeData, // Add OriginNodeData here
        'ProjectSettings': convertedSettings, // Use converted settings here
        'Nodes': mergedNodes, // Add the rest of the nodes under 'Nodes'
      };

      // Convert final structure to JSON string
      String jsonString = jsonEncode(finalJson);

      // Save the file using native file picker with .fmv restriction
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Interactive Movie',
        fileName: 'untitled_interactive_movie.fmv',
        type: FileType.custom,
        allowedExtensions: ['fmv'],
      );

      if (outputPath != null) {
        // Ensure file ends with .fmv
        if (!outputPath.endsWith('.fmv')) {
          outputPath += '.fmv';
        }

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

  notifyError(String error) {
//TODO implement
  }
}
