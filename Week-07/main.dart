import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login & Profile',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
// WELCOME SCREEN
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showFirst = true;

  void openLogin() {
    setState(() {
      showFirst = !showFirst;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    sizeCurve: Curves.bounceOut,
                    crossFadeState: showFirst
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 75,
                        color: Colors.indigo,
                      ),
                    ),
                    secondChild: Container(
                      width: 170,
                      height: 170,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waving_hand,
                        size: 90,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'WELCOME',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your journey starts here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: openLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// LOGIN
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  String registeredName = '';
  String registeredEmail = '';
  String registeredPassword = '';

  bool hidePassword = true;

  void login() {
    if (!formKey.currentState!.validate()) return;

    if (registeredEmail.isEmpty) {
      msg('Please register an account first.');
      return;
    }

    if (email.text.trim().toLowerCase() == registeredEmail &&
        password.text == registeredPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(
            name: registeredName,
            email: registeredEmail,
          ),
        ),
      );
    } else {
      msg('Invalid email or password.');
    }
  }

  void msg(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> register() async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );

    if (data != null) {
      setState(() {
        registeredName = data['name'];
        registeredEmail = data['email'];
        registeredPassword = data['password'];
      });

      email.text = registeredEmail;

      msg('Account created. Please login.');
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (_, orientation) {
            final landscape = orientation == Orientation.landscape;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: formKey,
                        child: landscape
                            ? Row(
                          children: [
                            Expanded(
                              child: Header(
                                icon: Icons.login,
                                title: 'Login',
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(child: loginForm()),
                          ],
                        )
                            : Column(
                          children: [
                            const Header(
                              icon: Icons.login,
                              title: 'Login',
                            ),
                            const SizedBox(height: 25),
                            loginForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loginForm() {
    return Column(
      children: [
        Field(
          controller: email,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 14),
        Field(
          controller: password,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: hidePassword,
          suffix: IconButton(
            onPressed: () => setState(
                  () => hidePassword = !hidePassword,
            ),
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          validator: Validators.password,
        ),
        const SizedBox(height: 18),
        Button(
          text: 'LOGIN',
          icon: Icons.login,
          onPressed: login,
        ),
        TextButton(
          onPressed: register,
          child: const Text("Don't have an account? Register"),
        ),
      ],
    );
  }
}
// REGISTER
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  void createAccount() {
    if (!formKey.currentState!.validate()) return;

    Navigator.pop(context, {
      'name': name.text.trim(),
      'email': email.text.trim().toLowerCase(),
      'phone': phone.text.trim(),
      'password': password.text,
    });
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (_, orientation) {
            final landscape = orientation == Orientation.landscape;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: formKey,
                        child: landscape
                            ? Row(
                          children: [
                            const Expanded(
                              child: Header(
                                icon: Icons.person_add_outlined,
                                title: 'Create Account',
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(child: registerForm()),
                          ],
                        )
                            : Column(
                          children: [
                            const Header(
                              icon: Icons.person_add_outlined,
                              title: 'Create Account',
                            ),
                            const SizedBox(height: 22),
                            registerForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget registerForm() {
    return Column(
      children: [
        Field(
          controller: name,
          label: 'Full Name',
          icon: Icons.person_outline,
          validator: Validators.name,
        ),
        const SizedBox(height: 12),

        Field(
          controller: email,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 12),

        Field(
          controller: phone,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboard: TextInputType.phone,
          validator: Validators.phone,
        ),
        const SizedBox(height: 12),

        Field(
          controller: password,
          label: 'Password',
          icon: Icons.lock_outline,
          obscure: hidePassword,
          suffix: IconButton(
            onPressed: () => setState(
                  () => hidePassword = !hidePassword,
            ),
            icon: Icon(
              hidePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          validator: Validators.password,
        ),
        const SizedBox(height: 12),

        Field(
          controller: confirm,
          label: 'Confirm Password',
          icon: Icons.lock_outline,
          obscure: hideConfirm,
          suffix: IconButton(
            onPressed: () => setState(
                  () => hideConfirm = !hideConfirm,
            ),
            icon: Icon(
              hideConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirm your password';
            }
            if (value != password.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),

        const SizedBox(height: 18),

        Button(
          text: 'REGISTER',
          icon: Icons.person_add_outlined,
          onPressed: createAccount,
        ),
      ],
    );
  }
}
// PROFILE

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String email;

  String phone = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
  }

  void editProfile() {
    final n = TextEditingController(text: name);
    final p = TextEditingController(text: phone);
    final b = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Field(
                controller: n,
                label: 'Name',
                icon: Icons.person_outline,
                validator: Validators.name,
              ),
              const SizedBox(height: 12),
              Field(
                controller: p,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboard: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: b,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.info_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = n.text.trim();
                phone = p.text.trim();
                bio = b.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: editProfile,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (_, orientation) {
            final landscape = orientation == Orientation.landscape;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: landscape
                          ? Row(
                        children: [
                          Expanded(child: profileHeader()),
                          const SizedBox(width: 30),
                          Expanded(child: profileDetails()),
                        ],
                      )
                          : Column(
                        children: [
                          profileHeader(),
                          const SizedBox(height: 22),
                          profileDetails(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget profileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 52,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget profileDetails() {
    return Column(
      children: [
        Info(Icons.person_outline, 'Name', name),
        Info(Icons.email_outlined, 'Email', email),
        Info(
          Icons.phone_outlined,
          'Phone',
          phone.isEmpty ? 'Not added' : phone,
        ),
        Info(
          Icons.info_outline,
          'Bio',
          bio.isEmpty ? 'No bio added' : bio,
        ),
        const SizedBox(height: 10),
        Button(
          text: 'EDIT PROFILE',
          icon: Icons.edit_outlined,
          onPressed: editProfile,
        ),
      ],
    );
  }
}
// REUSABLE WIDGETS
class Header extends StatelessWidget {
  final IconData icon;
  final String title;

  const Header({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 75,
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboard;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const Field({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboard,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const Info(
      this.icon,
      this.title,
      this.value, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// VALIDATION

class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final regex = RegExp(
      r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$',
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final phone = value.replaceAll(
      RegExp(r'[\s-]'),
      '',
    );

    final regex = RegExp(
      r'^(03\d{9}|\+923\d{9})$',
    );

    if (!regex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}
