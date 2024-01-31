
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

  void updateProgress(int id, String nameCategory, int progress, MainPageProvider mainProvider) async {
    final email = await SharedPrefHelper.getString(constants.email);

    await SQLHelper.updateTaskProgress(id, email, nameCategory, progress);
    _provider.refresh();

    int value = await SQLHelper.updateCategoryProgress(email, nameCategory);
    mainProvider.selectedCategory.totalProgress = value;
    mainProvider.refresh();
  }
}