// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class musicListAdapter extends TypeAdapter<musicList> {
  @override
  final int typeId = 0;

  @override
  musicList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return musicList(
      title: fields[0] as String,
      uri: fields[1] as String,
      id: fields[2] as int,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, musicList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is musicListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
