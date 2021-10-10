class ExampleModelUser {
  static const name = 'name';
}

abstract class ExampleModelCollection {
  final String collectionName;

  const ExampleModelCollection(this.collectionName);

  @override
  String toString() {
    return collectionName;
  }
}

class ExampleModelUserCollection extends ExampleModelCollection {
  ExampleModelUserCollection() : super('users');
  final name = ExampleModelUser.name;
}

class ExampleModel {
  static final users = ExampleModelUserCollection();
}
