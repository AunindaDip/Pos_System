class catagorymodel {
  String Name;

  catagorymodel({required this.Name});

  factory catagorymodel.fromJson(Map<String, dynamic> json) {
    return catagorymodel(
      Name: json['Name'],

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
    };
  }
}