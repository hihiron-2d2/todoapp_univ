import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_univ/add_book/add_book_model.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("book list sample"),
        ),
        body: Center(
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 100,
                      height: 160,
                      child: model.imageFile != null
                          ? Image.file(model.imageFile!)
                          : Container(color: Colors.grey,),
                    ),
                    onTap: () async {
                      await model.pickImage();
                    },
                  ),
                 TextField(
                  decoration: const InputDecoration(
                    hintText: '本のタイトル',
                  ),
                  onChanged: (text) {
                    //todo　取得したtextを使う
                    model.title = text;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: '本の著者',
                  ),
                  onChanged: (text) {
                    //todo　取得したtextを使う
                    model.author = text;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: () async {
                  //追加の処理
                  try {
                    await model.addBook();
                    Navigator.of(context).pop(true);
                  } catch (e){
                     final snackBar = SnackBar(
                       backgroundColor: Colors.amber,
                       content: Text(e.toString()),
                     );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }, child: const Text('追加する')),
              ],),
            );
          }),
        ),
      ),
    );
  }
}

