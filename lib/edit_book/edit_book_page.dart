import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_univ/domain/book.dart';
import 'package:todoapp_univ/edit_book/edit_book_model.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  // ignore: use_key_in_widget_constructors
  const EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Page"),
        ),
        body: Center(
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: model.titleController,
                  decoration: const InputDecoration(
                    hintText: '本のタイトル',
                  ),
                  onChanged: (text) {
                    model.setTitle(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: model.authorController,
                  decoration: const InputDecoration(
                    hintText: '本の著者',
                  ),
                  onChanged: (text) {
                    model.setAuthor(text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: model.isUpdated()
                        ? ()  async {
                        //追加の処理
                         try {
                           await model.update();
                             Navigator.of(context).pop(model.title);
                         } catch (e){
                           final snackBar = SnackBar(
                             backgroundColor: Colors.amber,
                             content: Text(e.toString()),
                         );
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } : null, //なんでここにnullがつくんだ？
                    child: const Text('更新する'),
                ),
              ],),
            );
          }),
        ),
      ),
    );
  }
}

