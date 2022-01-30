class About {
  About({
    this.aboutid,
    this.title,
    this.text,
    this.video,
  });

  String? aboutid;
  String? title;
  String? text;
  String? video;

  factory About.fromJson(Map<String, dynamic> json) => About(
        aboutid: json["aboutid"] == null ? null : json["aboutid"],
        title: json["title"] == null ? null : json["title"],
        text: json["text"] == null ? null : json["text"],
        video: json["video"] == null ? null : json["video"],
      );
}
