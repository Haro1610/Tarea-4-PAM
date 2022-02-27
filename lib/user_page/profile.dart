import 'dart:io';
import 'dart:typed_data';

import 'package:clase_10/user_page/bloc/request_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final screenShotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenShotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: 'feature_screenshot',
              tapTarget: const Icon(Icons.share),
              title: Text('Captura de pantalla'),
              description: Text('Pulsa para comparti una captura de pantalla'),
              backgroundColor: Colors.indigo,
              targetColor: Colors.white,
              textColor: Colors.black,
              overflowMode: OverflowMode.extendBackground,
              contentLocation: ContentLocation.below,
              onComplete: () async {
                print("screenShot pressed");
                return true;
              },
              onDismiss: () async {
                print("screenShot dismissed");
                return false;
              },
              onOpen: () async {
                print("screenShot open");
                return true;
              },
              child: IconButton(
                tooltip: "Compartir screenshot",
                onPressed: () async {
                  _shareAndSaveImage((await screenShotController.capture())!);
                },
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              BlocConsumer<PictureBloc, PictureState>(
                listener: (context, state) {
                  if (state is PictureErroState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${state.errorMsg}")),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PictureSelectedState) {
                    return CircleAvatar(
                      backgroundImage: FileImage(state.picture),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 122, 113, 113),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                "Bienvenido",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text("Usuario${UniqueKey()}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DescribedFeatureOverlay(
                    featureId: 'feature_tarjeta',
                    tapTarget: const Icon(Icons.credit_card),
                    title: Text('Ver tarjetas'),
                    description: Text(
                        'Pulsa este boton para ver informacion sobre la tarjeta'),
                    backgroundColor: Color.fromARGB(255, 29, 93, 150),
                    targetColor: Colors.white,
                    textColor: Colors.black,
                    overflowMode: OverflowMode.extendBackground,
                    contentLocation: ContentLocation.above,
                    onComplete: () async {
                      print("tarjeta pressed");
                      return true;
                    },
                    onDismiss: () async {
                      print("tarjeta dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("tarjeta open");
                      return true;
                    },
                    child: CircularButton(
                      textAction: "Info tarjeta",
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action: null,
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'feature_take_photo',
                    tapTarget: const Icon(Icons.camera_alt),
                    title: Text("Cambiar la foto"),
                    description: Text("Pulsa para tomar una foto"),
                    backgroundColor: Colors.orange,
                    textColor: Colors.black,
                    overflowMode: OverflowMode.extendBackground,
                    contentLocation: ContentLocation.trivial,
                    onComplete: () async {
                      print("photo pressed");
                      return true;
                    },
                    onDismiss: () async {
                      print("photo dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("photo open");
                      return true;
                    },
                    child: CircularButton(
                      textAction: "Changed photo",
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'feature_tutorial',
                    backgroundColor: Colors.green,
                    contentLocation: ContentLocation.below,
                    title: const Text("Explicación guidada de la app"),
                    tapTarget: const Icon(Icons.add),
                    overflowMode: OverflowMode.extendBackground,
                    textColor: Colors.black,
                    onComplete: () async {
                      print("tutorial pressed");
                      return true;
                    },
                    onDismiss: () async {
                      print("tutorial dismissed");
                      return false;
                    },
                    onOpen: () async {
                      print("tutorial open");
                      return true;
                    },
                    child: CircularButton(
                        textAction: "Ver tutorial",
                        iconData: Icons.play_arrow,
                        bgColor: Colors.green,
                        action: () {
                          FeatureDiscovery.discoverFeatures(
                              context, const <String>{
                            'feature_tutorial',
                            'feature_take_photo',
                            'feature_tarjeta',
                            'feature_screenshot'
                          });
                        }),
                  )
                ],
              ),
              SizedBox(height: 48),
              BlocConsumer<RequestBloc, RequestState>(
                listener: (context, state) {},
                builder: ((context, state) {
                  if (state is RequestSucces) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: state.mapAccounts["apiAaron"].length,
                      itemBuilder: (BuildContext context, int index) {
                        print(state.mapAccounts["apiAaron"][index]["nombre"]);
                        return CuentaItem(
                          tipoCuenta: state.mapAccounts["apiAaron"][index]
                                  ["nombre"]
                              .toString(),
                          terminacion: state.mapAccounts["apiAaron"][index]
                                  ["tarjeta"]
                              .toString(),
                          saldoDisponible: state.mapAccounts["apiAaron"][index]
                                  ["dinero"]
                              .toString(),
                        );
                      },
                    );
                  } else if (state is RequestErrorState) {
                    return Text("No hay datos disponibles");
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future _shareAndSaveImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File("${directory.path}.png");
    image.writeAsBytesSync(bytes);

    await Share.shareFiles([image.path]);
  }
}
