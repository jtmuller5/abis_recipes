import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class RecipePreviewViewModelBuilder extends ViewModelBuilder<RecipePreviewViewModel> {
  const RecipePreviewViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => RecipePreviewViewModel();
}

class RecipePreviewViewModel extends ViewModel<RecipePreviewViewModel> {
   static RecipePreviewViewModel of_(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<ViewModelProvider<ViewModel<RecipePreviewViewModel>>>()!.state) as RecipePreviewViewModel;
}
