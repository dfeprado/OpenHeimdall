import 'dart:core';
import 'dart:convert';

const TIMESTAMP_KEY = 'timestamp';
const TYPE_KEY = 'type';
const SCOPE_KEY = 'scope';
const MESSAGE_KEY = 'message';
const PROGRAM_KEY = 'program';

class ErrorPost {
  late DateTime _timestamp;
  late String _type;
  late String _scope;
  late String _message;
  late String _program;

  ErrorPost(this._timestamp, this._program, this._scope, this._type, this._message);

  ErrorPost.fromJson(String jsonString) {
    var json = jsonDecode(jsonString) as Map;

    if (!json.containsKey(TIMESTAMP_KEY) || !json.containsKey(TYPE_KEY) || !json.containsKey(SCOPE_KEY) || !json.containsKey(MESSAGE_KEY) || !json.containsKey(PROGRAM_KEY)) {
      throw FormatException('Wrong body format');
    }

    _timestamp = DateTime.parse(json[TIMESTAMP_KEY]);
    _type = json[TYPE_KEY];
    _scope = json[SCOPE_KEY];
    _message = json[MESSAGE_KEY];
    _program = json[PROGRAM_KEY];
  } 

  Map<String, dynamic> toJson() => {
    'timestamp': _timestamp.toIso8601String(),
    'program': _program,
    'scope': _scope,
    'type': _type,
    'message': _message
  };

  DateTime get timestamp => _timestamp;
  String get type => _type;
  String get scope => _scope;
  String get message => _message;
  String get program => _program;
}