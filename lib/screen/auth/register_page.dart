import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 64,
              ),
              Image(
                  image: NetworkImage(
                      "https://images.blush.design/694a573ec09c9ed2ea069f5b13d9749e?w=920&auto=compress&cs=srgb"),
                  width: 200),
              SizedBox(
                height: 32,
              ),
              Text(
                "Register Akun",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("Masukkan akun dan password yang telah disediakan"),
              SizedBox(height: 40),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(decoration: FormDecoration("Masukkan email")),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    textAlign: TextAlign.start,
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: FormDecoration("Masukkan password"),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    textAlign: TextAlign.start,
                    "Konfirmasi Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: FormDecoration("Masukkan konfirmasi password"),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      color: ThemeData().primaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      onPressed: () {},
                      child: Text(
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          "Register"),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration FormDecoration(String hintText) {
  return (InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontWeight: FontWeight.normal),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none)));
}
