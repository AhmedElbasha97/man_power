class HomeSlider {
  HomeSlider({
    this.sliderid,
    this.title,
    this.picpath,
  });

  String? sliderid;
  String? title;
  String? picpath;

  factory HomeSlider.fromJson(Map<String, dynamic> json) => HomeSlider(
        sliderid: json["sliderid"],
        title: json["title"],
        picpath: json["picpath"],
      );
}
