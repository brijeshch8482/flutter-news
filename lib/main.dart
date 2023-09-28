import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_new_app/models/artical_model.dart';
import 'package:flutter_new_app/network/network_enums.dart';
import 'package:flutter_new_app/network/network_helper.dart';
import 'package:flutter_new_app/network/network_service.dart';
import 'package:flutter_new_app/static/static_variabls.dart';
import 'package:flutter_new_app/widegts/article_widedts.dart';

import 'network/query_param.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News headline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'News headline'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder:  (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            // final json = snapshot.data;

            final List<Article> articles = snapshot.data as List<Article>;

            return ListView.builder(
                itemBuilder: (context, index){
                  return ArticleWidgets(article: articles[index],);
                },
              itemCount: articles.length,
            );
          }
          else if(snapshot.hasError){
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(height: 10,),
                  Text('Something went wrong')
                ],
              ),
            );

          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Future<List<Article>?> getData() async {

    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: StaticValues.apiUri,
      queryParam: QP.apiQP(
          apiKey: StaticValues.apiKey,
          country: StaticValues.apiCountry
      )
    );
    
    print(response?.statusCode);

    return await NetworkHelper.filterResponse(
        callBack: _listOfArticleFromJson,
        response: response,
        parameterName: CallBackParameterName.articles,
        onFailureCallbackWithMessage: (errorType, msg){

          print('Error type - $errorType - Message -> $msg');

          return null;
        }
    );

  }

  List<Article> _listOfArticleFromJson(json) => (json as List)
      .map((e) => Article.fromJson(e as Map<String, dynamic>))
      .toList();

}







