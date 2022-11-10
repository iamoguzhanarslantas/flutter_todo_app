import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController taskNameController = TextEditingController();
  late LocalStorage localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: InkWell(
          child: Icon(
            widget.task.isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: widget.task.isCompleted ? Colors.green : Colors.red,
            size: 28,
          ),
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            localStorage.updateTask(task: widget.task);
            setState(() {});
          },
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
            : TextField(
                controller: taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (newValue) {
                  if (newValue.length > 3) {
                    widget.task.name = newValue;
                    localStorage.updateTask(task: widget.task);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:  Text('min_character').tr(),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.dateTime),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
