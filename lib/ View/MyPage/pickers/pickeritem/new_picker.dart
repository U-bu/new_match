// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'new_picker_item.dart';

// // ignore: must_be_immutable
// class PickerPage extends ConsumerWidget {
// //  final String? areaitem;
// //   final String blooditem;
// //   final String heightitem;
//   // static String area = '';
//   // static String blood = '';
//   // static String height = '';

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemScope = ref.watch(itemScopeProvider);


//     return Scaffold(
//       appBar: AppBar(
//         title: Text('picker'),
//       ),
//       body: ListView.builder(
//         itemCount: itemScope.sheet.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () => showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return itemScope.sheet[index];
//         }),
        
          
//             child: Container(
//               height: 60,
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//               ),
//               child:  Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       '${itemScope.pickerItem[index]}',
//                     ),
//                   ),
//                  Text('${itemScope.pickerItem[index]}',),
                     
                   
                  
//                   Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



// class AreaSheet extends ConsumerWidget {  
//   AreaSheet();
// @override
//   Widget build(BuildContext context,WidgetRef ref) {
//         final itemScope = ref.watch(itemScopeProvider);
//         final int index = 0;
//                   return Scaffold(
//                     appBar: AppBar(
//                       leadingWidth: 0,
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                       title: Stack(
//                         children: [
//                           Align(
//                               alignment: Alignment.bottomLeft,
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text(
//                                   'キャンセル',
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.bottomRight,
//                               child: TextButton(
//                                    onPressed: () async {
//                                     try {
//                                       await itemScope.areaUpdate(itemScope.areaItem[index]);
//                                     } catch (e) {
//                                       const snackBar = SnackBar(
//                                         content: Text('エラー'),
//                                       );
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(snackBar);
//                                     }

//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('保存'))),
//                         ],
//                       ),
//                     ),
//                     body: CupertinoPicker(
//                       itemExtent: 35,
//                       onSelectedItemChanged: (int index){
//                       itemScope.set_areadrum(index);
//                       },
//                       scrollController:
//                           FixedExtentScrollController(initialItem: 0),
//                           children: itemScope.areaItem.map((String value) {
//                         return Text(value);
//                       }).toList(),),);
                     
    
//   } 
//   }
//   class JobSheet extends ConsumerWidget {  
//   JobSheet();
// @override
//   Widget build(BuildContext context,WidgetRef ref) {
//         final itemScope = ref.watch(itemScopeProvider);
//         final int index = 0;
//                   return Scaffold(
//                     appBar: AppBar(
//                       leadingWidth: 0,
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                       title: Stack(
//                         children: [
//                           Align(
//                               alignment: Alignment.bottomLeft,
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text(
//                                   'キャンセル',
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.bottomRight,
//                               child: TextButton(
//                                    onPressed: () async {
//                                     try {
//                                       await itemScope.jobUpdate(itemScope.jobItem[index]);
//                                     } catch (e) {
//                                       const snackBar = SnackBar(
//                                         content: Text('エラー'),
//                                       );
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(snackBar);
//                                     }

//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('保存'))),
//                         ],
//                       ),
//                     ),
//                     body: CupertinoPicker(
//                       itemExtent: 35,
//                       onSelectedItemChanged: (int index){
//                       itemScope.set_jobdrum(index);
//                       },
//                       scrollController:
//                           FixedExtentScrollController(initialItem: 0),
//                           children: itemScope.areaItem.map((String value) {
//                         return Text(value);
//                       }).toList(),),);
                     
    
//   } 
//   }

//   class BloodSheet extends ConsumerWidget {  
//   BloodSheet();
// @override
//   Widget build(BuildContext context,WidgetRef ref) {
//         final itemScope = ref.watch(itemScopeProvider);
//         final int index = 0;
//                   return Scaffold(
//                     appBar: AppBar(
//                       leadingWidth: 0,
//                       elevation: 0,
//                       backgroundColor: Colors.white,
//                       title: Stack(
//                         children: [
//                           Align(
//                               alignment: Alignment.bottomLeft,
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text(
//                                   'キャンセル',
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.bottomRight,
//                               child: TextButton(
//                                    onPressed: () async {
//                                     try {
//                                       await itemScope.bloodUpdate(itemScope.bloodItem[index]);
//                                     } catch (e) {
//                                       const snackBar = SnackBar(
//                                         content: Text('エラー'),
//                                       );
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(snackBar);
//                                     }

//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('保存'))),
//                         ],
//                       ),
//                     ),
//                     body: CupertinoPicker(
//                       itemExtent: 35,
//                       onSelectedItemChanged: (int index){
//                       itemScope.set_blooddrum(index);
//                       },
//                       scrollController:
//                           FixedExtentScrollController(initialItem: 0),
//                           children: itemScope.bloodItem.map((String value) {
//                         return Text(value);
//                       }).toList(),),);
                     
    
//   } 
//   }

  
 

  
 