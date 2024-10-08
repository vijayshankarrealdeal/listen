import 'package:listen/modules/form_submit.dart';
import 'package:listen/services/auth.dart';
import 'package:listen/services/db.dart';
import 'package:listen/widgets/submit_button.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Onboard extends StatelessWidget {
  const Onboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.power),
            onPressed: () =>
                Provider.of<Auth>(context, listen: false).signout(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        child: ChangeNotifierProvider<FormSubmit>(
          create: (ctx) => FormSubmit(),
          child: Consumer<FormSubmit>(builder: (context, fbsum, _) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Welcome! We're here to support your well-being. To guide your journey toward growth and a healthier you, we just need a few quick details."),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormField(
                    enabled: !fbsum.load,
                    controller: fbsum.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                    ),
                  ),
                  DropDownSearchField(
                    textFieldConfiguration: TextFieldConfiguration(
                        enabled: !fbsum.load,
                        controller: fbsum.role,
                        decoration:
                            const InputDecoration(hintText: 'Select you role')),
                    suggestionsCallback: (pattern) {
                      return ["User", "Psycologist"];
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      fbsum.role.text = suggestion;
                    },
                    displayAllSuggestionWhenTap: true,
                  ),
                  DropDownSearchField(
                    textFieldConfiguration: TextFieldConfiguration(
                        enabled: !fbsum.load,
                        controller: fbsum.cont,
                        decoration: const InputDecoration(hintText: 'Gender')),
                    suggestionsCallback: (pattern) {
                      return ["Male", "Female"];
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      fbsum.cont.text = suggestion;
                    },
                    displayAllSuggestionWhenTap: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                  TextFormField(
                    enabled: !fbsum.load,
                    controller: fbsum.email,
                    decoration: const InputDecoration(
                      hintText: 'Enter Email',
                    ),
                  ),
                  TextFormField(
                    enabled: !fbsum.load,
                    controller: fbsum.dobController,
                    decoration: InputDecoration(
                      hintText: 'Enter Date of Birth',
                      suffixIcon: IconButton(
                        icon: const Icon(CupertinoIcons.calendar_today),
                        onPressed: () {
                          fbsum.selectDate(context);
                        },
                      ),
                    ),
                    readOnly: true, // This prevents the user from typing manually
                    onTap: () {
                      fbsum.selectDate(context); // Open date picker when tapped
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  fbsum.load
                      ? const Center(child: CircularProgressIndicator())
                      : SubmitButton(
                          onPressed: () {
                            fbsum.registerUser(db, context);
                          },
                          showIcon: false,
                          buttonText: "Submit",
                        ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
