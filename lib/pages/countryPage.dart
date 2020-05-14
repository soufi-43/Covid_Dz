import 'package:covidz/pages/search.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');
    setState(() {
      countryData = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search(countryData));
            },
          )
        ],
        title: Text('Country Stats'),
      ),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    height: 130,
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                countryData[index]['country'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
                                height: 50,
                                width: 60,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'CONFIRMED:' +
                                      countryData[index]['cases'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Text(
                                  'ACTIVE:' +
                                      countryData[index]['active'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                Text(
                                  'RECOVERED:' +
                                      countryData[index]['recovered']
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                Text(
                                  'DEATHS:' +
                                      countryData[index]['deaths'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[100]
                                          : Colors.grey[900]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }
}
