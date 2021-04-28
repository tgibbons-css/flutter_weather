import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'weather.dart';

void main() {
  runApp(MyApp());
  //runApp(Text("Hello World"));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Daily> dailyForcast = [];

  Future<List<Daily>> _getListItems() async {
    String openWeatherStr = "https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=hourly,current,minutely,alerts&units=imperial&appid=b15632ec4a9f1a874aeb15b3e22c4503";
    Uri url = Uri.parse(openWeatherStr);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      Weather allWeather = weatherFromJson(response.body);
      List<Daily> dailyForcast = allWeather.daily;
      return dailyForcast;
    } else {
      print("HTTP Error with code ${response.statusCode}");
      return dailyForcast;
    }
  }

  @override
  initState() {
    super.initState();
    _getListItems().then((newUserList) {
      setState(() {
        dailyForcast = newUserList;
      });
    });
  }

  final _imageMap = {
    "Clear": 'graphics/sun.png',
    "Clouds": 'graphics/cloud.png',
    "Drizzle": 'graphics/light_rain.png',
    "Thunderstorm": 'graphics/rain.png',
    "Clouds": 'graphics/cloud.png',
    "Rain": 'graphics/snow.png'};

  Widget weatherIcon(String weatherDescription) {
    return Image(image: AssetImage(_imageMap[weatherDescription]));
    if (weatherDescription == "Clear")  {
      return Image(image: AssetImage('graphics/sun.png'));
    } else {
      return Image(image: AssetImage('graphics/rain.png'));
    }
  }

  Widget weatherTile (int position) {
    print ("Inside weatherTile and setting up tile for positon ${position}");
    String hiTemp = dailyForcast[position].temp.max.toString();
    String lowTemp = dailyForcast[position].temp.min.toString();
    return ListTile(
      leading: weatherIcon(dailyForcast[position].weather[0].main),
      title: Text("High of $hiTemp and Low of $lowTemp"),
      subtitle: Text(dailyForcast[position].weather[0].description),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: dailyForcast.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              child: weatherTile(position),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}