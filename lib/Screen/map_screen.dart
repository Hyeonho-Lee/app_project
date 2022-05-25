import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:app_project/Screen/home_screen.dart';
import 'package:app_project/Screen/profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  var response;
  List? all_event;
  late int _currentPageIndex;

  Completer<GoogleMapController> _controller = Completer();

  String country='';
  String locality='';
  String postalCode='';

  Position? position;

  List<Marker> _marker = [];

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
    _currentPageIndex = 1;

    position = null;

    getLocation();
    getJSONDate("progress");
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
    print("//////////////////////////////////");
    print(position!.latitude);
    print(position!.longitude);
    print("//////////////////////////////////");
    print(placemarks.toString());
    setState(() {
      //country = placemarks[0].country == null? "": placemarks[0].country!;
      //locality = placemarks[0].locality == null? "": placemarks[0].locality!;
      //postalCode = placemarks[0].postalCode == null? "": placemarks[0].postalCode!;
      // print(placemarks[0].toString());
    });
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        //child: SvgPicture.asset("/image/${iconName}_off.svg", width: 22),
      )
    );
 }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //설정 하지않으면 아이콘 누를경우 위로 올라감.
      onTap: (int index) {
        print(index);
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      selectedFontSize: 12,
      selectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("location", "지도"),
        _bottomNavigationBarItem("notes", "캘린더"),
        _bottomNavigationBarItem("chat", "커뮤니티"),
        _bottomNavigationBarItem("user", "설정"),
      ],
    );
  }

  Widget main() {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(position!.latitude, position!.longitude),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(_marker)
    );

    /*floatingActionButton: FloatingActionButton(
      onPressed: _goToTheLake,
      child: Icon(Icons.add)
    );*/
  }

  @override
  Widget build(BuildContext context) {

    Widget _bodyWidget() {
      switch (_currentPageIndex) {
        case 0:
          return HomeScreen();
          break;
        case 1:
          return main();
          break;
        case 2:
          return Container();
          break;
        case 3:
          return Container();
          break;
        case 4:
          return ProfileScreen();
          break;
      }
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyWidget(),
    );
  }

  Future getJSONDate(String value) async{
    var url;

    if (value == "new") {
      url = 'http://3.15.67.95:5050/new_event';
    }else if (value == "end") {
      url = 'http://3.15.67.95:5050/end_event';
    }else if (value == "progress") {
      url = 'http://3.15.67.95:5050/';
    }else {
      print("주소를 받아오지 못하였습니다.");
    }

    print(url);
    response = await http.get(Uri.parse(url));

    setState(() {
      if (response.statusCode == 200) {
        String text_replace = response.body;
        text_replace = text_replace.replaceAll('&#39;', '"');

        var json_decode = jsonDecode(text_replace);
        all_event = new List.empty(growable: true);
        all_event!.add(json_decode);

        //print(all_event);
        //print(all_event![0]["행사명"]['0']);
      }
    });

    if (all_event!.length != 0) {
      Marker mark_1 = Marker(
          markerId: MarkerId('1'),
          position: LatLng(all_event![0]["위도"]['3'], all_event![0]["경도"]['3']),
          infoWindow: InfoWindow(
              title: "111"
          )
      );

      Marker mark_2 = Marker(
          markerId: MarkerId('2'),
          position: LatLng(all_event![0]["위도"]['1'], all_event![0]["경도"]['1']),
          infoWindow: InfoWindow(
              title: "222"
          )
      );

      _marker.add(mark_1);
      _marker.add(mark_2);
    }
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(position!.latitude, position!.longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414
        )
    ));
  }
}