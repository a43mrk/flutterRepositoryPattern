
import 'database.dart';
import 'repository.dart';

class TakeByCriteriaApi implements Method<UserApi,List<User>> {
  final int id;
  final int take;
  final int skip;
  final User auth;
  final Map<String,dynamic> criteria;

  TakeByCriteriaApi({this.criteria, this.id, this.skip, this.take, this.auth});

  @override
  Future<List<User>> apply(UserApi s) {
    return s.takeByCriteria(this);
  }
 }

class GetAll implements Method<UserApi,List<User>> {
  final id;

  GetAll(this.id);

  @override
  Future<List<User>> apply(UserApi s) {
    return s.selectAll(this);
  }
}

class GetOne implements Method<UserApi,User> {
  final id;

  GetOne(this.id);

  @override
  Future<User> apply( UserApi s) {
    return s.selectOne(this);
  }
}

class Post<T> implements Method<UserApi, int> {
  final User auth;
  final T usr;
  Post(this.usr, this.auth);

  @override
  Future<int> apply(UserApi s) {
    return s.write(this);
  }
}

class UserApi implements ISource<UserApi, User> {
  @override
  final Set<Method> actions;

  UserApi({Set acts}):this.actions = acts != null ? acts : Set<Method>();

  @override
  void addAction(Method action){
    print("posting item");
    actions.add(action);
  }

  Future<List<User>> selectAll(GetAll state) async {
    print("fetching all items...");
    return [User(name: "Ali", personId: state.id)];
  }

  Future<User> selectOne(GetOne state) async {
    print("fetching one item...");
    return User(name: "Mahomet", personId: state.id);
  }

  Future<int> write(Post state) async {
    print('putting...');
    return state.usr.personId;
  }

  delete(int id){
    print("deleting...");
    return id;
  }

  Future<List<User>> takeByCriteria(TakeByCriteriaApi state) async {
    return [User(name: "Offf", personId: state.id)];
  }

  @override
  Future<T> exec<T>(Method s) {
    return s.apply(this);
  }

}
