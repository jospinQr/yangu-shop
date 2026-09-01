class MainNavigationState {
  const MainNavigationState({
    required this.isLoginSheetOpen,
    required this.isAutoLoginPromptDismissed,
    required this.loginSheetRequestCount,
  });

  const MainNavigationState.initial()
    : isLoginSheetOpen = false,
      isAutoLoginPromptDismissed = false,
      loginSheetRequestCount = 0;

  final bool isLoginSheetOpen;
  final bool isAutoLoginPromptDismissed;
  final int loginSheetRequestCount;

  MainNavigationState copyWith({
    bool? isLoginSheetOpen,
    bool? isAutoLoginPromptDismissed,
    int? loginSheetRequestCount,
  }) {
    return MainNavigationState(
      isLoginSheetOpen: isLoginSheetOpen ?? this.isLoginSheetOpen,
      isAutoLoginPromptDismissed:
          isAutoLoginPromptDismissed ?? this.isAutoLoginPromptDismissed,
      loginSheetRequestCount:
          loginSheetRequestCount ?? this.loginSheetRequestCount,
    );
  }
}
