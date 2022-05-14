import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.1429667, 129.03409),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(35.1429667, 129.03409),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
    _currentPageIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
        actions: [
          IconButton(
              onPressed: () {
                print('아이콘 클릭');
                getJSONDate("new");
              },
              icon: Icon(Icons.location_on)
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        child: Icon(Icons.add)
      ),
      //bottomNavigationBar: _bottomNavigationBarWidget(),
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
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}