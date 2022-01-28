import'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kilometry_user/authentication/signup_screen.dart';
import 'package:kilometry_user/global/global.dart';
import 'package:kilometry_user/splashScreen/splash_screen.dart';
import 'package:kilometry_user/widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget

{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if (!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Введите почту");
    }
    else if (passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Требуется пароль");
    }
    else
    {
      loginUserNow();
    }
  }

  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Загрузка, пожалуйста подождите...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Ошибка: " +msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
       DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey)
      {
        final snap = driverKey.snapshot;
        if(snap.value !=null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Вход выполнен.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "Нет записи э.почты.");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Ошибка при входе.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Вход пользователя",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Электронная почта",
                  hintText: "email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Пароль",
                  hintText: "******",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed:()
                {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey
                ),
                child: const Text(
                  "Войти",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,

                  ),
                ),
              ),

              TextButton(
                child: const Text(
                  "Зарегистрироватся?",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
