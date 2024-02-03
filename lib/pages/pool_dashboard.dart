import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '/exceptions/waller_exception.dart';
import '/extensions/string_extension.dart';
import '/constants.dart';
import '/pool/models/pool_factory.dart';
import '/models/crypto.dart';
import '/pool/providers/pool_stat_provider.dart';
import '/widgets/app_bar_widget.dart';
import '/pool/widgets/revenue_widget.dart';
import '/pool/widgets/summary_widget.dart';
import '/pool/widgets/workers_widget.dart';
import 'coins_dashboard.dart';

class PoolDashboard extends StatefulWidget {
  final Crypto crypto;

  const PoolDashboard({super.key, required this.crypto});

  @override
  State<PoolDashboard> createState() => _PoolDashboardState();
}

class _PoolDashboardState extends State<PoolDashboard> {
  PoolStatFactory _statistics = PoolStatFactory();
  PoolName _poolName = PoolName.herominers;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadPoolStat();
  }

  void _showAlert(String msg) async {
    await Future.delayed(const Duration(milliseconds: 50));

    if (!context.mounted) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(
            msg,
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.grey[300],
          actions: <Widget>[
            FilledButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(itemBorderRadius),
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const CoinsListingDashboard()),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  changePool(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pool has been cnahged'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _poolName = PoolName.values[index];
    });

    loadPoolStat();
  }

  Future<void> loadPoolStat({bool? disableLoading}) async {
    if (null == disableLoading) {
      setState(() => _loading = true);
    }

    try {
      var data = await PoolStatProvider.fetchData(_poolName, widget.crypto);

      setState(() {
        _loading = false;
        _statistics = data;
      });
    } on WalletException catch (e) {
      _showAlert(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  var isDialOpen = ValueNotifier<bool>(false);
  var buttonSize = const Size(56.0, 56.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        cryptoInfo: widget.crypto,
        actions: <Widget>[
          IconButton(
            icon: _loading
                ? const CircularProgressIndicator()
                : const Icon(
                    Icons.replay,
                    color: textColor,
                  ),
            onPressed: () => loadPoolStat(),
          ),
        ],
      ),
      body: DismissiblePage(
        backgroundColor: primaryColor,
        onDismissed: () {
          Navigator.of(context).pop();
        },
        direction: DismissiblePageDismissDirection.startToEnd,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: () => loadPoolStat(disableLoading: true),
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 2,
                          // offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      _poolName.name.capitalize(),
                      style: const TextStyle(color: textColor, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SummaryWidget(statistics: _statistics),
                const SizedBox(height: 12.0),
                RevenueWidget(statistics: _statistics),
                const SizedBox(height: 12.0),
                WorkersWidget(workers: _statistics.workers),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.add,
        activeIcon: Icons.close,
        // spacing: 3,
        // mini: mini,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        // dialRoot: customDialRoot
        //     ? (ctx, open, toggleChildren) {
        //         return ElevatedButton(
        //           onPressed: toggleChildren,
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor: Colors.blue[900],
        //             padding: const EdgeInsets.symmetric(
        //                 horizontal: 22, vertical: 18),
        //           ),
        //           child: const Text(
        //             "Custom Dial Root",
        //             style: TextStyle(fontSize: 17),
        //           ),
        //         );
        //       }
        //     : null,
        buttonSize:
            buttonSize, // it's the SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        // label: extend ? const Text("Open") : null, // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        // activeLabel: extend ? const Text("Close") : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        // childrenButtonSize: childrenButtonSize,
        // visible: visible,
        // direction: speedDialDirection,
        // switchLabelPosition: switchLabelPosition,

        /// If true user is forced to close dial manually
        // closeManually: closeManually,

        /// If false, backgroundOverlay will not be rendered.
        // renderOverlay: renderOverlay,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        // onOpen: () => debugPrint('OPENING DIAL'),
        // onClose: () => debugPrint('DIAL CLOSED'),
        // useRotationAnimation: true,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        // foregroundColor: Colors.black,
        backgroundColor: buttonColor,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        // isOpenOnStart: false,
        shape: const StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: List.generate(
          PoolName.values.length,
          (index) => SpeedDialChild(
            child: const Icon(Icons.factory),
            visible: PoolName.values[index] != _poolName,
            backgroundColor: PoolName.values[index] == _poolName
                ? Colors.redAccent
                : Colors.indigo,
            foregroundColor: textColor,
            label: PoolName.values[index].name.toUpperCase(),
            onTap: () => changePool(index),
            onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
        ),
      ),
    );
  }
}
