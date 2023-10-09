class AcceptanceMultiSelectionModel {
  final String title;
  bool isSelected;

  AcceptanceMultiSelectionModel({
    required this.isSelected,
    required this.title,
  });

  factory AcceptanceMultiSelectionModel.fromJson(Map<String, dynamic> json) {
    return AcceptanceMultiSelectionModel(
      isSelected: json['isSelected'],
      title: json['title'],
    );
  }
}
