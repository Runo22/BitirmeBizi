import 'dart:async';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

BuildContext scaffoldContext;

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
  final String furl;
  ControlPage({Key key, @required this.furl}) : super(key: key);
}

class _ControlPageState extends State<ControlPage> {
  String url;
  int direction = 0;
  Timer _milisectimer;
  Duration twentyMillis; // bunu bura ekldeim sıkıntı olabilir ?? 
  static const milisec = const Duration(milliseconds: 100);
  // var _directionController = TextEditingController();

  String _status = 'Not Connected';
  var response;

  double _speed = 0.0;
  bool zeroDirection = false;

  JoystickDirectionCallback onDirectionChanged(double degrees, double distance) {
    _getdirection(degrees, distance);
  }

  @override
  void initState() {
    url = 'http://${widget.furl}/';
    super.initState();
    getInitLedState();
    _runmoved();
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
    if(_status == 'Not Connected'){
      twentyMillis = const Duration(seconds: 1);
      new Timer(twentyMillis, () => _runmoved());
    }else{
      _milisectimer = new Timer.periodic(milisec, (Timer t) => premoved());
    }
  }

  void premoved(){  
                  //? buna gerek olmayabilir(yukarda tanımlı bool)
    if(zeroDirection == false){
      moved();
    }
    if(direction == 0){
      zeroDirection = true;
    }
    else{
      zeroDirection = false;
    }
  }

  void moved() async {
    try {
      response = await http.get(url + "update?value="+ '${direction.toString()}' + "#" +'${_speed.toInt().toString()}',
          headers: {"Accept": "plain/text"});
      //TODO
      //https://www.youtube.com/watch?v=8II1VPb-neQ&t=470s&ab_channel=PaulHalliday
      //burada setstate erkranı yeniletiyo bunu bloc kullanarak yap
      _status = response.body;

      print("Status: ${_status.toString()}");
      print("Speed: ${_speed.toInt().toString()}\nDirection: ${direction.toString()}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _milisectimer.cancel();
    super.dispose();
  }

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
              tooltip: "Bağlantıyı Kes",
              onPressed: () {
                dispose();
                Navigator.of(context).pop();
              }),
          title: Text(
            "Kontrol Ekranı",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          // color: Colors.transparent,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color(0xfffde4a9),
                Color(0xFFdfecea),
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),

              Image(
                image: AssetImage(
                  'dur.png',
                ),
                height: 130, // * change
                width: 130,
              ),

              SizedBox(
                height: 15,
              ),
              Text(
                'Anlık Hız: ${_speed.toInt().toString()}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Colors.tealAccent[400],
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                    // overlayColor: Colors.red
                    activeTrackColor: Colors.orange,
                    inactiveTrackColor: Colors.black38,
                    trackHeight: 15.0,
                    // showValueIndicator: ShowValueIndicator.onlyForDiscrete
                  ),
                  child: Slider(
                    value: _speed,
                    min: 0,
                    max: 4,
                    label: _speed.toInt().toString(),
                    onChanged: (newvalue) {
                      setState(() => _speed = newvalue); //_speed değiştirmek için slider da 
                    },
                    divisions: 4,
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              JoystickView(
                onDirectionChanged: onDirectionChanged,
                backgroundColor: Colors.black54,
                innerCircleColor: Colors.tealAccent[400],
                size: 200,
                // interval: Duration(milliseconds: 10),
              ),

              SizedBox(
                height: 40,
              ),

              ButtonTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // height: 30,
                  minWidth: deviceWidth - 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),),
                    child: Text(
                      "OTONOM",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => null, //TODO
                  )),

              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }

  void _getdirection(double deg, double dis) async{
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
