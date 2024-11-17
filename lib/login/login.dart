import 'package:listen/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) {
        return Scaffold(
            body: auth.optNow
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Enter 6 digits of OTP send to"),
                                Row(
                                  children: [
                                    Text(auth.phoneNum()),
                                    // TextButton(
                                    //     onPressed: () => auth.changeNum(),
                                    //     child: const Text("change number")),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.2),
                              child: TextField(
                                maxLength: 6,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  hintText: "OTP",
                                ),
                                controller: auth.valCon,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            auth.load
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Center(
                                    child: CupertinoButton(
                                        color: Colors.green.shade900,
                                        child: const Text("Continue"),
                                        onPressed: () {
                                          if (auth.valCon.text.length == 6) {
                                            try {
                                              auth.verifyOTP(auth.valCon.text);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error ${e.toString()}'),
                                                  action: SnackBarAction(
                                                    label: 'Try Again',
                                                    onPressed: () {
                                                      // Code to execute when 'Undo' is pressed
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'OTP Must be of 6 digits.'),
                                                action: SnackBarAction(
                                                  label: 'Try again',
                                                  onPressed: () {
                                                    // Code to execute when 'Undo' is pressed
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                TextButton(
                                  onPressed: () => auth.resend(context),
                                  child: Text(
                                    "RESEND",
                                    style: TextStyle(
                                      color: auth.resendAgain
                                          ? Colors.red
                                          : Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        //Gcolor: Color.fromARGB(255, 25, 91, 27),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(width: double.infinity),
                            const Text(
                              "Listeners",
                              style: TextStyle(fontSize: 45),
                            ),
                            const SizedBox(height: 80),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                children: [
                                  // country
                                  GestureDetector(
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Consumer<Auth>(
                                            builder: (context, data, _) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                )),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 18.0,
                                                    left: 4,
                                                    right: 4),
                                                child: CustomScrollView(
                                                  slivers: [
                                                    SliverToBoxAdapter(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: CupertinoButton(
                                                          child: const Icon(
                                                              CupertinoIcons
                                                                  .clear_circled),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context)),
                                                    )),
                                                    SliverToBoxAdapter(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child:
                                                            CupertinoSearchTextField(
                                                          controller:
                                                              data.searchText,
                                                          onChanged: (s) =>
                                                              data.search(s),
                                                        ),
                                                      ),
                                                    ),
                                                    SliverList(
                                                        delegate:
                                                            SliverChildListDelegate(
                                                      data.country
                                                          .where(
                                                            (element) => element
                                                                .name
                                                                .toLowerCase()
                                                                .contains(data
                                                                    .searchText
                                                                    .text
                                                                    .toLowerCase()),
                                                          )
                                                          .map(
                                                            (e) =>
                                                                CupertinoListTile(
                                                              leadingSize: kIsWeb
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.05
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.14,
                                                              onTap: () {
                                                                data.submit(
                                                                    e.code);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              leading:
                                                                  Text(e.code),
                                                              title:
                                                                  Text(e.name),
                                                              trailing: Text(
                                                                  e.letter),
                                                            ),
                                                          )
                                                          .toList(),
                                                    ))
                                                  ],
                                                )),
                                          );
                                        });
                                      },
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(18),
                                          topLeft: Radius.circular(18),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          auth.cpuntryDefautl,
                                          style: const TextStyle(fontSize: 19),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // number add
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(18),
                                          topRight: Radius.circular(18),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 2.0, left: 8.0),
                                        child: TextField(
                                          controller: auth.phoneNumber,
                                          maxLength: 10,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Allows only numeric input
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder
                                                .none, // Removes the border
                                            hintText: 'Enter Phone Number',
                                            counterText: '',
                                            hintStyle: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            auth.load
                                ? const CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () async {
                                      if (auth.phoneNumber.text.length == 10) {
                                        try {
                                          auth.signInWithPhone(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Error ${e.toString()}'),
                                              action: SnackBarAction(
                                                label: 'Try Again',
                                                onPressed: () {
                                                  // Code to execute when 'Undo' is pressed
                                                },
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Phone Number is Invalid'),
                                            action: SnackBarAction(
                                              label: 'Close',
                                              onPressed: () {
                                                // Code to execute when 'Undo' is pressed
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade900,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Text(
                                            "Get OTP",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                CupertinoIcons.forward,
                                                color: Colors.white,
                                              )),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 5),
                            auth.circleload
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      auth.signInWithGoogle();
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.065,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade900,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Text(
                                            "Sign In with Google",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                CupertinoIcons.forward,
                                                color: Colors.white,
                                              )),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                          ]),
                    ),
                  ));
      },
    );
  }
}
