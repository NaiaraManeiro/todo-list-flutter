
import '../helpers/helpers.dart';
import '../model/models.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;

class CompletedTasksLogic{

  final CompletedTasksProvider _provider;

  CompletedTasksLogic(this._provider);

  Future<List<CardItem>?> getDoneTasks() async {
    final email = await SharedPrefHelper.getString(constants.email);
    return await SQLHelper.getDoneTasks(email);
  }
}