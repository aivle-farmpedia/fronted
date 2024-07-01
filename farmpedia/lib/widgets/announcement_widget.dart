import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final String sunrise;
  final String sunset;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: _translateCityName(json['name']),
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
          .toLocal()
          .toString()
          .split(' ')[1]
          .split('.')[0],
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
          .toLocal()
          .toString()
          .split(' ')[1]
          .split('.')[0],
    );
  }

  static String _translateCityName(String cityName) {
    switch (cityName) {
      case 'Seoul':
        return '서울';
      case 'Busan':
        return '부산';
      case 'Incheon':
        return '인천';
      case 'Daegu':
        return '대구';
      case 'Daejeon':
        return '대전';
      case 'Gwangju':
        return '광주';
      case 'Suwon':
        return '수원';
      default:
        return cityName;
    }
  }
}

class WeeklyWeatherData {
  final String cityName;
  final List<DailyWeatherData> dailyWeather;

  WeeklyWeatherData({
    required this.cityName,
    required this.dailyWeather,
  });

  factory WeeklyWeatherData.fromJson(Map<String, dynamic> json) {
    var list = json['list'] as List;
    Map<String, List<DailyWeatherData>> dailyWeatherMap = {};

    for (var item in list) {
      var dailyWeather = DailyWeatherData.fromJson(item);
      String dateKey = DateFormat('yyyy-MM-dd').format(dailyWeather.date);
      if (dailyWeatherMap.containsKey(dateKey)) {
        dailyWeatherMap[dateKey]!.add(dailyWeather);
      } else {
        dailyWeatherMap[dateKey] = [dailyWeather];
      }
    }

    List<DailyWeatherData> dailyWeatherList = dailyWeatherMap.entries.map((entry) {
      double avgTemp = entry.value.map((e) => e.temperature).reduce((a, b) => a + b) / entry.value.length;
      return DailyWeatherData(
        date: entry.value[0].date,
        temperature: avgTemp,
        description: entry.value[0].description,
        icon: entry.value[0].icon,
      );
    }).toList();

    // 최대 7일의 데이터를 가져오도록 수정
    if (dailyWeatherList.length > 7) {
      dailyWeatherList = dailyWeatherList.sublist(0, 7);
    }

    return WeeklyWeatherData(
      cityName: _translateCityName(json['city']['name']),
      dailyWeather: dailyWeatherList,
    );
  }

  static String _translateCityName(String cityName) {
    switch (cityName) {
      case 'Seoul':
        return '서울';
      case 'Busan':
        return '부산';
      case 'Incheon':
        return '인천';
      case 'Daegu':
        return '대구';
      case 'Daejeon':
        return '대전';
      case 'Gwangju':
        return '광주';
      case 'Suwon':
        return '수원';
      default:
        return cityName;
    }
  }
}

class DailyWeatherData {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  DailyWeatherData({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory DailyWeatherData.fromJson(Map<String, dynamic> json) {
    return DailyWeatherData(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class AnnouncementWidget extends StatefulWidget {
  const AnnouncementWidget({super.key});

  @override
  _AnnouncementWidgetState createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  late Future<WeeklyWeatherData> futureWeeklyWeatherData;
  late VideoPlayerController videoPlayerController;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    futureWeeklyWeatherData = fetchWeeklyWeatherData();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.asset('video/sky.mp4')
      ..initialize().then((_) {
        setState(() {
          isVideoInitialized = true;
          videoPlayerController.play();
          videoPlayerController.setLooping(true);
        });
      });
  }

  Future<WeeklyWeatherData> fetchWeeklyWeatherData() async {
    Position position = await _determinePosition();
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=234aa1794618bbb93a907bda8e70884d&units=metric&lang=kr'));

    if (response.statusCode == 200) {
      return WeeklyWeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('날씨 데이터를 불러오는데 실패했습니다: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한이 영구적으로 거부되었습니다.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isVideoInitialized)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoPlayerController.value.size.width,
                height: videoPlayerController.value.size.height,
                child: VideoPlayer(videoPlayerController),
              ),
            ),
          ),
        FutureBuilder<WeeklyWeatherData>(
          future: futureWeeklyWeatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('날씨 데이터를 불러오는데 실패했습니다: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('날씨 데이터가 없습니다.'));
            } else {
              final weeklyWeatherData = snapshot.data!;
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        if (isVideoInitialized)
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: videoPlayerController.value.size.width,
                                height: videoPlayerController.value.size.height,
                                child: VideoPlayer(videoPlayerController),
                              ),
                            ),
                          ),
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  weeklyWeatherData.cityName,
                                  style: const TextStyle(
                                    fontFamily: 'GmarketSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color(0xff1D3557),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: weeklyWeatherData.dailyWeather.length,
                                  itemBuilder: (context, index) {
                                    final dailyWeather = weeklyWeatherData.dailyWeather[index];
                                    return Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${dailyWeather.date.month}/${dailyWeather.date.day}',
                                            style: const TextStyle(
                                              fontFamily: 'GmarketSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xff1D3557),
                                            ),
                                          ),
                                          Image.network(
                                            'http://openweathermap.org/img/wn/${dailyWeather.icon}@2x.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            '${dailyWeather.temperature.toStringAsFixed(2)}°C',
                                            style: const TextStyle(
                                              fontFamily: 'GmarketSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xff1D3557),
                                            ),
                                          ),
                                          Text(
                                            dailyWeather.description,
                                            style: const TextStyle(
                                              fontFamily: 'GmarketSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xff1D3557),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}