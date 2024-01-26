import 'package:ahli_gigi/config/api_config.dart';
import 'package:ahli_gigi/pages/dashboard/widget/daftar_layanan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahli_gigi/settings/constants/warna_apps.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Layanan extends StatefulWidget {
  const Layanan({super.key});

  @override
  State<Layanan> createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  late User? user;
  late Future<List<dynamic>> _serviceData;

  Future<List> getData() async {
    var url = Uri.parse('${ApiConfig.baseUrl}/api/Layanan'); //Api Link
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    _serviceData = getData();
    super.initState();
    initializeUser();
  }

  void initializeUser() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color.fromARGB(
          255, 0, 0, 0), //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Layanan',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        centerTitle: true,
      ),
      backgroundColor: AppColors.backGroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder<List<dynamic>>(
          future: _serviceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50.0), // Ganti nilai sesuai kebutuhan
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              List<dynamic> serviceList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white, // Warna latar belakang
                        // border: Border.all(
                        //   color: Colors.black45, // Warna border
                        //   width: 1, // Lebar border
                        // ),
                        borderRadius: BorderRadius.circular(
                            15.0), // Border radius untuk membuatnya menjadi rounded
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Warna shadow
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // Offset shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide
                                .none, // Hapus border bawaan dari TextField
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Popular
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      var service = serviceList[index];
                      return DaftarLayananCard(
                        imagePath: service['lokasi_gambar'],
                        nama_layanan: service['nama_layanan'],
                        harga: service['harga'].toString(),
                        deskripsi: service['deskripsi'],
                        isAvailable: false,
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
