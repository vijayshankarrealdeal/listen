import 'package:listen/routes/user_page.dart';
import 'package:listen/models/user_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listen/services/auth.dart';
import 'package:listen/services/db.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Listengloom"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Material(
          shape: RoundedRectangleBorder(
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
                Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.green, width: 1)),
                    ),
                    child: ListTile(title: Center(child: Text("Language")))),
                Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.green, width: 1)),
                    ),
                    child: ListTile(title: Center(child: Text("Need Help")))),
                Container(
                    decoration: BoxDecoration(
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoTextField(
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: Icon(CupertinoIcons.search),
                ),
                placeholder: "Search psychologist here",
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    6,
                    (idx) => const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: Icon(CupertinoIcons.wand_rays, size: 40),
                                radius: 40,
                              ),
                              const SizedBox(height: 5),
                              Text("Daily Tips")
                            ],
                          ),
                        )),
              ),
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
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const Text("Live Psycologist"),
                  //       TextButton(
                  //           onPressed: () => Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (ctx) =>
                  //                       ViewAllPsy(imges: images))),
                  //           child: const Text("View All")),
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: List.generate(
                  //         6,
                  //         (idx) => Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 8.0, vertical: 8.0),
                  //               child: Container(
                  //                 height:
                  //                     MediaQuery.of(context).size.height * 0.1,
                  //                 width:
                  //                     MediaQuery.of(context).size.height * 0.18,
                  //                 decoration: BoxDecoration(
                  //                     image: DecorationImage(
                  //                         image: CachedNetworkImageProvider(
                  //                             images[idx]),
                  //                         fit: BoxFit.cover),
                  //                     borderRadius: BorderRadius.circular(15)),
                  //               ),
                  //             )),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
