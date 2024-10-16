import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
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
      appBar: AppBar(),
      body: psychologist == null
          ? Column(
              children: [
                Text(user!.name),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              psychologist!.displayProfile)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ExpandableText(
                              psychologist!.name,
                              maxLines: 2,
                              expandText: "more",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
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
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ExpandableText(
                                psychologist!.psychologistTitle,
                                maxLines: 2,
                                expandText: ""),
                          ),
                          Text(
                              "${psychologist!.yearsOfExperience.toString()} Year Of Experience"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, thickness: 1, color: Colors.black12),
                  Text("Reviews And Rating",
                      style: Theme.of(context).textTheme.headlineSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        psychologist!.ratingsReviews.averageRating.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      AnimatedRatingStars(
                        initialRating:
                            psychologist!.ratingsReviews.averageRating,
                        onChanged: (double rating) {},
                        filledColor: Colors.amber,
                        emptyColor: Colors.grey,
                        filledIcon: Icons.star,
                        halfFilledIcon: Icons.star_half,
                        emptyIcon: Icons.star_border,
                        displayRatingValue: true,
                        interactiveTooltips: true,
                        customFilledIcon: Icons.star,
                        customHalfFilledIcon: Icons.star_half,
                        customEmptyIcon: Icons.star_border,
                        starSize: 40.0,
                        animationDuration: const Duration(milliseconds: 100),
                        animationCurve: Curves.easeInOut,
                        readOnly: true,
                      ),
                    ],
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.black54),
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
                                  style: Theme.of(context).textTheme.bodyLarge),
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
                                  Text(x.comment),
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
                  )
                ],
              ),
            ),
    );
  }
}
