import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_univ/add_book/add_book_page.dart';
import 'package:todoapp_univ/book_list/book_list_model.dart';
import 'package:todoapp_univ/domain/book.dart';
import 'package:todoapp_univ/edit_book/edit_book_page.dart';
import 'package:flutter/cupertino.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("book list sample"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<BookListModel>(builder: (context, model, child) {
              final List<Book>? books = model.books;

              if (books == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = books.map(
                      (book) => Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                //編集画面に遷移する
                                final String? title = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBookPage(book),
                                  ),
                                );

                                if (title != null){
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.lightGreen,
                                    content: Text('$titleを編集しました'),
                                  );
                                  model.fetchBookList();
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors .white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                await showDeleteDialog(context, book, model);
                              },
                              backgroundColor: Color(0xFFff4500),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                            leading: book.imgURL != null
                            ? Image.network(book.imgURL!)
                            : null,
                            title: Text(book.title),
                            subtitle: Text(book.author),
                          ),
                      ),
              )
              .toList();
              return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: widgets,
              );
            }),
          ),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                 //画面遷移
                 final bool? added = await Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const AddBookPage(),
                       fullscreenDialog: true,
                     ),
                 );

                 if (added != null && added){
                   final snackBar = SnackBar(
                     backgroundColor: Colors.lightGreen,
                     content: const Text('本を追加しました'),
                   );
                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   model.fetchBookList();
                 }
               },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }

  Future showDeleteDialog(
      BuildContext context,
      Book book,
      BookListModel model
      ) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
            return AlertDialog(
              title: const Text("削除の確認"),
              content: Text("『${book.title}』を削除しますか？"),
              actions: [
                CupertinoDialogAction(
                    child: const Text('Cancel'),
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                CupertinoDialogAction(
                  child: const Text('OK'),
                  //modelで削除
                  onPressed: () async {
                    await model.delete(book);
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('${book.title}を削除しました'),
                      );
                      model.fetchBookList();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                )
              ],
            );
        });
    }
  }

