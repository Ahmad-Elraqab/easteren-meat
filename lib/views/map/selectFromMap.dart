import 'dart:async';
import 'package:drivers/constants/colors.dart';
import 'package:drivers/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';


  typedef SelectFromMap = Function(double lat,double long ,String address);

class MapsDemo extends StatefulWidget {
  final SelectFromMap selectFromMap;

  const MapsDemo({Key key, this.selectFromMap}) : super(key: key);
  @override
  State createState() => MapsDemoState();
}


class MapsDemoState extends State<MapsDemo> {
  var geolocator = Geolocator();
  Position position;
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(26.40558441520493, 50.09851422160864),
    zoom: 11.0,
  );
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  StreamSubscription _getPositionSubscription;
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, timeInterval: 1000);
  GoogleMapController mapController;
  bool x = true;
  @override
  void initState() {
    super.initState();
    _getPositionSubscription = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          this.position=position;
          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
          if(x){
            x = false;
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude,position.longitude), zoom: 16.0),

              ),
            );
          }

        });
  }
  @override
  Widget build(BuildContext context) {

    return  Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: GoogleMap(
            onCameraMove: (object){
              _position = object;
//              debugPrint(object.target.toString());
            },
            onMapCreated: _onMapCreated,
            initialCameraPosition: _kInitialPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
//              options: GoogleMapOptions(
//                  myLocationEnabled: true
//              )

          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              onPressed: _getAddress,
              textColor: white,
              color: primaryColor,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                getTranslated(context, "back"),
              ),
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.center_focus_strong,
            size: 20,
          ),
        )
      ],


    );

  }

  void _onMapCreated(GoogleMapController controller) {

    mapController = controller;
//    mapController.addListener(_onMapChanged);
    _extractMapInfo();
    setState(() {

    });

  }
  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
//    _position = mapController.cameraPosition;
    print(_position.target.longitude);
//    _isMoving = mapController.isCameraMoving;
  }

  Future _getAddress() async {
//    Navigator.of(context).pop();
//return;
//    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
//     print(placemark.elementAt(0).locality);\
    print( _position.target.latitude);
    final coordinates = new Coordinates(_position.target.latitude,_position.target.longitude);


    /*ShippingTab.selectLat = _position.target.latitude.toString();
    ShippingTab.selectLong = _position.target.longitude.toString();*/
    print("lat|lng = "+_position.target.latitude.toString() +"||"+ _position.target.longitude.toString());
    print(coordinates);

//    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    if (addresses.length>0 ){
//      widget.selectFromMap(_position.target.latitude,_position.target.longitude,addresses.first.addressLine);
//
//    }else{
      widget.selectFromMap(_position.target.latitude,_position.target.longitude,"");

//    }
    Navigator.of(context).pop(true);
  }
  @override
  void dispose() {
    _getPositionSubscription.cancel();
    super.dispose();
  }

}