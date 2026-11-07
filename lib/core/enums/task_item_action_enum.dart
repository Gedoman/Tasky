enum TaskItemActionEnum {
  delete(name: "Delete"),
  edit(name: "Edit");

  final String name;
  const TaskItemActionEnum({required this.name});
}