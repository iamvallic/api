import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'VideoPrivet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<List<Category>> _getCategories() async {
    var data = await http.get("http://my-json-server.typicode.com/iamvallic/api/get-categoty-list");
    
    var jsonData = jsonDecode(data.body);
    List<Category> categories = [];

    for (var i in jsonData){
      Category category = Category(i["id"], i["category"]);
      categories.add(category);
    }
    print(categories.length);
    return categories;
  }

  Future<List<Author>> _getAuthors() async {

    var data = await http.get("http://my-json-server.typicode.com/iamvallic/api/authors");
    var jsonData = json.decode(data.body);
    List<Author> authors = [];

    for(var u in jsonData){
      Author author = Author(u["id"], u["name"], u["order_price"], u["photo"], u["social_instagram"], u["status"]);
      authors.add(author);
    }
    //print(authors.length);
    return authors;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SafeArea(
      
        child:
          FutureBuilder(
            future: _getCategories(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              print(snapshot.data);  //TEst purpose
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading...")
                  )
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: Text(snapshot.data[index].category),
                          trailing: 
                          IconButton(
                            icon: Icon(Icons.filter_list),
                            color: Colors.black,
                            onPressed: () {
                              print("Хватит тыкать на все подряд!");
                            },
                          ),
                        ),

                        Container(
                          constraints: BoxConstraints(maxHeight: 151),
                          child: FutureBuilder(
                            future: _getAuthors(),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              print(snapshot.data);
                              if(snapshot.data == null){
                                return Container(
                                  child: Center(
                                    child: Text("Loading...")
                                  )
                                );
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                          //      constraints: BoxConstraints(maxHeight: 200),
                                width: 150,
                                height: 150,
                                    child: Stack(
                                      children: <Widget>[
                                        Image.network(
                                          snapshot.data[index].photo
                                        ),
                                        Text(snapshot.data[index].name),
                                      ],
                                    ),
                                
                                 // onTap: (){

                        //Navigator.push(context, 
                        //  new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                        //);

                      //},
                    );
                  },
                );
              }
            },
          ),
        )

                    ],
                    );
                        
                    
                  },
                );
              }
            }
          ),
        
      // ],
      )
    );
  }
}

class DetailPage extends StatelessWidget {

  final Author author;

  DetailPage(this.author);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(author.name),
        ),
        body: Column(
          children: <Widget>[
            Text(author.name),
            Text(author.social_instagram),
            Text("Стоимость заказа видеопривета - '$author.order_price' руб"),
          ],)
    );
  }
}

class Category {
  final int id;
  final String category;
Category(this.id, this.category);
}

class Author {
  final int id;
  final String name;
  final int order_price;
  final String photo;
  final String social_instagram;
  final int status;
  Author(this.id, this.name, this.order_price, this.photo, this.social_instagram, this.status);
  //Author(this.index, this.about, this.name, this.email, this.picture);

}