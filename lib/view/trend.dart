import 'package:flutter/material.dart';
import '../trend_rss_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../webview_container.dart';

class TrendTab extends StatefulWidget {
  TrendTab(this.categoryName);
  final String categoryName;

  @override
  _TrendTabState createState() => _TrendTabState();

}

class _TrendTabState extends State<TrendTab> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: Colors.blue,
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(
                widget.categoryName,
                style: new TextStyle(color: Colors.white),
              ),
          Expanded(
          child: FutureBuilder(
                future: TrendRssService().getFeed(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    final feed = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: feed.items.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final item = feed.items[index];
                          return Container(
                              decoration: BoxDecoration(
                              border: Border(
                              bottom: BorderSide(color: Colors.black38),
                          ),
                          ),
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.links[0].toString()),
//                            subtitle: Text('公開日： ' + parseDate(item.published)),
                            contentPadding: EdgeInsets.all(8.0),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer(item
                                          .id
                                          .replaceFirst('http', 'https'))));
                            },
                          )
                          );
                        });

                  }else{
                    return Text('ng');
                  }
                }

              ),
          )

            ],
          ),
        ),
      ),
    );
  }

  parseDate(d){
    Intl.defaultLocale = 'ja_JP';
    initializeDateFormatting("ja_JP");
    DateTime parsedDate = DateTime.parse(d);
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(parsedDate);
    return formatted;
  }
}
