import 'dart:async';
import 'dart:convert';
import 'package:control_pad/control_pad.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';

BuildContext scaffoldContext;

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
  final String furl;
  final String ssehir;
  ControlPage({Key key, @required this.furl, @required this.ssehir})
      : super(key: key);
}

class _ControlPageState extends State<ControlPage> {
  String url;
  int direction, lastdiretion = 0;
  Timer _milisectimer;
  Duration twentyMillis;
  static const milisec =
      const Duration(milliseconds: 100); //veri gonderme araligi

  String _status = 'Not Connected';
  var response, responseOtonom;

  double _speed = 0.0;
  bool sameDirection = false;
  bool _doesOtonom = false;
  bool _isYavas = false;
  String randomItem;
  var durumListesi = ['yavas.png', 'okul.png', 'hayvan.png'];

  String _sehir = 'anchorage';
  int _woeid;
  String _weather = 'clear';
  String lokasyonApiURL =
      'https://www.metaweather.com/api/location/search/?query=';
  String weatherApiUrl = 'https://www.metaweather.com/api/location/';
  bool havaYet = false;

  JoystickDirectionCallback onDirectionChanged(
      double degrees, double distance) {
    _getdirection(degrees, distance);
  }

  @override
  void initState() {
    _sehir = widget.ssehir;
    getSehir();
    url = 'http://${widget.furl}/';
    getInitLedState();
    _runmoved();
    super.initState();
  }

  void getSehir() async {
    var gelen = await http.get(lokasyonApiURL + _sehir);
    var veri = json.decode(gelen.body)[0];

    _sehir = veri["title"];
    _woeid = veri["woeid"];
    getHavaDurumu();
  }

  void getHavaDurumu() async {
    var gelen = await http.get(weatherApiUrl + _woeid.toString());
    var veriler = json.decode(gelen.body);
    var veri = veriler["consolidated_weather"][0];

    setState(() {
      _weather = veri["weather_state_name"].replaceAll(' ', '').toLowerCase();
      print(_weather);
      //hava verisi gelince s??r???? ekran?? g??stermek i??in true oluyor
      havaYet = true;
    });
  }

  void checkHava() { //hava durumundan dolay?? yava??lamay?? kontrol eden kod
    var havaList = ['hail', 'heavyrain', 'snow'];
    if (havaList.contains(_weather)) {
      if (_speed == 2.0) {
        setState(() {
          _speed = 1.0;
        });
      }
    }
  }

  void checkYavas() { // sinyalden dolay?? yava??lama durumunu kontrol eden kod
    if (_isYavas == true) {
      if (_speed == 2.0) {
        setState(() {
          _speed = 1.0;
        });
      }
    }
  }

  getInitLedState() async {
    try {
      response = await http.get(url, headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'Dur';
      });
    } catch (e) {
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
        });
      }
    }
  }

  void _runmoved() async {
    if (_status == 'Not Connected') {
      twentyMillis = const Duration(seconds: 1);
      new Timer(twentyMillis, () => _runmoved());
    } else {
      _milisectimer = new Timer.periodic(milisec, (Timer t) => premoved());
    }
  }

  void premoved() {
    if (direction == lastdiretion) {
      sameDirection = true;
    } else {
      sameDirection = false;
    }
    lastdiretion = direction;

    if (sameDirection == false) {
      moved();
    }
    //otonom cevap beklerken kontrol?? i??in
    else if (_doesOtonom == true) {
      moved();
    }
  }

  void moved() async {
    //yava??lama durumlar??
    checkHava();
    checkYavas();

    //ELLE KONTROL
    if (_doesOtonom == false) {
      try {
        response = await http.get(
            url +
                "update?value=" +
                "${direction.toString()}${_speed.toInt().toString()}",
            headers: {"Accept": "plain/text"});
        _status = response.body;
      } catch (e) {
        print(e);
      }
    }

    //OTONOM KONTROL
    else if (_doesOtonom == true) {
      try {
        responseOtonom =
            await http.get(url + "otonom", headers: {"Accept": "plain/text"});
        _status = responseOtonom.body;
      } catch (e) {
        print(e);
      }
      if (_status == "ELLE") {
        setState(() {
          _doesOtonom = false;
        });
      }
    }

    if (_status == "yavas") {
          randomItem = (durumListesi..shuffle()).first;
          _isYavas = true;
          Future.delayed(Duration(seconds: 2), () {
            _isYavas = false;
            print("---YAVAS KODU BITTI---");
          });
        }
  }

  // @override
  // void dispose() {
  //   _milisectimer.cancel();
  //   super.dispose();
  // }

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange, //Colors.black45,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
              tooltip: "Ba??lant??y?? Kes",
              onPressed: () {
                dispose();
                Navigator.of(context).pop();
              }),
          title: Text(
            "Kontrol Ekran??",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: !havaYet
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color(0xfffde4a9),
                      Color(0xbad1ecea),
                    ])),
                child: Center(
                  child: LoadingJumpingLine.circle(),
                ))
            : Container(
                // color: Colors.transparent,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/arkaplanlar/$_weather.png"),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceHeight / 30,
                    ),
                    _isYavas
                        ? Container(
                            padding: EdgeInsets.only(
                                bottom: deviceHeight / 30,
                                top: deviceHeight / 80),
                            child: Image(
                              image: AssetImage(
                                  (durumListesi..shuffle()).first), //randomItem
                              height: deviceHeight / 5,
                              width: deviceHeight / 5,
                            ),
                          )
                        : SizedBox(
                            height: deviceHeight / 4,
                            width: deviceHeight / 3.5,
                            child: FlareActor("assets/car.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                animation: "play"),
                          ),

                    _doesOtonom
                        ? Container(
                            width: deviceWidth,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: deviceHeight / 40,
                                ),
                                Text(
                                  'Hedefe Gidiliyor',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87),
                                ),
                                Image(
                                  image: AssetImage('otonom.gif'),
                                  height: deviceHeight / 2.4,
                                  width: deviceHeight / 2.4,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                  'Anl??k H??z: ${(_speed * 55).toInt().toString()}',
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 20, left: 20),
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      thumbColor: Colors.tealAccent[400],
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 15),
                                      // overlayColor: Colors.red
                                      activeTrackColor: Colors.orange,
                                      inactiveTrackColor: Colors.black38,
                                      trackHeight: 15.0,
                                      // showValueIndicator: ShowValueIndicator.onlyForDiscrete
                                    ),
                                    child: Slider(
                                      value: _speed,
                                      min: 0,
                                      max: 2,
                                      label: (_speed * 55).toInt().toString(),
                                      onChanged: (newvalue) {
                                        setState(() => _speed =
                                            newvalue); //_speed de??i??tirmek i??in slider da
                                      },
                                      divisions: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight / 30,
                                ),
                                JoystickView(
                                  onDirectionChanged: onDirectionChanged,
                                  backgroundColor: Colors.black54,
                                  innerCircleColor: Colors.tealAccent[400],
                                  size: deviceHeight / 4,
                                  // interval: Duration(milliseconds: 10),
                                ),
                                SizedBox(
                                  height: deviceHeight / 15,
                                ),
                              ]),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _doesOtonom ? Colors.red : Colors.blue,
                          padding: EdgeInsets.fromLTRB(80, 14, 80, 14),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          _doesOtonom ? "DUR" : "OTONOM",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight
                                  .bold), // minWidth: deviceWidth - 40,
                        ),
                        onPressed: () {
                          if (_doesOtonom == false) {
                            setState(() {
                              _doesOtonom = true;
                              _speed = 2.0;
                            });
                          } else if (_doesOtonom == true) {
                            moved();
                            setState(() {
                              _doesOtonom = false;
                            });
                          }
                        }),
                  ],
                ),
              ));
  }

  void _getdirection(double deg, double dis) async {
    int val;
    if (dis < 0.25 || deg == 0) {
      val = 0;
    }
    // else if (deg == 0) {
    //   val = 0; //"dur";
    // }
    else if (deg <= 45 || deg >= 315) {
      val = 1; //"ileri";
    } else if (deg >= 225) {
      val = 2; //"sol";
    } else if (deg >= 135) {
      val = 3; //"geri";
    } else if (deg >= 45) {
      val = 4; //"sag";
    } else {
      val = 0; //"dur";
    }
    direction = val;
  }
}
