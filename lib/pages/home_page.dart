import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:provider/provider.dart';

import '../util/habit_util.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Create a new habit"
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                // get the new habit name
                String newHabitName = textController.text;

                // save to db
                context.read<HabitDatabase>().addHabit(newHabitName);

                // pop box
                Navigator.pop(context);

                // clear controller
                textController.clear();
              },
              child: const Text("Save"),
            ),

            MaterialButton(
              onPressed: () {

                // pop box
                Navigator.pop(context);

                // clear controller
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  // build habit list
  Widget _buildHabitList(){
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();
    
    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    
    // return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
        itemBuilder: (context, index){
          // get each invidual habit
          final habit = currentHabits[index];

          // check if the habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          // return habit tile UI
          return ListTile(
            title: Text(habit.name),
          );
        },
    );
  }
}
