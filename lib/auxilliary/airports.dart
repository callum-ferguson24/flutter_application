/*
 * A class including a collection of airports, within the United Kingdom and Ireland
 * This class contains a static Map of airport codes to their respective names and provides
 * a utility method to flip the map entries 
 */
class Airports {

  /*
   * Static map to store airport codes as keys and airport names as values
   * Including a comprehensive list of major airports in the UK and Ireland
   */
  static Map<String, String> airports = {

  // United Kingdom airports
  'ABZ': 'Aberdeen Airport',
  'BFS': 'Belfast International Airport',
  'BHD': 'Belfast City Airport',
  'BHX': 'Birmingham Airport',
  'BOH': 'Bournemouth Airport',
  'BRS': 'Bristol Airport',
  'CWL': 'Cardiff Airport',
  'DSA': 'Doncaster Sheffield Airport',
  'MME': 'Durham Tees Valley Airport',
  'EMA': 'East Midlands Airport',
  'EDI': 'Edinburgh Airport',
  'EXT': 'Exeter Airport',
  'GLA': 'Glasgow Airport',
  'INV': 'Inverness Airport',
  'IOM': 'Isle of Man Airport',
  'LBA': 'Leeds Bradford Airport',
  'LPL': 'Liverpool John Lennon Airport',
  'LCY': 'London City Airport',
  'LGW': 'London Gatwick Airport',
  'LHR': 'London Heathrow Airport',
  'LTN': 'London Luton Airport',
  'SEN': 'London Southend Airport',
  'STN': 'London Stansted Airport',
  'MAN': 'Manchester Airport',
  'NCL': 'Newcastle Airport',
  'NWI': 'Norwich Airport',
  'SOU': 'Southampton Airport',
  
  // Ireland airports
  'ORK': 'Cork Airport',
  'DUB': 'Dublin Airport',
  'NOC': 'Ireland West Airport Knock',
  'KIR': 'Kerry Airport',
  'SNN': 'Shannon Airport',

  };

/*
 * Method to flip the airport map so that the airport names become the keys and the airport codes become the values
 * Useful for looking up airport codes by airport name
 */
static Map<String, String> flippedMap(Map<String, String> airports) {
  return Map.fromEntries(airports.entries.map((entry) => MapEntry(entry.value, entry.key)));
}

}