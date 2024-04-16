import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteit/models/todo.dart';

const String TODO_COLLECTION_PREF =
    'todos'; //name of collection declared in firestore

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todoRef;

  DatabaseService() {
    _todoRef = _firestore.collection(TODO_COLLECTION_PREF).withConverter<Todo>(
        fromFirestore: (snapshots, _) => Todo.fromJSON(snapshots.data()!),
        toFirestore: (todo, _) => todo.toJSON());
  }

  Stream<QuerySnapshot> getTodos() {
    return _todoRef.snapshots();
  }

  void addTodo(Todo todo) async {
    _todoRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    _todoRef.doc(todoId).update(todo.toJSON());
  }

  void deleteTodo(String todoId) async {
    _todoRef.doc(todoId).delete();
  }
}
