import 'dart:convert';
import 'package:doctor_appointment_app/components/button.dart';
import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  String errorMessage = ''; // Variable para manejar el mensaje de error

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          if (errorMessage.isNotEmpty) ...[
            // Mostrar el mensaje de error
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            Config.spaceSmall,
          ],
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  try {
                    // Intentar obtener el token
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);

                    if (token) {
                      // Si el token es exitoso, obtener los datos del usuario
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final tokenValue = prefs.getString('token') ?? '';

                      if (tokenValue.isNotEmpty) {
                        // Obtener los datos del usuario
                        final response =
                            await DioProvider().getUser(tokenValue);
                        if (response != null) {
                          setState(() {
                            Map<String, dynamic> appointment = {};
                            final user = json.decode(response);

                            // Verificar si hay una cita para hoy
                            for (var doctorData in user['doctor']) {
                              if (doctorData['appointments'] != null) {
                                appointment = doctorData;
                              }
                            }

                            auth.loginSuccess(user, appointment);
                            MyApp.navigatorKey.currentState!.pushNamed('main');
                          });
                        }
                      }
                    }
                  } catch (e) {
                    // Si ocurre un error (credenciales incorrectas)
                    setState(() {
                      errorMessage =
                          'Whoops! Something went wrong. These credentials do not match our records.';
                    });
                  }
                },
                disable: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
