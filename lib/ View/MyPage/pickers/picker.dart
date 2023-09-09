import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_match/%20View/MyPage/pickers/pickeritem/pickeritem.dart';
import 'package:provider/provider.dart';
import '../../../Model/edit_model.dart';

// ignore: must_be_immutable
class Picker extends StatefulWidget {
  String areaitem;
  String blooditem;
  String heightitem;
  String ageitem;

  Picker(this.blooditem, this.heightitem, this.ageitem, this.areaitem,
      {super.key});
  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  static String area = '';
  static String blood = '';
  static String height = '';
  static String age = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          Column(children: [
            GestureDetector(
              onTap: _bloodselect,
              child: const BloodPicker(),
            ),
            GestureDetector(
              onTap: _heightselect,
              child: const HeightPicker(),
            ),
            GestureDetector(
              onTap: _areaselect,
              child: const AreaPicker(),
            ),
            GestureDetector(
              onTap: _ageselect,
              child: const AgePicker(),
            ),
          ]),
        ],
      ),
    );
  }

  void area_drum(int index) {
    setState(() {
      area = areaItem[index];
    });
  }

  void blood_drum(int index) {
    setState(() {
      blood = bloodItem[index];
    });
  }

  void height_drum(int index) {
    setState(() {
      height = heightItem[index];
    });
  }

  void age_drum(int index) {
    setState(() {
      age = ageItem[index];
    });
  }

  void _bloodselect() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<BloodEditModel>(
            create: (_) => BloodEditModel(blood),
            child: Consumer<BloodEditModel>(builder: (context, model, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child:
                    Consumer<BloodEditModel>(builder: (context, model, child) {
                  return Scaffold(
                    appBar: AppBar(
                      leadingWidth: 0,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'キャンセル',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await model.bloodupdate(blood);
                                    } catch (e) {
                                      final snackBar = SnackBar(
                                        content: Text(e.toString()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }

                                    Navigator.of(context).pop(blood);
                                  },
                                  child: const Text('保存'))),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: blood_drum,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      children: bloodItem.map((String value) {
                        return Text(value);
                      }).toList(),
                    ),
                  );
                }),
              );
            }),
          );
        });
  }

  void _heightselect() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<HeightEditModel>(
            create: (_) => HeightEditModel(height),
            child: Consumer<HeightEditModel>(builder: (context, model, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child:
                    Consumer<HeightEditModel>(builder: (context, model, child) {
                  return Scaffold(
                    appBar: AppBar(
                      leadingWidth: 0,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(height);
                                },
                                child: const Text(
                                  'キャンセル',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await model.heightupdate(height);
                                    } catch (e) {
                                      const snackBar = SnackBar(
                                        content: Text('エラー'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }

                                    Navigator.of(context).pop(height);
                                  },
                                  child: const Text('保存'))),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: height_drum,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      children: heightItem.map((String value) {
                        return Text(value);
                      }).toList(),
                    ),
                  );
                }),
              );
            }),
          );
        });
  }

  void _areaselect() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<AreaEditModel>(
            create: (_) => AreaEditModel(height),
            child: Consumer<AreaEditModel>(builder: (context, model, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child:
                    Consumer<AreaEditModel>(builder: (context, model, child) {
                  return Scaffold(
                    appBar: AppBar(
                      leadingWidth: 0,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'キャンセル',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await model.areaupdate(area);
                                    } catch (e) {
                                      final snackBar = SnackBar(
                                        content: Text(e.toString()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }

                                    Navigator.of(context).pop(area);
                                  },
                                  child: const Text('保存'))),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: area_drum,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      children: areaItem.map((String value) {
                        return Text(value);
                      }).toList(),
                    ),
                  );
                }),
              );
            }),
          );
        });
  }

  void _ageselect() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChangeNotifierProvider<AgeEditModel>(
            create: (_) => AgeEditModel(age),
            child: Consumer<AgeEditModel>(builder: (context, model, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Consumer<AgeEditModel>(builder: (context, model, child) {
                  return Scaffold(
                    appBar: AppBar(
                      leadingWidth: 0,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'キャンセル',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await model.ageupdate(age);
                                    } catch (e) {
                                      final snackBar = SnackBar(
                                        content: Text(e.toString()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }

                                    Navigator.of(context).pop(area);
                                  },
                                  child: const Text('保存'))),
                        ],
                      ),
                    ),
                    body: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: age_drum,
                      scrollController:
                          FixedExtentScrollController(initialItem: 0),
                      children: ageItem.map((String value) {
                        return Text(value);
                      }).toList(),
                    ),
                  );
                }),
              );
            }),
          );
        });
  }
}
