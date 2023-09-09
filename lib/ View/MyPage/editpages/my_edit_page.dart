import 'package:flutter/material.dart';
import '../../../Model/edit_model.dart';
import 'package:provider/provider.dart';

class NameEditPage extends StatelessWidget {
  NameEditPage(
    this.name,
  );

  final String? name;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NameEditModel>(
      create: (_) => NameEditModel(name)..fetchName(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                '名前の編集',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            Consumer<NameEditModel>(builder: (context, model, child) {
              return Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      try {
                        await model.nameupdate(model.namecontroller.text);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (context)=>
                        //         MyPage(model.name, model.area, model.pickertext1,model.pickertext2,''),
                        // ),);
                      } catch (e) {
                        final snackBar = SnackBar(
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      Navigator.of(context).pop();
                      model.fetchName();
                      print('保存しました');
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text('保存')),
              );
            }),
          ],
        ),
        body: Consumer<NameEditModel>(builder: (context, model, child) {
          return Column(children: [
            Column(
              children: [
                Stack(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.namecontroller,
                        onChanged: (text) async {},
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '名前',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ]);
        }),
      ),
    );
  }
}

class SelfEditPage extends StatelessWidget {
  SelfEditPage(
    this.self,
  );

  final String? self;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelfEditModel>(
      create: (_) => SelfEditModel(self)..fetchSelf(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '自己紹介の編集',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            Consumer<SelfEditModel>(builder: (context, model, child) {
              return Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      try {
                        await model.selfupdate(model.selfcontroller.text);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (context)=>
                        //         MyPage(model.name, model.area, model.pickertext1,model.pickertext2,''),
                        // ),);
                      } catch (e) {
                        final snackBar = SnackBar(
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      Navigator.of(context).pop();
                      model.fetchSelf();
                      print('保存しました');
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text('保存')),
              );
            }),
          ],
        ),
        body: Consumer<SelfEditModel>(builder: (context, model, child) {
          return Column(children: [
            Column(
              children: [
                Stack(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.selfcontroller,
                        onChanged: (text) async {},
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '自己紹介',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ]);
        }),
      ),
    );
  }
}
