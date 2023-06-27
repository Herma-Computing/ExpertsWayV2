class Message {
  String name;
  String message;
  Message({required this.name, required this.message});
}

List<Message> notifMessages = [
  Message(
      name: "finishedCourse", message: "Congratualtions, You have finished"),
  Message(
      name: "questionReply",
      message: "has replied to your question on the forum"),
  Message(name: "quiz", message: "You have a quiz on"),
  Message(name: "newCourse", message: "New course has been launched"),
];
