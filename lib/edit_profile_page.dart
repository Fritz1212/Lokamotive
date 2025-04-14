// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// Future <String> fetchData() async {
//   final response = await http.get(Uri.parse('http://localhost:3000/test'));

//   if(response.statusCode == 200) {
//     var data = response.body;
//     return data;
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   File? _profileImage;
//   final ImagePicker _picker = ImagePicker();

//   String? fullNameError;
//   String? emailError;
//   String? passwordError;

//   late WebSocketChannel channel;

//   @override
//   void initState() {
//     super.initState();
//     channel = IOWebSocketChannel.connect('ws://10.68.110.167:3000');
//   }

//   void sendAccount(String message) {
//     channel.sink.add(message);
//   }

//   void closeWebSocket() {
//     channel.sink.close();
//   }

//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           _profileImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to pick image')),
//       );
//     }
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Take a photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState!.validate()) {
//       // Handle form submission
//       // You can add your API call here
//       Navigator.pop(context, {
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'profileImage': _profileImage,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Edit Profile',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10),
//               // Profile Image Section
//               Stack(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFF1B3251),
//                       image: _profileImage != null
//                           ? DecorationImage(
//                               image: FileImage(_profileImage!),
//                               fit: BoxFit.cover,
//                             )
//                           : null,
//                     ),
//                     child: _profileImage == null
//                         ? SvgPicture.asset(
//                           'assets/Icon/user_profile_icon.svg',
//                           colorFilter: const ColorFilter.mode(
//                             Colors.white,
//                             BlendMode.srcIn,
//                           ),
//                           width: 80,
//                           height: 80,
//                         )
//                         : null,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: _showImageSourceDialog,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.orange,
//                         ),
//                         child: SvgPicture.asset(
//                           'assets/Icon/edit_profile_icon.svg',
//                           colorFilter: const ColorFilter.mode(
//                             Colors.white,
//                             BlendMode.srcIn,
//                           ),
//                           width: 30,
//                           height: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: MediaQuery.of(context).size.height * 0.07),
//               const Divider(
//                 color: Color.fromARGB(102, 0, 0, 0),
//                 thickness: 1.5,
//                 height: 1,
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//               // Full Name Field
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Full Name',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _nameController,
//                     // style: TextStyle(color: Color(0xff878787)),
//                     decoration: InputDecoration(
//                       hintText: 'User Name',
//                       fillColor: Color.fromARGB(51, 143, 188, 244),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       if (value.length < 2) {
//                         return 'Name must be at least 2 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               // Email Field
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Email',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       hintText: 'User Email',
//                       fillColor: Color.fromARGB(51, 143, 188, 244),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       final emailRegex = RegExp(
//                         r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
//                       );
//                       if (!emailRegex.hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//         margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Divider(
//               color: Color.fromARGB(102, 0, 0, 0),
//               thickness: 1.5,
//               height: 1,
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//             SizedBox(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.07,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _handleSubmit();
//                   sendAccount('{"action" : "EditProfile","user_name" : "${_nameController.text}", "email" : "${_emailController.text}"');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF225477),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lokamotive/dashboard_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://172.20.10.2:3000');
  }

  void sendAccount(String message) {
    channel.sink.add(message);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    channel.sink.close(); // Menutup WebSocket dengan benar
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;

      // Kirim data ke WebSocket
      final message =
          '{"action": "EditProfile", "user_name": "${_nameController.text}", "email": "${_emailController.text}", "old_email": "${GlobalData.email}"}';
      sendAccount(message);

      GlobalData.userName = _nameController.text;
      GlobalData.email = _emailController.text;

      Navigator.pop(context, {
        'name': name,
        'email': email,
        'profileImage': _profileImage,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Profile Image Section
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1B3251),
                      image: _profileImage != null
                          ? DecorationImage(
                              image: FileImage(_profileImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _profileImage == null
                        ? SvgPicture.asset(
                            'assets/Icon/user_profile_icon.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 80,
                            height: 80,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                        child: SvgPicture.asset(
                          'assets/Icon/edit_profile_icon.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  filled: true,
                  fillColor: const Color.fromARGB(51, 143, 188, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: const Color.fromARGB(51, 143, 188, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF225477),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
