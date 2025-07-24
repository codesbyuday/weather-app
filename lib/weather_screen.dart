import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/weather_api.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget{
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController searchController = TextEditingController();
  String cityName = 'Mumbai';
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try{
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'),
      );
      final data = jsonDecode(res.body);
      if(data['cod'] != '200'){
        throw "Unable to find a data ERROR OCCURED!";
      }
      return data;
    }
    catch(err){
      throw err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    appBar: AppBar(
      title: const Text("Weather App", style: TextStyle(fontWeight: FontWeight.bold,
        fontSize: 28
      ),
      ),
      centerTitle: true,
      actions: [
        IconButton(onPressed: (){
          setState(() {});
        }, icon: const Icon(Icons.refresh))
      ],
    ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 12),
                  const Text(
                    'Some error occurred.\nPlease check your internet or try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {}); // Retry the FutureBuilder
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = ((currentWeatherData['main']['temp'] - 273.15).toString()).substring(0,4);
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final country_Name = data['city']['country'];
          
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0x2230cfd0),
                  Color(0x37330867)
                ])
            ),
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white10,
                              hintText: "Enter the City Name",
                              prefixIcon: IconButton(onPressed: (){
                                if((searchController.text).replaceAll(" ", "") == ""){
                                  return;
                                }
                                else if(searchController.text != ""){
                                  setState(() {
                                    cityName = searchController.text;
                                  });
                                }
                              }, icon: Icon(Icons.search, size: 30)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                  
                              )
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.location_on_outlined),
                              const SizedBox(width: 6,),
                              Text('$cityName , $country_Name', style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //main
                        SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: Colors.black.withValues(alpha: 0.5),
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                  
                                    child: Column(
                                      children: [
                                         Text("$currentTemp °C", style: TextStyle(fontSize: 20,)
                                        ),
                                        SizedBox(height: 14),
                                        Icon(
                                          currentSky == 'Clouds'
                                              ? Icons.cloud : currentSky == 'Rain'
                                               ? Icons.cloudy_snowing : Icons.sunny, size: 60,
                                        ),
                                        SizedBox(height: 8),
                                        Text("$currentSky", style: TextStyle(fontSize: 20),)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ),
                         const SizedBox(height: 15),
                          const Text("Weather Forecasting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 12),
                                  
                          SizedBox(
                            height: 120,
                            child: ListView.builder(itemCount: 9,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index){
                              final forecastWeather = data['list'][index+1];
                              final time = DateTime.parse(forecastWeather['dt_txt']);
                                  return HourlyForecastItem(
                                      time: DateFormat.j().format(time),
                                      temperature: ((forecastWeather['main']['temp'] - 273.15).toString()).substring(0,4),
                                      icon: forecastWeather['weather'][0]['main'] == 'Clouds'
                                          ? Icons.cloud : currentSky == 'Rain'
                                          ? Icons.cloudy_snowing : Icons.sunny
                                  );
                            }
                            ),
                          ),
                          SizedBox(height: 15),
                          Text("Additional Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdditionalInfoItem(icon: Icons.water_drop, label: 'Humidity', value: currentHumidity.toString()),
                              AdditionalInfoItem(icon: Icons.air, label: 'Wind Speed', value: currentWindSpeed.toString()),
                              AdditionalInfoItem(icon: Icons.beach_access, label: 'Pressure', value: currentPressure.toString())
                            ],
                          )
                        ],
                      ),
                    ),
            
                    ),
                  
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 45),
                      child: Row(
                        children: [
                          Icon(Icons.copyright),
                          SizedBox(width: 6,),
                          Text("App Made by Uday Gupta"),
                        ],
                      )
                  ),
                )
              ],
            ),
          );
      },
      ),
    );
  }
}