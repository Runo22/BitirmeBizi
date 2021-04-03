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

      print('Printing the login data.');
      print('Email: ${_data.ip}');
      print('Password: ${_data.port}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 250, left: 45, right: 45),
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
                TextFormField(
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
                  height: 20,
                ),
                TextFormField(
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
                  height: 90,
                ),
                ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        // side: BorderSide(color: Colors.red)
                        ),
                    height: 60,
                    minWidth: 180,
                    child: RaisedButton(
                      child: Text(
                        "BAĞLAN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => this.submit(),
                    )),
              ],
            )),
      ),
    );

    // return new Scaffold(
    //   // backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
    //   appBar: new AppBar(
    //     // backgroundColor: Colors.black45,
    //     title: new Text('Login'),
    //     centerTitle: true,
    //   ),
    //   body: new Container(
    //       padding: new EdgeInsets.all(20.0),
    //       child: new Form(
    //         key: this._formKey,
    //         child: new ListView(
    //           children: <Widget>[
    //             new SizedBox(
    //               height: 80,
    //             ),
    //             new TextFormField(
    //                 keyboardType: TextInputType.number,
    //                 decoration: new InputDecoration(
    //                     hintText: '192.168.1.2', labelText: 'Ip Adres'),
    //                 validator: this._validateIP,
    //                 onSaved: (String value) {
    //                   this._data.ip = value;
    //                   print(_data.ip + ":" + _data.port);
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (BuildContext context) => ControlPage(
    //                                 furl: this._data.ip + ":" + this._data.port,
    //                               )));
    //                 }),
    //             new TextFormField(
    //                 keyboardType: TextInputType.number,
    //                 decoration: new InputDecoration(
    //                     hintText: '80', labelText: 'Host numrası'),
    //                 validator: this._validatePort,
    //                 onSaved: (String value) {
    //                   this._data.port = value;
    //                 }),
    //             new SizedBox(
    //               height: 40,
    //             ),
    //             new FloatingActionButton(
    //               child: new Icon(Icons.navigate_next),
    //               onPressed: this.submit,
    //             )
    //           ],
    //         ),
    //       )),
    // );
  }
}
