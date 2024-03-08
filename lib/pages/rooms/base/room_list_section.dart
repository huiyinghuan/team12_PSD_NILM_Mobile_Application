part of "rooms_lib.dart";

Widget rooms_list_section(BuildContext context, Function onTap) {
  return Column(
    children: [displayRooms(context, onTap)],
  );
}

Widget displayRooms(BuildContext context, Function onTap) {
  return FutureBuilder<List<Room>>(
    future: rooms,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return buildRoomTiles(snapshot.data!, onTap,
            context); // Call the extracted function with the data
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child:
              CircularProgressIndicator(), // Show a loading indicator while fetching data
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text(
              'Error: ${snapshot.error}'), // Show an error message if the future fails
        );
      } else {
        return const Center(
          child: Text(
              'No rooms available'), // Show a message if there are no rooms
        );
      }
    },
  );
}

Widget buildRoomTiles(List<Room> rooms, Function onTap, BuildContext context) {
  List<Widget> roomTiles = [];
  for (Room room in rooms) {
    roomTiles.add(Room_Tile(room: room, onTap: () => onTap(context, room)));
  }
  return Column(
    children: roomTiles,
  );
}
