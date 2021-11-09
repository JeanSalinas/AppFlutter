import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  create()async{
    try{
      await firebase.collection("Usuarios").doc(name.text).set({
        "Nombre":name.text,
        "Email": email.text
      });
    }catch (e){
      print(e);
    }
  }
  update()async{
    try{
      firebase.collection("Usuarios").doc(name.text).update({
        'email':email.text
      });
    }catch (e){
      print(e);
    }
  }
  delete()async{
    try{
      firebase.collection("Usuarios").doc(name.text).delete();
    }catch (e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear y eliminar registros en Flutter"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: "Nombre de Usuario",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
                )),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: email,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    )),
              ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    onPressed:(){
                      create();
                      name.clear();
                      email.clear();
                    },
                    child: Text("Crear")),
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed:(){
                      update();
                      name.clear();
                      email.clear();
                    },
                    child: Text("Actualizar")),
                ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    onPressed:(){
                      delete();
                      name.clear();
                      email.clear();
                    },
                    child: Text("Eliminar")),
                Container(
                  height: 300,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firebase.collection("Usuarios").snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context,i){

                            QueryDocumentSnapshot x = snapshot.data!.docs[i];
                            return ListTile(
                              title: Text(x['name']),
                              subtitle: Text(x['email']),
                            );
                          });
                        }else{
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                )
              ],
            )
            ],
        ),
      )
    );
  }

}
