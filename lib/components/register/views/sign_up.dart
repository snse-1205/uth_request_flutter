import 'package:flutter/material.dart';
import 'package:uth_request_flutter_application/components/register/views/register_academic.dart';
import 'package:uth_request_flutter_application/components/register/views/register_email_pin.dart';
import 'package:uth_request_flutter_application/components/register/views/register_info.dart';
import 'package:uth_request_flutter_application/components/register/views/register_password.dart';
import 'package:uth_request_flutter_application/components/utils/color.dart';
import 'package:uth_request_flutter_application/components/utils/string.dart';

class RegisterScreen extends StatefulWidget {
   const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 400,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    Center(
                      child: RegisterInfo(),
                    ),
                    Center(
                      child: RegisterAcademicPage(),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RegisterEmailPinPage(),
                        ],
                      ),
                    ),
                    Center(
                      child: RegisterPassword(),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin:  EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 16,
                    ),
                    width: _currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.secondary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              // BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_currentPage > 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text(botonAtras, style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarySecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:  EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_currentPage < 3) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        print("Registro completado");
                      }
                    },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    iconAlignment: IconAlignment.end,
                    label: Text(
                      _currentPage == 3 ? botonFinalizar : botonSiguiente,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:  EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      
    );
  }
}
