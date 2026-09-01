import 'package:bbo_shop_app/features/main/presentation/controllers/main_navigation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigationController extends Notifier<MainNavigationState> {
  @override
  MainNavigationState build() {
    return const MainNavigationState.initial();
  }

  void requestLoginSheet() {
    if (state.isLoginSheetOpen) {
      return;
    }

    state = state.copyWith(
      loginSheetRequestCount: state.loginSheetRequestCount + 1,
    );
  }

  bool markLoginSheetOpen() {
    if (state.isLoginSheetOpen) {
      return false;
    }

    state = state.copyWith(isLoginSheetOpen: true);
    return true;
  }

  void markLoginSheetClosed({
    required bool dismissAutoPrompt,
  }) {
    state = state.copyWith(
      isLoginSheetOpen: false,
      isAutoLoginPromptDismissed:
          dismissAutoPrompt || state.isAutoLoginPromptDismissed,
    );
  }
}

final mainNavigationControllerProvider =
    NotifierProvider<MainNavigationController, MainNavigationState>(
      MainNavigationController.new,
    );
