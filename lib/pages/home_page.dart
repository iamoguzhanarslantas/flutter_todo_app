import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/helper/translation_helper.dart';
import 'package:flutter_todo_app/main.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/widgets/custom_search_delegate.dart';
import 'package:flutter_todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTasks = [];
  late LocalStorage localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    allTasks = <Task>[];
    getAllTasksFromDB();
  }

  void getAllTasksFromDB() async {
    allTasks = await localStorage.getAllTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'title',
          style: TextStyle(
            color: Colors.black,
          ),
        ).tr(),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oankiListeElemani = allTasks[index];
                return Dismissible(
                  key: Key(oankiListeElemani.id),
                  //  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'remove_task',
                        ).tr(),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    allTasks.removeAt(index);
                    await localStorage.deleteTask(task: oankiListeElemani);
                    setState(() {});
                    return null;
                  },
                  child: TaskItem(
                    task: oankiListeElemani,
                  ),
                );
              },
              itemCount: allTasks.length,
            )
          : Center(
              child: Text('empty_task_list').tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 21),
                decoration: InputDecoration(
                  hintText: 'add_task'.tr(),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(
                      context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false,
                      onConfirm: (time) async {
                        var newTask = Task.create(
                          name: value,
                          dateTime: time,
                        );
                        allTasks.insert(0, newTask);
                        await localStorage.addTask(task: newTask);
                        setState(() {});
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('min_character').tr(),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSearchPage() async {
    await showSearch(
      context: context,
      delegate: CustomSearchDelegate(allTask: allTasks),
    );
    getAllTasksFromDB();
  }
}
