
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:selller/drawer.dart';

class SalesGraphScreen extends StatefulWidget {
  @override
  _SalesGraphScreenState createState() => _SalesGraphScreenState();
}

class _SalesGraphScreenState extends State<SalesGraphScreen> {
  bool showWeeklyData = true;
  List<FlSpot> weeklySales = [];
  List<FlSpot> monthlySales = [];
  Map<int, int> productSales = {};
  int selectedWeek = 0; // Default to Monday (0)
  int selectedMonth = 0; // Default to January (0)

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchOrders();
    await fetchProductSales();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse('http://192.168.100.239:5000/api/orders'));
    if (response.statusCode == 200) {
      final List<dynamic> orders = json.decode(response.body);
      processOrders(orders);
    } else {
      print('Failed to fetch orders');
    }
  }

  Future<void> fetchProductSales() async {
  String url = 'http://192.168.100.239:5000/api/product_sales';
  url += '?period=${showWeeklyData ? "weekly" : "monthly"}'; // Only pass period

  print("Fetching product sales from: $url");
  final response = await http.get(Uri.parse(url));
  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.body}");
  if (response.statusCode == 200) {
    final List<dynamic> sales = json.decode(response.body);
    processProductSales(sales);
  } else {
    print('Failed to fetch product sales');
  }
}
void processProductSales(List<dynamic> sales) {
  print("Fetched Product Sales: $sales");
  print("Selected Week: $selectedWeek, Selected Month: $selectedMonth");

  productSales = {};

  for (var sale in sales) {
    if (sale is! List || sale.length < 3) {  // ✅ Ensure valid format
      print("Skipping invalid sale format: $sale");
      continue;
    }

    int productId = sale[0];      // ✅ Extract Product ID
    int dayOfWeek = sale[1];      // ✅ Extract Day of the week
    int monthOfYear = sale[2];    // ✅ Extract Month of the year

    print("Processing Sale - Product: $productId, Day: $dayOfWeek, Month: $monthOfYear");

    if (showWeeklyData) {
      if (dayOfWeek == selectedWeek) {
        productSales[productId] = (productSales[productId] ?? 0) + 1;
        print("Added to weekly sales: Product $productId - Total: ${productSales[productId]}");
      }
    } else {
      if (monthOfYear == (selectedMonth + 1)) {
        productSales[productId] = (productSales[productId] ?? 0) + 1;
        print("Added to monthly sales: Product $productId - Total: ${productSales[productId]}");
      }
    }
  }

  print("Final Product Sales: $productSales");
  setState(() {});
}


// void processProductSales(List<dynamic> sales) {
//   print("Fetched Product Sales: $sales");

//   productSales = {};
//   if (showWeeklyData) {
//     // Filter sales for the selected week
//     for (var sale in sales) {
//       if (sale['day_of_week'] == selectedWeek) {
//         productSales[sale['ProductId']] = sale['sales'];
//       }
//     }
//   } else {
//     // Filter sales for the selected month
//     for (var sale in sales) {
//       if (sale['month_of_year'] == (selectedMonth + 1)) {
//         productSales[sale['ProductId']] = sale['sales'];
//       }
//     }
//   }

//   print("Product Sales: $productSales");
//   setState(() {});
// }

  // void processOrders(List<dynamic> orders) {
  //   print("Fetched Orders: $orders");

  //   Map<int, double> weeklyData = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
  //   Map<int, double> monthlyData = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0};

  //   for (var order in orders) {
  //     if (order['OrderDateTime'] == null) {
  //       print("Skipping order with null OrderDateTime: $order");
  //       continue;
  //     }

  //     DateTime orderDate;
  //     try {
  //       orderDate = DateTime.parse(order['OrderDateTime']);
  //       print("Parsed Date: $orderDate");
  //     } catch (e) {
  //       print("Failed to parse date: ${order['OrderDateTime']}. Error: $e");
  //       continue;
  //     }

  //     int weekNumber = _getDayIndex(orderDate);
  //     int monthNumber = _getMonthIndex(orderDate);

  //     weeklyData[weekNumber] = (weeklyData[weekNumber] ?? 0) + 1;
  //     monthlyData[monthNumber] = (monthlyData[monthNumber] ?? 0) + 1;
  //   }

  //   weeklySales = weeklyData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();
  //   monthlySales = monthlyData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();

  //   weeklySales.sort((a, b) => a.x.compareTo(b.x));
  //   monthlySales.sort((a, b) => a.x.compareTo(b.x));

  //   print("Weekly Sales: $weeklySales");
  //   print("Monthly Sales: $monthlySales");

  //   setState(() {});
  // }
void processOrders(List<dynamic> orders) {
  print("Fetched Orders: $orders");

  Map<int, double> weeklyData = {for (var i = 0; i < 7; i++) i: 0};
  Map<int, double> monthlyData = {for (var i = 0; i < 12; i++) i: 0};

  for (var order in orders) {
    if (order is! List || order.length < 2) {  // ✅ Ensure valid list format
      print("Skipping invalid order format: $order");
      continue;
    }

    int orderId = order[0]; // ✅ Order ID (int)
    String orderDateStr = order[1]; // ✅ Order DateTime (String)

    DateTime orderDate;
    try {
      orderDate = DateTime.parse(orderDateStr); // ✅ Convert to DateTime
      print("Parsed Date for Order $orderId: $orderDate");
    } catch (e) {
      print("Failed to parse date: $orderDateStr. Error: $e");
      continue;
    }

    int weekNumber = _getDayIndex(orderDate);
    int monthNumber = _getMonthIndex(orderDate);

    weeklyData[weekNumber] = (weeklyData[weekNumber] ?? 0) + 1;
    monthlyData[monthNumber] = (monthlyData[monthNumber] ?? 0) + 1;
  }

  weeklySales = weeklyData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();
  monthlySales = monthlyData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value)).toList();

  weeklySales.sort((a, b) => a.x.compareTo(b.x));
  monthlySales.sort((a, b) => a.x.compareTo(b.x));

  print("Weekly Sales: $weeklySales");
  print("Monthly Sales: $monthlySales");

  setState(() {});
}

  
  int _getDayIndex(DateTime date) {
    return date.weekday - 1; // 0 (Monday) to 6 (Sunday)
  }

  int _getMonthIndex(DateTime date) {
    return date.month - 1; // 0 (January) to 11 (December)
  }

  List<PieChartSectionData> getPieChartData() {
    return productSales.entries.map((entry) {
      return PieChartSectionData(
        color: Colors.primaries[entry.key % Colors.primaries.length],
        value: entry.value.toDouble(),
        title: 'Product ${entry.key}',
        radius: 60,
      );
    }).toList();
  }
  final ScreenshotController screenshotController = ScreenshotController();

  // ... (keep your existing fetchData, fetchOrders, fetchProductSales, processOrders, processProductSales, etc.)

  // Function to generate and download the PDF
  Future<void> generateAndDownloadPDF() async {
  try {
    print("Starting PDF generation...");

    // Capture the screen as an image
    final image = await screenshotController.capture();
    if (image == null) {
      print("Failed to capture screenshot: image is null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture screenshot")),
      );
      return;
    }
    print("Screenshot captured successfully");

    // Create a PDF document
    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(image);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ),
    );
    print("PDF document created");

    // Use the printing package to share or save the PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'sales_graph_${DateTime.now().toIso8601String()}.pdf',
    );
    print("PDF shared/saved successfully");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF generated and ready to download")),
    );
  } catch (e, stackTrace) {
    print("Error generating PDF: $e");
    print("Stack trace: $stackTrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error generating PDF: $e")),
    );
  }
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "Smart Supply",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF8E6CEF),
      ),
      drawer: CustomDrawer(),
      body: Screenshot(
        controller: screenshotController, // Wrap the content in Screenshot
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  SizedBox(height: 10),
                  Text(
                    "Sales Graph",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "The graph below displays product sales data on a ${showWeeklyData ? "weekly" : "monthly"} basis. Click the 'Monthly' button to switch.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Text("Sales Graph", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        minX: 0,
                        maxX: showWeeklyData ? 6 : 11,
                        minY: 0,
                        maxY: (showWeeklyData ? weeklySales : monthlySales)
                            .fold(0.0, (prev, spot) => spot.y > prev ? spot.y : prev) + 1,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (showWeeklyData) {
                                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  return Text(
                                    days[value.toInt()],
                                    style: TextStyle(fontSize: 12),
                                  );
                                } else {
                                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                  return Text(
                                    months[value.toInt()],
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        showWeeklyData ? "Select Day: " : "Select Month: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButton<int>(
                        value: showWeeklyData ? selectedWeek : selectedMonth,
                        items: showWeeklyData
                            ? List.generate(7, (index) => index).map((value) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(days[value]),
                                );
                              }).toList()
                            : List.generate(12, (index) => index).map((value) {
                                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(months[value]),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (showWeeklyData) {
                              selectedWeek = value!;
                            } else {
                              selectedMonth = value!;
                            }
                            fetchProductSales(); // Refetch product sales for the selected period
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 250,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                    ),
                    child: productSales.isEmpty
                        ? Center(child: Text("No sales for this period"))
                        : PieChart(
                            PieChartData(
                              sections: getPieChartData(),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showWeeklyData = !showWeeklyData;
                            selectedWeek = 0;
                            selectedMonth = 0;
                            fetchProductSales();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B70F1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          showWeeklyData ? "Monthly" : "Weekly",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Add a Download PDF button
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: generateAndDownloadPDF,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 167, 76, 175),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          "Download PDF",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... (keep your existing getPieChartData, _getDayIndex, _getMonthIndex, etc.)
}