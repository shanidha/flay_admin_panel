import 'package:fl_chart/fl_chart.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flay_admin_panel/core/resources/app_fonts.dart';
import 'package:flay_admin_panel/core/resources/app_images.dart';
import 'package:flutter/material.dart';


class DashboardContentScreen extends StatelessWidget {
  const DashboardContentScreen();

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>>  stats = [
        {"title": "Total Sales",     "value": "₹13,456.00", "delta": "+8.3% Last Week"},
        {"title": "Total Products",  "value": "20,000",     "delta": "+1.8% Last Week"},
        {"title": "Total Customers", "value": "346",        "delta": "-2.3% Last Week"},
        {"title": "Total Orders",    "value": "10,000",     "delta": "+3.1% Last Week"},
        {"title": "Pending Orders",  "value": "10",         "delta": "+1.7% Last Week"},
        {"title": "Shipping",        "value": "200",        "delta": "-0.5% Last Week"},
      ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        

          //  cards
          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: stats
                .map((e) => SizedBox(
                      width:MediaQuery.of(context).size.width/4,
                      child: Card(
                        color: AppColors.background,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.boxColor,
                                      
                                    ),
                                    child: Image.asset(AppImages.money,width: 20,height: 20,),
                                  ),
                                    const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start ,
                                      children: [
                                        Text(e['title']!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                                 const SizedBox(height: 8),
                                                                      Text(e['value']!,
                                        style: const TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           
                            const SizedBox(height: 4),
                            Container(
                              height: 60,
                               width: double.infinity,  
                               padding:  const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0),bottomLeft:Radius.circular(15),bottomRight: Radius.circular(15) ),
                                    color: AppColors.kCardColor,
                                    
                                  ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e['delta']!,
                                      style: const TextStyle(color: Colors.green,fontSize: FontSize.s13)),
                                        Text("View More",
                                      style: const TextStyle(color: AppColors.kGreyDark,fontSize: FontSize.s13,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),

          // Bar chart 
          Expanded(
            child: SizedBox(
              height: 300,
              child: Card(
                
                 color: AppColors.background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(BarChartData(
                    
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 40,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40,     
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                             reservedSize: 28,  
                            getTitlesWidget: (v, _) {
                              const months = [
                                "Jan",
                                "Feb",
                                "Mar",
                                "Apr",
                                "May",
                                "Jun",
                                "Jul",
                                "Aug",
                                "Sep",
                                "Oct",
                                "Nov",
                                "Dec"
                              ];
                              return Text(months[v.toInt()]);
                            },
                            interval: 1),
                      ),
                      
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: false),
                     borderData: FlBorderData(
              show: true,
              border: Border(
                left:   BorderSide(color: AppColors.kHintStyle, width: 1),
                bottom: BorderSide(color: AppColors.kHintStyle, width: 1),
                top:    BorderSide(color: Colors.transparent),
                right:  BorderSide(color: Colors.transparent),
              ),
                        ),
                    
                    barGroups: List.generate(
                      12,
                      (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(toY: (i + 5).toDouble(), 
              width: 16,
              borderRadius: BorderRadius.circular(0),
                         
              color: AppColors.primary,)
                            ]),
                    ),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
}