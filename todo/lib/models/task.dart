class Task {
  final int? id;
  final String title;
  final String description;
  bool _isCompleted = false;

  Task({this.id, required this.title, required this.description});

  bool get completed => _isCompleted;

  void toggleCompletion() {
    _isCompleted = !_isCompleted;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': _isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    ).._isCompleted = map['isCompleted'] == 1;
  }
}