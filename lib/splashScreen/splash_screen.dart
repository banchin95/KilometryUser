import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kilometry_user/authentication/login_screen.dart';
import 'package:kilometry_user/global/global.dart';
import 'package:kilometry_user/mainScreens/main_screen.dart';


class MySplashScreen extends StatefulWidget

{
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>

{

  startTimer()
  {
    Timer(const Duration(seconds: 1), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }

    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              new Image(
                  image: AssetImage("images/logo.png"),
                  height: 60,
                  width: 60,
              ),

             const SizedBox(height: 20,),

             const Text(
                "",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }
}
