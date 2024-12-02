import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String selectedMaritalStatus = '';
String selectedScholarityLevel = '';
String occupation = '';
String cityOfResidence = '';
String stateOfResidence = '';
String statusResidence = '';
String peopleEconomlyDepend = '';
String numberOfChildren = '';
String typeHome = '';
String bloodType = '';
String timeWorking = '';
String currentRole = '';
String contractType = '';

final _formKey = GlobalKey<FormState>();
final _formKey1 = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();
final _formKey3 = GlobalKey<FormState>();
final _formKey4 = GlobalKey<FormState>();

DateTime? selectedDate1;
final TextEditingController _dateController = TextEditingController();

bool registerBtn = false;

const marginCustom = EdgeInsets.symmetric(horizontal: 1.0, vertical: 0);

const spaceSizedBox = SizedBox(
  height: 2.5,
);
const radiusNormal = 25.0;
const radiusFocus = 1.0;
// const radiusBtn = 0.0;

String selectedProfession = '';

final List<String> professions = [
  'Ingeniero',
  'Doctor',
  'Profesor',
  'Arquitecto',
  'Abogado',
  'Diseñador',
  'Desarrollador',
  'Mecánico',
];

String selectedDepartamento = '';
final List<String> departamentos = [
  'Amazonas',
  'Antioquia',
  'Arauca',
  'Atlántico',
  'Bolívar',
  'Boyacá',
  'Caldas',
  'Caquetá',
  'Casanare',
  'Cauca',
  'Cesar',
  'Chocó',
  'Córdoba',
  'Cundinamarca',
  'Guainía',
  'Guaviare',
  'Huila',
  'La Guajira',
  'Magdalena',
  'Meta',
  'Nariño',
  'Norte de Santander',
  'Putumayo',
  'Quindío',
  'Risaralda',
  'San Andrés, Providencia y Santa Catalina',
  'Santander',
  'Sucre',
  'Tolima',
  'Valle del Cauca',
  'Vaupés',
  'Vichada',
];

List<Map<String, dynamic>> questionsForm = [
  {
    'question': '¿Cuál es su estado civil?',
    'categoryValue': 'Estado civil',
    'options': [
      'Soltero (a)',
      'Casado (a)',
      'Union libre',
      'Separado (a)',
      'Divorciado (a)',
      'Viudo (a)',
    ],
    'iconSection': Icons.bed_outlined,
    'storedVar': selectedMaritalStatus
  },
  {
    'question': '¿Cuál es su nivel de estudios?',
    'categoryValue': 'Nivel de estudios',
    'options': [
      'Primaria incompleta',
      'Primaria completa',
      'Bachillerato incompleto',
      'Bachillerato completo',
      'Técnico / tecnológico incompleto',
      'Técnico / tecnológico completo',
      'Profesional incompleto',
      'Profesional completo',
      'Carrera militar / policía',
      'Post-grado incompleto',
      'Post-grado completo'
    ],
    'iconSection': Icons.school_outlined,
    'storedVar': selectedScholarityLevel
  },
  // {
  //   'question': '¿Cuál es su tipo de vivienda?',
  //   'categoryValue': 'Tipo de vivienda',
  //   'options': ['Propia', 'Alquilada', 'Familiar', 'Otra'],
  //   'iconSection': Icons.home_outlined,
  //   'storedVar': typeHome
  // },
  // {
  //   'question': '¿Cuál es su estrato socioeconómico?',
  //   'categoryValue': 'Estrato social',
  //   'options': ['0', '1', '2', '3', '4', '5', '6', 'Rural', 'No sé'],
  //   'iconSection': Icons.insert_chart_outlined_outlined,
  //   'storedVar': statusResidence
  // },
  {
    'question': '¿Cuál es su tipo de sangre?',
    'categoryValue': 'Tipo de sangre',
    'options': ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'],
    'iconSection': Icons.bloodtype_outlined,
    'storedVar': bloodType
  },
  {
    'question': '¿Cuánto tiempo ha estado en esta empresa?',
    'categoryValue': 'Tiempo en la empresa',
    'options': ['Menos de un año', 'Mas de un año'],
    'iconSection': Icons.work_history_outlined,
    'storedVar': timeWorking
  },
  {
    'question': '¿Qué tipo de cargo tiene en la empresa?',
    'categoryValue': 'Tipo de cargo',
    'options': [
      'Jefatura',
      'Profesional',
      'Analista',
      'Técnico',
      'Tecnólogo',
      'Auxiliar',
      'Asistente administrativo',
      'Asistente técnico',
      'Operario',
      'Operador',
      'Ayudante',
      'Servicios generales',
    ],
    'iconSection': Icons.co_present_outlined,
    'storedVar': currentRole
  },
  {
    'question': '¿Qué tipo de contrato tiene en la empresa?',
    'categoryValue': 'Tipo de contrato',
    'options': [
      'Temporal de menos de 1 años',
      'Temporal de 1 año o mas',
      'Término indefinido',
      'Cooperado',
      'Prestación de servicios',
      'No sé'
    ],
    'iconSection': Icons.monetization_on_outlined,
    'storedVar': contractType
  },
];

class DemographicProfileWorker extends StatefulWidget {
  const DemographicProfileWorker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DemographicProfileWorkerState createState() =>
      _DemographicProfileWorkerState();
}

class _DemographicProfileWorkerState extends State<DemographicProfileWorker> {
  final PageController _pageController =
      PageController(); // Controlador para el PageView
  int _currentPage = 0; // Índice de la página actual

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent));
    });

    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Perfil Demográfico'),
        // ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Esquinas redondeadas
          ),
          splashColor: const Color.fromRGBO(155, 100, 255, 1.0),
          hoverElevation: 5,
          elevation: 0,
          onPressed: () {
            // Navegar a la siguiente página
            if (_currentPage < 3) {
              // Cambia este valor según el número de páginas
              _pageController.animateToPage(
                _currentPage + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          backgroundColor: const Color.fromRGBO(10, 120, 255, 1.0),
          child: const Icon(Icons.navigate_next_outlined),
        ),
        body: Center(
            child: Container(
          width: screenWidth > 720 ? screenWidth * 0.6 : screenWidth * 0.98,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  PersonalQuestions(),
                  PersonalQuestions2(),
                  ResidenceQuestions(),
                  // LaboralQuestions(),
                  HealthQuestions(),
                ],
              )),
              // Indicador de puntos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Color.fromRGBO(10, 100, 255, 1.0)
                          : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10), // Espaciado debajo de los puntos
            ],
          ),
        )));
  }
}

class PersonalQuestions extends StatefulWidget {
  const PersonalQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalQuestions createState() => _PersonalQuestions();
}

class _PersonalQuestions extends State<PersonalQuestions> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Establece la fecha inicial como la actual
      firstDate: DateTime(1900), // Permite seleccionar desde el año 1900
      lastDate: DateTime.now(), // Permite seleccionar hasta la fecha actual
    );

    if (picked != null && picked != selectedDate1) {
      setState(() {
        selectedDate1 = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                // Registro de usuario
                width: screenWidth,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(color: Colors.transparent
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.pink.withOpacity(0.25),
                    //     Colors.purple.withOpacity(0.25),
                    //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                    //     Colors.blue.withOpacity(0.25),
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   margin: marginCustom,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           '¿Cuál es su departamento de nacimiento?',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             color:
                      //                 Theme.of(context).colorScheme.secondary,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 3),
                      //         Autocomplete<String>(
                      //           optionsBuilder:
                      //               (TextEditingValue textEditingValue) {
                      //             if (textEditingValue.text.isEmpty) {
                      //               return const Iterable<String>.empty();
                      //             }
                      //             return departamentos
                      //                 .where((String profession) {
                      //               return profession.toLowerCase().contains(
                      //                   textEditingValue.text.toLowerCase());
                      //             });
                      //           },
                      //           onSelected: (String selection) {
                      //             setState(() {
                      //               selectedProfession = selection;
                      //             });
                      //           },
                      //           fieldViewBuilder: (BuildContext context,
                      //               TextEditingController textEditingController,
                      //               FocusNode focusNode,
                      //               VoidCallback onFieldSubmitted) {
                      //             return TextFormField(
                      //               controller: textEditingController,
                      //               focusNode: focusNode,
                      //               decoration: InputDecoration(
                      //                 prefixIcon: Padding(
                      //                   padding:
                      //                       const EdgeInsetsDirectional.only(
                      //                           start: 12.0),
                      //                   child: Icon(
                      //                     Icons.location_on_outlined,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary,
                      //                   ),
                      //                 ),
                      //                 labelText: 'Departamento de nacimiento',
                      //                 labelStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide: const BorderSide(
                      //                       color: Colors.blue, width: 1.5),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusFocus),
                      //                 ),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                     color: (registerBtn &&
                      //                             (occupation).isEmpty)
                      //                         ? Colors.red
                      //                         : Theme.of(context)
                      //                             .colorScheme
                      //                             .secondary,
                      //                     width: 0.75,
                      //                   ),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusNormal),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //     margin: marginCustom,
                      //     child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               '¿Cuál es su ciudad/municipio de nacimiento?',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .secondary,
                      //               ),
                      //             ),
                      //             spaceSizedBox,
                      //             TextFormField(
                      //               decoration: InputDecoration(
                      //                 prefixIcon: Padding(
                      //                   padding:
                      //                       const EdgeInsetsDirectional.only(
                      //                           start: 12.0),
                      //                   child: Icon(
                      //                     Icons.location_city_outlined,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary,
                      //                   ),
                      //                 ),
                      //                 counterStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .primaryColorDark),
                      //                 labelText:
                      //                     'Ciudad/municipio de nacimiento',
                      //                 labelStyle: TextStyle(
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .secondary),
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide: const BorderSide(
                      //                       color: Colors.blue, width: 1.5),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusFocus),
                      //                 ),
                      //                 enabledBorder: OutlineInputBorder(
                      //                   borderSide: BorderSide(
                      //                     color: (registerBtn &&
                      //                             (occupation).isEmpty)
                      //                         ? Colors.red
                      //                         : Theme.of(context)
                      //                             .colorScheme
                      //                             .secondary,
                      //                     width: 0.75,
                      //                   ),
                      //                   borderRadius:
                      //                       BorderRadius.circular(radiusNormal),
                      //                 ),
                      //               ),
                      //               style: TextStyle(
                      //                   color: Theme.of(context)
                      //                       .colorScheme
                      //                       .secondary),
                      //               validator: (value) {
                      //                 if (value == null || value.isEmpty) {
                      //                   return 'Por favor ingresa tu ciudad de nacimiento';
                      //                 }
                      //                 return null;
                      //               },
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   occupation = value;
                      //                 });
                      //               },
                      //             ),
                      //           ],
                      //         ))),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese su cédula de ciudadanía',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              TextFormField(
                                keyboardType: TextInputType
                                    .number, // Activa el teclado numérico
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Permite solo números
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12.0),
                                    child: Icon(
                                      Icons.contact_emergency_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  counterStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                  labelText: 'Número de cédula de ciudadanía',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.5),
                                    borderRadius:
                                        BorderRadius.circular(radiusFocus),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (registerBtn &&
                                              (numberOfChildren).isEmpty)
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      width: 0.75,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radiusNormal),
                                  ),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresu número de cédula';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    numberOfChildren = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de expedición',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    controller: _dateController,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(Icons.date_range_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary), // myIcon is a 48px-wide widget.
                                        ),
                                        labelText: 'Fecha de expedición',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: (registerBtn &&
                                                        selectedDate1 == null)
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75),
                                            borderRadius: BorderRadius.circular(
                                                radiusNormal))),
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor selecciona tu fecha de expedición';
                                      }
                                      return null;
                                    },
                                  ),
                                ])),
                      ),
                      Container(
                        margin: marginCustom,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingrese el departamento de expedición',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              spaceSizedBox,
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return departamentos
                                      .where((String profession) {
                                    return profession.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  setState(() {
                                    selectedProfession = selection;
                                  });
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      labelText: 'Departamento de expedición',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (occupation).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ingrese ciudad/municipio de expedición',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.location_city_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText:
                                          'Ciudad/municipio de expedición',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (occupation).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu ciudad de trabajo';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        occupation = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class PersonalQuestions2 extends StatefulWidget {
  const PersonalQuestions2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalQuestions2 createState() => _PersonalQuestions2();
}

class _PersonalQuestions2 extends State<PersonalQuestions2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    // Registro de usuario
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(color: Colors.transparent
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Colors.pink.withOpacity(0.25),
                        //     Colors.purple.withOpacity(0.25),
                        //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                        //     Colors.blue.withOpacity(0.25),
                        //   ],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        ),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...[
                            1,
                          ].expand((nc) {
                            List<Widget> widgets = [];

                            // Validar y configurar el valor inicial
                            String? initialValue =
                                questionsForm[nc]['storedVar'];
                            if (!questionsForm[nc]['options']
                                .contains(initialValue)) {
                              initialValue =
                                  null; // Si el valor no es válido, inicializa con null
                            }

                            // Agregar el DropdownButtonFormField
                            widgets.add(
                              Container(
                                margin: marginCustom,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            questionsForm[nc]['question'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          spaceSizedBox,
                                          DropdownButtonFormField<String>(
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 12.0),
                                                child: Icon(
                                                  questionsForm[nc]
                                                      ['iconSection'],
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              labelText: questionsForm[nc]
                                                  ['categoryValue'],
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusFocus),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: (registerBtn &&
                                                          !questionsForm[nc]
                                                                  ['options']
                                                              .contains(
                                                                  questionsForm[
                                                                          nc][
                                                                      'storedVar']))
                                                      ? Colors.red
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  width: 0.75,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusNormal),
                                              ),
                                            ),
                                            value: initialValue,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            items: questionsForm[nc]['options']
                                                .map<DropdownMenuItem<String>>(
                                                  (String value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedScholarityLevel =
                                                    newValue!;
                                              });
                                            },
                                            iconEnabledColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            validator: (value) => value == null
                                                ? 'Por favor selecciona una opción'
                                                : null,
                                          ),
                                        ])),
                              ),
                            );
                            if (selectedScholarityLevel.isNotEmpty &&
                                ![
                                  'Primaria incompleta',
                                  'Primaria completa',
                                  'Bachillerato incompleto',
                                  'Bachillerato completo',
                                ].contains(selectedScholarityLevel)) {
                              widgets.add(
                                Container(
                                    margin: marginCustom,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '¿Cuál es el nombre del programa que estudió?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              spaceSizedBox,
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(start: 12.0),
                                                    child: Icon(
                                                      Icons.book_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  counterStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                  labelText:
                                                      'Nombre del programa de estudio',
                                                  labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue,
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusFocus),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: (registerBtn &&
                                                              (occupation)
                                                                  .isEmpty)
                                                          ? Colors.red
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      width: 0.75,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusNormal),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingrese nombre del programa de estudio';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    occupation = value;
                                                  });
                                                },
                                              ),
                                            ])) ////////
                                    ),
                              );
                            }

                            // Agregar el TextFormField si es nc == 2
                            if (nc == 1) {
                              widgets.add(
                                Container(
                                    margin: marginCustom,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '¿Cuál es su ocupación o profesión?',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              spaceSizedBox,
                                              TextFormField(
                                                decoration: InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(start: 12.0),
                                                    child: Icon(
                                                      Icons.cases_outlined,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  counterStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                  labelText:
                                                      'Ocupación o profesión',
                                                  labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue,
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusFocus),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: (registerBtn &&
                                                              (occupation)
                                                                  .isEmpty)
                                                          ? Colors.red
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      width: 0.75,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusNormal),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Por favor ingresa tu ocupación o profesión';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    occupation = value;
                                                  });
                                                },
                                              ),
                                            ])) ////////
                                    ),
                              );
                            }
                            return widgets;
                          }),
                          ...[0].expand((nc) {
                            List<Widget> widgets = [];

                            // Validar y configurar el valor inicial
                            String? initialValue =
                                questionsForm[nc]['storedVar'];
                            if (!questionsForm[nc]['options']
                                .contains(initialValue)) {
                              initialValue =
                                  null; // Si el valor no es válido, inicializa con null
                            }

                            // Agregar el DropdownButtonFormField
                            widgets.add(
                              Container(
                                  margin: marginCustom,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionsForm[nc]['question'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            spaceSizedBox,
                                            DropdownButtonFormField<String>(
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_outlined),
                                              dropdownColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 12.0),
                                                  child: Icon(
                                                    questionsForm[nc]
                                                        ['iconSection'],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                labelText: questionsForm[nc]
                                                    ['categoryValue'],
                                                labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusFocus),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (registerBtn &&
                                                            !questionsForm[nc]
                                                                    ['options']
                                                                .contains(
                                                                    questionsForm[
                                                                            nc][
                                                                        'storedVar']))
                                                        ? Colors.red
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    width: 0.75,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusNormal),
                                                ),
                                              ),
                                              value: initialValue,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              items: questionsForm[nc]
                                                      ['options']
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  questionsForm[nc]
                                                      ['storedVar'] = newValue!;
                                                });
                                              },
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Por favor selecciona una opción'
                                                  : null,
                                            ),
                                          ]))),
                            );

                            // Agregar el TextFormField si es nc == 2

                            return widgets;
                          }),
                          Container(
                            margin: marginCustom,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿Cuántos hijos tiene?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    keyboardType: TextInputType
                                        .number, // Activa el teclado numérico
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permite solo números
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.child_care_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'Cantidad de hijos',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (numberOfChildren).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa la cantidad de hijos que tiene';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        numberOfChildren = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: marginCustom,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿Cuántas personas dependen económicamente de usted (aunque vivan en otro lugar)?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    keyboardType: TextInputType
                                        .number, // Activa el teclado numérico
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permite solo números
                                    ],
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.people_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText:
                                          'Personas que dependen económicamente de usted',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (peopleEconomlyDepend)
                                                      .isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa la cantidad de personas que dependen de usted';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        peopleEconomlyDepend = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class LaboralQuestions extends StatefulWidget {
  const LaboralQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LaboralQuestions createState() => _LaboralQuestions();
}

class _LaboralQuestions extends State<LaboralQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      // Registro de usuario
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: const BoxDecoration(color: Colors.transparent
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.pink.withOpacity(0.25),
                          //     Colors.purple.withOpacity(0.25),
                          //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                          //     Colors.blue.withOpacity(0.25),
                          //   ],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          ),
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: marginCustom,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿En qué departamento trabaja actualmente?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    Autocomplete<String>(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        }
                                        return departamentos
                                            .where((String profession) {
                                          return profession
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (String selection) {
                                        setState(() {
                                          selectedProfession = selection;
                                        });
                                      },
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              textEditingController,
                                          FocusNode focusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextFormField(
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 12.0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            labelText:
                                                'Departamento donde trabaja',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusFocus),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: (registerBtn &&
                                                        (occupation).isEmpty)
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusNormal),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                margin: marginCustom,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '¿En qué ciudad/municipio trabaja actualmente?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        spaceSizedBox,
                                        TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 12.0),
                                              child: Icon(
                                                Icons.location_city_outlined,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            counterStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                            labelText:
                                                'Ciudad/municipio donde trabaja',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusFocus),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: (registerBtn &&
                                                        (occupation).isEmpty)
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusNormal),
                                            ),
                                          ),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor ingresa tu ciudad de trabajo';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              occupation = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ))),
                            ...[5].expand((nc) {
                              List<Widget> widgets = [];

                              // Validar y configurar el valor inicial
                              String? initialValue =
                                  questionsForm[nc]['storedVar'];
                              if (!questionsForm[nc]['options']
                                  .contains(initialValue)) {
                                initialValue =
                                    null; // Si el valor no es válido, inicializa con null
                              }

                              // Agregar el DropdownButtonFormField
                              widgets.add(
                                Container(
                                  margin: marginCustom,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              overflow: TextOverflow.ellipsis,
                                              questionsForm[nc]['question'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            spaceSizedBox,
                                            DropdownButtonFormField<String>(
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_outlined),
                                              dropdownColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 12.0),
                                                  child: Icon(
                                                    questionsForm[nc]
                                                        ['iconSection'],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                labelText: questionsForm[nc]
                                                    ['categoryValue'],
                                                labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusFocus),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (registerBtn &&
                                                            !questionsForm[nc]
                                                                    ['options']
                                                                .contains(
                                                                    questionsForm[
                                                                            nc][
                                                                        'storedVar']))
                                                        ? Colors.red
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    width: 0.75,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusNormal),
                                                ),
                                              ),
                                              value: initialValue,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              items: questionsForm[nc]
                                                      ['options']
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        value,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  questionsForm[nc]
                                                      ['storedVar'] = newValue!;
                                                });
                                              },
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Por favor selecciona una opción'
                                                  : null,
                                            ),
                                          ])),
                                ),
                              );
                              return widgets;
                            }),
                            ...[3].expand((nc) {
                              List<Widget> widgets = [];

                              // Validar y configurar el valor inicial
                              String? initialValue =
                                  questionsForm[nc]['storedVar'];
                              if (!questionsForm[nc]['options']
                                  .contains(initialValue)) {
                                initialValue =
                                    null; // Si el valor no es válido, inicializa con null
                              }

                              // Agregar el DropdownButtonFormField
                              widgets.add(
                                Container(
                                  margin: marginCustom,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionsForm[nc]['question'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            spaceSizedBox,
                                            DropdownButtonFormField<String>(
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_outlined),
                                              dropdownColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 12.0),
                                                  child: Icon(
                                                    questionsForm[nc]
                                                        ['iconSection'],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                labelText: questionsForm[nc]
                                                    ['categoryValue'],
                                                labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusFocus),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (registerBtn &&
                                                            !questionsForm[nc]
                                                                    ['options']
                                                                .contains(
                                                                    questionsForm[
                                                                            nc][
                                                                        'storedVar']))
                                                        ? Colors.red
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    width: 0.75,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusNormal),
                                                ),
                                              ),
                                              value: initialValue,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              items: questionsForm[nc]
                                                      ['options']
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        value,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  timeWorking = newValue!;
                                                });
                                              },
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Por favor selecciona una opción'
                                                  : null,
                                            ),
                                          ])),
                                ),
                              );
                              if (timeWorking.isNotEmpty &&
                                  timeWorking == 'Mas de un año') {
                                widgets.add(
                                  Container(
                                    margin: marginCustom,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '¿Cuántos años lleva en la empresa?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          spaceSizedBox,
                                          TextFormField(
                                            keyboardType: TextInputType
                                                .number, // Activa el teclado numérico
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly, // Permite solo números
                                            ],
                                            decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 12.0),
                                                child: Icon(
                                                  Icons.edit_calendar_outlined,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              counterStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                              labelText:
                                                  'Cantidad de años en la empresa',
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusFocus),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: (registerBtn &&
                                                          (numberOfChildren)
                                                              .isEmpty)
                                                      ? Colors.red
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  width: 0.75,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        radiusNormal),
                                              ),
                                            ),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Por favor ingresa la cantidad de hijos que tiene';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                numberOfChildren = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return widgets;
                            }),
                            ...[5].expand((nc) {
                              List<Widget> widgets = [];

                              // Validar y configurar el valor inicial
                              String? initialValue =
                                  questionsForm[nc]['storedVar'];
                              if (!questionsForm[nc]['options']
                                  .contains(initialValue)) {
                                initialValue =
                                    null; // Si el valor no es válido, inicializa con null
                              }

                              // Agregar el DropdownButtonFormField
                              widgets.add(
                                Container(
                                  margin: marginCustom,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionsForm[nc]['question'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            spaceSizedBox,
                                            DropdownButtonFormField<String>(
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_outlined),
                                              dropdownColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 12.0),
                                                  child: Icon(
                                                    questionsForm[nc]
                                                        ['iconSection'],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                                labelText: questionsForm[nc]
                                                    ['categoryValue'],
                                                labelStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusFocus),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (registerBtn &&
                                                            !questionsForm[nc]
                                                                    ['options']
                                                                .contains(
                                                                    questionsForm[
                                                                            nc][
                                                                        'storedVar']))
                                                        ? Colors.red
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    width: 0.75,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          radiusNormal),
                                                ),
                                              ),
                                              value: initialValue,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              items: questionsForm[nc]
                                                      ['options']
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (String value) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: value,
                                                      child: Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        value,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  contractType = newValue!;
                                                });
                                              },
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Por favor selecciona una opción'
                                                  : null,
                                            ),
                                          ])),
                                ),
                              );
                              return widgets;
                            }),
                            Container(
                              margin: marginCustom,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su salario actual?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      keyboardType: TextInputType
                                          .number, // Activa el teclado numérico
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Permite solo números
                                      ],
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.attach_money_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText: 'Salario actual',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (registerBtn &&
                                                    (numberOfChildren).isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su salario';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          numberOfChildren = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class ResidenceQuestions extends StatefulWidget {
  const ResidenceQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResidenceQuestions createState() => _ResidenceQuestions();
}

class _ResidenceQuestions extends State<ResidenceQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  // Registro de usuario
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: Colors.transparent
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.pink.withOpacity(0.25),
                      //     Colors.purple.withOpacity(0.25),
                      //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                      //     Colors.blue.withOpacity(0.25),
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      ),
                  child: Form(
                    key: _formKey3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: marginCustom,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿Cuál es su departamento de residencia?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                spaceSizedBox,
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return departamentos
                                        .where((String profession) {
                                      return profession.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    setState(() {
                                      selectedProfession = selection;
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        labelText: 'Departamento de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (registerBtn &&
                                                    (occupation).isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su ciudad/municipio de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.location_city_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText:
                                            'Ciudad/Municipio de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (registerBtn &&
                                                    (occupation).isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa tu ciudad de residencia';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          occupation = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su barrio/localidad de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.home_work_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText:
                                            'Barrio/localidad de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (registerBtn &&
                                                    (occupation).isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su barrio de residencia';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          occupation = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        Container(
                            margin: marginCustom,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Cuál es su dirección de residencia?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    spaceSizedBox,
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 12.0),
                                          child: Icon(
                                            Icons.near_me_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        counterStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                        labelText: 'Dirección de residencia',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 1.5),
                                          borderRadius: BorderRadius.circular(
                                              radiusFocus),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (registerBtn &&
                                                    (occupation).isEmpty)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            width: 0.75,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              radiusNormal),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingrese su dirección';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          occupation = value;
                                        });
                                      },
                                    ),
                                  ],
                                ))),
                        // ...[2, 3].expand((nc) {
                        //   List<Widget> widgets = [];

                        //   // Validar y configurar el valor inicial
                        //   String? initialValue = questionsForm[nc]['storedVar'];
                        //   if (!questionsForm[nc]['options']
                        //       .contains(initialValue)) {
                        //     initialValue =
                        //         null; // Si el valor no es válido, inicializa con null
                        //   }

                        //   // Agregar el DropdownButtonFormField
                        //   widgets.add(
                        //     Container(
                        //         margin: marginCustom,
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 questionsForm[nc]['question'] ??
                        //                     'Pregunta no disponible',
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   color: Theme.of(context)
                        //                       .colorScheme
                        //                       .secondary,
                        //                 ),
                        //               ),
                        //               DropdownButtonFormField<String>(
                        //                 icon: const Icon(
                        //                     Icons.keyboard_arrow_down_outlined),
                        //                 dropdownColor: Theme.of(context)
                        //                     .scaffoldBackgroundColor,
                        //                 decoration: InputDecoration(
                        //                   prefixIcon: Padding(
                        //                     padding: const EdgeInsetsDirectional
                        //                         .only(start: 12.0),
                        //                     child: Icon(
                        //                       questionsForm[nc]['iconSection'],
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .secondary,
                        //                     ),
                        //                   ),
                        //                   labelText: questionsForm[nc]
                        //                       ['categoryValue'],
                        //                   labelStyle: TextStyle(
                        //                       color: Theme.of(context)
                        //                           .colorScheme
                        //                           .secondary),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderSide: const BorderSide(
                        //                         color: Colors.blue, width: 1.5),
                        //                     borderRadius: BorderRadius.circular(
                        //                         radiusFocus),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderSide: BorderSide(
                        //                       color: (registerBtn &&
                        //                               !questionsForm[nc]
                        //                                       ['options']
                        //                                   .contains(
                        //                                       questionsForm[nc][
                        //                                           'storedVar']))
                        //                           ? Colors.red
                        //                           : Theme.of(context)
                        //                               .colorScheme
                        //                               .secondary,
                        //                       width: 0.75,
                        //                     ),
                        //                     borderRadius: BorderRadius.circular(
                        //                         radiusNormal),
                        //                   ),
                        //                 ),
                        //                 value: initialValue,
                        //                 style: TextStyle(
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary),
                        //                 items: questionsForm[nc]['options']
                        //                     .map<DropdownMenuItem<String>>(
                        //                       (String value) =>
                        //                           DropdownMenuItem<String>(
                        //                         value: value,
                        //                         child: Text(
                        //                           value,
                        //                           style: TextStyle(
                        //                               color: Theme.of(context)
                        //                                   .colorScheme
                        //                                   .secondary),
                        //                         ),
                        //                       ),
                        //                     )
                        //                     .toList(),
                        //                 onChanged: (newValue) {
                        //                   setState(() {
                        //                     questionsForm[nc]['storedVar'] =
                        //                         newValue!;
                        //                   });
                        //                 },
                        //                 iconEnabledColor: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary,
                        //                 validator: (value) => value == null
                        //                     ? 'Por favor selecciona una opción'
                        //                     : null,
                        //               ),
                        //             ],
                        //           ),
                        //         )),
                        //   );
                        //   // Agregar el TextFormField si es nc == 2
                        //   if (nc == 1) {
                        //     widgets.add(
                        //       Container(
                        //         margin: marginCustom,
                        //         child: TextFormField(
                        //           decoration: InputDecoration(
                        //             prefixIcon: Padding(
                        //               padding: const EdgeInsetsDirectional.only(
                        //                   start: 12.0),
                        //               child: Icon(
                        //                 Icons.cases_outlined,
                        //                 color: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary,
                        //               ),
                        //             ),
                        //             counterStyle: TextStyle(
                        //                 color:
                        //                     Theme.of(context).primaryColorDark),
                        //             labelText:
                        //                 '¿Cuál es su ocupación o profesión?',
                        //             labelStyle: TextStyle(
                        //                 color: Theme.of(context)
                        //                     .colorScheme
                        //                     .secondary),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(
                        //                   color: Colors.blue, width: 1.5),
                        //               borderRadius:
                        //                   BorderRadius.circular(radiusFocus),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: (registerBtn &&
                        //                         (occupation).isEmpty)
                        //                     ? Colors.red
                        //                     : Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary,
                        //                 width: 0.75,
                        //               ),
                        //               borderRadius:
                        //                   BorderRadius.circular(radiusNormal),
                        //             ),
                        //           ),
                        //           style: TextStyle(
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .secondary),
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return 'Por favor ingresa tu ocupación o profesión';
                        //             }
                        //             return null;
                        //           },
                        //           onChanged: (value) {
                        //             setState(() {
                        //               occupation = value;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   }

                        //   return widgets;
                        // }),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

class HealthQuestions extends StatefulWidget {
  const HealthQuestions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthQuestions createState() => _HealthQuestions();
}

class _HealthQuestions extends State<HealthQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                // Registro de usuario
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: const BoxDecoration(color: Colors.white
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.pink.withOpacity(0.25),
                    //     Colors.purple.withOpacity(0.25),
                    //     const Color.fromARGB(255, 24, 241, 0).withOpacity(0.25),
                    //     Colors.blue.withOpacity(0.25),
                    //   ],wav
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    ),
                child: Form(
                  key: _formKey4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...[2].expand((nc) {
                        List<Widget> widgets = [];

                        // Validar y configurar el valor inicial
                        String? initialValue = questionsForm[nc]['storedVar'];
                        if (!questionsForm[nc]['options']
                            .contains(initialValue)) {
                          initialValue =
                              null; // Si el valor no es válido, inicializa con null
                        }

                        // Agregar el DropdownButtonFormField
                        widgets.add(
                          Container(
                              margin: marginCustom,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          questionsForm[nc]['question'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        spaceSizedBox,
                                        DropdownButtonFormField<String>(
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          dropdownColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 12.0),
                                              child: Icon(
                                                questionsForm[nc]
                                                    ['iconSection'],
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            labelText: questionsForm[nc]
                                                ['categoryValue'],
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusFocus),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: (registerBtn &&
                                                        !questionsForm[nc]
                                                                ['options']
                                                            .contains(
                                                                questionsForm[
                                                                        nc][
                                                                    'storedVar']))
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                width: 0.75,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      radiusNormal),
                                            ),
                                          ),
                                          value: initialValue,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          items: questionsForm[nc]['options']
                                              .map<DropdownMenuItem<String>>(
                                                (String value) =>
                                                    DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              questionsForm[nc]['storedVar'] =
                                                  newValue!;
                                            });
                                          },
                                          iconEnabledColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          validator: (value) => value == null
                                              ? 'Por favor selecciona una opción'
                                              : null,
                                        ),
                                      ]))),
                        );

                        // Agregar el TextFormField si es nc == 2

                        return widgets;
                      }),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué EPS está afiliado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.local_hospital_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'EPS',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (occupation).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su EPS';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        occupation = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué ARL se encuentra vinculado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.lock_person_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'ARL',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (occupation).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su ARL';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        occupation = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                      Container(
                          margin: marginCustom,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¿A qué fondo de pensionas está afiliado?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  spaceSizedBox,
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 12.0),
                                        child: Icon(
                                          Icons.card_travel_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      counterStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                      labelText: 'Fondo de pensiones',
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(radiusFocus),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: (registerBtn &&
                                                  (occupation).isEmpty)
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          width: 0.75,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(radiusNormal),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su fondo de pensiones';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        occupation = value;
                                      });
                                    },
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
