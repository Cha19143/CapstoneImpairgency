import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => HomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => HomePageWidget(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => HomePageWidget(),
        ),
        FFRoute(
          name: LoginWidget.routeName,
          path: LoginWidget.routePath,
          builder: (context, params) => LoginWidget(),
        ),
        FFRoute(
          name: Register1Widget.routeName,
          path: Register1Widget.routePath,
          builder: (context, params) => Register1Widget(),
        ),
        FFRoute(
          name: Register2Widget.routeName,
          path: Register2Widget.routePath,
          builder: (context, params) => Register2Widget(
            registrationData: params.getParam('registrationData', ParamType.JSON) ?? 
                (params.state.extra is Map<String, dynamic> 
                    ? params.state.extra as Map<String, dynamic> 
                    : {}),
          ),
        ),
        FFRoute(
          name: Register3Widget.routeName,
          path: Register3Widget.routePath,
          builder: (context, params) => Register3Widget(
            registrationData: params.state.extra is Map<String, dynamic>
                ? params.state.extra as Map<String, dynamic>
                : {},
          ),
        ),
        FFRoute(
          name: Register4Widget.routeName,
          path: Register4Widget.routePath,
          builder: (context, params) => Register4Widget(
            registrationData: params.state.extra is Map<String, dynamic>
                ? params.state.extra as Map<String, dynamic>
                : {},
          ),
        ),
        FFRoute(
          name: Register5Widget.routeName,
          path: Register5Widget.routePath,
          builder: (context, params) => Register5Widget(
            registrationData: params.state.extra is Map<String, dynamic>
                ? params.state.extra as Map<String, dynamic>
                : {},
          ),
        ),
        FFRoute(
          name: AddcontactWidget.routeName,
          path: AddcontactWidget.routePath,
          builder: (context, params) => AddcontactWidget(
            registrationData: params.state.extra is Map<String, dynamic>
                ? params.state.extra as Map<String, dynamic>
                : {},
          ),
        ),
        FFRoute(
          name: AllsetWidget.routeName,
          path: AllsetWidget.routePath,
          builder: (context, params) => AllsetWidget(),
        ),
        FFRoute(
          name: MainDashboardWidget.routeName,
          path: MainDashboardWidget.routePath,
          builder: (context, params) => MainDashboardWidget(),
        ),
        FFRoute(
          name: ScanEnvironmentWidget.routeName,
          path: ScanEnvironmentWidget.routePath,
          builder: (context, params) => ScanEnvironmentWidget(),
        ),
        FFRoute(
          name: SmartAssistanceWidget.routeName,
          path: SmartAssistanceWidget.routePath,
          builder: (context, params) => SmartAssistanceWidget(),
        ),
        FFRoute(
          name: EmergencySOSWidget.routeName,
          path: EmergencySOSWidget.routePath,
          builder: (context, params) => EmergencySOSWidget(),
        ),
        FFRoute(
          name: EmergencySOS2Widget.routeName,
          path: EmergencySOS2Widget.routePath,
          builder: (context, params) => EmergencySOS2Widget(),
        ),
        FFRoute(
          name: AdminLoginWidget.routeName,
          path: AdminLoginWidget.routePath,
          builder: (context, params) => AdminLoginWidget(),
        ),
        FFRoute(
          name: AdmindashboardWidget.routeName,
          path: AdmindashboardWidget.routePath,
          builder: (context, params) => AdmindashboardWidget(),
        ),
        FFRoute(
          name: UserManagementWidget.routeName,
          path: UserManagementWidget.routePath,
          builder: (context, params) => UserManagementWidget(),
        ),
        FFRoute(
          name: AnalyticsWidget.routeName,
          path: AnalyticsWidget.routePath,
          builder: (context, params) => AnalyticsWidget(),
        ),
        FFRoute(
          name: AfterRegisWidget.routeName,
          path: AfterRegisWidget.routePath,
          builder: (context, params) => AfterRegisWidget(),
        ),
        FFRoute(
          name: GuardianMainDWidget.routeName,
          path: GuardianMainDWidget.routePath,
          builder: (context, params) => GuardianMainDWidget(),
        ),
        FFRoute(
          name: GuardianCallWidget.routeName,
          path: GuardianCallWidget.routePath,
          builder: (context, params) => GuardianCallWidget(),
        ),
        FFRoute(
          name: AdminadduserWidget.routeName,
          path: AdminadduserWidget.routePath,
          builder: (context, params) => AdminadduserWidget(),
        ),
        FFRoute(
          name: GuardianLocationWidget.routeName,
          path: GuardianLocationWidget.routePath,
          builder: (context, params) => GuardianLocationWidget(),
        ),
        FFRoute(
          name: EditUserAdminWidget.routeName,
          path: EditUserAdminWidget.routePath,
          builder: (context, params) => EditUserAdminWidget(
            userId: params.getParam(
              'userId',
              ParamType.String,
            )
           ),
          ),
        FFRoute(
          name: UserManagement1Widget.routeName,
          path: UserManagement1Widget.routePath,
          builder: (context, params) => UserManagement1Widget(),
        ),
        FFRoute(
          name: UserManagement2Widget.routeName,
          path: UserManagement2Widget.routePath,
          builder: (context, params) => UserManagement2Widget(),
        ),
        
        FFRoute(
          name: GuardianRegisterWidget.routeName,
          path: GuardianRegisterWidget.routePath,
          builder: (context, params) => GuardianRegisterWidget(),
        ),
        
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

  
extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap {
    if (extra == null) return {};
    if (extra is Map<String, dynamic>) return extra as Map<String, dynamic>;
    return {};
  }
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
