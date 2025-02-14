import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listen/models/temp_data.dart';
import 'package:listen/models/user_app.dart';

class UserPage extends StatelessWidget {
  final FUsers? user;
  final Psychologist? psychologist;
  const UserPage({super.key, required this.user, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: psychologist == null
          ? Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user!.displayProfile),
                      radius: 75),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Name"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: user!.name,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: to make the border rounded
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Gender"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: {"F": "Female", "M": "Male"}[user!.gender],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: to make the border rounded
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Email"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: user!.email,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: to make the border rounded
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("DOB"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText:
                              user!.dob.toDate().toString().substring(0, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: to make the border rounded
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: CachedNetworkImageProvider(
                                      psychologist!.displayProfile),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                        "${psychologist!.ratingsReviews.averageRating.toString()} "),
                                    AnimatedRatingStars(
                                      initialRating: psychologist!
                                          .ratingsReviews.averageRating,
                                      onChanged: (double rating) {},
                                      filledColor: CupertinoColors.activeGreen,
                                      emptyColor: Colors.grey,
                                      filledIcon: Icons.star,
                                      halfFilledIcon: Icons.star_half,
                                      emptyIcon: Icons.star_border,
                                      displayRatingValue: true,
                                      interactiveTooltips: true,
                                      customFilledIcon: Icons.star,
                                      customHalfFilledIcon: Icons.star_half,
                                      customEmptyIcon: Icons.star_border,
                                      starSize: 10.0,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                      animationCurve: Curves.easeInOut,
                                      readOnly: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  psychologist!.name,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "Specialization",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: Colors.grey),
                                ),
                                Text(
                                  psychologist!.specialization,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.black),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ExpandableText(
                                    psychologist!.psychologistTitle,
                                    maxLines: 2,
                                    expandText: "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                                Text(
                                  "${psychologist!.yearsOfExperience.toString()} Year Of Experience",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Languages Spoken",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: psychologist!.languagesSpoken
                                      .map((x) => Text(
                                            "$x ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(color: Colors.black),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: CupertinoColors.systemGreen.withOpacity(0.27)),
                  const AnimatedSize(
                    duration: Duration(milliseconds: 300), // Animation duration
                    curve: Curves.easeInOut, // Smooth animation curve
                    child: ExpandableText(
                      "I am a compassionate and experienced psychologist specializing in helping individuals navigate life's challenges. "
                      "With expertise in cognitive-behavioral therapy, mindfulness, and trauma recovery, I provide personalized care tailored to each client’s unique needs. "
                      "Committed to fostering growth and resilience, I empower clients to achieve emotional well-being and lead fulfilling lives.",
                      expandText: "show more",
                      collapseText: "show less",
                      maxLines: 3,
                      linkColor: Colors.green,
                      expandOnTextTap: true,
                      collapseOnTextTap: true,
                    ),
                  ),
                  Divider(color: CupertinoColors.systemGreen.withOpacity(0.27)),
                  Text("User Review",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: psychologist!.ratingsReviews.reviews
                        .map(
                          (x) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(x.reviewerName,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Comments",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: Colors.grey),
                                  ),
                                  Text(x.comment,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(x.rating.toString()),
                                      AnimatedRatingStars(
                                        initialRating: x.rating,
                                        onChanged: (double rating) {},
                                        filledColor: Colors.green,
                                        emptyColor: Colors.grey,
                                        filledIcon: Icons.star,
                                        halfFilledIcon: Icons.star_half,
                                        emptyIcon: Icons.star_border,
                                        displayRatingValue: true,
                                        interactiveTooltips: true,
                                        customFilledIcon: Icons.star,
                                        customHalfFilledIcon: Icons.star_half,
                                        customEmptyIcon: Icons.star_border,
                                        starSize: 15.0,
                                        animationDuration:
                                            const Duration(milliseconds: 100),
                                        animationCurve: Curves.easeInOut,
                                        readOnly: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.black),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
