import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp_univ/add_book/add_book_page.dart';
import 'package:todoapp_univ/book_list/book_list_model.dart';
import 'package:todoapp_univ/domain/book.dart';
import 'package:todoapp_univ/edit_book/edit_book_page.dart';

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
        body: Center(
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
                            onPressed: (BuildContext context) async {
                              //編集画面に遷移する
                              bool? added = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditBookPage(book),
                                ),
                              );

                              if (added != null && added){
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.lightGreen,
                                  content: Text('本を編集しました'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              model.fetchBookList();

                            },
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors .white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: null,
                            backgroundColor: Color(0xFFff4500),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                          title: Text(book.title),
                          subtitle: Text(book.author),
                        ),
                    ),
            )
            .toList();
            return ListView(
                children: widgets,
            );
          }),
        ),
        floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                 //画面遷移
                 final String? title = await Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const AddBookPage(),
                       fullscreenDialog: true,
                     ),
                 );

                 if (title != null){
                   final snackBar = SnackBar(
                     backgroundColor: Colors.lightGreen,
                     content: Text('$titleを追加しました'),
                   );
                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                 }
                 model.fetchBookList();
               },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}

