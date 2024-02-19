
import '../helpers/helpers.dart';
import '../model/models.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;

class TaskLogic {

  final TaskProvider _provider;

  TaskLogic(this._provider);

  Future<List<TaskModel>> getTasks(String nameCategory) async {
    final email = await SharedPrefHelper.getString(constants.email);
    return SQLHelper.getTasksCategory(email, nameCategory);
  }

  Future<void> updateProgress(String nameCategory, MainPageProvider mainProvider) async {
    final email = await SharedPrefHelper.getString(constants.email);

    await SQLHelper.updateTasksProgress(email, nameCategory, _provider.tasks);

    await SQLHelper.updateCategoryProgress(email, nameCategory, mainProvider.selectedCategory!.totalProgress);
  }

  int totalProgress() {
    return _provider.tasks.map((task) => task.progress).reduce((a, b) => a + b) ~/ _provider.tasks.length;
  }
}