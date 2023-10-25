class Story {
  final int storyTrendingPosition;
  final String storyTitle;
  final String storyAuthor;

  factory Story.fromData(Map<String, dynamic> data) => Story(
    storyTrendingPosition: data['id'],
    storyTitle: data['title'],
    storyAuthor: data['by']
  );

  Story({
     required this.storyTrendingPosition, 
     required this.storyTitle, 
     required this.storyAuthor
    });
}