import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:agrigrow/core/constants/app_colors.dart';
import 'package:agrigrow/features/weather/presentation/providers/weather_provider.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/farm_weather_card.dart';
import 'package:agrigrow/features/dashboard/presentation/widgets/motors_list.dart';
import 'package:agrigrow/features/farm/presentation/pages/farm_list_page.dart';
import 'package:agrigrow/features/chat/presentation/pages/chat_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver {
  int _currentCarouselIndex = 0;
  int _selectedIndex = 0; // For Bottom Navigation

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Fetch weather once on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeather();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-fetch weather when app comes to foreground (e.g. from Settings)
      final weatherProvider = context.read<WeatherProvider>();
      if (weatherProvider.weather == null || weatherProvider.error != null) {
        _fetchWeather();
      }
    }
  }

  void _fetchWeather() {
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
                _fetchWeather();
              },
            ),
          ),
        );
      }
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
      const FarmListPage(),
      const ChatPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color.fromARGB(253, 251, 247, 247),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            _navItem(Icons.home, 0),
            _divider(),
            _navItem(Icons.assignment, 1),
            _divider(),
            _navItem(Icons.chat_bubble_outline, 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? AppColors.primaryGreen : Colors.grey,
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
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
      MotorItem(
        farmName: 'Palakkad',
        loraId: '25',
        schedule: '10:00am to 11:00am (daily)',
      ),
      MotorItem(
        farmName: 'Pollachi',
        loraId: '12',
        schedule: '07:00am to 08:00am (mon,wed)',
      ),
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
            ),
          ),
        ),

        SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                await context.read<WeatherProvider>().fetchWeather();
              },
              child: SingleChildScrollView(
                // Make entire page scrollable to prevent overflow
                physics: const AlwaysScrollableScrollPhysics(),
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
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'GOOD MORNING,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                'FARMER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
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
                                  date: DateFormat(
                                    'MMM d,yyyy h.mm a',
                                  ).format(DateTime.now()),
                                );
                              },
                              options: CarouselOptions(
                                height: 260,
                                // Adjust viewport fraction for smoother spacing
                                viewportFraction:
                                    MediaQuery.of(context).size.width > 600
                                    ? 0.5
                                    : 0.85,
                                enableInfiniteScroll:
                                    true, // Allow looping for auto-play
                                autoPlay: true, // Auto-play enabled
                                autoPlayInterval: const Duration(seconds: 4),
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentCarouselIndex = index;
                                  });
                                },
                              ),
                            ),
                            // Reduced bottom spacing
                            const SizedBox(height: 5),
                            // Dots Indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: farms.asMap().entries.map((entry) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(
                                      alpha: _currentCarouselIndex == entry.key
                                          ? 0.9
                                          : 0.4,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
    
                    // Motors List
                    // Using shrinkWrap: true so it fits in SingleChildScrollView
                    MotorsList(
                      motors: motors,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Let parent handle scroll
                    ),
    
                    // Add some bottom padding for better scroll experience
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
        ),
      ],
    );
  }
}
