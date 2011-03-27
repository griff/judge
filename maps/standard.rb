
# Politics
power('Austria', 'Austrian').homes  %w{bud tri vie}
power('England', 'English').homes   %w{edi lon lvp}
power('France',  'French').homes    %w{bre mar par}
power('Germany', 'German').homes    %w{ber kie mun}
power('Italy',   'Italian').homes   %w{nap rom ven}
power('Russia',  'Russian').homes   %w{mos sev stp war}
power('Turkey',  'Turkish').homes   %w{ank con smy}
unowned %w{bel bul den gre hol nwy por rum ser spa swe tun}

# Geography
province('adr') do 
  name        'Adriatic Sea'
  terrain     Water
  aliases     'adriatic'
  adjacencies alb, apu, ion, tri, ven
#    WATER   ADR     ABUTS   ALB APU ION TRI VEN
end
province('aeg') do 
  name  'Aegean Sea'
  terrain Water
  aliases 'aegean'
  adjacencies bul/sc, con, eas, gre, ion, smy
#    WATER   AEG     ABUTS   BUL/SC CON EAS GRE ION SMY
end
province('alb') do 
  name 'Albania'
  terrain Coast
  adjacencies adr, gre, ion, ser, tri
#    COAST   ALB     ABUTS   ADR GRE ION SER TRI
end
province('ank') do
  name 'Ankara'
  terrain Coast
  adjacencies arm, bla, con, smy(Army)
#    COAST   ANK     ABUTS   ARM BLA CON smy
end
province('apu') do
  name 'Apulia'
  terrain Coast
  adjacencies adr, ion, nap, rom(Army), ven
#    COAST   APU     ABUTS   ADR ION NAP rom VEN
end
province('arm') do
  name 'Armenia'
  terrain Coast
  adjacencies ank, bla, sev, smy(Army), syr(Army)
#    COAST   ARM     ABUTS   ANK BLA SEV smy syr
end
province('bal') do
  name 'Baltic Sea'
  terrain Water
  aliases 'baltic'
  adjacencies ber, bot, den, lvn, kie, pru, swe
#    WATER   BAL     ABUTS   BER BOT DEN LVN KIE PRU SWE
end
province('bar') do
  name 'Barents Sea'
  terrain Water
  aliases 'barents'
  adjacencies nwy, nwg, stp/nc
#    WATER   BAR     ABUTS   NWY NWG STP/NC
end
province('bel') do
  name 'Belgium'
  terrain Coast
  adjacencies bur, eng, hol, nth, pic, ruh
#    COAST   BEL     ABUTS   BUR ENG HOL  NTH PIC RUH
end
province('ber') do
  name 'Berlin'
  terrain Coast
  adjacencies bal, kie, mun, pru, sil
#    COAST   BER     ABUTS   BAL KIE MUN PRU SIL
end
province('bla') do
  name 'Black Sea'
  terrain Water
  aliases 'black'
  adjacencies ank, arm, bul/ec, con, rum, sev
#    WATER   BLA     ABUTS   ANK ARM BUL/EC CON RUM SEV
end
province('boh') do
  name 'Bohemia'
  terrain Land
  adjacencies gal, mun, sil, tyr, vie
  #LAND    BOH     ABUTS   GAL MUN SIL TYR VIE
end
province('bre') do
  name 'Brest'
  terrain Coast
  adjacencies eng, gas, mao, par, pic
  #COAST   BRE     ABUTS   ENG GAS MAO PAR PIC
end
province('bud') do
  name 'Budapest'
  terrain Land
  adjacencies gal, rum, ser, tri, vie
  #LAND    BUD     ABUTS   GAL RUM SER TRI VIE
end
province('bul') do
  name 'Bulgaria'
  terrain Coast
  adjacencies aeg, bla, con, gre, rum, ser
  coast('ec') do
    aliases %{bul(ec) bulgaria/ec bulgaria(ec)}
    adjacencies bla, con, rum
  end
  coast('sc') do
    aliases %{bul/sc bul(sc) bulgaria/sc bulgaria(sc)}
    adjacencies aeg, con, gre
  end
  #COAST   BUL/EC  ABUTS   BLA CON RUM
  #COAST   BUL/SC  ABUTS   AEG CON GRE
  #COAST   bul     ABUTS   AEG BLA CON GRE RUM SER
end
province('bur') do
  name 'Burgundy'
  terrain Land
  aliases 'burgandy'
  adjacencies bel, gas, ruh, mar, mun, par, pic, swi
  #LAND    BUR     ABUTS   BEL GAS RUH MAR MUN PAR PIC SWI
end
province('cly') do
  name 'Clyde'
  terrain Coast
  adjacencies edi, lvp, nao, nwg
  #COAST   CLY     ABUTS   EDI LVP NAO NWG
end
province('con') do
  name 'Constantinople'
  terrain Coast
  adjacencies aeg, bul/ec, bul/sc, bla, ank, smy
  #COAST   CON     ABUTS   AEG BUL/EC BUL/SC BLA ANK SMY
end
province('den') do
  name 'Denmark'
  terrain Coast
  adjacencies bal, hel, kie, nth, ska, swe
  #COAST   DEN     ABUTS   BAL HEL KIE NTH SKA SWE
end
province('eas') do
  name 'Eastern Mediterranean'
  terrain Water
  aliases %w{emed east eastern eastmed ems eme emd eas\ med}
  adjacencies aeg, ion, smy, syr
  #WATER   EAS     ABUTS   AEG ION SMY SYR
end
province('edi') do
  name 'Edinburgh'
  terrain Coast
  adjacencies cly, lvp(Army), nth, nwg, yor
  #COAST   EDI     ABUTS   CLY lvp NTH NWG YOR
end
province('eng') do
  name 'English Channel'
  terrain Water
  aliases %w{english channel ech eng\ ch}
  adjacencies bel, bre, iri, lon, mao, nth, pic, wal
  #WATER   ENG     ABUTS   BEL BRE IRI LON MAO NTH PIC WAL
end
province('fin') do
  name 'Finland'
  terrain Coast
  adjacencies bot, nwy(Army), stp/sc, swe
  #COAST   FIN     ABUTS   BOT nwy STP/SC SWE
end
province('gal') do
  name 'Galicia'
  terrain Land
  aliases 'galacia'
  adjacencies boh, bud, rum, sil, ukr, vie, war
  #LAND    GAL     ABUTS   BOH BUD RUM SIL UKR VIE WAR
end
province('gas') do
  name 'Gascony'
  terrain Coast
  adjacencies bur, bre, mao, mar(Army), par, spa/nc
  #COAST   GAS     ABUTS   BUR BRE MAO mar PAR SPA/NC
end
province('gre') do
  name 'Greece'
  terrain Coast
  adjacencies aeg, alb, bul/sc, ion, ser
  #COAST   GRE     ABUTS   AEG ALB BUL/SC ION SER
end
province('lyo') do
  name 'Gulf of Lyon'
  aliases %w{gol gulfofl lyon}
  terrain Water
  adjacencies mar, pie, spa/sc, tus, tys, wes
  #WATER   LYO     ABUTS   MAR PIE SPA/SC TUS TYS WES
end
province('bot') do
  name 'Gulf of Bothnia'
  aliases %w{gob both gulfofb bothnia}
  terrain Water
  adjacencies bal, fin, lvn, stp/sc, swe
  #WATER   BOT     ABUTS   BAL FIN LVN STP/SC SWE
end
province('hel') do
  name 'Helgoland Bight'
  aliases %w{helgoland heligoland heligoland\ bight}
  terrain Water
  adjacencies den, hol, kie, nth
  #WATER   HEL     ABUTS   DEN HOL KIE NTH
end
province('hol') do
  name 'Holland'
  terrain Coast
  adjacencies bel, hel, kie, nth, ruh
  #COAST   HOL     ABUTS   BEL HEL KIE NTH RUH
end
province('ion') do
  name 'Ionian Sea'
  aliases 'ionian'
  terrain Water
  adjacencies adr, aeg, alb, apu, eas, gre, nap, tun, tys
  #WATER   ION     ABUTS   ADR AEG ALB APU EAS GRE NAP TUN TYS
end
province('iri') do
  name 'Irish Sea'
  aliases %w{irish irs}
  terrain Water
  adjacencies eng, lvp, mao, nao, wal
  #WATER   IRI     ABUTS   ENG LVP MAO NAO WAL
end
province('kie') do
  name 'Kiel'
  terrain Coast
  adjacencies bal, ber, den, hel, hol, mun, ruh
  #COAST   KIE     ABUTS   BAL BER DEN HEL HOL MUN RUH
end
province('lvp') do
  name 'Liverpool'
  aliases %w{livp lpl}
  terrain Coast
  adjacencies cly, edi(Army), iri, nao, wal, yor(Army)
  #COAST   LVP     ABUTS   CLY edi IRI NAO WAL yor
end
province('lvn') do
  name 'Livonia'
  terrain Coast
  aliases %w{livo lvo lva}
  adjacencies bal, bot, mos, pru, stp/sc, war
  #COAST   LVN     ABUTS   BAL BOT MOS PRU STP/SC WAR
end
province('lon') do
  name 'London'
  terrain Coast
  adjacencies eng, nth, yor, wal
  #COAST   LON     ABUTS   ENG NTH YOR WAL
end
province('mar') do
  name 'Marseilles'
  terrain Coast
  aliases 'mars'
  adjacencies bur, gas(Army), lyo, pie, spa/sc, swi
  #COAST   MAR     ABUTS   BUR gas LYO PIE SPA/SC SWI
end
province('mao') do
  name 'Mid-Atlantic Ocean'
  terrain Water
  aliases %w{midatlanticocean midatlantic mid mat}
  adjacencies bre, eng, gas, iri, naf, nao, por, spa/nc, spa/sc, wes
  #WATER   MAO     ABUTS   BRE ENG GAS IRI NAF NAO POR SPA/NC SPA/SC WES
end
province('mos') do
  name 'Moscow'
  terrain Land
  adjacencies lvn, sev, stp, ukr, war
  #LAND    MOS     ABUTS   LVN SEV STP UKR WAR
end
province('mun') do
  name 'Munich'
  terrain Land
  adjacencies ber, boh, bur, kie, ruh, sil, tyr, swi
  #LAND    MUN     ABUTS   BER BOH BUR KIE RUH SIL TYR SWI
end
province('nap') do
  name 'Naples'
  terrain Coast
  adjacencies apu, ion, rom, tys
  #COAST   NAP     ABUTS   APU ION ROM TYS
end
province('nao') do
  name 'North Atlantic Ocean'
  terrain Water
  aliases 'nat'
  adjacencies cly, iri, lvp, mao, nwg
  #WATER   NAO     ABUTS   CLY IRI LVP MAO NWG
end
province('naf') do
  name 'North Africa'
  terrain Coast
  aliases %w{nora n\ afr}
  adjacencies mao, tun, wes
  #COAST   NAF     ABUTS   MAO TUN WES
end
province('nth') do
  name 'North Sea'
  terrain Water
  aliases %w{norsea nts}
  adjacencies bel, den, edi, eng, lon, hel, hol, nwy, nwg, ska, yor
  #WATER   NTH     ABUTS   BEL DEN EDI ENG LON HEL HOL NWY NWG SKA YOR
end
province('nwy') do
  name 'Norway'
  terrain Coast
  aliases %w{nor norw}
  adjacencies bar, fin(Army), nth, nwg, ska, stp/nc, swe
  #COAST   NWY     ABUTS   BAR fin NTH NWG SKA STP/NC SWE
end
province('nwg') do
  name 'Norwegian Sea'
  terrain Water
  aliases %w{norwegian norwsea nrg norg}
  adjacencies bar, cly, edi, nao, nwy, nth
  #WATER   NWG     ABUTS   BAR CLY EDI NAO NWY NTH
end
province('par') do
  name 'Paris'
  terrain Land
  adjacencies bur, bre, gas, pic
  #LAND    PAR     ABUTS   BUR BRE GAS PIC
end
province('pic') do
  name 'Picardy'
  terrain Coast
  adjacencies bel, bre, bur, eng, par
  #COAST   PIC     ABUTS   BEL BRE BUR ENG PAR
end
province('pie') do
  name 'Piedmont'
  terrain Coast
  adjacencies lyo, mar, tus, tyr, ven(Army), swi
  #COAST   PIE     ABUTS   LYO MAR TUS TYR ven SWI
end
province('por') do
  name 'Portugal'
  terrain Coast
  adjacencies mao, spa/nc, spa/sc
  #COAST   POR     ABUTS   MAO SPA/NC SPA/SC
end
province('pru') do
  name 'Prussia'
  terrain Coast
  adjacencies bal, ber, lvn, sil, war
  #COAST   PRU     ABUTS   BAL BER LVN SIL WAR
end
province('rom') do
  name 'Rome'
  terrain Coast
  adjacencies apu(Army), nap, tus, tys, ven(Army)
  #COAST   ROM     ABUTS   apu NAP TUS TYS ven
end
province('ruh') do
  name 'Ruhr'
  terrain Land
  adjacencies bel, bur, hol, kie, mun
  #LAND    RUH     ABUTS   BEL BUR HOL KIE MUN
end
province('rum') do
  name 'Rumania'
  terrain Coast
  adjacencies bla, bud, bul/ec, gal, ser, sev, ukr
  #COAST   RUM     ABUTS   BLA BUD BUL/EC GAL SER SEV UKR
end
province('ser') do
  name 'Serbia'
  terrain Land
  adjacencies alb, bud, bul, gre, rum, tri
  #LAND    SER     ABUTS   ALB BUD BUL GRE RUM TRI
end
province('sev') do
  name 'Sevastopol'
  terrain Coast
  aliases 'sevastapol'
  adjacencies arm, bla, mos, rum, ukr
  #COAST   SEV     ABUTS   ARM BLA MOS RUM UKR
end
province('sil') do
  name 'Silesia'
  terrain Land
  adjacencies ber, boh, gal, mun, pru, war
  #LAND    SIL     ABUTS   BER BOH GAL MUN PRU WAR
end
province('ska') do
  name 'Skagerrak'
  terrain Water
  adjacencies den, nwy, nth, swe
  #WATER   SKA     ABUTS   DEN NWY NTH SWE
end
province('smy') do
  name 'Smyrna'
  terrain Coast
  adjacencies aeg, ank(Army), arm(Army), con, eas, syr
  #COAST   SMY     ABUTS   AEG ank arm CON EAS SYR
end
province('spa') do
  name 'Spain'
  terrain Coast
  aliases 'spn'
  adjacencies gas, lyo, mao, mar, por, wes
  coast('nc') do
    aliases %w{spa(nc) spain/nc spain(nc) spn/nc spn(nc) spa\ (north coast)}
    adjacencies gas, mao, por
  end
  coast('sc') do
    aliases %w{spa(sc) spain/sc spain(sc) spn/sc spn(sc) spa\ (south coast)}
    adjacencies lyo, mao, por, wes
  end
  #COAST   SPA/NC  ABUTS   GAS MAO POR
  #COAST   SPA/SC  ABUTS   LYO MAO MAR POR WES
  #COAST   spa     ABUTS   GAS LYO MAO MAR POR WES
end
province('stp') do
  name 'St Petersburg'
  terrain Coast
  aliases %{stpete st.\ petersburg st.petersburg}
  adjacencies bar, bot, fin, lvn, mos, nwy
  coast('nc') do
    aliases %w{stp(nc) stpete/nc stpete(nc) st.\ petersburg/nc stp\ (north coast)}
    adjacencies bar, nwy
  end
  coast('sc') do
    aliases %w{stp(sc) stpete/sc stpete(sc) st.\ petersburg/sc stp\ (south+coast)}
    adjacencies bot, fin, lvn
  end
  #COAST   STP/NC  ABUTS   BAR NWY
  #COAST   STP/SC  ABUTS   BOT FIN LVN
  #COAST   stp     ABUTS   BAR BOT FIN LVN MOS NWY
end
province('swe') do
  name 'Sweden'
  terrain Coast
  adjacencies bal, bot, den, fin, nwy, ska
  #COAST   SWE     ABUTS   BAL BOT DEN FIN NWY SKA
end
province('syr') do
  name 'Syria'
  terrain Coast
  adjacencies arm(Army), eas, smy
  #COAST   SYR     ABUTS   arm EAS SMY
end
province('tri') do
  name 'Trieste'
  terrain Coast
  adjacencies adr, alb, bud, ser, tyr, ven, vie
  #COAST   TRI     ABUTS   ADR ALB BUD SER TYR VEN VIE
end
province('tun') do
  name 'Tunis'
  terrain Coast
  adjacencies ion, naf, tys, wes
  #COAST   TUN     ABUTS   ION NAF TYS WES
end
province('tus') do
  name 'Tuscany'
  terrain Coast
  adjacencies lyo, pie, rom, tys, ven(Army)
  #COAST   TUS     ABUTS   LYO PIE ROM TYS ven
end
province('tyr') do
  name 'Tyrolia'
  terrain Land
  aliases %{tyl trl tyo}
  adjacencies boh, mun, pie, tri, ven, vie, swi
  #LAND    TYR     ABUTS   BOH MUN PIE TRI VEN VIE SWI
end
province('tys') do
  name 'Tyrrhenian Sea'
  terrain Water
  aliases %{tyrr tyrrhenian tyn tyh}
  adjacencies ion, lyo, rom, nap, tun, tus, wes
  #WATER   TYS     ABUTS   ION LYO ROM NAP TUN TUS WES
end
province('ukr') do
  name 'Ukraine'
  terrain Land
  adjacencies gal, mos, rum, sev, war
  #LAND    UKR     ABUTS   GAL MOS RUM SEV WAR
end
province('ven') do
  name 'Venice'
  terrain Land
  adjacencies adr, apu, pie(Army), rom(Army), tri, tus(Army), tyr
  #COAST   VEN     ABUTS   ADR APU pie rom TRI tus TYR
end
province('vie') do
  name 'Vienna'
  terrain Land
  adjacencies boh, bud, gal, tri, tyr
  #LAND    VIE     ABUTS   BOH BUD GAL TRI TYR
end
province('wal') do
  name 'Wales'
  terrain Coast
  adjacencies eng, iri, lon, lvp, yor(Army)
  #COAST   WAL     ABUTS   ENG IRI LON LVP yor
end
province('war') do
  name 'Warsaw'
  terrain Land
  adjacencies gal, lvn, mos, pru, sil, ukr
  #LAND    WAR     ABUTS   GAL LVN MOS PRU SIL UKR
end
province('wes') do
  name 'Western Mediterranean'
  terrain Water
  aliases %{wmed west western westmed wms wme wmd west\ med wes\ med western\ med}
  adjacencies mao, lyo, naf, spa/sc, tun, tys
  #WATER   WES     ABUTS   MAO LYO NAF SPA/SC TUN TYS
end
province('yor') do
  name 'Yorkshire'
  terrain Coast
  aliases %{york yonkers}
  adjacencies edi, lon, lvp(Army), nth, wal(Army)
  #COAST   YOR     ABUTS   EDI LON lvp NTH wal
end
province('swi') do
  name 'Switzerland'
  terrain Shut
  adjacencies mar, bur, mun, tyr, pie
end
