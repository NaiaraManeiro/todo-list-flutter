
import '../helpers/helpers.dart';
import '../model/models.dart';
import '../providers/providers.dart';
import '../../assets/constants.dart' as constants;

class CompletedTasksLogic {
 
  final CompletedTasksProvider _provider;

  CompletedTasksLogic(this._provider);

  Future<List<CardItem>?> getDoneTasks() async {
    final email = await SharedPrefHelper.getString(constants.email);
    List<String>? categories;
    if (_provider.copyList != null) categories = _filterByCategories();
    return await SQLHelper.getDoneTasks(email, categories, _provider.startDate, _provider.endDate);
  }

  List<String>? _filterByCategories() {
    List<CardItem> filteredTaskes = _filterCardItems(_provider.copyList!, _provider.selectedCategories!);
    return filteredTaskes.map((item) => item.nameCategory).toList();
  }

  List<CardItem> _filterCardItems(List<CardItem> allCardItems, List<bool> selectedCategories) {
    return List.generate(allCardItems.length, (i) => allCardItems[i])
      .where((item) => selectedCategories[allCardItems.indexOf(item)])
      .toList();
  }

  void limpiarFiltro() {
    _provider.selectedCategories = _provider.copyList == null
      ? []
      : List.filled(_provider.copyList!.length, true);
    _provider.startDate = null;
    _provider.endDate = null;
    _provider.refresh();
  }
}