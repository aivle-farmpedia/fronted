class AutocompleteItem {
  final String name;
  final int id;

  AutocompleteItem({required this.name, required this.id});

  factory AutocompleteItem.fromJson(Map<String, dynamic> json) {
    return AutocompleteItem(
      name: json['name'],
      id: json['id'],
    );
  }
}
