import 'dart:convert';

import 'package:covidz/pages/countryPage.dart';
import 'package:covidz/panels/infoPanel.dart';
import 'package:covidz/panels/mostaffectedcountries.dart';
import 'package:covidz/panels/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:pie_chart/pie_chart.dart';

import 'datasource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = jsonDecode(response.body);
    });
  }

  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=deaths');
    setState(() {
      countryData = jsonDecode(response.body);
    });
  }


  Future fetchData()async {
    fetchCountryData();
    fetchWorldWideData();
  }

  @override
  void initState() {
    
    
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.lightbulb_outline
                : Icons.highlight),
            onPressed: () {
              DynamicTheme.of(context).setBrightness(
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light);
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          'COVID-19 TRACKER',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(18),
                color: Colors.orange[100],
                child: Text(
                  DataSource.quote,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Worldwide',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryBlack,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Regional',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? CircularProgressIndicator()
                  : WorldWidePanel(
                      worldData: worldData,
                    ),
              PieChart(dataMap:{

                'Confirmed':worldData==null? 2.5:worldData['cases'].toDouble(),
                'Active':worldData==null? 2.5:worldData['active'].toDouble(),
                'Recovered':worldData==null? 2.5:worldData['recovered'].toDouble(),
                'Deaths':worldData==null? 2.5:worldData['deaths'].toDouble(),


              },
              colorList: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.grey,
              ],),

              Text(
                'Most Affected Countries',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              countryData == null
                  ? Container()
                  : MostAffectedPanel(
                      countryData: countryData,
                    ),
              InfoPanel(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
