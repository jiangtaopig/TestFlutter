class Student {
  String name;
  int age;

  Student({required this.name, required this.age});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is Student) {
      return other.runtimeType == this.runtimeType &&
          other.name == this.name &&
          other.age == this.age;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + name.hashCode;
    result = 37 * result + age.hashCode;
    return result;
  }
}
