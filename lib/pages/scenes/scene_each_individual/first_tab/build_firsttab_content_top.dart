part of '../../scene_lib.dart';

Row contentTopRow(BuildContext context, IoT_Scene scene, setState) {
    // top row. icon and name
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Change Icon'),
                    content: SizedBox(
                      height: 300, // Set a fixed height for the AlertDialog
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            (iconList.length / 5)
                                .ceil(), // Calculate number of rows
                            (rowIndex) {
                              int startIndex = rowIndex * 5;
                              int endIndex = (rowIndex + 1) * 5;
                              if (endIndex > iconList.length) {
                                endIndex = iconList.length;
                              }
                              return Row(
                                children: List.generate(
                                  endIndex - startIndex,
                                  (index) => Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Future<Response> changeResponse =
                                            scene.changeIcon(
                                                iconList[startIndex + index]);
                                        changeResponse.then((value) {
                                          if (value.statusCode == 204) {
                                            scene.icon =
                                                iconList[startIndex + index];
                                            updateScenes(setState);
                                          }
                                        });
                                        // Add your onTap logic here
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image(
                                          image: AssetImage(
                                              'images/icons/${iconList[startIndex + index]}.png'),
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Image(
              image: AssetImage(
                scene.icon != null
                    ? 'images/icons/${scene.icon}.png'
                    : 'images/kitchen.png',
              ),
              fit: BoxFit.cover,
              color: scene.icon != null ? null : AppColors.primary3,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0), // Add desired padding here
          child: Text(
            scene.name!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }