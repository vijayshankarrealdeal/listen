import 'package:listen/app/show_daily_tips.dart';
import 'package:listen/models/daily_tips.dart';
import 'package:listen/modules/search_text_field_logic.dart';
import 'package:listen/routes/user_page.dart';
import 'package:listen/models/user_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listen/services/auth.dart';
import 'package:listen/services/db.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Listengloom"),
        actions: [
          Consumer<FUsers>(builder: (context, user, _) {
            return IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => UserPage(
                                user: user,
                                psychologist: null,
                              )),
                    ),
                icon: const Icon(CupertinoIcons.person_alt_circle,
                    color: Colors.green));
          }),
        ],
      ),
      drawer: SafeArea(
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Remove border radius
          ),
          child: Drawer(
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Consumer<FUsers>(builder: (context, user, _) {
                  return Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          CachedNetworkImageProvider(user.displayProfile),
                    ),
                  );
                }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.green, width: 1)),
                      ),
                      child: Consumer<FUsers>(builder: (context, user, _) {
                        return ListTile(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => UserPage(
                                            user: user,
                                            psychologist: null,
                                          )),
                                ),
                            title:
                                const Center(child: Text("Personal Details")));
                      })),
                ),
                // Container(
                //     decoration: const BoxDecoration(
                //       border: Border(
                //           bottom: BorderSide(color: Colors.green, width: 1)),
                //     ),
                //     child:
                //         const ListTile(title: Center(child: Text("Language")))),
                Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.green, width: 1)),
                    ),
                    child: const ListTile(
                        title: Center(child: Text("Need Help")))),
                Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.green, width: 1)),
                    ),
                    child: Consumer<Auth>(builder: (context, auth, _) {
                      return ListTile(
                          onTap: () => auth.signout(),
                          title: const Center(child: Text("Logout")));
                    })),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChangeNotifierProvider<SearchTextFieldLogic>(
                create: (ctx) => SearchTextFieldLogic(),
                child: Consumer<SearchTextFieldLogic>(
                    builder: (context, logic, _) {
                  return SearchField<FUsers>(
                    onSuggestionTap: (e) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage(
                            user: e.item,
                            psychologist: null,
                          ),
                        ),
                      );
                    },
                    hint: logic.controller.text.isEmpty
                        ? "Search"
                        : logic.controller.text,
                    onTapOutside: (p) {
                      logic.removefromSearchArea(context);
                    },
                    controller: logic.controller,
                    onSearchTextChanged: (a) {
                      logic.onChanged(db, a);
                      return logic.users
                          .map(
                            (e) => SearchFieldListItem(
                              e.name,
                              item: e,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: CachedNetworkImageProvider(
                                      e.displayProfile),
                                ),
                                title: Text(e.name),
                              ),
                            ),
                          )
                          .toList();
                    },
                    dynamicHeight: true,
                    maxSuggestionBoxHeight:
                        MediaQuery.of(context).size.height * 0.3,
                    suggestions: logic.users
                        .map(
                          (e) => SearchFieldListItem(
                            e.name,
                            item: e,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                    e.displayProfile),
                              ),
                              title: Text(e.name),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder<List<DailyTips>>(
                  initialData: List.generate(
                    (7),
                    (e) => DailyTips(
                        imageUrl: "https://vectorified.com/images/grey-circle-icon-26.jpg",
                        color: Colors.green,
                        text: "Loading"),
                  ),
                  stream: db.getDailyTips(),
                  builder: (context, snapshot) {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        snapshot.data!.length,
                        (idx) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context, // Pass the context directly here
                                  MaterialPageRoute(
                                    builder: (context) => ShowDailyTips(
                                        todayTip: snapshot.data![idx]),
                                  ), // Correct parameter passing
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        snapshot.data![idx].imageUrl),
                                    radius: 37,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text("Daily Tips")
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            sliver: SliverToBoxAdapter(
                child: Consumer<Database>(builder: (context, db, _) {
              return StreamBuilder<List<String>>(
                  initialData: const [
                    "https://i0.wp.com/yoshyra.com/wp-content/uploads/2020/12/Hero-Banner-Placeholder-Dark-1024x480-1.png?w=1024&ssl=1",
                    "https://i0.wp.com/yoshyra.com/wp-content/uploads/2020/12/Hero-Banner-Placeholder-Dark-1024x480-1.png?w=1024&ssl=1",
                    "https://i0.wp.com/yoshyra.com/wp-content/uploads/2020/12/Hero-Banner-Placeholder-Dark-1024x480-1.png?w=1024&ssl=1",
                  ],
                  stream: db.getBanners(),
                  builder: (context, snapshot) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 0.88,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      items: snapshot.data!.map((i) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: i,
                            fit: BoxFit.fill,
                          ),
                        );
                      }).toList(),
                    );
                  });
            })),
          ),
          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 0.88,
                enlargeCenterPage: false,
                enlargeFactor: 0.6,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              items: [
                "TkYiJdwblQM",
                "lDUZrXmb6P4",
                "1vXAhc7lfQU",
                "u5qoSoaWsOE",
              ].map((i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      launchUrl(
                          Uri.parse("https://www.youtube.com/watch?v=$i"));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                                'https://img.youtube.com/vi/$i/0.jpg')),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SliverToBoxAdapter(
              child:
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05))
        ],
      ),
    );
  }
}
