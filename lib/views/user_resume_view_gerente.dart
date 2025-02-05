// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:smartclothingproject/functions/bluetooth_notifier_data.dart';
// import 'package:smartclothingproject/functions/persistance_data.dart';
// import 'package:smartclothingproject/functions/show_toast.dart';
// import 'package:smartclothingproject/functions/update_notifiers_sensor_data.dart';
// import 'package:smartclothingproject/handlers/mongo_database.dart';
// import 'package:smartclothingproject/views/siso_page.dart';
// import 'package:smartclothingproject/views/home_user_worker.dart';

// class UserResumeView extends StatefulWidget {
//   final Map<String, dynamic> user;
//   const UserResumeView({
//     super.key,
//     required this.user,
//   });

//   @override
//   _UserResumeViewState createState() => _UserResumeViewState();
// }

// class _UserResumeViewState extends State<UserResumeView> {
//   late Map<String, dynamic> user;

//   void showDeleteUserDialog(BuildContext context) {
//     bool deletingUser = false;
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         opaque: false, // Permite que el fondo sea transparente
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return FadeTransition(
//             opacity: animation,
//             child: Stack(
//               children: [
//                 // Fondo desenfocado
//                 BackdropFilter(
//                   filter: ImageFilter.blur(
//                       sigmaX: 5.0,
//                       sigmaY: 5.0), // Ajusta el nivel de desenfoque
//                   child: Container(
//                     color: Colors.black.withOpacity(
//                         0.2), // Color semi-transparente sobre el fondo
//                   ),
//                 ),
//                 // Cuadro de diálogo
//                 deletingUser
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : Center(
//                         child: AlertDialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30)),
//                           contentPadding: const EdgeInsets.all(16),
//                           title: Text(
//                             'Eliminar a ${user['Name']} ${user['Surname']}',
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.lexend(
//                               color: Theme.of(context).colorScheme.tertiary,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 '¿Estás seguro de que deseas eliminar este usuario y todos sus datos guardados?',
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.lexend(
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   // Botón de "Eliminar"
//                                   ElevatedButton(
//                                     onPressed: () async {
//                                       setState(() {
//                                         deletingUser = true;
//                                       });
//                                       final mongoService =
//                                           Provider.of<MongoService>(context,
//                                               listen: false);
//                                       await mongoService.connect();
//                                       await mongoService.deleteDocument(
//                                           user['user_id'], 'users');
//                                       await mongoService.deleteDocument(
//                                           user['user_id'], 'data');
//                                       await mongoService.disconnect();
//                                       setState(() {
//                                         deletingUser = false;
//                                       });
//                                       showToast(message: 'Usuario eliminado');
//                                       saveLastPage('AdminPage');
//                                       Navigator.pushAndRemoveUntil(
//                                         context,
//                                         PageRouteBuilder(
//                                           pageBuilder: (context, animation,
//                                                   secondaryAnimation) =>
//                                               const SisoPage(),
//                                           transitionsBuilder: (context,
//                                               animation,
//                                               secondaryAnimation,
//                                               child) {
//                                             const beginOffset = Offset(0.0,
//                                                 1.0); // Comienza desde abajo
//                                             const endOffset = Offset
//                                                 .zero; // Termina en el centro
//                                             const curve = Curves.easeInOut;

//                                             var offsetTween = Tween(
//                                                     begin: beginOffset,
//                                                     end: endOffset)
//                                                 .chain(
//                                                     CurveTween(curve: curve));
//                                             var opacityTween = Tween<double>(
//                                                     begin: 0.0, end: 1.0)
//                                                 .chain(
//                                                     CurveTween(curve: curve));

//                                             return SlideTransition(
//                                               position:
//                                                   animation.drive(offsetTween),
//                                               child: FadeTransition(
//                                                 opacity: animation
//                                                     .drive(opacityTween),
//                                                 child: child,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                         (Route<dynamic> route) =>
//                                             false, // Elimina todas las vistas anteriores
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Theme.of(context).colorScheme.error,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Eliminar',
//                                       style: GoogleFonts.lexend(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   // Botón de "Cancelar"
//                                   OutlinedButton(
//                                     onPressed: () {
//                                       Navigator.of(context)
//                                           .pop(); // Cerrar el diálogo
//                                     },
//                                     style: OutlinedButton.styleFrom(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Cancelar',
//                                       style: GoogleFonts.lexend(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           );
//         },
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const curve = Curves.easeInOut; // Curva de animación suave

//           final scaleTween = Tween<double>(begin: 0.1, end: 1.0)
//               .chain(CurveTween(curve: curve));
//           final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
//               .chain(CurveTween(curve: curve));

//           return ScaleTransition(
//             scale: animation.drive(scaleTween), // Escala del zoom
//             child: FadeTransition(
//               opacity: animation.drive(
//                   fadeTween), // Efecto de desvanecimiento junto con el zoom
//               child: child,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     user = widget.user;
//     loadLastData();
//   }

//   Future<void> loadLastData() async {
//     final mongoService = Provider.of<MongoService>(context, listen: false);
//     await mongoService.connect();

//     final filter = {"user_id": user['user_id']};

//     List<Map<String, dynamic>> dataMongoDB =
//         await mongoService.getDocuments("data", filter: filter);

//     Map<String, dynamic> allSensorData = dataMongoDB.last;

//     if (allSensorData.isNotEmpty) {
//       updateNotifiersSensorData(allSensorData);
//     }

//     setState(() {});
//   }

//   void getUserData(Map<String, dynamic> user) async {
//     final mongoService = Provider.of<MongoService>(context, listen: false);
//     await mongoService.connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final double tempCorpValue =
//         double.tryParse(BlDataNotifier().temperatureCorporalData) ?? 0.0;
//     final double tempAmbValue =
//         double.tryParse(BlDataNotifier().temperatureAmbData) ?? 0.0;
//     final double humidityValue =
//         double.tryParse(BlDataNotifier().humidityData) ?? 0.0;
//     final int bpmData = int.tryParse(BlDataNotifier().bpmData) ?? 0;
//     final double anglePosition =
//         double.tryParse(BlDataNotifier().accelerometerXData) ?? 0.0;

//     String formattedDate = BlDataNotifier().dateTimeData;

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           weight: 50,
//           size: 32,
//         ),
//         toolbarHeight: 100,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: ClipRect(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               color: Colors.transparent,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.replay_outlined,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           // IconButton(
//           //   onPressed: () async {
//           //     showDeleteUserDialog(context);
//           //   },
//           //   icon: Icon(
//           //     Icons.delete_outline_outlined,
//           //     color: Theme.of(context)
//           //         .colorScheme
//           //         .tertiary
//           //         .withBlue(100)
//           //         .withGreen(100),
//           //   ),
//           // ),
//         ],
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: Text(
//           'Resumen',
//           style: GoogleFonts.lexend(
//             color: Theme.of(context).primaryColor,
//             fontSize: 25,
//           ),
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(15),
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: SingleChildScrollView(
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 width: screenWidth * 0.3, // Ancho fijo para el círculo
//                 height: screenHeight * 0.15,
//                 margin: const EdgeInsets.only(bottom: 10),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.secondary,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   user['Name'][0].toUpperCase(),
//                   style: GoogleFonts.wixMadeforDisplay(
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     fontSize: 40,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0,
//                           vertical:
//                               8.0), // Añadimos padding para mayor separación
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment
//                             .start, // Alineamos el contenido a la izquierda
//                         children: [
//                           // Título principal
//                           Text(
//                             'Datos Generales',
//                             style: GoogleFonts.wixMadeforDisplay(
//                               color: Theme.of(context).primaryColor,
//                               fontSize:
//                                   35, // Tamaño más grande para destacar el título
//                               fontWeight: FontWeight.bold, // Título en negrita
//                             ),
//                           ),
//                           const SizedBox(
//                               height:
//                                   8.0), // Espaciado entre el título y los demás datos
//                           // Información del usuario
//                           _buildInfoRow(context, 'Nombre completo:',
//                               '${user['Name']} ${user['Surname']}'),
//                           _buildInfoRow(context, 'Código:', user['user_id']),
//                           _buildInfoRow(
//                               context, 'Edad:', '${user['Age']} años'),
//                           _buildInfoRow(context, 'Correo:', user['Email']),
//                           _buildInfoRow(context, 'Género:', user['Gender']),
//                           _buildInfoRow(
//                               context, 'Celular:', user['PhoneNumber']),
//                           _buildInfoRow(context, 'CC:', user['Cedula']),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 width: screenWidth * 1,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 // height: screenHeight * 0.15,
//                 // color: Theme.of(context).colorScheme.error,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Último Reporte de Variables Médicas',
//                       style: GoogleFonts.wixMadeforDisplay(
//                         color: Theme.of(context).primaryColor,
//                         fontSize:
//                             35, // Tamaño más grande para destacar el título
//                         fontWeight: FontWeight.bold, // Título en negrita
//                       ),
//                     ),
//                     Center(
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(10), // Esquinas redondeadas
//                         ),
//                         elevation: 0,
//                         child: AnimatedContainer(
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).scaffoldBackgroundColor,
//                           ),
//                           duration: const Duration(milliseconds: 250),
//                           height: screenHeight * 0.12,
//                           width: screenWidth * 0.7,
//                           alignment: Alignment.center,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Icon(
//                                 getPostureIcon(anglePosition),
//                                 size: 50,
//                                 color:
//                                     getPostureIconColor(anglePosition, context),
//                               ),
//                               Text(
//                                 getPostureStatus(anglePosition),
//                                 style: GoogleFonts.lexend(
//                                     fontSize: 28,
//                                     letterSpacing: 0,
//                                     fontWeight: FontWeight.w600,
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const SectionHeader(title: 'Variables Ambientales'),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           DataCard(
//                               title: 'Temperatura Ambiental',
//                               value: '${(tempAmbValue * 10).ceil() / 10}°C',
//                               textColor: Theme.of(context).primaryColor),
//                           DataCard(
//                               title: 'Humedad',
//                               value: '${(humidityValue * 10).ceil() / 10}%',
//                               textColor: Theme.of(context).primaryColor),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const SectionHeader(title: 'Variables Corporales'),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           DataCard(
//                               title: 'Temperatura  Corporal',
//                               value: '${(tempCorpValue * 10).ceil() / 10}°C',
//                               textColor: Theme.of(context).primaryColor),
//                           DataCard(
//                             title: 'BPM',
//                             value: '$bpmData',
//                             textColor: Theme.of(context).primaryColor,
//                             icon: (Icons.favorite_rounded),
//                             iconColor: Colors.red,
//                           ),
//                         ],
//                       ),
//                     ),
//                     DataCard(
//                       title: 'Inclinación',
//                       value: '${(anglePosition * 10).ceil() / 10}°',
//                       textColor: Theme.of(context).primaryColor,
//                       icon: (Icons.personal_injury_outlined),
//                       iconColor: Theme.of(context).primaryColor,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Center(
//                       child: Text(
//                         textAlign: TextAlign.center,
//                         // 'lun, dic 23, 2024 - 09:04 a. m.',
//                         formattedDate,
//                         style: GoogleFonts.lexend(
//                             fontSize: 22,
//                             letterSpacing: 0,
//                             fontWeight: FontWeight.w500,
//                             color: Theme.of(context).primaryColor),
//                       ),
//                     ),
//                     Center(
//                         child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.watch_later_outlined,
//                           color: Theme.of(context).primaryColor,
//                           size: 18,
//                         ),
//                         Text(
//                           textAlign: TextAlign.center,
//                           'Última medición',
//                           style: GoogleFonts.lexend(
//                               fontSize: 18,
//                               letterSpacing: 0,
//                               fontWeight: FontWeight.w300,
//                               color: Theme.of(context).primaryColor),
//                         ),
//                       ],
//                     )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildInfoRow(BuildContext context, String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8.0), // Espaciado entre las filas
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Etiqueta (por ejemplo: "Nombre completo:")
//         Text(
//           '$label ',
//           style: GoogleFonts.wixMadeforDisplay(
//             color: Theme.of(context).primaryColor,
//             fontSize: 18,
//             fontWeight: FontWeight.w600, // Negrita ligera para la etiqueta
//           ),
//         ),
//         // Valor (por ejemplo: "John Doe")
//         Expanded(
//           child: Text(
//             value,
//             style: GoogleFonts.wixMadeforDisplay(
//               color: Theme.of(context).primaryColor,
//               fontSize: 18,
//               fontWeight: FontWeight.w400, // Peso regular para el valor
//             ),
//             overflow: TextOverflow.ellipsis, // Trunca el texto si es muy largo
//             maxLines: 1, // Muestra solo una línea
//           ),
//         ),
//       ],
//     ),
//   );
// }
