import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../extensions/string_extension.dart';
import '../providers/cryptocurrency_listing.dart';
import '/settings/models/settings_model.dart';
import '/settings/providers/settings_provider.dart';
import '/widgets/default_app_bar.dart';
import '/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final SettingsProvider _provider = SettingsProvider();
  final List<Currency> _currencies = Currency.values.toList();

  @override
  void initState() {
    super.initState();
    _provider.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: defaultAppBar(textTitle: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 500),
                decoration: const BoxDecoration(
                  color: listItemColor,
                ),
                child: const Text(
                  'Pool list',
                  style: TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              FormBuilderSwitch(
                name: 'hpoolState',
                initialValue: _provider.items.heroPool,
                title: Title(
                    color: textColor,
                    child: const Text(
                      'Herominers pool',
                      style: TextStyle(color: textColor, fontSize: 20),
                    )),
                decoration: const InputDecoration.collapsed(hintText: null),
                onChanged: (value) => saveChanges(_formKey.currentState),
              ),
              FormBuilderSwitch(
                name: 'wppoolState',
                initialValue: _provider.items.woolyPool,
                title: Title(
                    color: textColor,
                    child: const Text(
                      'WoolyPooly pool',
                      style: TextStyle(color: textColor, fontSize: 20),
                    )),
                decoration: const InputDecoration.collapsed(hintText: null),
                onChanged: (value) => saveChanges(_formKey.currentState),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 500),
                decoration: const BoxDecoration(
                  color: listItemColor,
                ),
                child: const Text(
                  'Currency list',
                  style: TextStyle(color: textColor, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _currencies.length,
                  itemBuilder: (_, index) => FormBuilderSwitch(
                    name: _currencies[index].name,
                    initialValue: _provider.items.cyrrency
                        .contains(_currencies[index].name),
                    title: Title(
                        color: textColor,
                        child: Text(
                          _currencies[index].name.capitalize(),
                          style:
                              const TextStyle(color: textColor, fontSize: 20),
                        )),
                    decoration: const InputDecoration.collapsed(hintText: null),
                    onChanged: (value) => saveChanges(_formKey.currentState),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveChanges(FormBuilderState? currentState) {
    print(currentState?.instantValue.toString());
    // print(currentState?.fields['_hpoolState']?.value);
    // print(currentState?.fields['_wppoolState']?.value);

    List<String> skip = ['hpoolState', 'wppoolState'];
    List<String> cyrrencyToSave = [];

    currentState?.instantValue.forEach((key, value) {
      if (skip.contains(key)) {
        return;
      }

      if (value == true) {
        cyrrencyToSave.add(key);
      }
    });

    setState(() {
      _provider.save(AppSettings(
        heroPool: currentState?.fields['hpoolState']?.value,
        woolyPool: currentState?.fields['wppoolState']?.value,
        cyrrency: cyrrencyToSave,
      ));
    });
  }
}
