class ImageModel {
  final int id;
  final String imageData;

  ImageModel({required this.id, required this.imageData});

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'] as int,
      imageData: map['imageData'] as String,
    );
  }
}
