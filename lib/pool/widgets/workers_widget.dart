import 'package:flutter/material.dart';

import '../../constants.dart';
import '../models/worker.dart';
import '../../extensions/number_extension.dart';

class WorkersWidget extends StatelessWidget {
  const WorkersWidget({super.key, required List<Worker> workers})
      : _workers = workers;

  final List<Worker> _workers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: secondaryColor,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Worker',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Hashrate (30 min.)',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 10,
            indent: 12,
            endIndent: 12,
            color: Colors.white30,
          ),
          WorkersRowBuilderWidget(workers: _workers),
        ],
      ),
    );
  }
}

class WorkersRowBuilderWidget extends StatelessWidget {
  const WorkersRowBuilderWidget({super.key, required List<Worker> workers})
      : _workers = workers;

  final List<Worker> _workers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: _workers.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomPaint(
                            painter: RedCirclePainter(_workers[index].offline),
                            child: Container(width: 10.0),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _workers[index].name,
                            style: const TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      Text(
                        '${NumberParsing(_workers[index].hashrate).digit(decimal: 2)} Gh/s',
                        style: const TextStyle(color: textColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class RedCirclePainter extends CustomPainter {
  bool offline;

  RedCirclePainter(this.offline);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = offline ? Colors.red : Colors.green
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2.0;
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
