Judge::MapReader.define_map('standard') do |map|
  # Politics
  map.power('Austria', 'Austrian').owns  bud, tri, vie
  map.power('England', 'English').owns   edi, lon, lvp
  map.power('France',  'French').owns    bre, mar, par
  map.power('Germany', 'German').owns    ber, kie, mun
  map.power('Italy',   'Italian').owns   nap, rom, ven
  map.power('Russia',  'Russian').owns   mos, sev, stp, war
  map.power('Turkey',  'Turkish').owns   ank, con, smy
  map.unowned bel, bul, den, gre, hol, nwy, por, rum, ser, spa, swe, tun
  
  # Geography
  map.province('adr') do |l|
    l.name = 'Adriatic Sea'
    l.type = Water
    l.aliases 'adriatic'
    l.adj alb, apu, ion, tri, ven
#    WATER   ADR     ABUTS   ALB APU ION TRI VEN
  end
  map.province('aeg') do |l|
    l.name = 'Aegean Sea'
    l.type = Water
    l.aliases 'aegean'
    l.adj bul/sc, con, eas, gre, ion, smy
#    WATER   AEG     ABUTS   BUL/SC CON EAS GRE ION SMY
  end
  map.province('alb') do |l|
    l.name = 'Albania'
    l.type = Coast
    l.adj adr, gre, ion, ser, tri
#    COAST   ALB     ABUTS   ADR GRE ION SER TRI
  end
  map.province('ank') do |l|
    l.name = 'Ankara'
    l.type = Coast
    l.adj arm, bla, con, smy(Army)
#    COAST   ANK     ABUTS   ARM BLA CON smy
  end
  map.province('apu') do |l|
    l.name = 'Apulia'
    l.type = Coast
    l.adj adr, ion, nap, rom(Army), ven
#    COAST   APU     ABUTS   ADR ION NAP rom VEN
  end
  map.province('arm') do |l|
    l.name = 'Armenia'
    l.type = Coast
    l.adj ank, bla, sev, smy(Army), syr(Army)
#    COAST   ARM     ABUTS   ANK BLA SEV smy syr
  end
  map.province('bal') do |l|
    l.name = 'Baltic Sea'
    l.type = Water
    l.aliases 'baltic'
    l.adj ber, bot, den, lvn, kie, pru, swe
#    WATER   BAL     ABUTS   BER BOT DEN LVN KIE PRU SWE
  end
  map.province('bar') do |l|
    l.name = 'Barents Sea'
    l.type = Water
    l.aliases 'barents'
    l.adj nwy, nwg, stp/nc
#    WATER   BAR     ABUTS   NWY NWG STP/NC
  end
  map.province('bel') do |l|
    l.name = 'Belgium'
    l.type = Coast
    l.adj bur(Army), eng, hol, nth, pic, ruh
#    COAST   BEL     ABUTS   bur ENG HOL  NTH PIC RUH
  end
  map.province('ber') do |l|
    l.name = 'Berlin'
    l.type = Coast
    l.adj bal, kie, mun, pru, sil
#    COAST   BER     ABUTS   BAL KIE MUN PRU SIL
  end
  map.province('bla') do |l|
    l.name = 'Black Sea'
    l.type = Water
    l.aliases 'black'
    l.adj ank, arm, bul/ec, con, rum, sev
#    WATER   BLA     ABUTS   ANK ARM BUL/EC CON RUM SEV
  end
  map.province('boh') do |l|
    l.name = 'Bohemia'
    l.type = Land
    l.adj gal, mun, sil, tyr, vie
    #LAND    BOH     ABUTS   GAL MUN SIL TYR VIE
  end
  map.province('bre') do |l|
    l.name = 'Brest'
    l.type = Coast
    l.adj eng, gas, mao, par, pic
    #COAST   BRE     ABUTS   ENG GAS MAO PAR PIC
  end
  map.province('bud') do |l|
    l.name = 'Budapest'
    l.type = Land
    #LAND    BUD     ABUTS   GAL RUM SER TRI VIE
  end
  map.province('bul') do |l|
    l.name = 'Bulgaria'
    l.type = Coast
    l.coast('ec') do |c|
      c.aliases 'bul(ec)', 'bulgaria/ec', 'bulgaria(ec)'
    end
    l.coast('sc') do |c|
      c.aliases 'bul/sc', 'bul(sc)', 'bulgaria/sc', 'bulgaria(sc)'
    end
    #COAST   BUL/EC  ABUTS   BLA CON RUM
    #COAST   BUL/SC  ABUTS   AEG CON GRE
    #COAST   bul     ABUTS   AEG BLA CON GRE RUM SER
  end
  map.province('bur') do |l|
    l.name = 'Burgundy'
    l.type = Land
    l.aliases 'burgandy'
    #LAND    BUR     ABUTS   BEL GAS RUH MAR MUN PAR PIC SWI
  end
  map.province('cly') do |l|
    l.name = 'Clyde'
    l.type = Coast
    #COAST   CLY     ABUTS   EDI LVP NAO NWG
  end
  map.province('con') do |l|
    l.name = 'Constantinople'
    l.type = Coast
    #COAST   CON     ABUTS   AEG BUL/EC BUL/SC BLA ANK SMY
  end
  map.province('den') do |l|
    l.name = 'Denmark'
    l.type = Coast
    #COAST   DEN     ABUTS   BAL HEL KIE NTH SKA SWE
  end
  map.province('eas') do |l|
    l.name = 'Eastern Mediterranean'
    l.type = Water
    l.aliases 'emed', 'east', 'eastern', 'eastmed', 'ems', 'eme', 'emd', 'eas med'
    #WATER   EAS     ABUTS   AEG ION SMY SYR
  end
  map.province('edi') do |l|
    l.name = 'Edinburgh'
    l.type = Coast
    #COAST   EDI     ABUTS   CLY lvp NTH NWG YOR
  end
  map.province('eng') do |l|
    l.name = 'English Channel'
    l.type = Water
    l.aliases 'english', 'channel', 'ech', 'eng ch'
    #WATER   ENG     ABUTS   BEL BRE IRI LON MAO NTH PIC WAL
  end
  map.province('fin') do |l|
    l.name = 'Finland'
    l.type = Coast
    #COAST   FIN     ABUTS   BOT nwy STP/SC SWE
  end
  map.province('gal') do |l|
    l.name = 'Galicia'
    l.type = Land
    l.aliases 'galacia'
    #LAND    GAL     ABUTS   BOH BUD RUM SIL UKR VIE WAR
  end
  map.province('gas') do |l|
    l.name = 'Gascony'
    l.type = Coast
    #COAST   GAS     ABUTS   BUR BRE MAO mar PAR SPA/NC
  end
  map.province('gre') do |l|
    l.name = 'Greece'
    l.type = Coast
    #COAST   GRE     ABUTS   AEG ALB BUL/SC ION SER
  end
  map.province('lyo') do |l|
    l.name = 'Gulf of Lyon'
    l.aliases 'gol', 'gulfofl', 'lyon'
    l.type = Water
    #WATER   LYO     ABUTS   MAR PIE SPA/SC TUS TYS WES
  end
  map.province('bot') do |l|
    l.name = 'Gulf of Bothnia'
    l.aliases 'gob', 'both', 'gulfofb', 'bothnia'
    l.type = Water
    #WATER   BOT     ABUTS   BAL FIN LVN STP/SC SWE
  end
  map.province('hel') do |l|
    l.name = 'Helgoland Bight'
    l.aliases 'helgoland', 'heligoland', 'heligoland bight'
    l.type = Water
    #WATER   HEL     ABUTS   DEN HOL KIE NTH
  end
  map.province('hol') do |l|
    l.name = 'Holland'
    l.type = Coast
    #COAST   HOL     ABUTS   BEL HEL KIE NTH RUH
  end
  map.province('ion') do |l|
    l.name = 'Ionian Sea'
    l.aliases 'ionian'
    l.type = Water
    #WATER   ION     ABUTS   ADR AEG ALB APU EAS GRE NAP TUN TYS
  end
  map.province('iri') do |l|
    l.name = 'Irish Sea'
    l.aliases 'irish', 'irs'
    l.type = Water
    #WATER   IRI     ABUTS   ENG LVP MAO NAO WAL
  end
  map.province('kie') do |l|
    l.name = 'Kiel'
    l.type = Coast
    #COAST   KIE     ABUTS   BAL BER DEN HEL HOL MUN RUH
  end
  map.province('lvp') do |l|
    l.name = 'Liverpool'
    l.aliases 'livp', 'lpl'
    l.type = Coast
    #COAST   LVP     ABUTS   CLY edi IRI NAO WAL yor
  end
  map.province('lvn') do |l|
    l.name = 'Livonia'
    l.type = Coast
    l.aliases 'livo', 'lvo', 'lva'
    #COAST   LVN     ABUTS   BAL BOT MOS PRU STP/SC WAR
  end
  map.province('lon') do |l|
    l.name = 'London'
    l.type = Coast
    #COAST   LON     ABUTS   ENG NTH YOR WAL
  end
  map.province('mar') do |l|
    l.name = 'Marseilles'
    l.type = Coast
    l.aliases 'mars'
    #COAST   MAR     ABUTS   BUR gas LYO PIE SPA/SC SWI
  end
  map.province('mao') do |l|
    l.name = 'Mid-Atlantic Ocean'
    l.type = Water
    l.aliases 'midatlanticocean', 'midatlantic', 'mid', 'mat'
    #WATER   MAO     ABUTS   BRE ENG GAS IRI NAF NAO POR SPA/NC SPA/SC WES
  end
  map.province('mos') do |l|
    l.name = 'Moscow'
    l.type = Land
    #LAND    MOS     ABUTS   LVN SEV STP UKR WAR
  end
  map.province('mun') do |l|
    l.name = 'Munich'
    l.type = Land
    #LAND    MUN     ABUTS   BER BOH BUR KIE RUH SIL TYR SWI
  end
  map.province('nap') do |l|
    l.name = 'Naples'
    l.type = Coast
    #COAST   NAP     ABUTS   APU ION ROM TYS
  end
  map.province('nao') do |l|
    l.name = 'North Atlantic Ocean'
    l.type = Water
    l.aliases 'nat'
    #WATER   NAO     ABUTS   CLY IRI LVP MAO NWG
  end
  map.province('naf') do |l|
    l.name = 'North Africa'
    l.type = Coast
    l.aliases 'nora', 'n afr'
    #COAST   NAF     ABUTS   MAO TUN WES
  end
  map.province('nth') do |l|
    l.name = 'North Sea'
    l.type = Water
    l.aliases 'norsea', 'nts'
    #WATER   NTH     ABUTS   BEL DEN EDI ENG LON HEL HOL NWY NWG SKA YOR
  end
  map.province('nwy') do |l|
    l.name = 'Norway'
    l.type = Coast
    l.aliases 'nor', 'norw'
    #COAST   NWY     ABUTS   BAR fin NTH NWG SKA STP/NC SWE
  end
  map.province('nwg') do |l|
    l.name = 'Norwegian Sea'
    l.type = Water
    l.aliases 'norwegian', 'norwsea', 'nrg', 'norg',
    #WATER   NWG     ABUTS   BAR CLY EDI NAO NWY NTH
  end
  map.province('par') do |l|
    l.name = 'Paris'
    l.type = Land
    #LAND    PAR     ABUTS   BUR BRE GAS PIC
  end
  map.province('pic') do |l|
    l.name = 'Picardy'
    l.type = Coast
    #COAST   PIC     ABUTS   BEL BRE BUR ENG PAR
  end
  map.province('pie') do |l|
    l.name = 'Piedmont'
    l.type = Coast
    #COAST   PIE     ABUTS   LYO MAR TUS TYR ven SWI
  end
  map.province('por') do |l|
    l.name = 'Portugal'
    l.type = Coast
    #COAST   POR     ABUTS   MAO SPA/NC SPA/SC
  end
  map.province('pru') do |l|
    l.name = 'Prussia'
    l.type = Coast
    #COAST   PRU     ABUTS   BAL BER LVN SIL WAR
  end
  map.province('rom') do |l|
    l.name = 'Rome'
    l.type = Coast
    #COAST   ROM     ABUTS   apu NAP TUS TYS ven
  end
  map.province('ruh') do |l|
    l.name = 'Ruhr'
    l.type = Land
    #LAND    RUH     ABUTS   BEL BUR HOL KIE MUN
  end
  map.province('rum') do |l|
    l.name = 'Rumania'
    l.type = Coast
    #COAST   RUM     ABUTS   BLA BUD BUL/EC GAL SER SEV UKR
  end
  map.province('ser') do |l|
    l.name = 'Serbia'
    l.type = Land
    #LAND    SER     ABUTS   ALB BUD BUL GRE RUM TRI
  end
  map.province('sev') do |l|
    l.name = 'Sevastopol'
    l.type = Coast
    l.aliases 'sevastapol'
    #COAST   SEV     ABUTS   ARM BLA MOS RUM UKR
  end
  map.province('sil') do |l|
    l.name = 'Silesia'
    l.type = Land
    #LAND    SIL     ABUTS   BER BOH GAL MUN PRU WAR
  end
  map.province('ska') do |l|
    l.name = 'Skagerrak'
    l.type = Water
    #WATER   SKA     ABUTS   DEN NWY NTH SWE
  end
  map.province('smy') do |l|
    l.name = 'Smyrna'
    l.type = Coast
    #COAST   SMY     ABUTS   AEG ank arm CON EAS SYR
  end
  map.province('spa') do |l|
    l.name = 'Spain'
    l.type = Coast
    l.aliases 'spn'
    l.coast('nc') do |c|
      c.aliases 'spa(nc)', 'spain/nc', 'spain(nc)', 'spn/nc', 'spn(nc)', 'spa (north coast)'
    end
    l.coast('sc') do |c|
      c.aliases 'spa(sc)', 'spain/sc', 'spain(sc)', 'spn/sc', 'spn(sc)', 'spa (south coast)'
    end
    #COAST   SPA/NC  ABUTS   GAS MAO POR
    #COAST   SPA/SC  ABUTS   LYO MAO MAR POR WES
    #COAST   spa     ABUTS   GAS LYO MAO MAR POR WES
  end
  map.province('stp') do |l|
    l.name = 'St Petersburg'
    l.type = Coast
    l.aliases 'stpete', 'st. petersburg', 'st.petersburg'
    l.coast('nc') do |c|
      c.aliases = 'stp(nc)', 'stpete/nc', 'stpete(nc)', 'st. petersburg/nc', 'stp (north coast)'
    end
    l.coast('sc') do |c|
      c.aliases = 'stp(sc)', 'stpete/sc', 'stpete(sc)', 'st. petersburg/sc', 'stp (south+coast)'
    end
    #COAST   STP/NC  ABUTS   BAR NWY
    #COAST   STP/SC  ABUTS   BOT FIN LVN
    #COAST   stp     ABUTS   BAR BOT FIN LVN MOS NWY
  end
  map.province('swe') do |l|
    l.name = 'Sweden'
    l.type = Coast
    #COAST   SWE     ABUTS   BAL BOT DEN FIN NWY SKA
  end
  map.province('syr') do |l|
    l.name = 'Syria'
    l.type = Coast
    #COAST   SYR     ABUTS   arm EAS SMY
  end
  map.province('tri') do |l|
    l.name = 'Trieste'
    l.type = Coast
    #COAST   TRI     ABUTS   ADR ALB BUD SER TYR VEN VIE
  end
  map.province('tun') do |l|
    l.name = 'Tunis'
    l.type = Coast
    #COAST   TUN     ABUTS   ION NAF TYS WES
  end
  map.province('tus') do |l|
    l.name = 'Tuscany'
    l.type = Coast
    #COAST   TUS     ABUTS   LYO PIE ROM TYS ven
  end
  map.province('tyr') do |l|
    l.name = 'Tyrolia'
    l.type = Land
    l.aliases 'tyl', 'trl', 'tyo'
    #LAND    TYR     ABUTS   BOH MUN PIE TRI VEN VIE SWI
  end
  map.province('tys') do |l|
    l.name = 'Tyrrhenian Sea'
    l.type = Water
    l.aliases 'tyrr', 'tyrrhenian', 'tyn', 'tyh'
    #WATER   TYS     ABUTS   ION LYO ROM NAP TUN TUS WES
  end
  map.province('ukr') do |l|
    l.name = 'Ukraine'
    l.type = Land
    #LAND    UKR     ABUTS   GAL MOS RUM SEV WAR
  end
  map.province('ven') do |l|
    l.name = 'Venice'
    l.type = Land
    #COAST   VEN     ABUTS   ADR APU pie rom TRI tus TYR
  end
  map.province('vie') do |l|
    l.name = 'Vienna'
    l.type = Land
    #LAND    VIE     ABUTS   BOH BUD GAL TRI TYR
  end
  map.province('wal') do |l|
    l.name = 'Wales'
    l.type = Coast
    #COAST   WAL     ABUTS   ENG IRI LON LVP yor
  end¨
  map.province('war') do |l|
    l.name = 'Warsaw'
    l.type = Land
    #LAND    WAR     ABUTS   GAL LVN MOS PRU SIL UKR
  end
  map.province('wes') do |l|
    l.name = 'Western Mediterranean'
    l.type = Water
    l.aliases 'wmed', 'west', 'western', 'westmed', 'wms', 'wme', 'wmd', 'west med', 'wes med', 'western med'
    #WATER   WES     ABUTS   MAO LYO NAF SPA/SC TUN TYS
  end
  map.province('yor') do |l|
    l.name = 'Yorkshire'
    l.type = Coast
    l.aliases 'york', 'yonkers'
    #COAST   YOR     ABUTS   EDI LON lvp NTH wal
  end
  map.province('swi') do |l|
    l.name = 'Switzerland'
    l.type = Shut
    l.adjecencies mar, bur, mun, tyr, pie
  end
end