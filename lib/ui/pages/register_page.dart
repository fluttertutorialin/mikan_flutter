import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mikan_flutter/internal/extension.dart';
import 'package:mikan_flutter/mikan_flutter_routes.dart';
import 'package:mikan_flutter/providers/index_model.dart';
import 'package:mikan_flutter/providers/register_model.dart';
import 'package:mikan_flutter/providers/subscribed_model.dart';
import 'package:mikan_flutter/topvars.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "register",
  routeName: "register",
)
@immutable
class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion(
      value: context.fitSystemUiOverlayStyle,
      child: ChangeNotifierProvider<RegisterModel>(
        create: (_) => RegisterModel(),
        child: Builder(builder: (context) {
          final registerModel =
              Provider.of<RegisterModel>(context, listen: false);
          return Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: edgeH24V36WithStatusBar,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          normalFormHeader,
                          sizedBoxH16,
                          _buildUserNameField(theme, registerModel),
                          sizedBoxH16,
                          _buildPasswordField(theme, registerModel),
                          sizedBoxH16,
                          _buildConfirmPasswordField(theme, registerModel),
                          sizedBoxH16,
                          _buildEmailField(theme, registerModel),
                          sizedBoxH16,
                          _buildQQField(theme, registerModel),
                          sizedBoxH56,
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  FluentIcons.chevron_left_24_regular,
                                  size: 16.0,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                minWidth: 0.0,
                                padding: edge16,
                                shape: circleShape,
                                color: theme.backgroundColor,
                              ),
                              sizedBoxW12,
                              Expanded(
                                child: _buildRegisterButton(theme),
                              )
                            ],
                          ),
                          sizedBoxH56,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRegisterButton(final ThemeData theme) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.loading,
      shouldRebuild: (pre, next) => pre != next,
      builder: (context, loading, __) {
        final Color btnColor = loading ? theme.primaryColor : theme.accentColor;
        final Color iconColor =
            btnColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
        return ElevatedButton(
          onPressed: () {
            if (loading) return;
            if (_formKey.currentState!.validate()) {
              context.read<RegisterModel>().submit(() {
                context.read<IndexModel>().refresh();
                context.read<SubscribedModel>().refresh();
                Navigator.popUntil(
                  context,
                  (route) => route.settings.name == Routes.home,
                );
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SpinKitWave(
                  size: 20.0,
                  type: SpinKitWaveType.center,
                  color: iconColor,
                ),
              sizedBoxW12,
              Text(
                loading ? "?????????" : "??????",
                style: TextStyle(
                  color: iconColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizedBoxW12,
              if (loading)
                SpinKitWave(
                  size: 20.0,
                  type: SpinKitWaveType.center,
                  color: iconColor,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserNameField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.userNameController,
      cursorColor: theme.accentColor,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: '?????????',
        hintText: '??????????????????',
        hintStyle: TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.person_24_regular,
          color: theme.accentColor,
        ),
      ),
      validator: (value) {
        return value.isNullOrBlank ? "?????????????????????" : null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildEmailField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.emailController,
      cursorColor: theme.accentColor,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: '??????',
        hintText: '???????????????',
        hintStyle: TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.mail_24_regular,
          color: theme.accentColor,
        ),
      ),
      validator: (value) {
        if (value.isNullOrBlank) return "??????????????????";
        if (!RegExp(r".+@.+\..+").hasMatch(value!)) return "?????????????????????";
        return null;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildQQField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return TextFormField(
      controller: registerModel.qqController,
      cursorColor: theme.accentColor,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        labelText: 'QQ',
        hintText: '?????????QQ??????',
        hintStyle: TextStyle(fontSize: 14.0),
        prefixIcon: Icon(
          FluentIcons.emoji_surprise_24_regular,
          color: theme.accentColor,
        ),
      ),
      validator: (value) {
        if (value.isNotBlank) {
          if (!RegExp(r"\d+").hasMatch(value!)) return "QQ??????????????????";
          if (value.length < 5) {
            return "QQ???????????????5???";
          }
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPasswordField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.showPassword,
      shouldRebuild: (pre, next) => pre != next,
      builder: (_, showPassword, __) {
        return TextFormField(
          obscureText: !showPassword,
          cursorColor: theme.accentColor,
          controller: registerModel.passwordController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            labelText: '??????',
            hintText: '???????????????',
            hintStyle: TextStyle(fontSize: 14.0, letterSpacing: 0.0),
            prefixIcon: Icon(
              FluentIcons.password_24_regular,
              color: theme.accentColor,
            ),
            suffixIcon: IconButton(
              icon: showPassword
                  ? Icon(
                      FluentIcons.eye_show_24_regular,
                      color: theme.accentColor,
                    )
                  : Icon(
                      FluentIcons.eye_show_24_filled,
                      color: theme.accentColor,
                    ),
              onPressed: () {
                registerModel.showPassword = !showPassword;
              },
            ),
          ),
          validator: (value) {
            if (value.isNullOrBlank) return "??????????????????";
            if (value!.length < 6) return "????????????6???";
            return null;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }

  Widget _buildConfirmPasswordField(
    final ThemeData theme,
    final RegisterModel registerModel,
  ) {
    return Selector<RegisterModel, bool>(
      selector: (_, model) => model.showPassword,
      shouldRebuild: (pre, next) => pre != next,
      builder: (_, showPassword, __) {
        return TextFormField(
          obscureText: !showPassword,
          cursorColor: theme.accentColor,
          controller: registerModel.confirmPasswordController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            labelText: '????????????',
            hintText: '?????????????????????',
            hintStyle: TextStyle(fontSize: 14.0, letterSpacing: 0.0),
            prefixIcon: Icon(
              FluentIcons.key_multiple_20_regular,
              color: theme.accentColor,
            ),
            suffixIcon: IconButton(
              icon: showPassword
                  ? Icon(
                      FluentIcons.eye_show_24_regular,
                      color: theme.accentColor,
                    )
                  : Icon(
                      FluentIcons.eye_show_24_filled,
                      color: theme.accentColor,
                    ),
              onPressed: () {
                registerModel.showPassword = !showPassword;
              },
            ),
          ),
          validator: (value) {
            if (value.isNullOrBlank) return "????????????????????????";
            if (value != registerModel.passwordController.text)
              return "????????????????????????????????????????????????";
            return null;
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }
}
