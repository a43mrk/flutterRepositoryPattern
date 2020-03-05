
import 'api.dart';
import 'repository.dart';

class FetchAll implements Method<UserModel,List<User>> {
  final int id;

  FetchAll(this.id);

  @override
  Future<List<User>> apply( UserModel s) {
    return s.selectAll(this);
  }
}

class TakeByCriteria implements Method<UserModel,List<User>> {
  final int id;
  final int take;
  final int skip;
  final User auth;
  final Map<String,dynamic> criteria;

  TakeByCriteria({this.criteria, this.id, this.skip, this.take, this.auth});

  @override
  Future<List<User>> apply(Executable s) {
    if(s is UserModel){
      return s.takeByCriteria(this);
    } else if( s is UserApi){
      return s.takeByCriteria(this);
    } else {
      return Future.error('cannot apply this state.');
    }
  }
 }

class FetchOne implements Method<UserModel,User> {
  final id;

  FetchOne(this.id);

  @override
  Future<User> apply(UserModel s) {
    return s.selectOne(this);
  }
}

class WriteOne implements Method<UserModel, int> {
  final User usr;
  WriteOne(this.usr);

  @override
  Future<int> apply(UserModel s) {
    return s.write(this);
  }
}

class Add<T> implements Method<UserModel, int> {
  final T usr;
  Add(this.usr);

  @override
  Future<int> apply(UserModel s) {
    return s.add(this);
  }
}

class UserModel implements ICache<UserModel, User> {
  // @override
  // final Set<Method> actions;

  // UserModel({Set acts}):this.actions = acts != null ? acts : Set<Method>();

  // @override
  // void addAction(Method action){
  //   print('adding action...');
  //   actions.add(action);
  // }

  Future<List<User>> selectAll(FetchAll state) async {
    print("selecting everything...");
    return [User(name: "Marry", personId: state.id )];
  }

  Future<User> selectOne(FetchOne state) async {
    print("selecting from ....");
    return User(name: "john", personId: state.id);
  }

  Future<int> write(WriteOne state) async {
    print("writing...");
    return 1;
  }

  Future<int> add(Add state) async {
    print("adding...");
    return state.usr.personId + 1;
  }

  Future<bool> update(User usr) async {
    print("updating user...");
    return true;
  }

  delete(int id){
    print("dropping $id");
    return id;
  }

  Future<List<User>> takeByCriteria(Method state) async {
    if(state is TakeByCriteria){
      print("got list..");
      return [User(name: "Don", personId: state.id)];
    } else {
      return Future.error("no data");
    }
  }



  @override
  Future<T> exec<T>(Method s) {
    // if(s is Take){
    //   return s.takeByCriteria({});
    // } else {
    //   return Future.error("cannot execute this method.");
    // }
    return s.apply(this);
  }


}


class User extends IModel {
  final String name;
  final int personId;

  User({
    this.name,
    this.personId,
  });

  @override
  String toString() {
    return "Hi im $name!";
  }

  @override
  setSynced() {
    print('sync done.');
  }
}