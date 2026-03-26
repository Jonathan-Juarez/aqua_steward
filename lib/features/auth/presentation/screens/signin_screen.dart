import 'package:aqua_steward/controller/auth_controller.dart';
import 'package:aqua_steward/core/router/app_router.dart';
import 'package:aqua_steward/core/theme/app_divider.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _signinUser() async {
    setState(() {
      _isLoading = true;
    });
    await _authController
        .signinUser(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
        )
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores de texto.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: _formKey,
      body: ContainerFormat(
        children: [
          Text(
            'Iniciar sesión',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextFieldFormat(
            labelText: "Correo electronico",
            icon: AppIcon.emailOutlined,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            maxLength: 40,
            validator: AppValidators.validateEmail,
          ),
          TextFieldFormat(
            labelText: "Contraseña",
            icon: AppIcon.password,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            maxLength: 30,
            validator: AppValidators.validatePassword,
          ),
          ButtonMain(
            formKey: _formKey,
            label: "Iniciar sesión",
            isLoading: _isLoading,
            onPressed: _signinUser,
          ),
          ButtonDynamic(
            label: "¿Olvidaste tu contraseña?",
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.forgotPassword),
          ),
          AppDivider.dv8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿No tienes cuenta?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ButtonDynamic(
                label: "Registrarse",
                onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
