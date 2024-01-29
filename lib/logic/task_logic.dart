
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

  void updateProgress(int id, String nameCategory, String progress, MainPageProvider mainProvider) async {
    final email = await SharedPrefHelper.getString(constants.email);
    SQLHelper.updateTaskProgress(id, email, nameCategory, progress).then((value) {
      _provider.refresh();
      SQLHelper.updateCategoryProgress(email, nameCategory).then((value) => mainProvider.refresh());
    });
  }
}