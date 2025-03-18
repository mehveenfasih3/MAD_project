import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:selller/drawer.dart';
import 'package:selller/main.dart';

class SalesGraphScreen extends StatefulWidget {
  @override
  _SalesGraphScreenState createState() => _SalesGraphScreenState();
}

class _SalesGraphScreenState extends State<SalesGraphScreen> {
  bool showWeeklyData = true;

  List<FlSpot> weeklySales = [
    FlSpot(0, 8), FlSpot(1, 7), FlSpot(2, 3), FlSpot(3, 2), FlSpot(4, 5), FlSpot(5, 7), FlSpot(6, 8)
  ];

  List<FlSpot> monthlySales = [
    FlSpot(0, 30), FlSpot(1, 25), FlSpot(2, 40), FlSpot(3, 50), FlSpot(4, 35), FlSpot(5, 55), FlSpot(6, 45)
  ];

  List<PieChartSectionData> getPieChartData() {
    return [
      PieChartSectionData(color: Colors.blue, value: showWeeklyData ? 40 : 70, title: 'Product A', radius: 60),
      PieChartSectionData(color: Colors.green, value: showWeeklyData ? 30 : 50, title: 'Product B', radius: 60),
      PieChartSectionData(color: Colors.orange, value: showWeeklyData ? 20 : 40, title: 'Product C', radius: 60),
      PieChartSectionData(color: Colors.red, value: showWeeklyData ? 10 : 30, title: 'Product D', radius: 60),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          
          
          title: Text('Smart Supply',style:  TextStyle(fontSize: 24,fontWeight: FontWeight.w900)
        ),
        // actions: [
        //  Image(image: AssetImage('assets/Icons/image.png'),
        //  )  
        // ],
        backgroundColor: Color(0xFF8E6CEF),
        ),
        drawer: CustomDrawer(),
         
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
//                 IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     Navigator.pushReplacement(
// context,
// MaterialPageRoute(builder: (context)=> MyHomePage()));
//                   },
//                 ),
                SizedBox(height: 10),
        
                // Title
                Text(
                  "Sales Graph",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
        
                // Subtitle
                Text(
                  "The graph below displays product sales data on a ${showWeeklyData ? "weekly" : "monthly"} basis. Click the 'Monthly' button to switch.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 20),
        
                // Line Chart
                Text("Sales Graph", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 300, // Added height to prevent overflow
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) => Text(value.toString()),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              int index = value.toInt();
                              if (showWeeklyData) {
                                return index >= 0 && index < 7
                                    ? Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index])
                                    : Text('');
                              } else {
                                return index >= 0 && index < 4
                                    ? Text(["Week 1", "Week 2", "Week 3", "Week 4"][index])
                                    : Text('');
                              }
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: showWeeklyData ? weeklySales : monthlySales,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
        
                // Pie Chart
                Container(
                  height: 250,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  ),
                  child: PieChart(
                    PieChartData(
                      sections: getPieChartData(),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                SizedBox(height: 20),
        
                // Toggle Button
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showWeeklyData = !showWeeklyData;
                        });
                      },
                    style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B70F1), // Correct property
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                            child: Text(
                        showWeeklyData ? "Monthly" : "Weekly",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
