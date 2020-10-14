import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:mapa_inicial/src/views/fullscreenmap.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuntodePartida(),
    );
  }
}

class PuntodePartida extends StatefulWidget {
  @override
  _PuntodePartidaState createState() => _PuntodePartidaState();
}

class _PuntodePartidaState extends State<PuntodePartida> {
  var latitud = 0.0;
  var longitud = 0.0;

  void _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitud = position.latitude;
      print(latitud);
      longitud = position.longitude;
      print(longitud);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenMap(Lat: latitud,Lon: longitud)
        ));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bienvenido',
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(69),
          child: ClipPath(
            clipper: CustomAppBar(),
            child: Container(
              color: Color.fromRGBO(255,240,0,1),
              child: Stack(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Color.fromRGBO(255,240,0,1),
                    leading: Container(
                      padding: EdgeInsets.only(left: 25, bottom: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.menu,
                          size: 28,
                          color: Color.fromRGBO(16, 44, 84, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(),
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10.0, 30.0, 0, 20),
                      child: Text(
                        'Mis Rutas',
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(16, 44, 84, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: FullScreenMap(),

      ),
    );
  }
}


class FullScreenMap extends StatefulWidget {
  final double Lat;
  final double Lon;
  FullScreenMap({Key key,this.Lat=0,this.Lon=0}) : super(key: key);
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [

        MapboxMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.Lat,widget.Lon),
          zoom: 14,
        ),
      ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(16,44,84,1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.gps_fixed),
                          iconSize: 30,
                          color: Colors.white,
                          onPressed: (){
                            // _getCurrentLocation();
                          },
                        ),
                      ),
                    ),
                    Form(
                      // key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 10, right:10,),
                                  height: 35,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(width: 2, color: Color.fromRGBO(215,215,215,1)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Ingrese dirección',
                                    ),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(168,168,168,1),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.search,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 25),
                            child: RaisedButton(
                              onPressed: (){},
                              textColor: Color.fromRGBO(16,44,84,1),
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                width: 206,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255,240,0,1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.only(left: 71, right: 71, top: 9, bottom: 9),
                                child: Text(
                                  'Confirmar',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ) ,
    );
  }


}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);

    //  path.quadraticBezierTo(3/4 * size.width, size.height, size.width, size.height - 20) ;
    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
