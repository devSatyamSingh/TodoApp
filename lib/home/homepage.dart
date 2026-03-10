import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../splashscreen.dart';

class HomePages extends StatefulWidget {
  HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  String userName = "User";
  bool isProcessing = false;

  TextEditingController taskController = TextEditingController();

  Set<int> expandedTasks = {};

  @override
  void initState() {
    super.initState();
    loadUserName();
    Future.microtask(() => context.read<TaskProvider>().loadTasks());
  }

  void loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final provider = context.watch<TaskProvider>();

    List tasks = provider.tasks;

    int totalTasks = tasks.length;

    int completedTasks = tasks
        .where((task) => task["completed"] == true)
        .length;

    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog();
        return exitApp;

      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showTaskDialog,
          backgroundColor: Colors.cyan,
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Task",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
        body: Column(
          children: [
            /// -------- APP BAR --------
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: h * 0.06,
                left: w * 0.05,
                right: w * 0.05,
                bottom: h * 0.018,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.cyanAccent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(w * 0.08),
                  bottomRight: Radius.circular(w * 0.08),
                ),
              ),
      
              child: Row(
                children: [
                  CircleAvatar(
                    radius: w * 0.06,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.cyan, size: w * 0.07),
                  ),
      
                  SizedBox(width: w * 0.04),
      
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello 👋",
                        style: TextStyle(color: Colors.white, fontSize: w * 0.04),
                      ),
      
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
      
                      Text(
                        "Manage your tasks",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: w * 0.035,
                        ),
                      ),
                    ],
                  ),
      
                  Spacer(),
      
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      padding: EdgeInsets.all(w * 0.025),
      
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
      
                      child: Icon(Icons.logout, color: Colors.cyan),
                    ),
                  ),
                ],
              ),
            ),
      
            /// -------- MY TASKS TITLE --------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.015,
              ),
      
              child: Row(
                children: [
                  Text(
                    "My Tasks",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
      
            /// -------- TASK COUNTER --------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.01,
                    ),
      
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
      
                    child: Text(
                      "Total : $totalTasks",
                      style: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
      
                  SizedBox(width: w * 0.03),
      
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.01,
                    ),
      
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
      
                    child: Text(
                      "Completed : $completedTasks",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            SizedBox(height: h * 0.01),
      
            Expanded(
              child: provider.loading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context.read<TaskProvider>().loadTasks();
                      },
                      child: tasks.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(height: h * 0.17),
                                _buildEmptyState(w, h),
                              ],
                            )
                          : _buildTaskList(w, tasks),
                    ),
            ),
          ],
        ),
      ),
    );


  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);

            },
            child: Text("No"),

          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);

            },

            child: Text("Yes"),

          ),

        ],

      ),

    ) ??
        false;
  }

  /// -------- EMPTY UI --------

  Widget _buildEmptyState(double w, double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.070),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan.withOpacity(0.1),
            ),

            child: Icon(
              Icons.task_alt,
              size: w * 0.16,
              color: Colors.cyan.withOpacity(0.5),
            ),
          ),

          SizedBox(height: h * 0.017),

          Text(
            "No Tasks Yet",
            style: TextStyle(fontSize: w * 0.055, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: h * 0.01),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Text(
              "Tap the + button to add your first task and start being productive!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: w * 0.035, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// -------- TASK LIST --------

  Widget _buildTaskList(double w, List tasks) {
    return ListView.builder(
      padding: EdgeInsets.all(w * 0.04),

      itemCount: tasks.length,

      itemBuilder: (context, index) {
        final task = tasks[index];
        final isExpanded = expandedTasks.contains(index);

        return Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: w * 0.03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: InkWell(
            borderRadius: BorderRadius.circular(15),

            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedTasks.remove(index);
                } else {
                  expandedTasks.add(index);
                }
              });
            },

            child: Column(
              children: [
                ListTile(
                  leading: Checkbox(
                    activeColor: Colors.cyan,
                    value: task["completed"],
                    onChanged: (value) async {
                      setState(() {
                        isProcessing = true;
                      });
                      await context.read<TaskProvider>().updateTask(
                        task["id"],
                        value!,
                      );
                      setState(() {
                        isProcessing = false;
                      });
                    },
                  ),

                  title: Text(
                    task["title"],
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w500,
                      decoration: task["completed"]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showTaskDialog(
                            index: index,
                            oldTitle: task["title"],
                            taskId: task["id"],
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(index);
                        },
                      ),
                    ],
                  ),
                ),

                if (isExpanded)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),

                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey),

                        SizedBox(width: 4),

                        Text(
                          task["completed"] ? "Completed" : "Pending",
                          style: TextStyle(
                            fontSize: 12,
                            color: task["completed"]
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),

                        Spacer(),

                        Text(
                          "Tap to ${isExpanded ? 'collapse' : 'expand'}",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// -------- ADD / EDIT TASK --------

  void _showTaskDialog({int? index, String? oldTitle, String? taskId}) {
    if (oldTitle != null) {
      taskController.text = oldTitle;
    } else {
      taskController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Task" : "Edit Task"),

          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Enter task",
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      if (taskController.text.trim().isEmpty) return;
                      setState(() {
                        isProcessing = true;
                      });
                      if (index == null) {
                        await context.read<TaskProvider>().addTask(
                          taskController.text.trim(),
                        );
                      } else {
                        await context.read<TaskProvider>().editTask(
                          taskId!,
                          taskController.text.trim(),
                        );
                      }
                      taskController.clear();
                      setState(() {
                        isProcessing = false;
                      });
                      Navigator.pop(context);
                    },

              child: Text(index == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  /// -------- DELETE --------

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final tasks = context.read<TaskProvider>().tasks;

        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isProcessing = true;
                });
                await context.read<TaskProvider>().deleteTask(tasks[index]["id"]);
                setState(() {
                  isProcessing = false;
                });
                Navigator.pop(context);
              },
              child: Text("Delete"),
            )
          ],
        );
      },
    );
  }

  /// -------- LOGOUT --------

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),

        content: Text("Are you sure you want to logout?"),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              context.read<AuthProvider>().logout(context);
            },
            child: Text("Yes, Logout"),
          ),
        ],
      ),
    );
  }
}
