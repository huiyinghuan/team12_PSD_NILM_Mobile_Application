part of 'dashboard_lib.dart';

Widget buildUsageSection(BuildContext context) {
  return FutureBuilder<List<Energy_Consumption>>(
    future: energies,
    builder: (context, snapshot) {
      String consumption =
          '0.00'; // Placeholder while loading or in case of an error
      String consumptionCost =
          '0.00'; // Placeholder while loading or in case of an error
      final currentDate = DateFormat('dd MMMM yyyy')
          .format(DateTime.now()); // Current date formatting

      if (snapshot.hasData &&
          snapshot.connectionState == ConnectionState.done) {
        // Process electrical consumption data
        // List<NILM_Appliance> appliances = snapshot.data!;

        // Convert and format to two decimal places
        consumption = double.parse(snapshot.data!.first.consumptionKwh ?? '0')
            .toStringAsFixed(2);
        consumptionCost =
            double.parse(snapshot.data!.first.consumptionCost ?? '0')
                .toStringAsFixed(2);

        // Utilizes the containerWithConsumptionData for consistent UI
        return containerWithConsumptionData(
            currentDate, consumption, consumptionCost);
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
      borderRadius: const BorderRadius.only(
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
                gradient: const LinearGradient(
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
                    offset: const Offset(0, 3),
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
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: usageKWh,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD36E2F),
                              )),
                          const TextSpan(
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
                    const SizedBox(height: 10),
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
