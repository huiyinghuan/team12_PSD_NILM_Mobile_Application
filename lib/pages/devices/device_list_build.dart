part of 'list_device_lib.dart';

Container buildDeviceList(Function onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    child: FutureBuilder<List<dynamic>>(
      future: devices,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Column(
                children: buildExpansionTiles(snapshot.data!, context, onTap),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD36E2F),
          ),
        );
      },
    ),
  );
}
