// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb ? const FirebaseOptions(
      apiKey: "AIzaSyCPwX9upDp-flkmNsCavMonifBQluastBQ",
    authDomain: "proyecto-final-6b20e.firebaseapp.com",
    projectId: "proyecto-final-6b20e",
    storageBucket: "proyecto-final-6b20e.firebasestorage.app",
    messagingSenderId: "826917239714",
   appId: "1:826917239714:web:34136d38b90440492ed0fb",
    ) : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  void _showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Advertencia'),
        content: const Text('Si se borra la app, los datos no quedarán guardados.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          TextButton(
            child: const Text('¿Seguro que quieres seguir?'),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await FirebaseAuth.instance.signInAnonymously();

              if (!dialogContext.mounted) return;

              Navigator.push(
                dialogContext,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 120, color: Colors.blue),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _showGuestDialog(context),
                child: const Text('¿Quieres iniciar sesión como invitado?'),
              ),
              const SizedBox(height: 8),
              const Text('o'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
                child: const Text('¿Quieres iniciar sesión con un correo?'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text('¿No te has registrado aun?\nDa clic aquí', textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;

Future<void> loginWithEmail() async {
  if (!mounted) return; // Por seguridad extra antes de empezar

  setState(() => isLoading = true);
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return; // Verificamos que el widget sigue montado

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return; // Verificamos que sigue montado antes de usar setState
    setState(() => error = e.message ?? 'Error');
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

Future<void> loginWithGoogle() async {
  if (!mounted) return;

  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  } catch (e) {
    if (!mounted) return;

    setState(() => error = 'Error con Google Sign-In: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.person, size: 120, color: Colors.blue),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Usuario', filled: true, fillColor: Colors.cyanAccent),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña', filled: true, fillColor: Colors.cyanAccent),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : loginWithEmail,
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: isLoading ? null : loginWithGoogle,
                  child: const Text('Iniciar sesión con Google'),
                ),
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(error, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Text('¿No te has registrado aún?\nDa clic aquí', textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  Future<void> register() async {
    if (!mounted) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => error = e.message ?? 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.person, size: 120, color: Colors.blue),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Usuario', filled: true, fillColor: Colors.cyanAccent),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña', filled: true, fillColor: Colors.cyanAccent),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Registrarse'),
                ),
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(error, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text('¿Ya tienes una cuenta?\nDa clic aquí', textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const InitialScreen()),
                (_) => false,
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          '¡Bienvenido, ${user?.email ?? 'Invitado'}!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
