import 'dart:math';
import 'package:flutter/material.dart';

class AchievedTasksWidgets extends StatelessWidget {
   AchievedTasksWidgets({super.key , required this.totalTask, required this.totalDoneTask , required this.percent });


   int totalTask = 0;

   int totalDoneTask = 0;

   double percent =0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achieved Tasks",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "$totalTask Out of $totalDoneTask Done",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -pi / 2,
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: CircularProgressIndicator(
                      value: percent,
                      backgroundColor: Color(0xFF6D6D6D),
                      valueColor: AlwaysStoppedAnimation(Color(0xFF15b86c)),
                      strokeWidth: 4,
                    ),
                  ),
                ),
                Text(
                  "${(percent * 100).toInt()}%",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
