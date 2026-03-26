import 'package:aqua_steward/controller/auth_controller.dart';
import 'package:aqua_steward/core/theme/app_icon.dart';
import 'package:aqua_steward/core/theme/app_sizedbox.dart';
import 'package:aqua_steward/core/utils/app_validators.dart';
import 'package:aqua_steward/core/widgets/button_main.dart';
import 'package:aqua_steward/core/widgets/button_dynamic.dart';
import 'package:aqua_steward/core/widgets/container_formart.dart';
import 'package:aqua_steward/features/auth/presentation/widgets/scaffold_account.dart';
import 'package:aqua_steward/core/widgets/text_field_format.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _signupUser() async {
    setState(() {
      _isLoading = true;
    });
    await _authController
        .signupUser(
          context: context,
          name: _nameController.text,
          last_name: _lastNameController.text,
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
  Widget build(BuildContext context) {
    return ScaffoldAccount(
      formKey: _formKey,
      body: ContainerFormat(
        children: [
          Text('Registrarse', style: Theme.of(context).textTheme.titleMedium),
          AppSizedBox.height8,
          Row(
            children: [
              Expanded(
                child: TextFieldFormat(
                  labelText: "Nombre",
                  icon: AppIcon.personOutlined,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  maxLength: 20,
                  validator: AppValidators.validateRequired,
                ),
              ),
              AppSizedBox.width8,
              Expanded(
                child: TextFieldFormat(
                  labelText: "Apellido",
                  icon: AppIcon.personOutlined,
                  keyboardType: TextInputType.name,
                  controller: _lastNameController,
                  maxLength: 20,
                  validator: AppValidators.validateRequired,
                ),
              ),
            ],
          ),
          TextFieldFormat(
            labelText: "Correo electrónico",
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
            label: "Registrarse",
            isLoading: _isLoading,
            onPressed: _signupUser,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Tienes cuenta?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ButtonDynamic(
                label: "Iniciar sesión",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
