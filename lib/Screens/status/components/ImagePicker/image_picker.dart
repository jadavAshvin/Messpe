//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

// import 'dart:io';
// import 'dart:ui';
// import 'package:fiberchat/Configs/Enum.dart';
// import 'package:fiberchat/Configs/app_constants.dart';
// import 'package:fiberchat/Screens/status/components/VideoPicker/VideoPicker.dart';
// import 'package:fiberchat/Screens/status/editImage/editImage.dart';
// import 'package:fiberchat/Services/Providers/Observer.dart';
// import 'package:fiberchat/Services/localization/language_constants.dart';
// import 'package:fiberchat/Utils/open_settings.dart';
// import 'package:fiberchat/Utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// class StatusImageEditor extends StatefulWidget {
//   StatusImageEditor({
//     Key? key,
//     required this.title,
//     required this.callback,
//   }) : super(key: key);
//
//   final String title;
//   final Function(String str, File file) callback;
//
//   @override
//   _StatusImageEditorState createState() => new _StatusImageEditorState();
// }
//
// class _StatusImageEditorState extends State<StatusImageEditor> {
//   File? _imageFile;
//   ImagePicker picker = ImagePicker();
//   bool isLoading = false;
//   GlobalKey globalKey = new GlobalKey();
//
//   List<DrawingArea> points = [];
//   Color? selectedColor;
//   double? strokeWidth;
//   bool isDrawing = false;
//   bool _inProcess = false;
//   String? error;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedColor = primaryColors;
//     strokeWidth = 2.0;
//   }
//
//   final TextEditingController textEditingController =
//   new TextEditingController();
//
//   void captureImage(ImageSource captureMode) async {
//     final observer = Provider.of<Observer>(this.context, listen: false);
//     error = null;
//     try {
//       XFile? pickedImage = await (picker.pickImage(source: captureMode));
//       if (pickedImage != null) {
//         _imageFile = File(pickedImage.path);
//
//         if (_imageFile!.lengthSync() / 1000000 >
//             observer.maxFileSizeAllowedInMB) {
//           error =
//           '${getTranslated(this.context, 'maxfilesize')} ${observer.maxFileSizeAllowedInMB}MB\n\n${getTranslated(this.context, 'selectedfilesize')} ${(_imageFile!.lengthSync() / 1000000).round()}MB';
//
//           setState(() {
//             _imageFile = null;
//           });
//         } else {
//           setState(() {});
//         }
//       }
//     } catch (e) {}
//   }
//
//   Widget _buildImage() {
//     if (_imageFile != null) {
//       return Image.file(_imageFile!);
//     } else {
//       return new Text(getTranslated(context, 'takeimage'),
//           style: new TextStyle(
//             fontSize: 18.0,
//             color: DESIGN_TYPE == Themetype.whatsapp
//                 ? fiberchatWhite
//                 : fiberchatBlack,
//           ));
//     }
//   }
//
//   void selectColor() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Color Chooser'),
//         content: SingleChildScrollView(
//           child: ColorPicker(
//             pickerColor: selectedColor!,
//             onColorChanged: (color) {
//               this.setState(() {
//                 selectedColor = color;
//               });
//             },
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Close"))
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Fiberchat.getNTPWrappedWidget(WillPopScope(
//       child: Scaffold(
//         backgroundColor:
//         DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatWhite,
//         appBar: new AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Icon(
//                 Icons.keyboard_arrow_left,
//                 size: 30,
//                 color: DESIGN_TYPE == Themetype.whatsapp
//                     ? fiberchatWhite
//                     : fiberchatBlack,
//               ),
//             ),
//             // title: new Text(
//             //   widget.title,
//             //   style: TextStyle(
//             //     fontSize: 18,
//             //     color: DESIGN_TYPE == Themetype.whatsapp
//             //         ? fiberchatWhite
//             //         : fiberchatBlack,
//             //   ),
//             // ),
//             backgroundColor: DESIGN_TYPE == Themetype.whatsapp
//                 ? Colors.black
//                 : fiberchatWhite,
//             actions: _imageFile != null
//                 ? <Widget>[
//
//                   IconButton(
//                       icon: Icon(
//                         Icons.crop,
//                         color: DESIGN_TYPE == Themetype.whatsapp
//                             ? fiberchatWhite
//                             : fiberchatBlack,
//                       ),
//                       onPressed: () async {
//                         setState(() {
//                           _inProcess = true;
//                         });
//                         if (_imageFile != null) {
//                           File? cropped =
//                           await ImageCropper.cropImage(
//                               sourcePath: _imageFile!.path,
//                               aspectRatioPresets:
//                               Platform.isAndroid
//                                   ? [
//                                 CropAspectRatioPreset
//                                     .square,
//                                 CropAspectRatioPreset
//                                     .ratio3x2,
//                                 CropAspectRatioPreset
//                                     .original,
//                                 CropAspectRatioPreset
//                                     .ratio4x3,
//                                 CropAspectRatioPreset
//                                     .ratio16x9
//                               ]
//                                   : [
//                                 CropAspectRatioPreset
//                                     .original,
//                                 CropAspectRatioPreset
//                                     .square,
//                                 CropAspectRatioPreset
//                                     .ratio3x2,
//                                 CropAspectRatioPreset
//                                     .ratio4x3,
//                                 CropAspectRatioPreset
//                                     .ratio5x3,
//                                 CropAspectRatioPreset
//                                     .ratio5x4,
//                                 CropAspectRatioPreset
//                                     .ratio7x5,
//                                 CropAspectRatioPreset
//                                     .ratio16x9
//                               ],
//                               androidUiSettings:
//                               AndroidUiSettings(
//                                   toolbarTitle:
//                                   'Crop Image',
//                                   toolbarColor:
//                                   primaryColors,
//                                   toolbarWidgetColor:
//                                   Colors.white,
//                                   statusBarColor:
//                                   primaryColors,
//                                   activeControlsWidgetColor:
//                                   primaryColors,
//                                   initAspectRatio:
//                                   CropAspectRatioPreset
//                                       .original,
//                                   lockAspectRatio: false),
//                               iosUiSettings: IOSUiSettings(
//                                 title: 'Crop Image',
//                               ));
//                           if (cropped != null)
//                             setState(() {
//                               _imageFile = cropped;
//                               _inProcess = false;
//                             });
//                         }
//                       }),
//                   IconButton(
//                       icon: Icon(
//                         Icons.emoji_emotions_outlined,
//                         color: DESIGN_TYPE == Themetype.whatsapp
//                             ? fiberchatWhite
//                             : fiberchatBlack,
//                       ),
//                       onPressed: () async {}),
//                   IconButton(
//                       icon: Icon(
//                         Icons.text_fields_outlined,
//                         color: DESIGN_TYPE == Themetype.whatsapp
//                             ? fiberchatWhite
//                             : fiberchatBlack,
//                       ),
//                       onPressed: () async {}),
//                   IconButton(
//                       icon: Icon(
//                         Icons.edit,
//                         color: DESIGN_TYPE == Themetype.whatsapp
//                             ? fiberchatWhite
//                             : fiberchatBlack,
//                       ),
//                       onPressed: () async {
//                             Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                               return EditImage(imageFile: _imageFile,);
//                             }
//                             ));
//                         // Painter((_controller));
//                       }),
//                   IconButton(
//                       icon: Icon(
//                         Icons.check,
//                         color: DESIGN_TYPE == Themetype.whatsapp
//                             ? fiberchatWhite
//                             : fiberchatBlack,
//                       ),
//                       onPressed: () {
//                         widget.callback(
//                             textEditingController.text.isEmpty
//                                 ? ''
//                                 : textEditingController.text,
//                             _imageFile!);
//                       }),
//
//               SizedBox(
//                 width: 8.0,
//               ),
//             ]
//                 : []),
//         body: Stack(children: [
//           new Column(children: [
//             new Expanded(
//                 child: new Center(
//                     child: error != null
//                         ? fileSizeErrorWidget(error!)
//                         :
//                     // Container()
//
//                     _buildImage())),
//             _imageFile != null
//                 ? Container(
//               padding: EdgeInsets.all(12),
//               height: 80,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.black,
//               child: Row(children: [
//                 Flexible(
//                   child: TextField(
//                     maxLength: 100,
//                     maxLines: null,
//                     textAlign: TextAlign.center,
//                     style:
//                     TextStyle(fontSize: 18.0, color: fiberchatWhite),
//                     controller: textEditingController,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         // width: 0.0 produces a thin "hairline" border
//                         borderRadius: BorderRadius.circular(1),
//                         borderSide: BorderSide(
//                             color: Colors.transparent, width: 1.5),
//                       ),
//                       hoverColor: Colors.transparent,
//                       focusedBorder: OutlineInputBorder(
//                         // width: 0.0 produces a thin "hairline" border
//                         borderRadius: BorderRadius.circular(1),
//                         borderSide: BorderSide(
//                             color: Colors.transparent, width: 1.5),
//                       ),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(1),
//                           borderSide:
//                           BorderSide(color: Colors.transparent)),
//                       contentPadding: EdgeInsets.fromLTRB(7, 4, 7, 4),
//                       hintText: getTranslated(context, 'typeacaption'),
//                       hintStyle:
//                       TextStyle(color: Colors.grey, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ]),
//             )
//                 : _buildButtons()
//           ]),
//           Positioned(
//             child: isLoading && _inProcess
//                 ? Container(
//               child: Center(
//                 child: CircularProgressIndicator(
//                     valueColor:
//                     AlwaysStoppedAnimation<Color>(fiberchatBlue)),
//               ),
//               color: DESIGN_TYPE == Themetype.whatsapp
//                   ? fiberchatBlack.withOpacity(0.8)
//                   : fiberchatWhite.withOpacity(0.8),
//             )
//                 : Container(),
//           )
//         ]),
//       ),
//       onWillPop: () => Future.value(!isLoading),
//     ));
//   }
//
//   Widget _buildButtons() {
//     return new ConstrainedBox(
//         constraints: BoxConstraints.expand(height: 80.0),
//         child: new Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               _buildActionButton(new Key('retake'), Icons.photo_library, () {
//                 Fiberchat.checkAndRequestPermission(Permission.photos)
//                     .then((res) {
//                   if (res) {
//                     captureImage(ImageSource.gallery);
//                   } else {
//                     Fiberchat.showRationale(getTranslated(context, 'pgi'));
//                     Navigator.pushReplacement(
//                         context,
//                         new MaterialPageRoute(
//                             builder: (context) => OpenSettings()));
//                   }
//                 });
//               }),
//               _buildActionButton(new Key('upload'), Icons.photo_camera, () {
//                 Fiberchat.checkAndRequestPermission(Permission.camera)
//                     .then((res) {
//                   if (res) {
//                     captureImage(ImageSource.camera);
//                   } else {
//                     getTranslated(context, 'pci');
//                     Navigator.pushReplacement(
//                         context,
//                         new MaterialPageRoute(
//                             builder: (context) => OpenSettings()));
//                   }
//                 });
//               }),
//             ]));
//   }
//
//   Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
//     return new Expanded(
//       // ignore: deprecated_member_use
//       child: new RaisedButton(
//           key: key,
//           child: Icon(icon, size: 30.0),
//           shape: new RoundedRectangleBorder(),
//           color:
//           DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatgreen,
//           textColor: fiberchatWhite,
//           onPressed: onPressed as void Function()?),
//     );
//   }
// }
//
// class MyCustomPainter extends CustomPainter {
//   List<DrawingArea> points;
//   Color selecedColor;
//   double strokeWidth;
//
//   MyCustomPainter(this.points, this.selecedColor, this.strokeWidth);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     print("called");
//     Paint backgroundColor = Paint()..color = Colors.transparent;
//     Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     canvas.drawRect(rect, backgroundColor);
//
//     // Paint paint = Paint();
//     // paint.color = selecedColor;
//     // paint.strokeWidth = strokeWidth;
//     // paint.isAntiAlias = true;
//     // paint.strokeCap = StrokeCap.round;
//
//     for (int x = 0; x < points.length - 1; x++) {
//       print('inside for loop');
//       if (points[x] != null && points[x + 1] != null) {
//         print('in if');
//         canvas.drawLine(
//             points[x].point, points[x + 1].point, points[x].areaPaint);
//       } else if (points[x] != null && points[x + 1] == null) {
//         print('in els if');
//         canvas.drawPoints(
//             PointMode.points, [points[x].point], points[x].areaPaint);
//       }
//     }
//     // TODO: implement paint
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     // throw UnimplementedError();
//     return true;
//   }
// }
//
// class DrawingArea {
//   Offset point;
//   Paint areaPaint;
//
//   DrawingArea(this.point, this.areaPaint);
// }

//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fiberchat/Configs/Enum.dart';
import 'package:fiberchat/Configs/app_constants.dart';
import 'package:fiberchat/Screens/status/components/VideoPicker/VideoPicker.dart';
import 'package:fiberchat/Screens/status/editImage/newDraw.dart';
import 'package:fiberchat/Screens/status/filterImage/FiltersMatrix.dart';
import 'package:fiberchat/Screens/status/storyMaker/story_maker.dart';
import 'package:fiberchat/Services/Providers/Observer.dart';
import 'package:fiberchat/Services/localization/language_constants.dart';
import 'package:fiberchat/Utils/open_settings.dart';
import 'package:fiberchat/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class StatusImageEditor extends StatefulWidget {
  StatusImageEditor({
    Key? key,
    required this.title,
    required this.callback,
  }) : super(key: key);

  final String title;
  final Function(String str, File file) callback;

  @override
  _StatusImageEditorState createState() => new _StatusImageEditorState();
}

class _StatusImageEditorState extends State<StatusImageEditor> {
  File? _imageFile;
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  GlobalKey globalKey = new GlobalKey();

  List<DrawingArea> points = [];

  List<DrawingArea> removedPathList = [];
  List<List<DrawingArea>> mainPoints = [];
  Color? selectedColor;
  double? strokeWidth;
  bool isDrawing = false;
  bool _inProcess = false;
  String? error;
  bool _isShowFilter = false;

  @override
  void initState() {
    super.initState();
    selectedColor = primaryColors;
    strokeWidth = 2.0;
  }

  ValueNotifier currentPresetFilter =
      ValueNotifier(FiltersMatrix.filtersList.keys.first);
  double filterOpacity = 1;

  int currentImage = 0;
  ValueNotifier<String> currentFilter = ValueNotifier('normal');

  img.Image? tinyImage;

  List<Widget> _getFilters() {
    List<Widget> filtersList = [];

    if (tinyImage == null) {
      return [
        Text(
          "Image is null",
          style: TextStyle(color: Colors.white),
        )
      ];
    }
    if (tinyImage != null) {
      for (var filterName in FiltersMatrix.filtersList.keys) {
        filtersList.add(InkWell(
          onTap: () {
            currentFilter.value = filterName;

            // filterOpacity = 1;
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ColorFiltered(
                colorFilter:
                    ColorFilter.matrix(FiltersMatrix.filtersList[filterName]!),
                child: Image.memory(
                  Uint8List.fromList(img.encodeJpg(tinyImage!)),
                  fit: BoxFit.cover,
                  width: 100,
                ),
              ),
            ),
          ),
        ));
      }
      return filtersList;
    }
    return filtersList;
  }

  final TextEditingController textEditingController =
      new TextEditingController();

  void captureImage(ImageSource captureMode) async {
    final observer = Provider.of<Observer>(this.context, listen: false);
    error = null;
    try {
      XFile? pickedImage = await (picker.pickImage(source: captureMode));
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        Uint8List imageBytes = await _imageFile!.readAsBytes();
        print('called imageBytes');
        img.Image decodedImage = img.decodeImage(
          imageBytes,
        )!;
        print('called');
        tinyImage = img.copyResize(decodedImage, width: 100);
         print("after tinyImage"+ tinyImage!.width.toString());
        //tinyImage = decodedImage;

        if (_imageFile!.lengthSync() / 1000000 >
            observer.maxFileSizeAllowedInMB) {
          error =
              '${getTranslated(this.context, 'maxfilesize')} ${observer.maxFileSizeAllowedInMB}MB\n\n${getTranslated(this.context, 'selectedfilesize')} ${(_imageFile!.lengthSync() / 1000000).round()}MB';

          setState(() {
            _imageFile = null;
          });
        } else {
          setState(() {
            print("tiny image $tinyImage image file $_imageFile");
          });
        }
      }
    } catch (e) {}
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return RepaintBoundary(
        key: globalKey,

        child: ValueListenableBuilder(
          valueListenable: currentFilter,
          builder: (context,currentFilter,child){
            return ColorFiltered(
                colorFilter:
                ColorFilter.matrix(FiltersMatrix.filtersList[currentFilter]!),
                child: Image.file(_imageFile!));
          },
        ),
      );
    } else {
      return new Text(getTranslated(context, 'takeimage'),
          style: new TextStyle(
            fontSize: 18.0,
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatWhite
                : fiberchatBlack,
          ));
    }
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color Chooser'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor!,
            onColorChanged: (color) {
              this.setState(() {
                selectedColor = color;
              });
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Fiberchat.getNTPWrappedWidget(WillPopScope(
      child: Scaffold(
        backgroundColor:
            DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatWhite,
        appBar: new AppBar(
            leading: isDrawing
                ? Container()
                : IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      size: 30,
                      color: DESIGN_TYPE == Themetype.whatsapp
                          ? fiberchatWhite
                          : fiberchatBlack,
                    ),
                  ),
            // title: new Text(
            //   widget.title,
            //   style: TextStyle(
            //     fontSize: 18,
            //     color: DESIGN_TYPE == Themetype.whatsapp
            //         ? fiberchatWhite
            //         : fiberchatBlack,
            //   ),
            // ),
            backgroundColor: DESIGN_TYPE == Themetype.whatsapp
                ? Colors.black
                : fiberchatWhite,
            actions: _imageFile != null
                ? <Widget>[
              _isShowFilter ? Container() :
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.crop,
                              color: DESIGN_TYPE == Themetype.whatsapp
                                  ? fiberchatWhite
                                  : fiberchatBlack,
                            ),
                            onPressed: () async {
                              setState(() {
                                _inProcess = true;
                              });
                              if (_imageFile != null) {
                                File? cropped = await ImageCropper.cropImage(
                                    sourcePath: _imageFile!.path,
                                    aspectRatioPresets: Platform.isAndroid
                                        ? [
                                            CropAspectRatioPreset.square,
                                            CropAspectRatioPreset.ratio3x2,
                                            CropAspectRatioPreset.original,
                                            CropAspectRatioPreset.ratio4x3,
                                            CropAspectRatioPreset.ratio16x9
                                          ]
                                        : [
                                            CropAspectRatioPreset.original,
                                            CropAspectRatioPreset.square,
                                            CropAspectRatioPreset.ratio3x2,
                                            CropAspectRatioPreset.ratio4x3,
                                            CropAspectRatioPreset.ratio5x3,
                                            CropAspectRatioPreset.ratio5x4,
                                            CropAspectRatioPreset.ratio7x5,
                                            CropAspectRatioPreset.ratio16x9
                                          ],
                                    androidUiSettings: AndroidUiSettings(
                                        toolbarTitle: 'Crop Image',
                                        toolbarColor: primaryColors,
                                        toolbarWidgetColor: Colors.white,
                                        statusBarColor: primaryColors,
                                        activeControlsWidgetColor:
                                            primaryColors,
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    iosUiSettings: IOSUiSettings(
                                      title: 'Crop Image',
                                    ));
                                if (cropped != null){

                                  _imageFile = cropped;
                                  Uint8List imageBytes = await _imageFile!.readAsBytes();
                                  print('called imageBytes');
                                  img.Image decodedImage = img.decodeImage(
                                    imageBytes,
                                  )!;
                                  print('called');
                                  tinyImage = decodedImage;
                                  setState(() {
                                    _inProcess = false;
                                  });
                                }

                              }
                            }),
                        // IconButton(
                        //     icon: Icon(
                        //       Icons.emoji_emotions_outlined,
                        //       color: DESIGN_TYPE == Themetype.whatsapp
                        //           ? fiberchatWhite
                        //           : fiberchatBlack,
                        //     ),
                        //     onPressed: () async {}),

                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: DESIGN_TYPE == Themetype.whatsapp
                                  ? fiberchatWhite
                                  : fiberchatBlack,
                            ),
                            onPressed: () async {
                              // setState(() {
                              //   isDrawing = !isDrawing;
                              // });
                              final file = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FlutterPainterExample(
                                            file: _imageFile,
                                          ))) as File?;
                              if (file != null) {

                                _imageFile = file;
                                Uint8List imageBytes = await _imageFile!.readAsBytes();
                                print('called imageBytes');
                                img.Image decodedImage = img.decodeImage(
                                  imageBytes,
                                )!;
                                print('called');
                                tinyImage = decodedImage;

                                print("called");
                                setState(() {
                                });
                              }

                              // Painter((_controller));
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.text_fields_outlined,
                              color: DESIGN_TYPE == Themetype.whatsapp
                                  ? fiberchatWhite
                                  : fiberchatBlack,
                            ),
                            onPressed: () async {
                              final File editedFile =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StoryMaker(
                                    filePath: _imageFile!.path,
                                  ),
                                ),
                              );

                              _imageFile = editedFile;
                              Uint8List imageBytes = await _imageFile!.readAsBytes();
                              print('called imageBytes');
                              img.Image decodedImage = img.decodeImage(
                                imageBytes,
                              )!;
                              print('called');
                              tinyImage = decodedImage;
                              setState(() {

                              });
                              //print('editedFile: ${editedFile!.path}');
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.check,
                              color: DESIGN_TYPE == Themetype.whatsapp
                                  ? fiberchatWhite
                                  : fiberchatBlack,
                            ),
                            onPressed: () {
                              widget.callback(
                                  textEditingController.text.isEmpty
                                      ? ''
                                      : textEditingController.text,
                                  _imageFile!);
                            }),
                      ],
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                  ]
                : []),
        body: Stack(children: [
          new Column(children: [
            new Expanded(
                child: new Center(
              child: error != null
                  ? fileSizeErrorWidget(error!)
                  :
                  // Container()

                  _buildImage(),
            )),
            _imageFile != null
                ? Column(
                    children: [
                      GestureDetector(
                        onPanEnd: (details) async {
                          // Swiping in right direction.
                          print(details.velocity.pixelsPerSecond.direction);
                          if (details.velocity.pixelsPerSecond.direction < 0) {
                            setState(() {
                              _isShowFilter = !_isShowFilter;
                            });
                          }
                          if (details.velocity.pixelsPerSecond.direction > 0) {

                            setState(() {
                              currentFilter.value = 'normal';
                              _isShowFilter = !_isShowFilter;
                            });
                            String path = "";
                            RenderRepaintBoundary boundry =
                                globalKey.currentContext!.findRenderObject()
                                    as RenderRepaintBoundary;
                            print('after RenderRepaintBoundary');
                            final image = await boundry.toImage(pixelRatio: 8.0);
                            print('after image');
                            ByteData? byData = await image.toByteData(
                                format: ui.ImageByteFormat.png);
                            print('after byData');
                            Uint8List bytes = byData!.buffer.asUint8List();
                            print('after bytes');
                            // _imageFile = File(image);
                            print('$bytes');
                            final pathTemp = await getTemporaryDirectory();
                            path = pathTemp.path +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString() +
                                '.png';
                            _imageFile = await File(path).writeAsBytes(bytes);

                          }
                          setState(() {

                          });

                          // Swiping in left direction.
                          // if (details.delta.dy < 0) {}
                        },
                        child: Column(
                          children: [
                            Icon(
                              _isShowFilter
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              'Filter',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      _isShowFilter
                          ? SizedBox(
                              height: 150,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _getFilters(),
                              ),
                            )
                          : Container(),
                      _isShowFilter
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(12),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black,
                              child: Row(children: [
                                Flexible(
                                  child: TextField(
                                    maxLength: 100,
                                    maxLines: null,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18.0, color: fiberchatWhite),
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.circular(1),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                      ),
                                      hoverColor: Colors.transparent,
                                      focusedBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderRadius: BorderRadius.circular(1),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(7, 4, 7, 4),
                                      hintText: getTranslated(
                                          context, 'typeacaption'),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                    ],
                  )
                : _buildButtons()
          ]),
          Positioned(
            child: isLoading && _inProcess
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(fiberchatBlue)),
                    ),
                    color: DESIGN_TYPE == Themetype.whatsapp
                        ? fiberchatBlack.withOpacity(0.8)
                        : fiberchatWhite.withOpacity(0.8),
                  )
                : Container(),
          )
        ]),
      ),
      onWillPop: () => Future.value(!isLoading),
    ));
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(new Key('retake'), Icons.photo_library, () {
                Fiberchat.checkAndRequestPermission(Permission.photos)
                    .then((res) {
                  if (res) {
                    captureImage(ImageSource.gallery);
                  } else {
                    Fiberchat.showRationale(getTranslated(context, 'pgi'));
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => OpenSettings()));
                  }
                });
              }),
              _buildActionButton(new Key('upload'), Icons.photo_camera, () {
                Fiberchat.checkAndRequestPermission(Permission.camera)
                    .then((res) {
                  if (res) {
                    captureImage(ImageSource.camera);
                  } else {
                    getTranslated(context, 'pci');
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => OpenSettings()));
                  }
                });
              }),
            ]));
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color:
              DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatgreen,
          textColor: fiberchatWhite,
          onPressed: onPressed as void Function()?),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<List<DrawingArea>> mainPoints;
  Color selectedColor;
  double strokeWidth;

  MyCustomPainter(this.mainPoints, this.selectedColor, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    print("called");
    Paint backgroundColor = Paint()..color = Colors.transparent;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, backgroundColor);

    // Paint paint = Paint();
    // paint.color = selecedColor;
    // paint.strokeWidth = strokeWidth;
    // paint.isAntiAlias = true;
    // paint.strokeCap = StrokeCap.round;

    for (List<DrawingArea> points in mainPoints) {
      for (int x = 0; x < points.length - 1; x++) {
        // print('inside for loop');
        if (points[x] != null && points[x + 1] != null) {
          // print('in if');
          canvas.drawLine(
              points[x].point, points[x + 1].point, points[x].areaPaint);
        } else if (points[x] != null && points[x + 1] == null) {
          // print('in els if');
          canvas.drawPoints(
              ui.PointMode.points, [points[x].point], points[x].areaPaint);
        }
      }
    }

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea(this.point, this.areaPaint);
}
