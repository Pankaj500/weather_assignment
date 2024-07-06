import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_assignment/controllers/weather_controller.dart';

final isloadingprovider = StateProvider((ref) => false);

final refreshstring = StateProvider((ref) => "");

class WeatherDetails extends ConsumerWidget {
  WeatherDetails({super.key});

  final WeatherController _weatherController = WeatherController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final data = ref.watch(weatherprovider);
    var isloading = ref.watch(isloadingprovider);
    var refstring = ref.watch(refreshstring);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
        backgroundColor: Colors.amberAccent,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.03,
                  right: width * .03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${data.location!.name}',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${data.location!.region},${data.location!.country}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${data.location!.localtime}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Image.network(
                      'https:${data.current!.condition!.icon}',
                      scale: 0.4,
                    ),
                    Text(
                      '${data.current!.condition!.text}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      '${data.current!.tempC}ºc',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      height: height * 0.25,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${data.current!.humidity}%',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Humidity',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${data.current!.cloud}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Cloud',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${data.current!.windKph}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Wind Speed(Kph)',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${data.current!.windDegree}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Wind Degree',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _weatherController.weatherdata(ref, refstring, context);
                      },
                      child: const Text('Refresh'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
