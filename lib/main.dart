import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  runApp(const MyApp());

}

Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  await DesktopWindow.setWindowSize(const Size(700, 850));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ETA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(title: 'ETA Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Declare the controllers for the text fields
  final currentTimeController = TextEditingController();
  final delayController = TextEditingController();
  final etaController = TextEditingController();

// Declare a function to calculate the ETA
  void calculateETA() {
// Get the input values from the text fields
    String currentTime = currentTimeController.text;
    String delay = delayController.text;

// Check if the input values are valid
    if (currentTime.isNotEmpty && delay.isNotEmpty) {
// Parse the input values as TimeOfDay and Duration objects
      TimeOfDay current =
          TimeOfDay.fromDateTime(DateTime.parse('2023-11-23 $currentTime:00'));
      Duration late = Duration(minutes: int.parse(delay));

// Add the delay to the current time to get the ETA
      TimeOfDay eta = current.replacing(
          hour: (current.hour +
                  late.inHours +
                  (current.minute + late.inMinutes) ~/ 60) %
              24,
          minute: (current.minute + late.inMinutes) % 60);

// Format the ETA as a string
      String etaString = eta.format(context);

// Display the ETA in the third text field
      setState(() {
        etaController.text = etaString;
      });
    } else {
// Display an error message if the input values are invalid
      setState(() {
        etaController.text = 'Please enter STOP TIME IN MILITARY TIME';
      });
    }
  }

// Declare a function to clear the form
  void clearForm() {
// Clear the text fields
    setState(() {
      currentTimeController.clear();
      delayController.clear();
      etaController.clear();
      testWindowFunctions();
    });
  }

  @override
  Widget build(BuildContext context) {

    // Url Launcher here
    final Uri _url = Uri.parse('https://github.com/tlaw22/bus_eta');
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }
    // End Url Launcher
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            "ETA to Stop",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          elevation: 0.3,
          leading: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(12)),
              child: Image.asset("lib/assets/images/logo.png")),
          actions: [
            Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(12)),
                child: Image.asset("lib/assets/images/logo.png")),

          ]),
      body: Container(padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/assets/images/stop-sign.png", height: 100.0),
                  Expanded(
                    child: const Text("Enter stop times using 4 digits",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
        // Create a text field for the current time
              const SizedBox(
                height: 25,
              ),
              TextField(
                maxLength: 5,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                controller: currentTimeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Military Time IE: 1PM = 13:00 / 5AM = 05:00',
                    labelText: 'Enter the stop time (HH:MM)',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.black45),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
              const SizedBox(height: 3),
        // Create a text field for the delay
              TextField(
                maxLength: 3,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                controller: delayController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the delay in minutes',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.black45),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ),
              const SizedBox(height: 10),
        // Create a text field for the ETA
              TextField(
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    backgroundColor: Colors.black45),
                controller: etaController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your ETA is:',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.black45),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                readOnly: true,
              ),
              const SizedBox(height: 10),
        // Create a row of buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
        // Create a button to calculate the ETA
                  ElevatedButton(
                    onPressed: calculateETA,
                    child: const Text('Calculate'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                  const SizedBox(width: 10),
        // Create a button to clear the form
                  ElevatedButton(
                    onPressed: () {
                      clearForm();
                      Clipboard.setData(
                          ClipboardData(text: etaController.text.toString()));
                      AnimatedSnackBar.rectangle(
                        'Success',
                        'The form has been cleared!',
                        type: AnimatedSnackBarType.success,
                        brightness: Brightness.dark,
                      ).show(context);
                    },
                    child: const Text('Clear'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                  const SizedBox(width: 10),
        // Create a button to clear the form
                  ElevatedButton(
                      child: const Text('Time Chart'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => buildBottomSheet(context),
                        );
                      }),
                  const SizedBox(width: 10),
        // insert iconbutton
                GestureDetector(child: Image.asset("lib/assets/images/github.jpg", height: 25,),
                onTap: _launchUrl),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
// Begin bottomSheet Class
  Widget buildBottomSheet(BuildContext contest) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
      ),
      child: Container(
        height: 700,
        padding: EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Image.asset("lib/assets/images/time-table2.png"),
        ]),
      ),
    );
  }
}
