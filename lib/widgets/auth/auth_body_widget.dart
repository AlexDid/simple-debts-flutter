import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/services/users_service.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/widgets/auth/auth_form_widget.dart';
import 'package:simpledebts/widgets/profile/user_data_form_widget.dart';

class AuthBodyWidget extends StatefulWidget {
  @override
  _AuthBodyWidgetState createState() => _AuthBodyWidgetState();
}

class _AuthBodyWidgetState extends State<AuthBodyWidget> {
  final _authStore = GetIt.instance<AuthStore>();
  final _usersService = GetIt.I<UsersService>();
  bool _showUserDataForm = false;

  Future<void> _submitAuthForm(BuildContext context, AuthForm authForm, bool isLogin) async {
    try {
      if(isLogin) {
        await _authStore
            .login(authForm)
            .then((_) => _usersService.sendDeviceToken());
        _navigateToMainScreen();
      } else {
        await _authStore
            .signUp(authForm)
            .then((_) => _usersService.sendDeviceToken());
        setState(() => _showUserDataForm = true);
      }
    } on Failure catch(error) {
      ErrorHelper.showErrorSnackBar(context, error.message);
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacementNamed(DebtsListScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 50.0,
        vertical: 26
      ),
      child: SingleChildScrollView(
        child: _showUserDataForm == false
            ? AuthFormWidget(
              onSubmit: (form, isLogin) => _submitAuthForm(context, form, isLogin),
            )
            : Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 50.0
              ),
              child: UserDataFormWidget(
                onSuccess: _navigateToMainScreen,
                onSkip: _navigateToMainScreen,
              ),
            ),
      ),
    );
  }
}