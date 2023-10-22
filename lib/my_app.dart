import 'package:flutter/material.dart';
import 'package:flutter_cep/pages/cep_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.robotoTextTheme().apply(bodyColor: Colors.white),
      ),
      home: const CepPage(),
    );
  }
}
