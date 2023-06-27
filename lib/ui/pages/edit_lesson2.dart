import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:expertsway/db/database_helper.dart';
import 'package:expertsway/models/contributor_lesson.dart';
import 'package:expertsway/services/api_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expertsway/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:expertsway/theme/theme.dart';
import '../../main.dart';
import '../../models/lesson.dart';
import '../widgets/gradient_button.dart';
import 'course_detail/controller.dart';

class EditLesson2 extends GetView<MyController> {
  EditLesson2({super.key});

  final TextEditingController _lessonTitlecontroller = TextEditingController();
  final TextEditingController _lessonDescriptioncontroller = TextEditingController();
  final TextEditingController lessoncontentcontroller = TextEditingController();
  final List<TextEditingController> _controllers = [];
  final List<dynamic> _fields = [];
  final List<String> itemName = [];
  final FocusNode textfocusnode = FocusNode();
  List<File?> selectedImages = [];
  bool isSaved = false;
  List<LessonElement> lessonlist = [];

  List<String> chooseContTypeitems = ['Choose content type', 'title', 'paragraph', 'image', 'code'];
  List<String> programmingItems = [
    'Java',
    'C++',
  ];

  // String? lessonafterSelectedItem = 'lesson list';
  // String? choosecontTypeSelectedItems = 'Choose content type';
  // String? programmingSelectedItems = 'Java';
  bool isSliding = false; // Flag to track if the widget is being slid
  final formKey = GlobalKey<FormState>();

  void readlesson(String slug) async {
    lessonlist = await DatabaseHelper.instance.readLessonsOfACourse(slug);
    if (lessonlist.isNotEmpty) {
      for (var element in lessonlist) {
        if (!controller.lessonafterItems.contains(element.title)) {
          controller.lessonafterItems.add(element.title);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color secondbackgroundColor = Theme.of(context).cardColor;
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));
    TextTheme textTheme = Theme.of(context).textTheme;

    readlesson(controller.courseSlug.value);

    return Scaffold(
      backgroundColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 25, 32, 36),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                TextButton(
                  child: Icon(
                    Icons.chevron_left,
                    color: themeProvider.currentTheme == ThemeData.light() ? Colors.black : Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 330),
                  child: Text('Edit Lesson',
                      textAlign: TextAlign.end, style: textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Form(
                key: formKey,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lesson Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.currentTheme == ThemeData.light() ? Colors.black : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _lessonTitlecontroller,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                          hintText: "enter lesson title",
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          fillColor: secondbackgroundColor,
                          filled: true,
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          errorStyle: const TextStyle(fontSize: 0.01),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter lesson title';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Lesson description",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.currentTheme == ThemeData.light() ? Colors.black : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _lessonDescriptioncontroller,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                          hintText: "enter lesson short description",
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          fillColor: secondbackgroundColor,
                          filled: true,
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          errorStyle: const TextStyle(fontSize: 0.01),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter lesson short description';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "This lesson will be added after",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.currentTheme == ThemeData.light() ? Colors.black : Colors.white,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 38, 38, 38),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                              fillColor: secondbackgroundColor,
                              filled: true,
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              contentPadding: const EdgeInsets.all(15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            value: controller.lessonAfterSelectedItem.value,
                            items: controller.lessonafterItems
                                .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[400],
                                      ),
                                    )))
                                .toList(),
                            onChanged: (item) => controller.lessonAfterSelectedItem.value = item!,
                            validator: (value) {
                              if (value == 'lesson list') {
                                return '';
                              } else {
                                return null;
                              }
                            },
                          ),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lesson Content",
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.currentTheme == ThemeData.light() ? Colors.black : Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: true,
                          child: InkWell(
                            onTap: () {
                              // setState(() {
                              controller.isaddbtntap.value = !controller.isaddbtntap.value;
                              // });
                            },
                            child: const CircleAvatar(
                              backgroundColor: maincolor,
                              radius: 20,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10)
                      ],
                    ),
                    true
                        ? Column(
                            children: [
                              addContent(context),
                              _listView(context),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            height: 250,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 10),
                                Text("No content Available", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                                SizedBox(height: 10),
                                Text(
                                  "To add course content, press the + button and choose the type of content you want to add, You can then either send your lesson to reviewed by our staff or press Add page to continue adding more content",
                                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 170, 170, 170)),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: Container(
          width: double.infinity,
          height: 52,
          margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
          // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: GradientBtn(
            onPressed: () => send(controller.courseSlug.value, context),
            btnName: 'Send',
            defaultBtn: true,
            isPcked: false,
            height: 48,
          ),
        ),
      ),
    );
  }

  Future<String?> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    String filepath = '';
    if (pickedImage != null) {
      selectedImages.add(File(pickedImage.path));

      filepath = pickedImage.path;
      return filepath;
    }
    return null;
  }

  Widget buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
      );

  Widget _listView(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color secondbackgroundColor = Theme.of(context).cardColor;
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 350,
      margin: const EdgeInsets.only(bottom: 20),
      child: GetX<MyController>(builder: (
        context,
      ) {
        return ListView.builder(
          itemCount: controller.lescontFields.length,
          itemBuilder: (context, index) {
            if (controller.lescontFields.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Slidable(
                      key: ObjectKey(controller.lescontFields[index]),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          controller.removeFieldandController(index);
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              controller.removeFieldandController(index);
                            },
                            label: '',
                            icon: Icons.delete,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.only(top: 13),
                          ),
                        ],
                      ),
                      startActionPane: ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (_) {
                            final txtcontroller = TextEditingController();
                            final field = TextFormField(
                                controller: txtcontroller,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  hintText: "Enter page title",
                                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                  fillColor: secondbackgroundColor,
                                  filled: true,
                                  border: inputBorder,
                                  enabledBorder: inputBorder,
                                  errorStyle: const TextStyle(fontSize: 0.01),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  // TextEditingController cont = TextEditingController(text: '|*te*xt*| $value');
                                  // _controllers[index + 1] = cont;
                                },
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Enter page title';
                                  } else {
                                    return null;
                                  }
                                });
                            Lessoncontent lessoncontent = Lessoncontent(title: txtcontroller);

                            controller.addFieldandController(field, lessoncontent, index + 1);

                            // setState(() {
                            //   if (_controllers.isEmpty) {
                            //     _fields.add(field);
                            //     _controllers.add(controller);
                            //   } else {
                            //     _fields.insert(index + 1, field);
                            //     _controllers.insert(index + 1, controller);
                            //   }
                            // });
                          },
                          label: '',
                          icon: Icons.text_fields,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.only(top: 13),
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            final txtcontroller = TextEditingController();
                            final field = TextFormField(
                              controller: txtcontroller,
                              cursorColor: Colors.blue,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Enter paragraph",
                                counterText: '',
                                contentPadding: const EdgeInsets.all(20),
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                fillColor: secondbackgroundColor,
                                filled: true,
                                border: inputBorder,
                                enabledBorder: inputBorder,
                                errorStyle: const TextStyle(fontSize: 0.01),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              onChanged: (value) {
                                TextEditingController cont = TextEditingController(text: '|*pa*ra*| $value');
                                _controllers[index + 1] = cont;
                              },
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please Enter paragraph';
                                } else {
                                  return null;
                                }
                              },
                            );
                            // setState(() {
                            //   if (_controllers.isEmpty) {
                            //     _fields.add(field);
                            //     _controllers.add(controller);
                            //   } else {
                            //     _fields.insert(index + 1, field);
                            //     _controllers.insert(index + 1, controller);
                            //   }
                            // });
                            Lessoncontent lessoncontent = Lessoncontent(p: txtcontroller);

                            controller.addFieldandController(field, lessoncontent, index + 1);
                          },
                          label: '',
                          icon: Icons.text_snippet,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.only(top: 13),
                        ),
                        SlidableAction(
                          onPressed: (_) async {
                            String? filepa = await pickImage();
                            filepa != null
                                ? _fields.insert(
                                    index + 1,
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        width: double.infinity,
                                        height: 250,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: secondbackgroundColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.file(
                                          File(filepa),
                                        )))
                                : null;
                          },
                          label: '',
                          icon: Icons.image,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.only(top: 13),
                        ),
                        SlidableAction(
                          onPressed: (_) {
                            final txtcontroller = TextEditingController();
                            final field = Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: TextFormField(
                                      controller: txtcontroller,
                                      cursorColor: Colors.blue,
                                      maxLines: 10,
                                      decoration: InputDecoration(
                                        hintText: "public class Main(){\n \t\t print(\"hello world\");\n}",
                                        counterText: '',
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                        fillColor: secondbackgroundColor,
                                        filled: true,
                                        border: inputBorder,
                                        enabledBorder: inputBorder,
                                        errorStyle: const TextStyle(fontSize: 0.01),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      onChanged: (value) {
                                        TextEditingController cont = TextEditingController(text: '|*co*de*| $value');
                                        _controllers[index + 1] = cont;
                                      },
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Please enter a sample code';
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: SizedBox(
                                    width: 180,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            canvasColor: themeProvider.currentTheme == ThemeData.light()
                                                ? Colors.white
                                                : const Color.fromARGB(255, 38, 38, 38),
                                          ),
                                          child: DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                                fillColor: secondbackgroundColor,
                                                filled: true,
                                                border: inputBorder,
                                                enabledBorder: inputBorder,
                                                contentPadding: const EdgeInsets.all(15),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.blue),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                              value: controller.programmingSelectedItems.value,
                                              items: controller.programmingItems
                                                  .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey[400],
                                                        ),
                                                      )))
                                                  .toList(),
                                              onChanged: (item) => controller.programmingSelectedItems.value = item!),
                                        )),
                                  ),
                                )
                              ],
                            );
                            Lessoncontent lessoncontent = Lessoncontent(code: txtcontroller);

                            controller.addFieldandController(field, lessoncontent, index + 1);

                            // setState(() {
                            //   if (_controllers.isEmpty) {
                            //     _fields.add(field);
                            //     _controllers.add(controller);
                            //   } else {
                            //     _fields.insert(index + 1, field);
                            //     _controllers.insert(index + 1, controller);
                            //   }
                            // });
                          },
                          label: '',
                          icon: Icons.code,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.only(top: 13),
                        )
                      ]),
                      child: controller.lescontFields[index]),
                ),
              );
            } else {
              return addContent(context);
            }
          },
        );
      }),
    );
  }

  Widget addContent(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color secondbackgroundColor = Theme.of(context).cardColor;
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context), borderRadius: BorderRadius.circular(10));
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
        padding: const EdgeInsets.all(8),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 38, 38, 38),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              fillColor: secondbackgroundColor,
              filled: true,
              border: inputBorder,
              enabledBorder: inputBorder,
              contentPadding: const EdgeInsets.all(15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            value: controller.contTypeSelectedItems.value,
            items: controller.ContTypeItems.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[400],
                  ),
                ))).toList(),
            onChanged: (item) async {
              controller.contTypeSelectedItems.value = item!;

              switch (item) {
                case 'title':
                  final txtcontroller = TextEditingController();
                  final field = TextFormField(
                    controller: txtcontroller,
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      hintText: "Enter page title",
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      fillColor: secondbackgroundColor,
                      filled: true,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      errorStyle: const TextStyle(fontSize: 0.01),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      TextEditingController cont = TextEditingController(text: '|*te*xt*| $value');
                      // bool isthere = false;
                      // _controllers.map((e) {
                      //   isthere = e.text == cont.text;
                      //   if (isthere) {
                      //     isthere = true;
                      //   }
                      // });

                      // for (var element in _controllers) {
                      //   isthere = element.text == cont.text;
                      // }
                      // if (!isthere) {
                      _controllers.insert(0, cont);
                      // }
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter page title';
                      } else {
                        return null;
                      }
                    },
                  );
                  Lessoncontent lessoncontent = Lessoncontent(title: txtcontroller);

                  controller.addFieldandController(field, lessoncontent, null);

                  // setState(() {
                  //   _controllers.insert(0, controller);
                  //   _fields.insert(0, field);
                  // });
                  break;
                case 'paragraph':
                  final txtcontroller = TextEditingController();
                  final field = TextFormField(
                    controller: txtcontroller,
                    cursorColor: Colors.blue,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Enter paragraph",
                      counterText: '',
                      contentPadding: const EdgeInsets.all(20),
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      fillColor: secondbackgroundColor,
                      filled: true,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      errorStyle: const TextStyle(fontSize: 0.01),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onSaved: (value) {
                      //  controller.updateField(txtcontroller, 1);
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter paragraph';
                      } else {
                        return null;
                      }
                    },
                  );
                  // setState(() {
                  //   _controllers.add(controller);
                  //   _fields.insert(0, field);
                  // });
                  // TextEditingController cont = TextEditingController(text: '|*pa*ra*| ${txtcontroller.text}');

                  Lessoncontent lessoncontent = Lessoncontent(p: txtcontroller);

                  controller.addFieldandController(field, lessoncontent, null);

                  break;
                case 'image':
                  // Uint8List? file;
                  // final field = file == null
                  //     ?
                  String? filepa = await pickImage();
                  filepa != null
                      ? _fields.insert(
                          0,
                          Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              height: 250,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: secondbackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.file(
                                File(filepa),
                              )))
                      : null;

                  break;

                case 'code':
                  final txtcontroller = TextEditingController();

                  final field = Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: TextFormField(
                          controller: txtcontroller,
                          cursorColor: Colors.blue,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: "public class Main(){\n \t\t print(\"hello world\");\n}",
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                            fillColor: secondbackgroundColor,
                            filled: true,
                            border: inputBorder,
                            enabledBorder: inputBorder,
                            errorStyle: const TextStyle(fontSize: 0.01),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: textTheme.displayMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            TextEditingController cont = TextEditingController(text: '|*co*de*| $value');
                            _controllers.insert(0, cont);
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a sample code';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          width: 180,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: themeProvider.currentTheme == ThemeData.light() ? Colors.white : const Color.fromARGB(255, 38, 38, 38),
                                ),
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                      fillColor: secondbackgroundColor,
                                      filled: true,
                                      border: inputBorder,
                                      enabledBorder: inputBorder,
                                      contentPadding: const EdgeInsets.all(15),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    value: controller.programmingSelectedItems.value,
                                    items: controller.programmingItems
                                        .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[400],
                                              ),
                                            )))
                                        .toList(),
                                    onChanged: (item) => controller.programmingSelectedItems.value = item!),
                              )),
                        ),
                      )
                    ],
                  );
                  Lessoncontent lessoncontent = Lessoncontent(code: txtcontroller);

                  controller.addFieldandController(field, lessoncontent, null);

                  // setState(() {
                  //   _controllers.insert(0, controller);
                  //   _fields.insert(0, field);
                  // });
                  break;
                default:
              }
            },
            validator: (value) {
              if (value == 'Choose content type') {
                return '';
              } else {
                return null;
              }
            },
          ),
        ));
  }

  send(String slug, BuildContext context) async {
    isSaved = false;
    final form = formKey.currentState!;
    // setState(() {
    isSaved = true;
    // });
    try {
      if (form.validate() && controller.lescontFields.isNotEmpty) {
        formKey.currentState!.save();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
                  child: CircularProgressIndicator(color: maincolor),
                ));

        List<Lessoncontent> vard = [];

        for (var elem in controller.lessonContents.value) {
          vard.add(elem);
        }

        // _controllers.removeWhere((element) => element.text.substring(0, 9) != '|*te*xt*|' || '|*pa*ra*|'  );

        List<Lessoncontent> lessonContent = [];

        ContributeLesson contributors = ContributeLesson(
          courseSlug: slug,
          afterLesson: controller.lessonAfterSelectedItem.value,
          lessonTitle: _lessonTitlecontroller.text,
          lessonDescription: _lessonDescriptioncontroller.text,
          lessonContent: vard,
        );

        String res = await ApiProvider().createContributor(contributeLesson: contributors);
        navigatorKey.currentState!.popUntil((rout) => rout.isFirst);
        final List val = lessonContent.map((e) => e.toJson()).toList();
        final List v = [];
        for (var element in val) {
          v.add(element.toString());
        }
        // if (mounted) {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          titleSize: 20,
          messageSize: 17,
          backgroundColor: maincolor,
          borderRadius: BorderRadius.circular(8),
          message: res,
          duration: const Duration(seconds: 15),
        ).show(context);
        // }
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
