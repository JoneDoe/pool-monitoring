import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
              // const SizedBox(height: 10),
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

    setState(() {
      _provider.save(AppSettings(
        heroPool: currentState?.fields['hpoolState']?.value,
        woolyPool: currentState?.fields['wppoolState']?.value,
      ));
    });
  }
}
