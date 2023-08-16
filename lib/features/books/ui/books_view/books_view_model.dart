import 'package:code_on_the_rocks/code_on_the_rocks.dart';
import 'package:flutter/material.dart';

class BooksViewModelBuilder extends ViewModelBuilder<BooksViewModel> {
  const BooksViewModelBuilder({
    super.key,
    required super.builder,
  });

  @override
  State<StatefulWidget> createState() => BooksViewModel();
}

class BooksViewModel extends ViewModel<BooksViewModel> {

  TextEditingController bookTitleController = TextEditingController();

   static BooksViewModel of_(BuildContext context) => getModel<BooksViewModel>(context);
}