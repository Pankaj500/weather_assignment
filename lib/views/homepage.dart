import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_assignment/controllers/weather_controller.dart';
import 'package:weather_assignment/views/weather_details.dart';

final isloadinghome = StateProvider((ref) => false);

final savedcityprovider = StateNotifierProvider<SavedCityProvider, String>(
    (ref) => SavedCityProvider());

class SavedCityProvider extends StateNotifier<String> {
  SavedCityProvider() : super('') {
    getsavecity();
  }
  Future<void> getsavecity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    state = pref.getString('last_search_city') ?? '';
  }

  Future<void> savecity(String city) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('last_search_city', city);
    state = city;
  }
}

class Homepage extends ConsumerWidget {
  Homepage({super.key});

  final WeatherController _weatherController = WeatherController();
  final TextEditingController textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final savedCity = ref.watch(savedcityprovider);
    final data = ref.watch(weatherprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.03,
            top: height * 0.4,
          ),
          child: Column(
            children: [
              SizedBox(
                width: width,
                child: SearchBar(
                  controller: textcontroller,
                  hintText: savedCity.isEmpty
                      ? 'enter a city'
                      : 'last search city $savedCity',
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textcontroller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter any city first'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    if (await _weatherController.weatherdata(
                            ref, textcontroller.text, context) ==
                        false) {
                      print('some error occured');
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherDetails(),
                        ),
                      );
                      await _weatherController.weatherdata(
                          ref, textcontroller.text, context);
                      ref
                          .read(savedcityprovider.notifier)
                          .savecity(textcontroller.text);
                      ref.read(refreshstring.notifier).state =
                          textcontroller.text;
                    }
                  }
                },
                child: isloadinghome == true
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Get Weather Details',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
