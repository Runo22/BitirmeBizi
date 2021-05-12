import 'package:esp_control/pages/control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ConnectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ConnectPageState();
}

class IPData {
  String ip = '';
  String port = '';
}

class _ConnectPageState extends State<ConnectPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  IPData _data = new IPData();

  TextEditingController _ipController;
  TextEditingController _hostController;
  double deviceHeight;

  @override //Gereksiz Silinebilir
  void initState() {
    _ipController = new TextEditingController(text: '192.168.1.200');
    _hostController = new TextEditingController(text: '80');
    super.initState();
  }

  String _validateIP(String s) {
    if (s.contains(" ") || s.contains(",")) {
      return "Lütfen boşluk veya virgül kullanmayın.";
    }
    var splitted = s.split(".");
    int len = splitted.length;
    print(len.toString());
    if (len == 4) {
      for (var i = 0; i < len; i++) {
        try {
          for (var i = 0; i < len; i++) {
            var a = int.parse(splitted[i]);
            if (a > 255 || a < 0) {
              return 'Geçerli bir IP adresi girin.';
            }
          }
          return null;
        } catch (e) {
          return 'Geçerli bir IP adresi girin.';
        }
      }
    }
    return 'Geçerli bir IP adresi girin.';
  }

  String _validatePort(String value) {
    try {
      int.parse(value);
    } catch (e) {
      return 'Uygun bir Port girin';
    }
    return null;
  }

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      // print('Printing the login data.');
      // print('Email: ${_data.ip}');
      // print('Password: ${_data.port}');
      // print(deviceHeight.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      //klavye açılınca overflow olmasın diye
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: deviceHeight/6.5, left: 45, right: 45),
        // color: Colors.amber[200],
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xfffde4a9),
              Color(0xFFdfecea),
            ])),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image(
                  image: AssetImage(
                    'ytu.png',
                  ),
                  height: deviceHeight/3.7, // * change
                  width: deviceHeight/3.7,
                ),
                SizedBox(
                  height: deviceHeight/18,
                ),
                TextFormField(
                    controller: _ipController,
                    keyboardType: TextInputType.number,
                    style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: '192.168.1.2',
                      labelText: 'Ip Adresi',
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            width: 0.1,
                          )),
                    ),
                    validator: this._validateIP,
                    onSaved: (String value) {
                      this._data.ip = value;
                      print(_data.ip + ":" + _data.port);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ControlPage(
                                    furl: this._data.ip + ":" + this._data.port,
                                  )));
                    }),
                SizedBox(
                  height: deviceHeight/43,
                ),
                TextFormField(
                    controller: _hostController,
                    keyboardType: TextInputType.number,
                    style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                    decoration: new InputDecoration(
                      hintText: '80',
                      labelText: 'Host numrası',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: this._validatePort,
                    onSaved: (String value) {
                      this._data.port = value;
                    }),
                SizedBox(
                  height: deviceHeight/9.5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    "BAĞLAN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold),
                  ),
                  onPressed: () => this.submit(),
                ),
              ],
            )),
      ),
    );
  }
}
