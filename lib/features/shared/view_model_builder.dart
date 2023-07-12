import 'package:abis_recipes/app/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  ValueNotifier<bool> loading = ValueNotifier(false);

  bool get isLoading => loading.value;

  void setLoading(bool val) {
    loading.value = val;
    notifyListeners();
  }
}

abstract class ViewModelWidget<T extends ChangeNotifier> extends Widget {
  const ViewModelWidget({super.key});

  @protected
  Widget build(BuildContext context, T model);

  @override
  ModelGetterElement<T> createElement() => ModelGetterElement<T>(this);
}

class ModelGetterElement<T extends ChangeNotifier> extends ComponentElement {
  ModelGetterElement(ViewModelWidget widget) : super(widget);

  @override
  ViewModelWidget<T> get widget => super.widget as ViewModelWidget<T>;

  @override
  Widget build() => ListenableBuilder(
        listenable: getIt<T>(),
        builder: (context, child) => widget.build(this, getIt<T>()),
      );

  @override
  void update(ViewModelWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}

class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  const ViewModelBuilder({
    Key? key,
    required this.modelToRegister,
    required this.builder,
    this.onModelCreated,
    this.onModelDisposed,
    this.disposeModel = true,
  }) : super(key: key);

  /// Model with optional parameters to register
  final T modelToRegister;

  /// Optional function that can be run when the model is created
  /// The model will be registered before this function is called so it will be accessible
  final Function(T model)? onModelCreated;

  /// Optional function that can be run when the model is disposed
  final Function(T model)? onModelDisposed;

  /// Set to false to leave model in GetIt when this widget is disposed
  final bool disposeModel;

  /// The widget to build
  final Widget Function(
    BuildContext context,
    T model,
    Widget? child,
  ) builder;

  @override
  State<ViewModelBuilder> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier> extends State<ViewModelBuilder<T>> {
  T get model => getIt<T>();

  @override
  void initState() {
    if (kDebugMode) print('State: Initializing ViewModelBuilder of type ${T.toString()}');

    /// If the model is not registered, register it
    if (!getIt.isRegistered<T>()) {
      if (kDebugMode) print('State: Registering ${T.toString()} in GetIt');
      getIt.registerSingleton<T>(widget.modelToRegister);
    }

    if (widget.onModelCreated != null) {
      widget.onModelCreated!(model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, child) {
          return widget.builder(context, model, null);
        });
  }

  @override
  void dispose() {
    if (widget.disposeModel) {
      if (kDebugMode) print('State: Unregistering ${T.toString()} in GetIt');
      getIt.unregister<T>(
        disposingFunction: widget.onModelDisposed != null ? widget.onModelDisposed!(model) : null,
      );
    }
    super.dispose();
  }
}
