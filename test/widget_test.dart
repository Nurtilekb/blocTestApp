import 'package:bloc_test/bloc_test.dart';
import 'package:bloctestapp/bloc/auth/auth_bloc.dart';
import 'package:bloctestapp/bloc/auth/auth_event.dart';
import 'package:bloctestapp/bloc/auth/auth_state.dart';
import 'package:bloctestapp/pages/authentication/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(const SignInRequested(email: '', password: ''));
    registerFallbackValue(const AuthInitial());
  });

  setUp(() {
    authBloc = MockAuthBloc();
  });

  tearDown(() {
    authBloc.close();
  });

  testWidgets('SignInPage renders all UI elements', (
    WidgetTester tester,
  ) async {
    when(() => authBloc.state).thenReturn(const Unauthenticated());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const SignInPage(),
        ),
      ),
    );

    expect(find.text('Notes Pinner'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Sign In button dispatches SignInRequested', (
    WidgetTester tester,
  ) async {
    when(() => authBloc.state).thenReturn(const Unauthenticated());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const SignInPage(),
        ),
      ),
    );

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'test@example.com');
    await tester.enterText(textFields.at(1), 'password123');
    await tester.pump();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    verify(
      () => authBloc.add(
        const SignInRequested(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
    ).called(1);
  });

  testWidgets('Empty fields shows error SnackBar', (WidgetTester tester) async {
    when(() => authBloc.state).thenReturn(const Unauthenticated());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const SignInPage(),
        ),
      ),
    );

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Please fill in all fields'), findsOneWidget);
    verifyNever(() => authBloc.add(any()));
  });
}
