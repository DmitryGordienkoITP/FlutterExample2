import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/const/text_constants.dart';
import '../../../../core/common/helpers/app_validators.dart';
import '../../../../core/services/auth_service.dart';
import '../../../shared/app_label.dart';
import '../../../shared/buttons/primary_button.dart';
import '../../../shared/inputs/text_input_with_controls.dart';
import '../../../themes/palette.dart';
import '../../../themes/styles/app_text_styles.dart';
import '../../legals_screen.dart';

class _ViewModelState {
  final nameConstroller = TextEditingController();
  final emailConstroller = TextEditingController();
  final passwordConstroller = TextEditingController();
  bool isLegalsRead = false;
  bool hasFailedValidationAttemp = false;
  bool isLoading = false;

  _ViewModelState() {
    //nameConstroller.text = 'test';
    //emailConstroller.text = 'test@mail.com';
    //passwordConstroller.text = 'A123123';
  }
}

class _ViewModel extends ChangeNotifier {
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final AuthService _authService = GetIt.instance.get<AuthService>();

  triggerLegalsCheckbox(bool? value) {
    state.isLegalsRead = value!;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!_formKey.currentState!.validate()) {
      state.hasFailedValidationAttemp = true;
      return false;
    }
    state.isLoading = true;
    notifyListeners();
    final isSuccess = await _authService.signUp(
      state.nameConstroller.text,
      state.emailConstroller.text,
      state.passwordConstroller.text,
    );
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

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const SignUpWidget(),
    );
  }

  final minWidgetHeight = 600.0;
  final bottomBarSize = 90;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<_ViewModel>();
    final nativeTopPadding = MediaQuery.of(context).padding.top;
    final nativeBottomPadding = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height -
        nativeTopPadding -
        nativeBottomPadding;
    final kbSize = MediaQuery.of(context).viewInsets.bottom;
    var available = screenHeight - bottomBarSize;
    var available2 = screenHeight - kbSize;
    available = available < available2 ? available : available2;

    var delta =
        available - minWidgetHeight < 0 ? minWidgetHeight - available : 0;

    return Form(
      key: vm._formKey,
      child: Scrollbar(
        thickness: 6,
        thumbVisibility: true,
        child: LayoutBuilder(
          builder: (p0, constraints) => Padding(
            padding: EdgeInsets.fromLTRB(16, nativeTopPadding, 16, 0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minWidgetHeight,
                  maxHeight: delta == 0 ? available : minWidgetHeight + delta,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: _Title(),
                    ),
                    const _Fields(),
                    const _Controls(),
                    if (delta > 0) SizedBox(height: delta.toDouble())
                  ],
                ),
              ),
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
        'Регистрация',
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
            child: const _NameFieldWidget()),
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: const _EmailFieldWidget()),
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: const _PasswordFieldWidget()),
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: const _RepeatedPasswordFieldWidget()),
        const _LegalsWidget(),
        const _StatusWidget(),
      ],
    );
  }
}

class _StatusWidget extends StatelessWidget {
  const _StatusWidget();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();

    return SizedBox(
      height: 50,
      //padding: const EdgeInsets.symmetric(vertical: 10),
      child: vm.state.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : null,
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    Key? key,
  }) : super(key: key);

  Future<void> _submit(_ViewModel vm, BuildContext context) async {
    FocusScope.of(context).unfocus();
    await vm.submit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<_ViewModel>(
      builder: (context, vm, child) => PrimaryButton(
        disabled: !vm.state.isLegalsRead,
        title: const Text("Зарегистрироваться"),
        onPressed: () => _submit(vm, context),
      ),
    );
  }
}

class _NameFieldWidget extends StatelessWidget {
  const _NameFieldWidget();

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return TextInputWithControls(
      clearable: true,
      controller: vm.state.nameConstroller,
      validator: AppValidators.username,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      label: const AppLabel("Имя", marked: true),
      textInputType: TextInputType.emailAddress,
    );
  }
}

class _EmailFieldWidget extends StatelessWidget {
  const _EmailFieldWidget();

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return TextInputWithControls(
      clearable: true,
      controller: vm.state.emailConstroller,
      validator: AppValidators.email,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      label: const AppLabel("Электронный адрес", marked: true),
      textInputType: TextInputType.emailAddress,
    );
  }
}

class _PasswordFieldWidget extends StatelessWidget {
  const _PasswordFieldWidget();

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return TextInputWithControls(
      controller: vm.state.passwordConstroller,
      validator: AppValidators.password,
      obscure: true,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      label: const AppLabel("Пароль", marked: true),
      helperText: TextConstants.passwordHelper,
    );
  }
}

class _RepeatedPasswordFieldWidget extends StatelessWidget {
  const _RepeatedPasswordFieldWidget();

  @override
  Widget build(BuildContext context) {
    var vm = context.read<_ViewModel>();
    return TextInputWithControls(
      obscure: true,
      onChanged: vm.onFormChange,
      onSaved: (value) {},
      validator: (value) => value != vm.state.passwordConstroller.text
          ? 'Пароли не совпадают'
          : null,
      label: const AppLabel("Повторите пароль", marked: true),
    );
  }
}

class _LegalsWidget extends StatelessWidget {
  const _LegalsWidget();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<_ViewModel>();

    return Row(
      children: [
        Checkbox(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
          checkColor: AppPalette.white,
          value: vm.state.isLegalsRead,
          onChanged: (value) {
            FocusScope.of(context).unfocus();
            vm.triggerLegalsCheckbox(value);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 17)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Согласен с условиями",
                style: AppTextStyles.body.copyWith(color: AppPalette.black),
              ),
              Text(
                "политики конфиденциальности",
                style: AppTextStyles.body.copyWith(
                  color: AppPalette.accentGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(LegalsScreen.routeName);
          },
        ),
      ],
    );
  }
}
