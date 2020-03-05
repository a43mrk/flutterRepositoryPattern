
import 'dart:collection';

import 'api.dart';
import 'database.dart';

class Repository<T extends IModel,A extends User> {
  final HashMap<int,HashMap<int,HashMap<int,T>>> _cacheForPagingByPersonId = HashMap<int,HashMap<int,HashMap<int,T>>>();
  final HashMap<int,HashMap<int,T>> _cacheForPagingList = HashMap<int,HashMap<int,T>>();
  final HashMap<int,T> _cache = HashMap<int,T>();
  final ISource api;
  final ICache db;

  Repository(this.api, this.db);



  // Future<List<T>> exec<L extends Method, R extends Method>(){
  //   if(db == null){
  //     for(var a in db.actions){
  //       if(a is L) {
  //         return db.exec<List<T>>(a);
  //       }
  //     }
  //   } else {
  //     for(var a in api.actions){
  //       if(a is R) return api.exec<List<T>>(a);
  //     }
  //   }
  // }

  Future<List<T>> take({int id, int take, int skip, A auth, Map<String, dynamic> criteria }) async {
    if(_cacheForPagingByPersonId[auth.personId] == null || _cacheForPagingByPersonId[auth.personId][id] == null || !(_cacheForPagingByPersonId[auth.personId][id].length < (take + skip))) {
          try {
            var data = await db.exec<List<T>>(TakeByCriteria(id: id, take: take, skip: skip, criteria: criteria));
            if(data == null || data.length == 0){
              var resp = await api.exec<List<T>>(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                if (resp != null) {
                  for(T item in resp) {
                    item.setSynced();
                    item.created = DateTime.now();
                    item.updated = DateTime.now();
                      int itemId = await db.exec<int>(Add<T>(item));
                      if(item.id == null)
                        item.id = itemId;
                      _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                  }
                  return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
              } else {
                return Future.error("check your internet connection and try again...");
              }
            } else {
              if(_cacheForPagingByPersonId[auth.personId] == null) _cacheForPagingByPersonId[auth.personId] = HashMap();
              if(_cacheForPagingByPersonId[auth.personId][id] == null) _cacheForPagingByPersonId[auth.personId][id] = HashMap();
              data.asMap().forEach((index,item){
                    _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
              });
              return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
            }
          } catch(onError) {
              var resp = await api.exec<List<T>>(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
              if (resp != null) {
                for(T item in resp) {
                    item.setSynced();
                    item.created = DateTime.now();
                    item.updated = DateTime.now();
                    int itemId = await db.exec(Add<T>(item));
                    if(item.id == null) item.id = itemId;
                    if(_cacheForPagingByPersonId[auth.personId] == null) _cacheForPagingByPersonId[auth.personId] = HashMap();
                    if(_cacheForPagingByPersonId[auth.personId][id] == null) _cacheForPagingByPersonId[auth.personId][id] = HashMap();

                    _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                }
                return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
              } else {
                return Future.error("try again after while...");
              }
          }
    } else {
      if(DateTime.now().difference(_cacheForPagingByPersonId[auth.personId][id].values.last.updated).inSeconds > 30 ){
            var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                if (resp != null) {
                  for(T item in resp) {
                    item.setSynced();
                    item.created = DateTime.now();
                    item.updated = DateTime.now();
                      int itemId = await db.exec(Add<T>(item));
                      if(item.id == null)
                        item.id = itemId;
                      _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                  }
                return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
              } else {
                return Future.error("check your internet connection and try again...");
              }
      } else {
        return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
      }
    }
  }

  Future<List<T>> takeByCriteria({int id, int take, int skip, A auth, Map<String, dynamic> criteria }) async {
    try {
        var src = api as ISource;
        if(src is ISource){
          if(id != null){
            if(_cacheForPagingByPersonId[auth.personId] == null || _cacheForPagingByPersonId[auth.personId][id] == null || !(_cacheForPagingByPersonId[auth.personId][id].length < (take + skip))) {
                  try {
                    var data = await db.exec<List<T>>(TakeByCriteria(id: id, take: take, skip: skip, criteria: criteria));
                    if(data == null || data.length == 0){
                      var resp = await api.exec<List<T>>(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                        if (resp != null) {
                          for(T item in resp) {
                            item.setSynced();
                            item.created = DateTime.now();
                            item.updated = DateTime.now();
                              int itemId = await db.exec<int>(Add<T>(item));
                              if(item.id == null)
                                item.id = itemId;
                              _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                          }
                          return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
                      } else {
                        return Future.error("check your internet connection and try again...");
                      }
                    } else {
                      if(_cacheForPagingByPersonId[auth.personId] == null) _cacheForPagingByPersonId[auth.personId] = HashMap();
                      if(_cacheForPagingByPersonId[auth.personId][id] == null) _cacheForPagingByPersonId[auth.personId][id] = HashMap();
                      data.asMap().forEach((index,item){
                            _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                      });
                      return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
                    }
                  } catch(onError) {
                      var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                      if (resp != null) {
                        for(T item in resp) {
                            item.setSynced();
                            item.created = DateTime.now();
                            item.updated = DateTime.now();
                            int itemId = await db.exec(Add<T>(item));
                            if(item.id == null) item.id = itemId;
                            if(_cacheForPagingByPersonId[auth.personId] == null) _cacheForPagingByPersonId[auth.personId] = HashMap();
                            if(_cacheForPagingByPersonId[auth.personId][id] == null) _cacheForPagingByPersonId[auth.personId][id] = HashMap();

                            _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                        }
                        return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
                      } else {
                        return Future.error("try again after while...");
                      }
                  }
            } else {
              if(DateTime.now().difference(_cacheForPagingByPersonId[auth.personId][id].values.last.updated).inSeconds > 30 ){
                    var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                        if (resp != null) {
                          for(T item in resp) {
                            item.setSynced();
                            item.created = DateTime.now();
                            item.updated = DateTime.now();
                              int itemId = await db.exec(Add<T>(item));
                              if(item.id == null)
                                item.id = itemId;
                              _cacheForPagingByPersonId[auth.personId][id][item.id] = item;
                          }
                        return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
                      } else {
                        return Future.error("check your internet connection and try again...");
                      }
              } else {
                return [_cacheForPagingByPersonId[auth.personId][id].values.toList()[skip]];
              }
            }

            } else { // only deal for id == null
              if(_cacheForPagingList[auth.personId] == null || !(_cacheForPagingList[auth.personId].length < (take + skip))) {
                      try {
                        var data = await db.exec(TakeByCriteria(id: id, take: take, skip: skip, criteria: criteria));
                        if(data == null || data.length == 0){
                          var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                            if (resp != null) {
                              for(T item in resp) {
                                item.setSynced();
                                item.created = DateTime.now();
                                item.updated = DateTime.now();
                                  int itemId = await db.exec(Add<T>(item));
                                  if(item.id == null)
                                    item.id = itemId;
                                  if(_cacheForPagingList[auth.personId] == null)
                                    _cacheForPagingList[auth.personId] = HashMap();
                                  _cacheForPagingList[auth.personId][item.id] = item;
                              }
                              return [_cacheForPagingList[auth.personId].values.toList()[skip]];
                          } else {
                            return Future.error("check your internet connection and try again...");
                          }
                        } else {
                          if(_cacheForPagingList[auth.personId] == null) _cacheForPagingList[auth.personId] = HashMap();
                          data.asMap().forEach((index,item){
                                _cacheForPagingList[auth.personId][item.id] = item;
                          });
                          return [_cacheForPagingList[auth.personId].values.toList()[skip]];
                        }
                      } catch(onError) {
                          var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                          if (resp != null) {
                              for(T item in resp) {
                                item.setSynced();
                                item.created = DateTime.now();
                                item.updated = DateTime.now();
                                int itemId = await db.exec(Add<T>(item));
                                if(item.id == null) item.id = itemId;
                                if(_cacheForPagingList[auth.personId] == null) _cacheForPagingList[auth.personId] = HashMap();

                                _cacheForPagingList[auth.personId][item.id] = item;
                            }
                            return [_cacheForPagingList[auth.personId].values.toList()[skip]];
                          } else {
                            return Future.error("try again after while...");
                          }
                      }
                } else {
                  if(DateTime.now().difference(_cacheForPagingList[auth.personId].values.last.updated).inSeconds > 30 ){
                                        var resp = await api.exec(TakeByCriteria(id: id, take: take, skip: skip, auth: auth, criteria: criteria));
                            if (resp != null) {
                              for(T item in resp) {
                                item.setSynced();
                                item.created = DateTime.now();
                                item.updated = DateTime.now();
                                  int itemId = await db.exec(Add<T>(item));
                                  if(item.id == null)
                                    item.id = itemId;
                                  _cacheForPagingList[auth.personId][item.id] = item;
                              }
                            return [_cacheForPagingList[auth.personId].values.toList()[skip]];
                          } else {
                            return Future.error("check your internet connection and try again...");
                          }
                  } else {
                    return [_cacheForPagingList[auth.personId].values.toList()[skip]];
                  }
                }
            }
          } else {
          return Future.error("wrong type was given");
        }
    } on Exception {
      // logout user
      // Vawait locator.get<SharedPreferences>().clear();
      // clearCache();
      // locator.get<NavigationService>().navigateOneWay( DomainSelectionScreen.routeName);
    }
  }

    Future<T> add(T data,{ A credential }) async {
    if( credential == null){
      try{
        int tmp = await db.exec(Add(data));
        data.created = DateTime.now();
        data.updated = DateTime.now();
        if(data.id == null)
          data.id = tmp;
        _cache[tmp] = data;
        return _cache[tmp];
      } catch(e){
        return Future.error(e);
      }
    } else {
      try {
        if(api is ISource){
          var src = api as ISource;
          int sig;
            try {
              data.created = DateTime.now();
              T resp = await api.exec(Post(data, credential));
              if (resp != null && resp is! Error) {
                  if(!data.isSynced){
                    data.setSynced();
                    data.updated = DateTime.now();
                    data.id = resp.id; // id or signal code?
                    sig = await db.exec(Add(data)); // unwrap int
                    if (sig != null){
                      data.id = sig; // or set id from database;
                      _cache[sig] = data;
                      return data;
                    }
                  } else {
                    return data;
                  }
              }
            } catch(onError) {
              return Future.error("update failed try again...");
            }
        } else {
          return Future.error("your source is read only.");
        }
      } on Exception {
        // logout user
        // await locator.get<SharedPreferences>().clear();
        // clearCache();
        // locator.get<NavigationService>().navigateOneWay( DomainSelectionScreen.routeName);
      }
    }
  }

}

abstract class Method<S,T> {

  Future<T> apply(S s);
}

abstract class Executable {

  Future<T> exec<T>(Method s);
}

abstract class Take<T> implements Executable{
  Future<T> takeByCriteria(Method s);
}


abstract class IModel{
  int id;
  int parentId;
  DateTime created;
  DateTime updated;
  bool isSynced;

  setSynced();
}


// TODO: try to manage an list of callbacks? (){} with specific signatures?
abstract class ICache<S,T> implements Executable {
  // final Set<Method> actions;

  // ICache(this.actions);

  // void addAction(Method action);
}

abstract class ISource<S,T> implements Executable {
  // final Set<Method> actions;

  // ISource(this.actions);

  // void addAction(Method action);
}


