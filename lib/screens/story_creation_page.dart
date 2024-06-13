import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class StoryCreationPage extends StatefulWidget {
  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  List<XFile> selectedImages = [];
  List<XFile> selectedVideos = [];
  VideoPlayerController? _videoPlayerController;
  late final AssetsAudioPlayer _assetsAudioPlayer;
  File? _trimmedVideo;
  GiphyGif? _selectedGif;
  File? _audioFile;
  final GlobalKey<SignatureState> _signaturePadKey =
      GlobalKey<SignatureState>();

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> _captureMedia(bool isVideo) async {
    final ImagePicker _picker = ImagePicker();
    if (isVideo) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        setState(() {
          selectedVideos.add(video);
          _initializeVideoPlayer(File(video.path));
        });
      }
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          selectedImages.add(image);
        });
      }
    }
  }

  Future<void> _pickMedia(bool isVideo) async {
    final ImagePicker _picker = ImagePicker();
    if (isVideo) {
      final List<XFile>? videos = await _pickMultipleVideos(_picker);
      if (videos != null) {
        setState(() {
          selectedVideos.addAll(videos);
          if (videos.isNotEmpty) {
            _initializeVideoPlayer(File(videos.first.path));
          }
        });
      }
    } else {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        setState(() {
          selectedImages.addAll(images);
        });
      }
    }
  }

  Future<List<XFile>?> _pickMultipleVideos(ImagePicker picker) async {
    List<XFile> pickedVideos = [];
    bool picking = true;
    while (picking) {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        pickedVideos.add(video);
      } else {
        picking = false;
      }
    }
    return pickedVideos;
  }

  void _initializeVideoPlayer(File file) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _editImage(int index) async {
    // Placeholder for image editing functionality
    final editedImageFile = File(selectedImages[index].path);
    setState(() {
      selectedImages[index] = XFile(editedImageFile.path);
    });
  }

  Future<void> _trimVideo(int index) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/trimmed_video.mp4';

    final result = await FFmpegKit.execute(
      '-i ${selectedVideos[index].path} -ss 00:00:00 -to 00:00:10 -c copy $outputPath',
    );
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      setState(() {
        _trimmedVideo = File(outputPath);
        _initializeVideoPlayer(_trimmedVideo!);
      });
    } else {
      print('Failed to trim video');
    }
  }

  Future<void> _addStickerToImage(int index) async {
    // Implement your sticker logic here. For simplicity, this code uses a placeholder.
    final stickerPath = await _getSticker();
    if (stickerPath != null) {
      final imageFile = File(selectedImages[index].path);
      // Add the sticker to the image (this part needs implementation).
      setState(() {
        selectedImages[index] = XFile(imageFile.path);
      });
    }
  }

  Future<String?> _getSticker() async {
    // Placeholder for actual sticker selection logic.
    // Return the path to the sticker image.
    return null;
  }

  Future<void> _addMusicToVideo(int index) async {
    // Replace this line with the correct path to the audio file you want to add to the video
    final String audioFilePath = 'path_to_your_audio_file.mp3';

    // Open the audio file
    await _assetsAudioPlayer.open(
      Audio.file(audioFilePath),
    );

    setState(() {
      _audioFile = File(audioFilePath);
    });

    final videoPath = selectedVideos[index].path;
    final outputPath = await _mergeAudioVideo(videoPath, _audioFile!.path);

    if (outputPath != null) {
      setState(() {
        selectedVideos[index] = XFile(outputPath);
        _initializeVideoPlayer(File(outputPath));
      });
    }
  }

  Future<String?> _mergeAudioVideo(String videoPath, String audioPath) async {
    final directoryPath = (await getTemporaryDirectory()).path;
    final outputPath =
        '$directoryPath/output_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final command =
        '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest "$outputPath"';

    var result = await FFmpegKit.execute(command);
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      print('Video and audio merged successfully');
      return outputPath;
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      print('Video and audio merging cancelled');
    } else {
      // ERROR
      print('Error merging video and audio');
    }
    return null;
  }

  Future<void> _pickGif() async {
    final GiphyGif? gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: 'YOUR_GIPHY_API_KEY', // Add your Giphy API key here
    );
    if (gif != null) {
      setState(() {
        _selectedGif = gif;
      });
    }
  }

  Future<void> _drawOnImage(int index) async {
    if (index < selectedImages.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Draw on Image')),
            body: Signature(
              key: _signaturePadKey,
              onSign: () {
                setState(() {});
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final sign = _signaturePadKey.currentState;
                if (sign != null) {
                  // Get the drawn image as bytes
                  final imageBytes = await _exportSignatureAsBytes(sign);

                  if (imageBytes != null) {
                    // Save the bytes to a file (example: write to a temporary file)
                    final tempDir = await getTemporaryDirectory();
                    final filePath = '${tempDir.path}/drawn_image.png';
                    final file = File(filePath);
                    await file.writeAsBytes(imageBytes);

                    // Update the selectedImages list with the new image file
                    setState(() {
                      selectedImages[index] = XFile(filePath);
                    });

                    Navigator.pop(context);
                  }
                }
              },
              child: Icon(Icons.check),
            ),
          ),
        ),
      );
    } else {
      // Handle drawing on video if necessary
    }
  }

  Future<Uint8List?> _exportSignatureAsBytes(SignatureState signState) async {
    try {
      // Convert drawn content to a Bitmap (Canvas)
      final Uint8List? imageBytes = (await signState.getData()) as Uint8List?;
      return imageBytes;
    } catch (e) {
      print('Error exporting signature as bytes: $e');
      return null;
    }
  }

  Future<void> _drawOnVideo(int index) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/output_video.mp4';

    // Extract frames from the video
    await FFmpegKit.execute(
        '-i ${selectedVideos[index].path} ${tempDir.path}/frame_%04d.png');

    // Iterate through each frame and allow the user to draw on it
    final frameFiles = Directory(tempDir.path)
        .listSync()
        .where((file) => file.path.endsWith('.png'))
        .toList();

    for (var frameFile in frameFiles) {
      final frameImage =
          img.decodeImage(File(frameFile.path).readAsBytesSync());
      if (frameImage != null) {
        // Create a drawing canvas
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('Draw on Frame')),
              body: Signature(
                key: _signaturePadKey,
                onSign: () {
                  setState(() {});
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final sign = _signaturePadKey.currentState;
                  if (sign != null) {
                    // Get the drawn image as Uint8List
                    final imageBytes = await sign.getData();
                    // ignore: unnecessary_null_comparison
                    if (imageBytes != null) {
                      final drawnImage =
                          img.decodeImage(imageBytes as List<int>);
                      if (drawnImage != null) {
                        final combinedImage =
                            img.copyInto(frameImage, drawnImage, blend: true);

                        // Save the new frame
                        File(frameFile.path)
                          ..writeAsBytesSync(img.encodePng(combinedImage));

                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: Icon(Icons.check),
              ),
            ),
          ),
        );
      }
    }

    // Reassemble the video
    await FFmpegKit.execute(
        '-framerate 30 -i ${tempDir.path}/frame_%04d.png -c:v libx264 -pix_fmt yuv420p $outputPath');

    setState(() {
      selectedVideos[index] = XFile(outputPath);
      _initializeEditedVideoPlayer(File(outputPath));
    });
  }

  void _initializeEditedVideoPlayer(File file) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Creation'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _captureMedia(false),
                  child: Text('Capture Photo'),
                ),
                ElevatedButton(
                  onPressed: () => _captureMedia(true),
                  child: Text('Capture Video'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickMedia(false),
                  child: Text('Pick Photos'),
                ),
                ElevatedButton(
                  onPressed: () => _pickMedia(true),
                  child: Text('Pick Videos'),
                ),
              ],
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: selectedImages.length + selectedVideos.length,
              itemBuilder: (context, index) {
                if (index < selectedImages.length) {
                  return GestureDetector(
                    onTap: () => _editImage(index),
                    onLongPress: () => _drawOnImage(index),
                    child: PhotoView(
                      imageProvider: FileImage(
                        File(selectedImages[index].path),
                      ),
                    ),
                  );
                } else {
                  final videoIndex = index - selectedImages.length;
                  return GestureDetector(
                    onTap: () => _trimVideo(videoIndex),
                    onLongPress: () => _drawOnImage(index),
                    child: _videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          )
                        : Container(
                            color: Colors.black,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            _selectedGif != null
                ? Image.network(
                    _selectedGif!.images.original!.url!,
                    height: 200,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickGif,
              child: Text('Add GIF'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement story posting logic here
              },
              child: Text('Post Story'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addStickerToImage(0); // Example: Add sticker to the first image
          _addMusicToVideo(0); // Example: Add music to the first video
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
