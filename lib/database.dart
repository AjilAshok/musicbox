import 'package:hive_flutter/hive_flutter.dart';

part 'database.g.dart';

@HiveType(typeId: 0)
class musicList extends HiveObject{
  musicList({required this.title,required this.uri,required this.id,required this.duration});


  @HiveField(0)
  String title;
  @HiveField(1)
  String uri;
  @HiveField(2)
  int id;
  @HiveField(3)
  int duration;
}