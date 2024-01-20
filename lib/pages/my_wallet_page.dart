import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../extensions/string_extension.dart';
import '../constants/colors.dart';
import '../providers/cryptocurrency_listing.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class EntryItem {
  String name, token;

  EntryItem({required this.name, required this.token});
}

class _MyWalletPageState extends State<MyWalletPage> {
  List<String> options =
      Currency.values.map((Currency cyrrecy) => cyrrecy.name).toList();

  List<EntryItem> entries = [
    EntryItem(name: 'Bitoc', token: 'a21adsgffdg31asdfasdfdga2313'),
    EntryItem(name: 'Etc', token: '21312edfsdgsdfgasdfg'),
  ];

  void onDismissedAction(DismissDirection direction, int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return BackButton(
            onPressed: () => Navigator.pop(context),
          );
        }),
        title: const Text(
          'My Wallet',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.transparent,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            direction: DismissDirection.endToStart,
            background: buildSwipeActionWidget(),
            key: ObjectKey(entries[index]),
            onDismissed: (direction) => onDismissedAction(direction, index),
            child: WalletItemWidget(wallet: entries[index]),
          );
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: buttonColor,
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        shape: const StadiumBorder(),
        onPress: () => newItemPopup(context),
      ),
    );
  }

  Future<dynamic> newItemPopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Add token'),
            content: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'token',
                    decoration: const InputDecoration(
                      labelText: 'Token',
                    ),
                    // obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderField(
                    name: "name",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    builder: (FormFieldState<dynamic> field) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Choose coin",
                          // contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                          border: InputBorder.none,
                          errorText: field.errorText,
                        ),
                        child: Container(
                          height: 100,
                          child: CupertinoPicker(
                            itemExtent: 30,
                            children: options
                                .map((c) => Text(c.capitalize()))
                                .toList(),
                            onSelectedItemChanged: (index) {
                              field.didChange(options[index]);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      // Validate and save the form values
                      formKey.currentState?.saveAndValidate();
                      debugPrint(formKey.currentState?.fields['coin']?.value);

                      // On another side, can access all field values without saving form with instantValues
                      formKey.currentState?.validate();
                      debugPrint(formKey.currentState?.instantValue.toString());

                      if (formKey.currentState?.isValid == true) {
                        setState(() {
                          entries.add(
                            EntryItem(
                              name: formKey.currentState?.fields['name']?.value,
                              token:
                                  formKey.currentState?.fields['token']?.value,
                            ),
                          );
                        });
                      }
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class WalletItemWidget extends StatelessWidget {
  const WalletItemWidget({
    super.key,
    required this.wallet,
  });

  final EntryItem wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(158, 255, 3, 11),
            Color.fromARGB(158, 214, 85, 5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      height: 80,
      child: ListTile(
        onLongPress: () => onLongPress(wallet.token),
        contentPadding: const EdgeInsets.only(left: 10.0),
        title: Text(
          wallet.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: Text(
          wallet.token,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

void onLongPress(String token) {}

Widget buildSwipeActionWidget() => Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete_forever,
        color: textColor,
      ),
    );
