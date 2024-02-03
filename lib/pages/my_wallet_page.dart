import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../my_wallet/data/bucket.dart';
import '../extensions/string_extension.dart';
import '../constants.dart';
import '../providers/cryptocurrency_listing.dart';
import '../my_wallet/exception.dart';
import '../my_wallet/models/wallet_entry.dart';
import '../my_wallet/widgets/wallet_item_widgte.dart';

class MyWalletsPage extends StatefulWidget {
  const MyWalletsPage({super.key});

  @override
  State<MyWalletsPage> createState() => _MyWalletsPageState();
}

class _MyWalletsPageState extends State<MyWalletsPage> {
  final Bucket _bucket = Bucket();

  List<String> options =
      Currency.values.map((Currency cyrrecy) => cyrrecy.name).toList();

  @override
  void initState() {
    _bucket.loadData();

    super.initState();
  }

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
          'My Wallets',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
      ),
      body: _bucket.size() > 0
          ? ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _bucket.size(),
              separatorBuilder: (BuildContext context, int idx) =>
                  const Divider(
                color: Colors.transparent,
              ),
              itemBuilder: (BuildContext context, int idx) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: buildSwipeActionWidget(),
                  key: UniqueKey(),
                  onDismissed: (direction) => onDismissedAction(direction, idx),
                  child: WalletItemWidget(wallet: _bucket.getAt(idx)),
                );
              },
            )
          : const SizedBox(
              height: 330,
              child: Center(
                child: Image(
                  image: AssetImage('assets/oops.png'),
                  color: Colors.white,
                  width: 180,
                ),
              ),
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
        onPress: () => newItemPopupForm(context),
      ),
    );
  }

  final formKey = GlobalKey<FormBuilderState>();

  Future<dynamic> newItemPopupForm(BuildContext context) {
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
                        child: SizedBox(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          var formState = formKey.currentState;

                          // Validate and save the form values
                          formState?.saveAndValidate();
                          debugPrint(formState?.value.toString());

                          // On another side, can access all field values without saving form with instantValues
                          // formKey.currentState?.validate();
                          // debugPrint(formKey.currentState?.instantValue.toString());

                          if (formState?.isValid == true) {
                            try {
                              addNewWallet(WalletEntryItem(
                                name: formState?.fields['name']?.value,
                                token: formState?.fields['token']?.value,
                              ));
                              Navigator.pop(context);
                            } on WalletEntryItemException catch (_) {
                              formState?.fields['name']
                                  ?.invalidate('Coin already exists');
                            }
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: textColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addNewWallet(WalletEntryItem item) {
    setState(() {
      _bucket.add(item);
    });
  }

  void onDismissedAction(DismissDirection direction, int index) {
    setState(() {
      _bucket.remove(index);
    });
  }
}

Widget buildSwipeActionWidget() => Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete_forever,
        color: textColor,
      ),
    );
