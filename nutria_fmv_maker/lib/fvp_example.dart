import 'package:flutter/material.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';

class VideoMetadataWidget extends StatefulWidget {
  final String videoFilePath;
  const VideoMetadataWidget({Key? key, required this.videoFilePath})
      : super(key: key);

  @override
  _VideoMetadataWidgetState createState() => _VideoMetadataWidgetState();
}

class _VideoMetadataWidgetState extends State<VideoMetadataWidget> {
  MediaInformation? _mediaInformation;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMetadata();
  }

  Future<void> _fetchMetadata() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use the runProbe method to retrieve metadata.
      // Note: There are no additional parameters exposed here, so if you need to override
      // any ffprobe parameters, you'd have to modify the plugin or check its source.
      final info = await FFMpegHelper.instance.runProbe(widget.videoFilePath,
          'C:\\dev\\flutter_projects\\Nutria_FMV_Maker\\nutria_fmv_maker\\ffmpeg\\bin');
      setState(() {
        _mediaInformation = info;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMetadataDisplay() {
    if (_mediaInformation == null) {
      return const Text('No metadata found.');
    }

    // The properties below are examples. Inspect your MediaInformation object
    // to see which fields are available (e.g., formatName, duration, bitrate, etc.).
    dynamic info = _mediaInformation!.getAllProperties();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Format: ${_mediaInformation!.getFormat() ?? 'Unknown'}'),
        Text(
            'Duration: ${_mediaInformation!.getDuration() ?? 'Unknown'} seconds'),
        Text('Bitrate: ${_mediaInformation!.getBitrate() ?? 'Unknown'}'),
        Text('fps : ${parseFrameRate(findValueForKey(info, 'r_frame_rate')) ?? 'Unknown'}'),
        Text(
            'aspect ratio : ${findValueForKey(info, 'display_aspect_ratio') ?? 'Unknown'}'),
        SelectableText(
            '${_mediaInformation!.getAllProperties() ?? 'Unknown'}'),

        // You can add more fields here if MediaInformation includes additional parameters.
      ],
    );
  }

  String parseFrameRate(String fpsString) {
  // Check if the string contains a fraction
  if (fpsString.contains('/')) {
    final parts = fpsString.split('/');
    if (parts.length == 2) {
      final numerator = double.tryParse(parts[0].trim());
      final denominator = double.tryParse(parts[1].trim());
      if (numerator != null && denominator != null && denominator != 0) {
        // Perform the division and round the result to 2 decimals
        return (numerator / denominator).toStringAsFixed(2);
      }
    }
    // Fallback if parsing fails
    return '0.00';
  } else {
    // Directly parse the numeric value and round to 2 decimals
    final parsedValue = double.tryParse(fpsString.trim());
    if (parsedValue != null) {
      return parsedValue.toStringAsFixed(2);
    }
    // Fallback if parsing fails
    return '0.00';
  }
}


  dynamic findValueForKey(dynamic data, String targetKey) {
    if (data is Map) {
      if (data.containsKey(targetKey)) {
        return data[targetKey];
      }
      // Search in nested maps
      for (var key in data.keys) {
        final result = findValueForKey(data[key], targetKey);
        if (result != null) {
          return result;
        }
      }
    } else if (data is List) {
      // Iterate over each item in the list
      for (var item in data) {
        final result = findValueForKey(item, targetKey);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Text('Error: $_error')
                : _buildMetadataDisplay(),
      ),
    );
  }
}
