

import 'api.dart';
import 'database.dart';
import 'repository.dart';

class Bloc {
  final Repository _repository = Repository<User,User>(UserApi(), UserModel());

  // Future<String> fetchAll(int id) async {
  //   _repository.api.addAction(GetAll(id));
  //   _repository.db.addAction(FetchAll(id));
  //   List<User> result = await _repository.exec<FetchAll,GetAll>();
  //   for(var item in result){
  //     // _repository.db.addAction(WriteOne(item));
  //     _repository.add(item, credential: item);
  //   }
  //   return result.first.name.toString();
  // }

  Future<String> take(int id) async {
    // _repository.api.addAction(GetAll(id));
    // _repository.db.addAction(FetchAll(id));
    List<User> result = await _repository.take(id: id, auth: User(personId: 21), skip: 0, take: 1);
    return result.first.name.toString();
  }
}