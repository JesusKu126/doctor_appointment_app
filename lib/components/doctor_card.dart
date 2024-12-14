import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/screens/doctor_details.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        onTap: () {
          // Pasar detalles a la página de detalles
          MyApp.navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => DoctorDetails(
                doctor: doctor,
                isFav: isFav,
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              // Imagen del perfil del doctor

              SizedBox(
                width: Config.widthSize * 0.33,
                child: Builder(
                  builder: (context) {
                    // Imprime la URL de la imagen para verificarla en la consola
                    print("URL de la imagen: ${doctor['doctor_profile']}");

                    return Image.network(
                      doctor['doctor_profile'], // URL de la imagen
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Depura si hay un error al cargar la imagen
                        print('Error al cargar la imagen: $error');
                        return const Icon(Icons.error,
                            size: 50, color: Colors.red);
                      },
                    );
                  },
                ),
              ),

              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr ${doctor['doctor_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${doctor['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text('4.5'),
                          SizedBox(width: 5),
                          Text('Reviews'),
                          SizedBox(width: 5),
                          Text('(20)'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
