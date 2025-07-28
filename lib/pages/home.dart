import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:smarthome_app_ui/constants.dart';
import 'package:smarthome_app_ui/models/models.dart';
import 'package:smarthome_app_ui/pages/profile.dart';
import 'package:smarthome_app_ui/pages/room_detail.dart';
import 'package:smarthome_app_ui/services/rooms.dart';
import 'package:smarthome_app_ui/services/devices.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Rooms? selectedRoom;
  List<Devices> selectedDevice = <Devices>[];

  // Music player instance and state
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isMusicPlaying = false;

  @override
  void initState() {
    selectedRoom = rooms[0];
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appBgcolor,
      appBar: AppBar(
        backgroundColor: appBgcolor,
        elevation: 0.0,
        title: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const Profile(),
              ),
            );
          },
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              "assets/image/people/p1.jpg",
              height: 40,
            ),
          ),
        ),
        actions: <Widget>[
          Image.asset(
            "assets/image/menu.png",
            height: 35,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Hello, Ashu",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white,
                  fontSize: 24,
                ),
              ),
              const Text(
                "Good to see you again!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: lightWhite,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 30),
              roomWidget(),
              const SizedBox(height: 30),
              imageSlider(),
              const SizedBox(height: 30),
              const Text(
                "Devices",
                style: TextStyle(
                  color: white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                ),
                itemCount: deviceList.length,
                itemBuilder: (BuildContext context, int index) {
                  final Devices device = deviceList[index];
                  final bool isTurnedOn = selectedDevice.contains(device);

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // Pehle normal toggle logic
                          if (isTurnedOn) {
                            selectedDevice.remove(device);
                          } else {
                            selectedDevice.add(device);
                          }

                          // Agar ye 'Music' device hai, to music play/pause
                          if (device.title == "Music") {
                            if (isTurnedOn) {
                              // Agar already ON tha, ab OFF ho raha hai => pause
                              _audioPlayer.pause();
                              isMusicPlaying = false;
                            } else {
                              // Agar abhi OFF tha, ab ON ho raha hai => play
                              _audioPlayer.play(AssetSource('audio/song.mp3'));
                              isMusicPlaying = true;
                            }
                          }

                          // Agar ye 'Router' device hai, to snack bar dikhaye
                          if (device.title == "Router") {
                            if (isTurnedOn) {
                              // Ab OFF ho raha hai => Wifi band ho gaya
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Aapka Wifi band ho gaya hai"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              // Ab ON ho raha hai => Wifi chaloo ho gaya
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Aapka Wifi chaloo ho gaya hai"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              isTurnedOn
                                  ? device.logoPathIfOn
                                  : device.logoPathIfOff,
                              height: 30,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              device.title,
                              style: const TextStyle(
                                color: white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                "Family Members",
                style: TextStyle(
                  color: white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              familyMember(
                "assets/image/people/p1.jpg",
                "Himanshu",
                true,
                mediaQuery,
              ),
              familyMember(
                "assets/image/people/p2.jpg",
                "Shivam",
                false,
                mediaQuery,
              ),
              familyMember(
                "assets/image/people/p1.jpg",
                "Aman",
                true,
                mediaQuery,
              ),
              familyMember(
                "assets/image/people/p2.jpg",
                "Ravi",
                true,
                mediaQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget familyMember(
    String imagePath,
    String name,
    bool isPhoneConnected,
    Size mediaQuery,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: lightBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              imagePath,
              height: 40,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                    fontSize: 17,
                  ),
                ),
                Text(
                  isPhoneConnected ? "Connected" : "Not Connected",
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    color: mediumWhite,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Icon(Icons.battery_2_bar_outlined),
              SizedBox(width: mediaQuery.width * 0.02),
              const Icon(Icons.link),
              SizedBox(width: mediaQuery.width * 0.02),
              Icon(
                isPhoneConnected
                    ? Icons.comment
                    : Icons.comments_disabled_rounded,
                color: isPhoneConnected ? white : lightWhite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  SingleChildScrollView imageSlider() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 300,
            width: 230,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const RoomDetail(
                      roomName: "Living Room",
                      roomCondition: "Moderate",
                      temperature: "29°C",
                      humidity: "25%",
                      light: 32,
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/image/living_room.jpg",
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                  const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ColoredBox(
                      color: Colors.black38,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Living Room",
                        style: TextStyle(
                          fontSize: 18,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 300,
            width: 230,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const RoomDetail(
                      roomName: "Kitchen",
                      roomCondition: "Moderate",
                      temperature: "27°C",
                      humidity: "23%",
                      light: 30,
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/image/kitchen.jpg",
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                  const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ColoredBox(
                      color: Colors.black38,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Kitchen",
                        style: TextStyle(
                          fontSize: 18,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 300,
            width: 230,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const RoomDetail(
                      roomName: "Guest Room",
                      roomCondition: "Bad",
                      temperature: "42°C",
                      humidity: "53%",
                      light: 16,
                    ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/image/guest_room.jpg",
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                  const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ColoredBox(
                      color: Colors.black38,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Guest Room",
                        style: TextStyle(
                          fontSize: 18,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox roomWidget() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: rooms.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedRoom = rooms[index];
              });
            },
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: selectedRoom == rooms[index] ? themeColor : lightBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                child: Image.asset(
                  rooms[index].logoPath,
                  fit: BoxFit.cover,
                  height: 25,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
