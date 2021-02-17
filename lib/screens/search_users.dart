import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/user.dart';

import 'chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchUser extends StatefulWidget {
  static const routeName = "/search-user";

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  var searchField = TextEditingController();
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  Algolia algolia;
  var db = FirebaseFirestore.instance;
  var isLoading = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    AlgoliaQuery query = algolia.instance.index('stocklot_users');
    query = query.search(searchField.text.trim());
    print(query);
    var objects = await query.getObjects();
    _results = objects.hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  void initState() {
    algolia = Algolia.init(
      applicationId: 'LZKX0WD9CY',
      apiKey: '1eb28c1524592cdd52247c83ea61d54b',
    );
    super.initState();
  }

  @override
  void dispose() {
    searchField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: searchField,
                    // autofocus: true,
                    onChanged: (text) {
                      if (text.trim().length > 1) _search();
                    },
                    decoration: InputDecoration(hintText: "Enter user name..."),
                  ),
                  Expanded(
                    child: _searching == true
                        ? Center(
                            child: Text("Searching, please wait..."),
                          )
                        : _results.length == 0
                            ? Center(
                                child: Text("No results found."),
                              )
                            : ListView.builder(
                                itemCount: _results.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  AlgoliaObjectSnapshot snap = _results[index];

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage:
                                          snap.data["dp"] != null &&
                                                  snap.data["dp"] != ""
                                              ? NetworkImage(snap.data["dp"])
                                              : null,
                                      child: snap.data["dp"] != null &&
                                              snap.data["dp"] != ""
                                          ? null
                                          : Text(
                                              snap.data["personName"][0],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    title: Text(snap.data["personName"]),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(snap.data["rating"].toString())
                                          ],
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                    onTap: () async {
                                      if (Provider.of<Users>(context,
                                              listen: false)
                                          .getUser
                                          .phone != snap.objectID)
                                        Navigator.of(context).pushNamed(
                                            ChatScreen.routeName,
                                            arguments: {
                                              "id": snap.objectID,
                                              "name": snap.data["personName"],
                                              "dp": snap.data["dp"],
                                            });
                                      else Fluttertoast.showToast(msg: "It's you!");
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}
