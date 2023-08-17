import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class NewBookViewModelBuilder extends ViewModelBuilder<NewBookViewModel> {
  const NewBookViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => NewBookViewModel();
}

class NewBookViewModel extends ViewModel<NewBookViewModel> {

  PageController pageController = PageController(initialPage: 0);

  TextEditingController bookTitleController = TextEditingController();

   static NewBookViewModel of_(BuildContext context) => getModel<NewBookViewModel>(context);
}