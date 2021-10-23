class Anime {
  int animeId = 0;
  String animeName = '';
  String animeImg = '';

  Anime(
      {required this.animeId, required this.animeName, required this.animeImg});

  Anime.fromJson(Map<String, dynamic> json) {
    animeId = json['anime_id'];
    animeName = json['anime_name'];
    animeImg = json['anime_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['anime_id'] = animeId;
    data['anime_name'] = animeName;
    data['anime_img'] = animeImg;
    return data;
  }
}
