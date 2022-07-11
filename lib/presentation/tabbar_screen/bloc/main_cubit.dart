import 'package:ccvc_mobile/config/base/base_cubit.dart';
import 'package:ccvc_mobile/presentation/tabbar_screen/bloc/main_state.dart';
import 'package:ccvc_mobile/presentation/tabbar_screen/ui/tabbar_item.dart';
import 'package:rxdart/rxdart.dart';

class MainCubit extends BaseCubit<MainState> {
  MainCubit() : super(MainStateInitial());
  final BehaviorSubject<TabBarType> _selectTabBar =
      BehaviorSubject<TabBarType>.seeded(TabBarType.home);

  Stream<TabBarType> get selectTabBar => _selectTabBar.stream;

  void selectTab(TabBarType tab) {
    _selectTabBar.sink.add(tab);
  }

  void dispose() {
    _selectTabBar.close();
  }
}
