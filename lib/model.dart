
class Note{
  final int? id;
  final String title ;
  final String content;
  final DateTime createdAt;

  // class constructor
  Note({this.id ,required this.title , required this.content, this.DateTime});

  // Convert note to map insertion
  Map<String ,dynamic> ToMap(){
    return {
      'id': id,
      'title':title ,
      'content' :content,
      'cratedAt' : createdAt.toIso8601String()
      
    };
  }

  // Create note from map
  factory Note.fromMap(Map<String,dynamic> map){
    return Note(
      id: map['id'] as int ,
      title : map['title'] as String ,
      content : map['content'] as String,
      createdAt : DateTime.parse(map['createdAt'] as String),
    )
  }

  // Extension -> Creates copy with method for the note class -> Update the object value
  extension NoteCopy on Note{
    Note copyWith({int? id , String? title ,String? content ,DateTime? created}){
      return Note(id : id?? this.id , title :title?? this.title, content: content?? this.content ,createdAt: createdAt?? this.createdAt);
    }
  }
}