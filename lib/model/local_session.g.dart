// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalSessionAdapter extends TypeAdapter<LocalSession> {
  @override
  final int typeId = 1;

  @override
  LocalSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalSession(
      uid: fields[0] as int,
      email: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalSession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
