class TempData {
  TempData() {
    createPsychologistList(psyData, profilePic);
  }

  List<String> profilePic = [
    'https://images.pexels.com/photos/18892681/pexels-photo-18892681/free-photo-of-blonde-model-in-shadow.jpeg',
    'https://images.pexels.com/photos/15037721/pexels-photo-15037721/free-photo-of-man-sitting-on-chair.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6480700/pexels-photo-6480700.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/17360606/pexels-photo-17360606/free-photo-of-beautiful-woman-in-white-tank-top.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/11041295/pexels-photo-11041295.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/19794933/pexels-photo-19794933/free-photo-of-beautiful-bride-with-flowers.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/18398363/pexels-photo-18398363/free-photo-of-woman-in-white-shirt.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/12225939/pexels-photo-12225939.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/27928237/pexels-photo-27928237/free-photo-of-young-woman-in-white-crochet-dress-and-jewelry.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/16094696/pexels-photo-16094696/free-photo-of-face-of-smiling-woman.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ];

  List<Map<String, dynamic>> psyData = [
    {
      "uid": "EWaa6QEIrggJWzihp8oIcQnDFNE3",
      "name": "Dr. Emily Smith",
      "psychologist_title": "Clinical Psychologist",
      "specialization": "Cognitive Behavioral Therapy",
      "years_of_experience": 10,
      "languages_spoken": ["English", "Spanish"],
      "displayProfile": "emily_smith.jpg",
      "ratings_reviews": {
        "average_rating": 4.7,
        "reviews": [
          {
            "review_id": "b27f41c5-9a85-4bd3-9a2f-c3c4c3d5fa0c",
            "reviewer_name": "John Doe",
            "rating": 5,
            "comment":
                "Dr. Smith was very attentive and helped me through tough times."
          },
          {
            "review_id": "d9f8f92e-593a-4d1c-ae4d-cb6e9de67db6",
            "reviewer_name": "Jane Roe",
            "rating": 4,
            "comment": "Great experience, but had to wait for my appointment."
          }
        ]
      }
    },
    {
      "uid": "a94f56a7-b1c1-432f-86c7-1c1e7c28ef9f",
      "name": "Dr. Michael Johnson",
      "psychologist_title": "Child Psychologist",
      "specialization": "Developmental Psychology",
      "years_of_experience": 15,
      "languages_spoken": ["English", "French"],
      "displayProfile": "michael_johnson.jpg",
      "ratings_reviews": {
        "average_rating": 4.9,
        "reviews": [
          {
            "review_id": "d87c4f71-5c24-4c61-88d1-8a2a6bb33ad7",
            "reviewer_name": "Sarah Lee",
            "rating": 5,
            "comment":
                "Dr. Johnson really connected with my child and helped us tremendously."
          },
          {
            "review_id": "c85c1bde-b12d-4e19-91e9-4a2ef9f4529d",
            "reviewer_name": "Alice Wong",
            "rating": 4.8,
            "comment": "Very professional and knowledgeable in child behavior."
          }
        ]
      }
    },
    {
      "uid": "b1f5f82b-3f25-45c4-9a8b-9c3f1d37a6b2",
      "name": "Dr. Anna Taylor",
      "psychologist_title": "Forensic Psychologist",
      "specialization": "Criminal Behavior Analysis",
      "years_of_experience": 8,
      "languages_spoken": ["English"],
      "displayProfile": "anna_taylor.jpg",
      "ratings_reviews": {
        "average_rating": 4.6,
        "reviews": [
          {
            "review_id": "d95f3bbd-8f42-43f8-a93d-3bcb9f709a5b",
            "reviewer_name": "Michael Brown",
            "rating": 4.5,
            "comment":
                "Dr. Taylor provided insightful guidance during the case."
          },
          {
            "review_id": "bb2df7c8-6238-4a9f-8d6b-528f3bfa1d0a",
            "reviewer_name": "Angela Green",
            "rating": 4.7,
            "comment": "Extremely professional and dedicated."
          }
        ]
      }
    },
    {
      "uid": "9f67b6a4-7d72-45eb-a0ed-19adfd6d63ef",
      "name": "Dr. James White",
      "psychologist_title": "Neuropsychologist",
      "specialization": "Brain Injury Rehabilitation",
      "years_of_experience": 12,
      "languages_spoken": ["English", "German"],
      "displayProfile": "james_white.jpg",
      "ratings_reviews": {
        "average_rating": 4.8,
        "reviews": [
          {
            "review_id": "3b81a65c-46b8-4e27-914b-9f8b92f4bbdc",
            "reviewer_name": "Olivia Clark",
            "rating": 5,
            "comment":
                "Dr. White was fantastic in helping me recover from a concussion."
          },
          {
            "review_id": "1e8fcb2d-44d7-46b2-9f88-54f264ce1a71",
            "reviewer_name": "Liam Lewis",
            "rating": 4.9,
            "comment": "Very knowledgeable in his field."
          }
        ]
      }
    },
    {
      "uid": "7421c9fe-8721-46b7-9e34-f45f46f0e8c8",
      "name": "Dr. Olivia Martinez",
      "psychologist_title": "Health Psychologist",
      "specialization": "Chronic Illness Management",
      "years_of_experience": 9,
      "languages_spoken": ["English", "Spanish"],
      "displayProfile": "olivia_martinez.jpg",
      "ratings_reviews": {
        "average_rating": 4.5,
        "reviews": [
          {
            "review_id": "9e5e9b9e-15e5-49f9-84c9-0e6d75b2f9e5",
            "reviewer_name": "Ethan Robinson",
            "rating": 4.4,
            "comment": "Dr. Martinez helped me cope with my chronic pain."
          },
          {
            "review_id": "fc7f6c87-88f5-4701-aea9-fcb37dd4b9b5",
            "reviewer_name": "Sophia Garcia",
            "rating": 4.6,
            "comment": "Kind and understanding."
          }
        ]
      }
    },
    {
      "uid": "4eb6db7b-84a3-4873-bc4f-7c12dfe9a769",
      "name": "Dr. William Lee",
      "psychologist_title": "Sports Psychologist",
      "specialization": "Performance Anxiety",
      "years_of_experience": 11,
      "languages_spoken": ["English", "Korean"],
      "displayProfile": "william_lee.jpg",
      "ratings_reviews": {
        "average_rating": 4.9,
        "reviews": [
          {
            "review_id": "2b98d6f7-cd4f-456a-8417-d34a7fcb835b",
            "reviewer_name": "Jacob Wright",
            "rating": 5,
            "comment": "Dr. Lee helped me improve my mental game as an athlete."
          },
          {
            "review_id": "4ef6dbf8-cc14-4b71-8c56-b1c6e44eb962",
            "reviewer_name": "Charlotte Harris",
            "rating": 4.8,
            "comment": "Fantastic advice on managing performance anxiety."
          }
        ]
      }
    },
    {
      "uid": "e843a2e3-604a-4f76-b3b4-0b9e20b25e35",
      "name": "Dr. Evelyn Patel",
      "psychologist_title": "Counseling Psychologist",
      "specialization": "Relationship Counseling",
      "years_of_experience": 7,
      "languages_spoken": ["English", "Hindi"],
      "displayProfile": "evelyn_patel.jpg",
      "ratings_reviews": {
        "average_rating": 4.6,
        "reviews": [
          {
            "review_id": "ff7c948e-2b4d-40d1-b34d-bc64f53f69bc",
            "reviewer_name": "Amelia Martinez",
            "rating": 4.7,
            "comment":
                "Dr. Patel really helped improve communication in our marriage."
          },
          {
            "review_id": "fc82d623-8b19-4b98-bcd3-27f1dfd82465",
            "reviewer_name": "Daniel Turner",
            "rating": 4.6,
            "comment": "Insightful and empathetic."
          }
        ]
      }
    },
    {
      "uid": "a5b4d9d7-f5f5-4d71-b3c9-2f5a5b46c1a2",
      "name": "Dr. Daniel Harris",
      "psychologist_title": "Industrial-Organizational Psychologist",
      "specialization": "Workplace Behavior",
      "years_of_experience": 14,
      "languages_spoken": ["English", "French"],
      "displayProfile": "daniel_harris.jpg",
      "ratings_reviews": {
        "average_rating": 4.8,
        "reviews": [
          {
            "review_id": "9c2c5f3f-f9e5-4b58-8c9f-9316e99f7b29",
            "reviewer_name": "David Gonzalez",
            "rating": 4.9,
            "comment":
                "Dr. Harris provided great insights into improving team dynamics."
          },
          {
            "review_id": "af8f5c79-fc18-48e9-953b-cfc6b5e52f74",
            "reviewer_name": "Emma Cooper",
            "rating": 4.7,
            "comment": "Very experienced in organizational behavior."
          }
        ]
      }
    },
    {
      "uid": "d23a7f92-8c9d-4fb9-b276-bd6c819b6224",
      "name": "Dr. Grace Kim",
      "psychologist_title": "Clinical Neuropsychologist",
      "specialization": "Neurodegenerative Diseases",
      "years_of_experience": 13,
      "languages_spoken": ["English", "Korean"],
      "displayProfile": "grace_kim.jpg",
      "ratings_reviews": {
        "average_rating": 4.7,
        "reviews": [
          {
            "review_id": "c65f6c3b-bf37-4b5d-9106-92a6e6a1e95c",
            "reviewer_name": "Mia Adams",
            "rating": 4.8,
            "comment":
                "Dr. Kim was extremely helpful in managing my father's dementia."
          },
          {
            "review_id": "f87a5c99-1a6f-43d6-bfbf-33889b6f7289",
            "reviewer_name": "Benjamin Parker",
            "rating": 4.7,
            "comment": "Very patient and knowledgeable."
          }
        ]
      }
    },
    {
      "uid": "7c6a5f32-98af-41d3-825e-2f91c9b1b987",
      "name": "Dr. Nathan Allen",
      "psychologist_title": "Educational Psychologist",
      "specialization": "Learning Disabilities",
      "years_of_experience": 9,
      "languages_spoken": ["English", "Spanish"],
      "displayProfile": "nathan_allen.jpg",
      "ratings_reviews": {
        "average_rating": 4.6,
        "reviews": [
          {
            "review_id": "e98c5b47-2a9a-4d16-824f-935b5d84761b",
            "reviewer_name": "Harper Peterson",
            "rating": 4.7,
            "comment":
                "Dr. Allen helped my son overcome his learning challenges."
          },
          {
            "review_id": "5f6b7f52-4a4b-4d35-a1d1-598e73c41263",
            "reviewer_name": "Lucas Powell",
            "rating": 4.5,
            "comment": "Great at identifying learning barriers."
          }
        ]
      }
    },
    {
      "uid": "c88d7c95-8a48-46f9-9dc1-4b36fb0f96e7",
      "name": "Dr. Chloe Green",
      "psychologist_title": "Geriatric Psychologist",
      "specialization": "Aging and Mental Health",
      "years_of_experience": 10,
      "languages_spoken": ["English", "French"],
      "displayProfile": "chloe_green.jpg",
      "ratings_reviews": {
        "average_rating": 4.8,
        "reviews": [
          {
            "review_id": "8d6c8b5b-7e7a-4f45-9181-57f635f43b5e",
            "reviewer_name": "Mason Bell",
            "rating": 5,
            "comment": "Dr. Green helped my grandmother through her depression."
          },
          {
            "review_id": "5f4c2e6d-b45d-4d1d-847c-7d96f6d0c647",
            "reviewer_name": "Isabella Price",
            "rating": 4.7,
            "comment": "Very compassionate and understanding."
          }
        ]
      }
    }
  ];

  List<Psychologist> psychologistList = [];

  void createPsychologistList(
      List<Map<String, dynamic>> jsonData, List<String> profilePictures) {
    for (int i = 0; i < jsonData.length; i++) {
      // Assign profile picture based on the index (or use any custom logic)
      jsonData[i]['displayProfile'] = profilePic[i % profilePic.length];

      // Create a Psychologist object from the JSON data
      Psychologist psychologist = Psychologist.fromJson(jsonData[i]);

      // Add the psychologist object to the list
      psychologistList.add(psychologist);
    }
  }
}

class Psychologist {
  final String uid;
  final String name;
  final String psychologistTitle;
  final String specialization;
  final int yearsOfExperience;
  final List<String> languagesSpoken;
  final String displayProfile;
  final RatingsReviews ratingsReviews;

  Psychologist({
    required this.uid,
    required this.name,
    required this.psychologistTitle,
    required this.specialization,
    required this.yearsOfExperience,
    required this.languagesSpoken,
    required this.displayProfile,
    required this.ratingsReviews,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) {
    return Psychologist(
      uid: json['uid'],
      name: json['name'],
      psychologistTitle: json['psychologist_title'],
      specialization: json['specialization'],
      yearsOfExperience: json['years_of_experience'],
      languagesSpoken: List<String>.from(json['languages_spoken']),
      displayProfile: json['displayProfile'],
      ratingsReviews: RatingsReviews.fromJson(json['ratings_reviews']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'psychologist_title': psychologistTitle,
      'specialization': specialization,
      'years_of_experience': yearsOfExperience,
      'languages_spoken': languagesSpoken,
      'displayProfile': displayProfile,
      'ratings_reviews': ratingsReviews.toJson(),
    };
  }
}

class RatingsReviews {
  final double averageRating;
  final List<Review> reviews;

  RatingsReviews({
    required this.averageRating,
    required this.reviews,
  });

  factory RatingsReviews.fromJson(Map<String, dynamic> json) {
    return RatingsReviews(
      averageRating: json['average_rating'].toDouble(),
      reviews: List<Review>.from(
          json['reviews'].map((review) => Review.fromJson(review))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

class Review {
  final String reviewId;
  final String reviewerName;
  final double rating;
  final String comment;

  Review({
    required this.reviewId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      reviewerName: json['reviewer_name'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'reviewer_name': reviewerName,
      'rating': rating,
      'comment': comment,
    };
  }
}
