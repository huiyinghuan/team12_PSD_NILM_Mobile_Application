part of '../scene_lib.dart';

Row buildSceneInfo(IoT_Scene scene, bool enableScene, navigateTo) {
  String? description;
  if (scene.description == "" || scene.description == null) {
    description = "No description";
  }
  int countOfDevices;
  try {
    countOfDevices = jsonDecode(scene.content)[0]['actions'].length;
  } catch (e) {
    countOfDevices = jsonDecode(scene.content)['actions'].length;
  }

  return Row(
    children: [
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
            text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Description: ',
                      style: GoogleFonts.poppins(color: AppColors.primary2),
                    ),
                    TextSpan(
                      text: '${description ?? scene.description}\n\n',
                      style: GoogleFonts.poppins(),
                    ),
                    TextSpan(
                      text: 'Number of Devices: ',
                      style: GoogleFonts.poppins(color: AppColors.primary2),
                    ),
                    TextSpan(
                      text: '$countOfDevices',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),  
              )        
          ],
        ),
      ),
    ],
  );
}

