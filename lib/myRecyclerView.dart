import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'MainScreen.dart';
import 'my_model.dart';

final List<my_model> model = [
  const my_model("Enter Title","" )
];

class MyRecycler extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyRecyclerStatefulWidget(),
      ),
    );
  }
}

class MyRecyclerStatefulWidget extends StatefulWidget {
  const MyRecyclerStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyRecyclerStatefulWidget> createState() => _MyRecyclerState();
}

class _MyRecyclerState extends State<MyRecyclerStatefulWidget> {
  //declare vars here

  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('NotesTable').snapshots();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF931EA6),
      ),
      home: Scaffold(
    appBar: AppBar(
      title: const Text('My Notes'),
      centerTitle: true,
      backgroundColor: Colors.purple,
    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(mykey: model[0]),
                ),
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.add),
          ),
          body:StreamBuilder<QuerySnapshot>(
            stream: users,
            builder: (
            BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if(snapshot.hasError) {return const Text("Ooops something has a problem");}
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Text('Loading');
              }
              final data = snapshot.requireData;


              return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context,index) {
                      String myTitle = data.docs[index]['Title'];
                      String myNotes = data.docs[index]['notes'];
                      final List<my_model> model2 = [
                        my_model(myTitle,myNotes )
                      ];
                      model2.add(my_model(myTitle,myNotes ));
                      return Dismissible(
                        key: Key(myTitle),
                        onDismissed: (direction) {
                          // Remove the item from the data source.
                          setState(() {

                            final db = FirebaseFirestore.instance;
                            db.collection('NotesTable').doc(myTitle).delete();


                          });

                          // Then show a snackbar.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$myTitle dismissed')));
                        },
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            child: ListTile(
                              title: Text(myTitle,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(mykey: model2[index]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
            },
          )
      ),
    );
  }
}