import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:todo_project/data/data.dart';
import 'package:todo_project/data/functions.dart';
import 'package:todo_project/loginScreen.dart';
import 'package:todo_project/utilis/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> displayContent = []; 
  bool? isDarkTheme = false; 
  
  

  @override
  void initState() {
    super.initState();
    _loadDataContent();
  }

  _loadDataContent() {
    List<Map<String, dynamic>>? getDetails = LocalStorage.getListMap("userDetail");
    String? emailAdress = LocalStorage.getString("email");
    isDarkTheme = LocalStorage.getBool("isDarkTheme");
    isDarkTheme ??= false;
    



    for (var entry in getDetails!) {
      if (entry["email"] == emailAdress) {
        displayContent = List<Map<String, dynamic>>.from(entry["tasks"] ?? []);
        break;
      }
    }
  }

  ThemeData get themeData {

    return isDarkTheme!
        ? ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.darkBlue,
            scaffoldBackgroundColor: AppColors.black,
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: AppColors.white),
            ),
          )
        : ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.darkBlue,
            scaffoldBackgroundColor: AppColors.white,
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: AppColors.black),
            ),
          );
  }

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme!;
      LocalStorage.setBool("isDarkTheme", isDarkTheme!);
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController priorityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Task Content"),
              ),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: "Priority (High or Low)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                List<Map<String, dynamic>>? getDetails = LocalStorage.getListMap("userDetail");
                String? task = contentController.text;
                String? priority = priorityController.text;
                String? emailAdress = LocalStorage.getString("email");

                for (var entry in getDetails!) {
                  if (entry["email"] == emailAdress) {
                    if (entry["tasks"] == null) {
                      entry["tasks"] = [];
                    }
                    entry["tasks"].add({"task": task, "priority": priority, "completed" : false});
                    displayContent.add({"task": task, "priority": priority, "completed" : false});
                    LocalStorage.setListMap("userDetail", getDetails);
                    break;
                  }
                }

                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(Map<String, dynamic> taskData, int index) {
    final TextEditingController contentController = TextEditingController(text: taskData["task"]);
    final TextEditingController priorityController = TextEditingController(text: taskData["priority"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Task Content"),
              ),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: "Priority (High or Low)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String? emailAdress = LocalStorage.getString("email");
                List<Map<String, dynamic>>? getDetails = LocalStorage.getListMap("userDetail");

                for (var entry in getDetails!) {
                  if (entry["email"] == emailAdress) {
                    entry["tasks"][index]["task"] = contentController.text;
                    entry["tasks"][index]["priority"] = priorityController.text;
                    displayContent[index]["task"] = contentController.text;
                    displayContent[index]["priority"] = priorityController.text;
                    LocalStorage.setListMap("userDetail", getDetails);
                    break;
                  }
                }

                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home Page", style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: Icon(isDarkTheme! ? Icons.wb_sunny : Icons.nights_stay, color: isDarkTheme! ? AppColors.white : AppColors.black,),
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: Icon(Icons.login_outlined),
              color: isDarkTheme! ? AppColors.golden : AppColors.darkBlue,
              onPressed: () {
                String? emailAdress = "";
                LocalStorage.setString("email", emailAdress);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: displayContent.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkTheme! ? Colors.grey[800] : AppColors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Slidable(
                endActionPane: ActionPane(motion: const ScrollMotion(), 
                    children: [
                    SlidableAction(onPressed: (context){
                      String? emailAdress = LocalStorage.getString("email");
                          List<Map<String, dynamic>>? getDetails = LocalStorage.getListMap("userDetail");
                
                          for (var entry in getDetails!) {
                            if (entry["email"] == emailAdress) {
                              entry["tasks"].removeAt(index);
                              LocalStorage.setListMap("userDetail", getDetails);
                              break;
                            }
                          }
                          displayContent.removeAt(index);
                          setState(() {});
                      
                       
                    },
                    backgroundColor:   AppColors.darkBlue,
                    foregroundColor: AppColors.white,
                    icon: Icons.delete,
                    
                    
                    )
                    ]),
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(color: isDarkTheme! ? AppColors.white : AppColors.black),
                  ),
                  title: Text(
                    displayContent[index]["task"] ?? "",
                    style: TextStyle(
                      color: isDarkTheme! ? AppColors.golden : AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    displayContent[index]["priority"] ?? "",
                    style: TextStyle(color: isDarkTheme! ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: isDarkTheme! ? AppColors.golden : AppColors.darkBlue),
                        onPressed: () {
                          _showEditTaskDialog(displayContent[index], index);
                        },
                      ),
                      IconButton(
                  icon: Icon(
                       displayContent[index]["completed"] == true  ? Icons.check_box : Icons.check_box_outline_blank,
                          color: isDarkTheme! ? AppColors.white : AppColors.black
        ),                        onPressed: () {
                          String? emailAdress = LocalStorage.getString("email");
                          List<Map<String, dynamic>>? getDetails = LocalStorage.getListMap("userDetail");
                
                          for (var entry in getDetails!) {
                            if (entry["email"] == emailAdress) {
                               displayContent[index]["completed"] = !displayContent[index]["completed"];
                              LocalStorage.setListMap("userDetail", getDetails);
                              break;
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                      backgroundColor: (isDarkTheme ?? false) ? AppColors.golden : AppColors.darkBlue,
                      content: Text("Task Completed Successfully", style: TextStyle(color: isDarkTheme! ? AppColors.black : AppColors.white),),
                      action: SnackBarAction(label: "undo",textColor: isDarkTheme! ? AppColors.black : AppColors.white, onPressed: (){}), 
                ));
                          setState(() {});

                        if(displayContent[index]["completed"] == true){
                      Future.delayed(const Duration(seconds: 1), () {
                        for (var entry in getDetails) {
                                if (entry["email"] == emailAdress) {
                  entry["tasks"].removeAt(index);
                  LocalStorage.setListMap("userDetail", getDetails);
                  break;
                }
              }
              displayContent.removeAt(index);
              setState(() {});
                        }
                      );
        }
              


                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isDarkTheme! ? AppColors.golden  : AppColors.darkBlue,
          onPressed: _showAddTaskDialog,
          child: Icon(
            Icons.add,
            color: isDarkTheme! ? AppColors.black : AppColors.white,
          ),
        ),
      ),
    );
  }
}
