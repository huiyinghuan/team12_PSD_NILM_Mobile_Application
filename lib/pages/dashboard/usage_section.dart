part of 'dashboard_lib.dart';

Widget buildUsageSection(BuildContext context, ElectricityData electricity) {
  return FutureBuilder<List<Energy_Consumption>>(
    future: energies,
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          snapshot.connectionState == ConnectionState.done &&
          electricity != null) {
        // Use the appropriate format that matches the input string
        DateFormat inputFormat = DateFormat('d MMM yyyy hh:mm a');
        DateTime parsedTimestamp;

        try {
          parsedTimestamp = inputFormat.parse(electricity.timestamp);
        } on FormatException {
          // Handle the situation where the date format does not match
          return Text(
            'Invalid date format',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          );
        }

        // Use DateFormat to convert the DateTime into the desired format
        String formattedDate =
            DateFormat('dd MMM yyyy').format(parsedTimestamp);
        String consumption =
            electricity.totalPowerConsumption?.toStringAsFixed(2) ?? '0.00';
        String consumptionCost =
            (electricity.totalPowerConsumption * 0.15)?.toStringAsFixed(2) ??
                '0.00';

        return containerWithConsumptionData(
            formattedDate, consumption, consumptionCost);
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Text(
          'Failed to load energy consumption',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
        );
      }
    },
  );
}

// This widget builds the visual representation of the energy consumption data
Widget containerWithConsumptionData(String date, String usageKWh, String cost) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text('Usage',
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB1F4CF),
                    Color(0xFF9890E3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(date,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: usageKWh,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD36E2F),
                              )),
                          TextSpan(
                              text: ' KWh',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1.0,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Cost : \$$cost',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 25,
              child: Image.asset(
                'images/lightning.png',
                width: 100,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
