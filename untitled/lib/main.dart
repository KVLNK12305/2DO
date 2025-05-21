import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      themeMode: ThemeMode.system, // Automatically use dark or light based on system
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.amber,
          background: Colors.grey[50]!,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple[600]!,
          secondary: Colors.greenAccent,
          tertiary: Colors.pinkAccent,
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.greenAccent,
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            shadows: [
              Shadow(
                color: Colors.greenAccent.withOpacity(0.7),
                blurRadius: 8,
              ),
            ],
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple[800],
          foregroundColor: Colors.lightGreenAccent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash screen with animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start the animation
    _controller.forward().then((_) {
      // Navigate to home page after animation completes
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: Duration(milliseconds: 750),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '2DO',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.greenAccent : Colors.indigo,
                        shadows: isDarkMode ? [
                          Shadow(
                            color: Colors.greenAccent.withOpacity(0.7),
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          ),
                        ] : [
                          Shadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    if (_controller.value > 0.5)
                      AnimatedOpacity(
                        opacity: (_controller.value - 0.5) * 2,
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          'Get Things Done',
                          style: TextStyle(
                            fontSize: 22,
                            color: isDarkMode ? Colors.pinkAccent : Colors.amber[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Main ToDo App with Pie Chart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Task categories with counts
  final Map<String, TaskCategory> categories = {
    'Work': TaskCategory('Work', Colors.red, 5),
    'Personal': TaskCategory('Personal', Colors.blue, 3),
    'Shopping': TaskCategory('Shopping', Colors.green, 2),
    'Health': TaskCategory('Health', Colors.orange, 4),
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '2DO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: isDarkMode ? 8 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isDarkMode ? 16 : 12),
                side: isDarkMode ? BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1) : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Overview',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 250,
                      child: Row(
                        children: [
                          // Pie chart
                          Expanded(
                            flex: 3,
                            child: CustomPaint(
                              painter: PieChartPainter(
                                categories: categories.values.toList(),
                                isDarkMode: isDarkMode,
                              ),
                              child: Container(),
                            ),
                          ),
                          // Legend
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: categories.values.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? category.color.withOpacity(0.8)
                                              : category.color,
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: isDarkMode ? [
                                            BoxShadow(
                                              color: category.color.withOpacity(0.5),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ] : null,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${category.name} (${category.count})',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // Category cards
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories.values.toList()[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: isDarkMode ? 8 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isDarkMode ? 16 : 12),
                    side: isDarkMode ? BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 1) : BorderSide.none,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? category.color.withOpacity(0.8)
                            : category.color,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isDarkMode ? [
                          BoxShadow(
                            color: category.color.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ] : null,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('${category.count} tasks'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      // Navigate to category detail page
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task functionality
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}

// Task Category model
class TaskCategory {
  final String name;
  final Color color;
  final int count;

  TaskCategory(this.name, this.color, this.count);
}

// Custom Pie Chart Painter
class PieChartPainter extends CustomPainter {
  final List<TaskCategory> categories;
  final bool isDarkMode;

  PieChartPainter({required this.categories, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.2;

    // Calculate total tasks
    final totalTasks = categories.fold(0, (sum, category) => sum + category.count);

    // Draw pie slices
    double startAngle = -math.pi / 2; // Start from top (12 o'clock position)

    for (var category in categories) {
      final sweepAngle = 2 * math.pi * category.count / totalTasks;

      // Create paint for slice
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = isDarkMode
            ? category.color.withOpacity(0.7)
            : category.color;

      // Draw slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Add glow effect for dark mode
      if (isDarkMode) {
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = category.color.withOpacity(0.6)
          ..strokeWidth = 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          glowPaint,
        );
      }

      // Add subtle border for light mode
      if (!isDarkMode) {
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white.withOpacity(0.8)
          ..strokeWidth = 1.5;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          borderPaint,
        );
      }

      startAngle += sweepAngle;
    }

    // Draw center circle (optional for better aesthetics)
    final centerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDarkMode
          ? Color(0xFF1E1E1E)
          : Colors.white;

    canvas.drawCircle(center, radius * 0.5, centerPaint);

    if (isDarkMode) {
      final centerGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.greenAccent.withOpacity(0.3)
        ..strokeWidth = 1.5
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(center, radius * 0.5, centerGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}