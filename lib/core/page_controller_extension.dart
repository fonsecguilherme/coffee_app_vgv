import 'package:flutter/material.dart';

extension PageControllerExtension on PageController {
  int get currentPageIndex {
    return switch (hasClients) {
      true when page != null => page!.round(),
      _ => 0,
    };
  }

  void changePage(int index) {
    animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
