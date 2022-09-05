class Base1 {
  String name;

  Base1({required this.name}) : assert(name != null);
}

class D1 {
  int age;

  D1({required this.age});

  D1.show(int value)
      : age = value,
        assert(value > 0) {
    print("age = $age");
  }
}
