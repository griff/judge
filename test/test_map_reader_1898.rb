require 'test_map_reader'

class TestMapReader1898 < Test::Unit::TestCase
  include MapReaderTest
  
  def setup
    setup_reader
    @powers = [
      {
        :name => 'AUSTRIA',
        :own_word => 'AUSTRIAN',
        :abbreviation => 'A',
        :homes => ['BUD', 'TRI', 'VIE'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'ENGLAND',
        :own_word => 'ENGLISH',
        :abbreviation => 'E',
        :homes => ['EDI', 'LON', 'LVP'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'FRANCE',
        :own_word => 'FRENCH',
        :abbreviation => 'F',
        :homes => ['BRE', 'MAR', 'PAR'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'GERMANY',
        :own_word => 'GERMAN',
        :abbreviation => 'G',
        :homes => ['BER', 'KIE',  'MUN'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'ITALY',
        :own_word => 'ITALIAN',
        :abbreviation => 'I',
        :homes => ['NAP', 'ROM', 'VEN'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'RUSSIA',
        :own_word => 'RUSSIAN',
        :abbreviation => 'R',
        :homes => ['MOS', 'SEV', 'STP', 'WAR'],
        :factories => [],
        :partisans => []
      },
      {
        :name => 'TURKEY',
        :own_word => 'TURKISH',
        :abbreviation => 'T',
        :homes => ['ANK', 'CON', 'SMY'],
        :factories => [],
        :partisans => []
      },
    ]
    @unowned = ['BEL', 'BUL', 'DEN', 'GRE', 'HOL', 'NWY', 'POR', 'RUM', 
                  'SER', 'SPA', 'SWE', 'TUN',]
    @locations = [
      {:name=>'Adriatic Sea', :full_abbreviation=>'ADR', :aliases=>['ADRIATIC'], :ambiguous=>[]}, 
      {:name=>'Aegean Sea', :full_abbreviation=>'AEG', :aliases=>['AEGEAN'], :ambiguous=>[]}, 
      {:name=>'Albania', :full_abbreviation=>'ALB', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Ankara', :full_abbreviation=>'ANK', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Apulia', :full_abbreviation=>'APU', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Armenia', :full_abbreviation=>'ARM', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Baltic Sea', :full_abbreviation=>'BAL', :aliases=>['BALTIC'], :ambiguous=>[]}, 
      {:name=>'Barents Sea', :full_abbreviation=>'BAR', :aliases=>['BARENTS'], :ambiguous=>[]}, 
      {:name=>'Belgium', :full_abbreviation=>'BEL', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Berlin', :full_abbreviation=>'BER', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Black Sea', :full_abbreviation=>'BLA', :aliases=>['BLACK'], :ambiguous=>[]}, 
      {:name=>'Bohemia', :full_abbreviation=>'BOH', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Brest', :full_abbreviation=>'BRE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Budapest', :full_abbreviation=>'BUD', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Bulgaria (east coast)', :full_abbreviation=>'BUL/EC', :aliases=>['BUL(EC)', 'BULGARIA/EC', 'BULGARIA(EC)'], :ambiguous=>[]},
      {:name=>'Bulgaria (south coast)', :full_abbreviation=>'BUL/SC', :aliases=>['BUL(SC)', 'BULGARIA/SC', 'BULGARIA(SC)'], :ambiguous=>[]}, 
      {:name=>'Bulgaria', :full_abbreviation=>'BUL', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Burgundy', :full_abbreviation=>'BUR', :aliases=>['BURGANDY'], :ambiguous=>[]}, 
      {:name=>'Clyde', :full_abbreviation=>'CLY', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Constantinople', :full_abbreviation=>'CON', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Denmark', :full_abbreviation=>'DEN', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Eastern Mediterranean', :full_abbreviation=>'EAS', :aliases=>['EMED', 'EAST', 'EASTERN', 'EASTMED', 'EMS', 'EME', 'EMD', 'EAS MED'], :ambiguous=>[]}, 
      {:name=>'Edinburgh', :full_abbreviation=>'EDI', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'English Channel', :full_abbreviation=>'ENG', :aliases=>['ENGLISH', 'CHANNEL', 'ECH', 'ENG CH'], :ambiguous=>[]}, 
      {:name=>'Finland', :full_abbreviation=>'FIN', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Galicia', :full_abbreviation=>'GAL', :aliases=>['GALACIA'], :ambiguous=>[]}, 
      {:name=>'Gascony', :full_abbreviation=>'GAS', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Greece', :full_abbreviation=>'GRE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Gulf of Lyon', :full_abbreviation=>'LYO', :aliases=>['GOL', 'GULFOFL', 'LYON'], :ambiguous=>[]},
      {:name=>'Gulf of Bothnia', :full_abbreviation=>'BOT', :aliases=>['GOB', 'BOTH', 'GULFOFB', 'BOTHNIA'], :ambiguous=>[]}, 
      {:name=>'Helgoland Bight', :full_abbreviation=>'HEL', :aliases=>['HELGOLAND', 'HELIGOLAND', 'HELIGOLAND BIGHT'], :ambiguous=>[]}, 
      {:name=>'Holland', :full_abbreviation=>'HOL', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Ionian Sea', :full_abbreviation=>'ION', :aliases=>['IONIAN'], :ambiguous=>[]},
      {:name=>'Irish Sea', :full_abbreviation=>'IRI', :aliases=>['IRISH', 'IRS'], :ambiguous=>[]}, 
      {:name=>'Kiel', :full_abbreviation=>'KIE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Liverpool', :full_abbreviation=>'LVP', :aliases=>['LIVP', 'LPL'], :ambiguous=>[]}, 
      {:name=>'Livonia', :full_abbreviation=>'LVN', :aliases=>['LIVO', 'LVO', 'LVA'], :ambiguous=>[]}, 
      {:name=>'London', :full_abbreviation=>'LON', :aliases=>[], :ambiguous=>[]},
      {:name=>'Marseilles', :full_abbreviation=>'MAR', :aliases=>['MARS'], :ambiguous=>[]}, 
      {:name=>'Mid-Atlantic Ocean', :full_abbreviation=>'MAO', :aliases=>['MIDATLANTICOCEAN', 'MIDATLANTIC', 'MID', 'MAT'], :ambiguous=>[]}, 
      {:name=>'Moscow', :full_abbreviation=>'MOS', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Munich', :full_abbreviation=>'MUN', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Naples', :full_abbreviation=>'NAP', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'North Atlantic Ocean', :full_abbreviation=>'NAO', :aliases=>['NAT'], :ambiguous=>[]}, 
      {:name=>'North Africa', :full_abbreviation=>'NAF', :aliases=>['NORA', 'N AFR'], :ambiguous=>[]}, 
      {:name=>'North Sea', :full_abbreviation=>'NTH', :aliases=>['NORSEA', 'NTS'], :ambiguous=>[]},
      {:name=>'Norway', :full_abbreviation=>'NWY', :aliases=>['NOR', 'NORW'], :ambiguous=>[]}, 
      {:name=>'Norwegian Sea', :full_abbreviation=>'NWG', :aliases=>['NORWEGIAN', 'NORWSEA', 'NRG', 'NORG'], :ambiguous=>[]}, 
      {:name=>'Paris', :full_abbreviation=>'PAR', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Picardy', :full_abbreviation=>'PIC', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Piedmont', :full_abbreviation=>'PIE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Portugal', :full_abbreviation=>'POR', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Prussia', :full_abbreviation=>'PRU', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Rome', :full_abbreviation=>'ROM', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Ruhr', :full_abbreviation=>'RUH', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Rumania', :full_abbreviation=>'RUM', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Serbia', :full_abbreviation=>'SER', :aliases=>[], :ambiguous=>[]},
      {:name=>'Sevastopol', :full_abbreviation=>'SEV', :aliases=>['SEVASTAPOL'], :ambiguous=>[]}, 
      {:name=>'Silesia', :full_abbreviation=>'SIL', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Skagerrak', :full_abbreviation=>'SKA', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Smyrna', :full_abbreviation=>'SMY', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Spain (north coast)', :full_abbreviation=>'SPA/NC', :aliases=>['SPA(NC)', 'SPAIN/NC', 'SPAIN(NC)', 'SPN/NC', 'SPN(NC)', 'SPA (NORTH COAST)'], :ambiguous=>[]}, 
      {:name=>'Spain (south coast)', :full_abbreviation=>'SPA/SC', :aliases=>['SPA(SC)', 'SPAIN/SC', 'SPAIN(SC)', 'SPN/SC', 'SPN(SC)', 'SPA (SOUTH COAST)'], :ambiguous=>[]}, 
      {:name=>'Spain', :full_abbreviation=>'SPA', :aliases=>['SPN'], :ambiguous=>[]},
      {:name=>'St Petersburg (north coast)', :full_abbreviation=>'STP/NC', :aliases=>['STP(NC)', 'STPETE/NC', 'STPETE(NC)', 'ST. PETERSBURG/NC', 'STP (NORTH COAST)'], :ambiguous=>[]}, 
      {:name=>'St Petersburg (south coast)', :full_abbreviation=>'STP/SC', :aliases=>['STP(SC)', 'STPETE/SC', 'STPETE(SC)', 'ST. PETERSBURG/SC', 'STP (SOUTH COAST)'], :ambiguous=>[]},
      {:name=>'St Petersburg', :full_abbreviation=>'STP', :aliases=>['STPETE', 'ST. PETERSBURG', 'ST.PETERSBURG'], :ambiguous=>[]}, 
      {:name=>'Sweden', :full_abbreviation=>'SWE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Syria', :full_abbreviation=>'SYR', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Trieste', :full_abbreviation=>'TRI', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Tunis', :full_abbreviation=>'TUN', :aliases=>[], :ambiguous=>[]},
      {:name=>'Tuscany', :full_abbreviation=>'TUS', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Tyrolia', :full_abbreviation=>'TYR', :aliases=>['TYL', 'TRL', 'TYO'], :ambiguous=>[]}, 
      {:name=>'Tyrrhenian Sea', :full_abbreviation=>'TYS', :aliases=>['TYRR', 'TYRRHENIAN', 'TYN', 'TYH'], :ambiguous=>[]}, 
      {:name=>'Ukraine', :full_abbreviation=>'UKR', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Venice', :full_abbreviation=>'VEN', :aliases=>[], :ambiguous=>[]},
      {:name=>'Vienna', :full_abbreviation=>'VIE', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Wales', :full_abbreviation=>'WAL', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Warsaw', :full_abbreviation=>'WAR', :aliases=>[], :ambiguous=>[]}, 
      {:name=>'Western Mediterranean', :full_abbreviation=>'WES', :aliases=>['WMED', 'WEST', 'WESTERN', 'WESTMED', 'WMS', 'WME', 'WMD', 'WEST MED', 'WES MED', 'WESTERN MED'], :ambiguous=>[]}, 
      {:name=>'Yorkshire', :full_abbreviation=>'YOR', :aliases=>['YORK', 'YONKERS'], :ambiguous=>[]}, 
      {:name=>'Switzerland', :full_abbreviation=>'SWI', :aliases=>[], :ambiguous=>[]},
      ]
    @map = @reader.read('1898')
  end
  
  def test_visual
    assert_equal 'standard', @map.visual, "Map names do not match"
  end
end
