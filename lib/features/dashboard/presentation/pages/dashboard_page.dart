import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/features/weather/presentation/providers/weather_provider.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/farm_weather_card.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/motors_list.dart';
import 'package:agrigrow/features/dashboard/presentation/pages/farm_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentCarouselIndex = 0;
  int _selectedIndex = 0; // For Bottom Navigation

  @override
  void initState() {
    super.initState();
    // Fetch weather once on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = context.read<WeatherProvider>();
      weatherProvider.fetchWeather().then((_) {
        if (weatherProvider.error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(weatherProvider.error!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                   weatherProvider.fetchWeather();
                },
              ),
            ),
          );
        }
      });
    });
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of Pages for Bottom Nav
    final List<Widget> pages = [
      _buildHomeContent(),
      const FarmListPage(), // Navigate to Farm List (Tasks)
      const Center(child: Text("Chat - Coming Soon")),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 30), label: 'Tasks'), // Assignment icon works for Farm List
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline, size: 30), label: 'Chat'),
          ],
      ),
    );
  }

  // Extracted Home Content to keep build method clean
  Widget _buildHomeContent() {
    // Mock Data for Farms
    final List<Map<String, String>> farms = [
      {'name': 'Palakkad, Kerala'},
      {'name': 'Pollachi, Tamil Nadu'},
      {'name': 'Coimbatore, Tamil Nadu'},
    ];

    // Mock Data for Motors
    final motors = [
      MotorItem(farmName: 'Palakkad', loraId: '25', schedule: '10:00am to 11:00am (daily)'),
      MotorItem(farmName: 'Pollachi', loraId: '12', schedule: '07:00am to 08:00am (mon,wed)'),
    ];

    return Stack(
        children: [
            // Top Green Background
            Container(
                height: 300,
                decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                    )
                ),
            ),
            
            SafeArea(
                child: Column(
                    children: [
                        // Header
                        Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                children: [
                                    const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white24,
                                        child: Icon(Icons.person, color: Colors.white, size: 30),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            const Text('GOOD MORNING,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                            const Text('FARMER', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                                        onPressed: () {},
                                    )
                                ],
                            ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Carousel
                        Consumer<WeatherProvider>(
                            builder: (context, weatherProvider, child) {
                                return Column(
                                    children: [
                                        CarouselSlider.builder(
                                            itemCount: farms.length,
                                            itemBuilder: (context, index, realIndex) {
                                                return FarmWeatherCard(
                                                    weather: weatherProvider.weather,
                                                    farmName: farms[index]['name']!,
                                                    date: DateFormat('MMM d,yyyy h.mm a').format(DateTime.now()),
                                                );
                                            },
                                            options: CarouselOptions(
                                                height: 320,
                                                viewportFraction: 0.85,
                                                enableInfiniteScroll: false,
                                                enlargeCenterPage: true,
                                                onPageChanged: (index, reason) {
                                                    setState(() {
                                                        _currentCarouselIndex = index;
                                                    });
                                                },
                                            ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Dots Indicator
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: farms.asMap().entries.map((entry) {
                                                return Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black.withValues(alpha: _currentCarouselIndex == entry.key ? 0.9 : 0.4),
                                                    ),
                                                );
                                            }).toList(),
                                        ),
                                    ],
                                );
                            },
                        ),
                        
                        // Motors List
                        Expanded(
                            child: SingleChildScrollView(
                                child: MotorsList(motors: motors),
                            ),
                        ),
                    ],
                ),
            ),
        ],
      );
  }
}
