import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/enums/api_exception_type.dart';
import '../../../../core/common/exceptions/api_exception.dart';
import '../../../../core/common/helpers/api_exception_helper.dart';
import '../../../../core/common/helpers/app_validators.dart';
import '../../../../core/services/auth_service.dart';
import '../../../shared/buttons/primary_button.dart';
import '../../../shared/inputs/text_input_with_controls.dart';
import '../../../themes/palette.dart';
import 'logo_widget.dart';

class _ViewModelState {
  final emailConstroller = TextEditingController();
  final passwordConstroller = TextEditingController();
  String email = '';
  String password = '';
  bool hasFailedSubmitAttempt = false;
  bool hasFailedValidationAttemp = false;
  bool isLoading = false;
  _ViewModelState() {
    emailConstroller.text = 'test@mail.com';
    passwordConstroller.text = 'A123123';
  }
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final AuthService _authService = GetIt.instance.get<AuthService>();

  ApiException? _error;

  Future<bool> submit() async {
    if (!_formKey.currentState!.validate()) {
      state.hasFailedValidationAttemp = true;
      return false;
    }
    state.isLoading = true;
    notifyListeners();
    var isSuccess = false;
    try {
      isSuccess = await _authService.login(
        state.emailConstroller.text,
        state.passwordConstroller.text,
      );
    } catch (error) {
      _error = error as ApiException;
    }
    _error = isSuccess ? null : _error;
    state.hasFailedSubmitAttempt = !isSuccess;
    state.isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  void onFormChange(String? value) {
    if (state.hasFailedValidationAttemp) {
      _formKey.currentState!.validate();
    }
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const LoginWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    final kbSize = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: vm._formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top,
          16,
          100,
        ),
        child: LayoutBuilder(
          builder: (ctx, constraints) => ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 500,
              maxHeight: constraints.maxHeight - kbSize < 500
                  ? 500
                  : constraints.maxHeight - kbSize,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const LogoWidget(),
                const Spacer(),
                const _Title(),
                const Spacer(),
                SizedBox(
                  height: 220,
                  child: Column(
                    children: const [
                      _Fields(),
                      _StatusWidget(),
                    ],
                  ),
                ),
                const Spacer(),
                const _Controls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Вход в Личный кабинет',
        style: TextStyle(
          color: AppPalette.black,
          fontSize: 28,
          height: 34 / 28,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: const _EmailFieldWidget()),
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: const _PasswordFieldWidget()),
      ],
    );
  }
}

class _StatusWidget extends StatelessWidget {
  const _StatusWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();

    return vm.state.isLoading
        ? const Center(
            child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CircularProgressIndicator(),
          ))
        : vm.state.hasFailedSubmitAttempt &&
                vm._error!.type != ApiExceptionType.serverUnavailable
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    ApiExceptionHelper.getMessageByType(vm._error!.type),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppPalette.red,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    Key? key,
  }) : super(key: key);

  Future<void> _submit(_ViewModel vm, BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      await vm.submit();
    } catch (error) {
      /// error handler?
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    return PrimaryButton(
      title: const Text("Войти"),
      onPressed: () {
        _submit(vm, context);
      },
    );
  }
}

class _EmailFieldWidget extends StatelessWidget {
  const _EmailFieldWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    return TextInputWithControls(
      controller: vm.state.emailConstroller,
      validator: (value) => AppValidators.email(value),
      clearable: true,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      label: const Text("Логин"),
      textInputType: TextInputType.emailAddress,
    );
  }
}

class _PasswordFieldWidget extends StatelessWidget {
  const _PasswordFieldWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    return TextInputWithControls(
      controller: vm.state.passwordConstroller,
      validator: (value) => AppValidators.mandatoryPassword(value),
      obscure: true,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      label: const Text("Пароль"),
    );
  }
}
