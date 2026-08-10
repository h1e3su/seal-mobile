import 'package:flutter/material.dart';
import 'view_state.dart';

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setLoading() => setState(ViewState.loading);
  void setSuccess() => setState(ViewState.success);
  void setIdle() => setState(ViewState.idle);

  void setError(String? message) {
    _errorMessage = message;
    setState(ViewState.error);
  }

  void clearError() {
    _errorMessage = null;
    if (_state == ViewState.error) {
      setState(ViewState.idle);
    }
  }
}
