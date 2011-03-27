import os
from codecs import open


class Map:
        #       ----------------------------------------------------------------------
        def __init__(self, name = 'standard'):
                victory = phase = rootMap = flagDir = validated = textOnly = None
                home, locName, locType, locAbut, abutRules = {}, {}, {}, {}, {}
                ownWord, abbrev, centers, units, powName, flag = {}, {}, {}, {}, {}, {}
                rules, files, powers, scs, error, notify = [], [], [], [], [], []
                flow, unclear, size, homeYears, dummies, locs = [], [], [], [], [], []
                reserves, militia, dynamic, factory, partisan = [], [], {}, {}, {}
                leagues, directives = {}, {}
                aliases = {                     '-': '-',               'H': 'H',               'P': 'P',
                        'A': 'A',               'F': 'F',               'S': 'S',               'C': 'C',
                        'B': 'BUILD',   'R': 'REMOVE',  'D': 'DISBAND',
                        'ARMY': 'A',    'FLEET': 'F',   'SUPPORT': 'S', 'SUPPORTS': 'S',
                        'CONVOY': 'C',  'CONVOYS': 'C', 'HOLD': 'H',    'HOLDS': 'H',
                        'TO': '-',              'MOVE': '-',    'MOVES': '-',   'M': '-',
                        'SEA': '',              'OCEAN': '',    'GULF': '',             'OF': '',
                        'THE': '',              'IN': '',               'AT': '',               'PROXY': 'P'    }
                vars(self).update(locals())
                self.load()
                self.validate()
        #       ----------------------------------------------------------------------
        def validate(self, phases = ''):
                if not phases and self.validated: return
                for phase in phases:
                        for when, what in self.dynamic.items():
                                if ((when.isupper() and phase.startswith(when))
                                or      (when.islower() and when.upper() == phase)): self.load(what)
                error, self.rootMap = self.error, self.rootMap or self.name
                self.powers, self.validated = self.home.keys(), 1
                try: self.powers.remove('UNOWNED')
                except: pass
                self.powers.sort()
                if len(self.powers) < 2:
                        error += ['MAP DOES NOT SPECIFY AT LEAST TWO POWERS']
                for place in self.locName.values():
                        if place.upper() not in self.powers and not self.areatype(place):
                                error += ['NAMED LOCATION NOT ON MAP: ' + place]
                for place, abuts in self.locAbut.items():
                        upAbuts = [x.upper() for x in abuts]
                        for abut in abuts:
                                upAbut = abut.upper()
                                if upAbuts.count(upAbut) > 1:
                                        error += ['SITES ABUT TWICE: %s-' % place.upper() + upAbut]
                                        while upAbut in upAbuts: upAbuts.remove(upAbut)
                        if place.upper() not in self.locName.values():
                                error += ['MAP LOCATION HAS NO FULL NAME: ' + place]
                        [error.append('ONE-WAY ADJACENCY IN MAP: %s -> ' % place + x)
                                for x in abuts if 'SHUT' not in map(self.areatype, (place, x))
                                and not self.abuts('A', x, '-', place)
                                and not self.abuts('F', x, '-', place)]
                for power, places in self.home.items():
                        for site in places:
                                if site != '&SC':
                                        if site not in self.scs: self.scs += [site]
                                        if not self.areatype(site):
                                                error += ['BAD HOME FOR %s: ' % power + site]
                                if power == 'UNOWNED' or site == '&SC': continue
                                for other, locs in self.home.items():
                                        if locs.count(site) != (other == power):
                                                if other == 'UNOWNED': self.home['UNOWNED'].remove(site)
                                                else: error += ['HOME MULTIPLY OWNED: ' + site]
                for scs in self.centers.values():
                        self.scs.extend([x for x in scs if x not in self.scs])
                #       -----------------------------------------------------------
                #       Validate factory and partisan sites (non-SC build locations)
                #       -----------------------------------------------------------
                for power, places in self.factory.items():
                        for site in places:
                                if power == 'UNOWNED': error += ['UNOWNED FACTORY: ' + site]
                                elif not self.areatype(site):
                                        error += ['BAD FACTORY FOR %s: ' % power + site]
                                elif site in self.scs:
                                        error += ['FACTORY CANNOT BE SC: ' + site]
                                for other, locs in self.factory.items():
                                        if locs.count(site) != (other == power):
                                                error += ['FACTORY MULTIPLY OWNED: ' + site]
                for power, places in self.partisan.items():
                        for site in places:
                                if power == 'UNOWNED':
                                        error += ['UNOWNED PARTISAN SITE: ' + site]
                                elif not self.areatype(site):
                                        error += ['BAD PARTISAN SITE FOR %s: ' % power + site]
                                elif site in self.scs:
                                        error += ['PARTISAN SITE CANNOT BE SC: ' + site]
                                for other, locs in self.partisan.items():
                                        if locs.count(site) != (other == power):
                                                error += ['PARTISAN SITE MULTIPLY OWNED: ' + site]
                                for other, locs in self.factory.items():
                                        if site in locs:
                                                error += ['PARTISAN SITE CANNOT BE FACTORY: ' + site]
                #       -----------------
                #       Validate RESERVES
                #       -----------------
                error += ['BAD RESERVES POWER: ' + x
                        for x in self.reserves if x not in self.powers]
                #       ----------------
                #       Validate MILITIA
                #       ----------------
                error += ['BAD MILITIA POWER: ' + x
                        for x in self.militia if x not in self.powers]
                #       ----------------------------------
                #       Validate special abut restrictions
                #       ----------------------------------
                for key in self.abutRules:
                        if key[-1] == ')':
                                if key[:-1] not in self.scs:
                                        error += ['BAD OWNERSHIP ABUT RESTRICTION: (' + key]
                        elif key[-1] == ':':
                                if key[0] not in [self.abbrev.get(x, x[0])
                                        for x in self.powers]:
                                        error += ['BAD POWER ABUT RESTRICTION: ' + key]
                        elif key not in '~*':
                                error += ['UNKNOWN SPECIAL ABUT RESTRICTION: ' + key]
                        elif self.abutRules.get('~*'[key == '~']):
                                error += ['ILLEGAL SPECIAL ABUT RESTRICTIONS: BOTH ~ AND *']
                #       -----------------
                #       Validate initial
                #       centers and units
                #       -----------------
                for power, places in self.centers.items(): [error.append(
                        'BAD INITIAL OWNED CENTER FOR %s: ' % power + x) for x in places
                        if x not in ('SC!', 'SC?') and not self.areatype(x)]
                for power in self.powers:
                        self.centers[power] = self.centers.get(power, self.home[power])
                        [error.append('BAD INITIAL UNIT FOR %s: ' % power + x)
                                for x in self.units.get(power, []) if not self.isValidUnit(x)]
                if 'UNOWNED' in self.home: del self.home['UNOWNED']
                #       ----------------
                #       Ensure a default
                #       game-year FLOW
                #       ----------------
                self.flow = self.flow or [
                        'SPRING:MOVEMENT,RETREATS',
                        'FALL:MOVEMENT,RETREATS',
                        'WINTER:ADJUSTMENTS'    ]
                #       ------------------
                #       Validate game FLOW
                #       ------------------
                abbrev = {      'M': 'MOVEMENT', 'R': 'RETREATS', 'A': 'ADJUSTMENTS' }
                try:
                        self.seq = []
                        for item in self.flow:
                                if item == 'NEWYEAR':
                                        self.seq += [item]
                                        continue
                                season, phases = item.split(':')
                                for phase in phases.split(','):
                                        if abbrev.get(phase[0]) not in (None, phase):
                                                error += ['BAD PHASE TYPE IN FLOW (%s IS ALREADY %s)' %
                                                        (`phase[0]`, `abbrev[phase[0]]`)]
                                        newPhase = season + ' ' + phase
                                        if newPhase in self.seq and season != 'NEWYEAR':
                                                error += ['PHASE IN FLOW TWICE: ' + newPhase]
                                        self.seq += [newPhase]
                                        abbrev[phase[0]] = phase
                except: error += ['BAD FLOW SPECIFICATION']
                #       ---------------------------
                #       Validate initial game phase
                #       ---------------------------
                self.phase = self.phase or 'SPRING 1901 MOVEMENT'
                try:
                        phase = self.phase.split()
                        if len(phase) != 3: raise
                        self.firstYear = int(phase[1])
                except: error += ['BAD PHASE IN MAP FILE: ' + self.phase]
                self.victory = self.victory or [len(self.scs) // 2 + 1]
                #       ----------------------
                #       Load map specific info
                #       ----------------------
                #return self.loadInfo()
        #       ----------------------------------------------------------------------
        def loadInfo(self):
                error = self.error
                self.victory = self.victory or [centers // 2 + 1]
                #       -----------------
                #       Open ps info file
                #       -----------------
                try: file = open(host.packageDir + '/maps/psinfo',
                        encoding = 'latin-1')
                except: return error.append('PSINFO FILE NOT FOUND')
                #       ------------------------------------
                #       Assign default values
                #       Order: bbox papersize rotation blind
                #       ------------------------------------
                self.bbox, self.papersize, self.rotation = None, '', 3
                defVals = [''] * 3
                curVals = defVals[:]
                #       -----------------------------------------------------------
                #       Parse the file, searching for the map name
                #       and determining its parameter values
                #       Missing values are replaced with the default values.
                #   Special values:
                #               '_': replace with the default value
                #               '-': copy the corresponding value for the preceding map
                #               '=': copy all remaining values from the preceding map
                #       -----------------------------------------------------------
                for line in file:
                        word = line.split()
                        if not word or word[0][0] == '#': continue
                        curName = word.pop(0)
                        for idx in range(len(defVals)):
                                if len(word) <= idx or word[idx] == '_':
                                        curVals[idx] = defVals[idx]
                                elif word[idx] == '-': pass
                                elif word[idx] == '=': break
                                else: curVals[idx] = word[idx]
                        if curName == self.rootMap: break
                if curName != self.rootMap: return error.append(
                        'MAP NOT DEFINED IN PSINFO FILE: ' + self.rootMap)      
                #       ------------------------------------------------------
                #       Determine bbox and pixel size of graphic map at 72 dpi
                #       after rotation (for .gif file creation and display)
                #       ------------------------------------------------------
                if curVals[0] != '':
                        try: 
                                bbox = [eval(x) for x in curVals[0].split(',')]
                                if len(bbox) == 4:
                                        self.bbox = bbox
                                        self.size = [bbox[2] - bbox[0], bbox[3] - bbox[1]]
                                else: raise 
                        except: error.append('BBOX NOT CORRECT IN PSINFO FOR MAP: ' +
                                self.rootMap)
                #       -------------------
                #       Determine papersize
                #       -------------------
                if curVals[1] != '': self.papersize = curVals[1]
                #       -----------------------------------------
                #       Determine rotation from page orientation: 
                #               Portrait:       0 (No rotation)
                #               Landscape:      3 (270 degrees rotation)
                #               (Seascape:      1 (90 degrees rotation))
                #       -----------------------------------------
                if curVals[2] != '':
                        try: 
                                rotation = eval(curVals[2])
                                if rotation in range(4): self.rotation = rotation
                                else: raise
                        except: error.append('ROTATION NOT 0 TO 3 IN PSINFO FOR MAP: ' +
                                self.rootMap)
        #       ----------------------------------------------------------------------
        def load(self, fileName = 0):
                error = self.error
                if type(fileName) is not list:
                        fileName, power = fileName or (self.name + '.map'), 0
                        try: file = open(globalMapDir + fileName,
                                encoding = 'latin-1')
                        except: return error.append('MAP FILE NOT FOUND: ' + fileName)
                        self.files += [fileName]
                else: file = fileName
                phase = variant = 0
                for line in file:
                        word = line.split()
                        if not word or word[0][0] == '#': continue
                        upword = word[0].upper()
                        if word[-1].upper() in ('DIRECTIVE', 'DIRECTIVES'):
                                if len(word) > 2: error += ['BAD VARIANT DIRECTIVE LINE IN MAP']
                                elif len(word) == 1: variant = 'ALL'
                                elif upword == 'END': variant = 0
                                else:
                                        where = host.packageDir + '/variants'
                                        dirs = [x.upper() for x in os.listdir(where)
                                                if os.path.isdir(where + '/' + x)]
                                        if upword in dirs: variant = upword
                                        else: error += ['BAD VARIANT IN DIRECTIVE LINE IN MAP']
                        elif variant: self.directives.setdefault(variant, []).append(line)
                        #       ----------------------------------------
                        #       Dynamic map instructions to be processed
                        #       by the game only in specific game phases
                        #       ----------------------------------------
                        elif upword in ('FROM', 'IN'):
                                data = [x.strip() for x in ' '.join(word[1:]).split(':')]
                                if not data: error += ['BAD %s DIRECTIVE IN MAP' % upword]
                                elif upword == 'IN': phase = data[0].upper()
                                elif (' ' in data[0] or data[-1] != 'M'
                                or not data[1:-1].isdigit()): error += ['BAD FROM DIRECTIVE']
                                else: phase = data[0].lower()
                                if phase == 'start': phase = 0
                                elif len(data) > 1:
                                        self.dynamic.setdefault(phase, []).append(data[1])
                                        phase = 0
                        elif phase: self.dynamic.setdefault(phase, []).append(line)
                        #       ------------------------------------------
                        #       Text-Only specification (no .ps available)
                        #       ------------------------------------------
                        elif upword == 'TEXTONLY': self.textonly = 1
                        #       ----------------------------------
                        #       Centers needed to obtain a VICTORY
                        #       ----------------------------------
                        elif upword == 'VICTORY':
                                if self.victory: error += ['TWO VICTORY LINES IN MAP']
                                try: self.victory = map(int, word[1:])
                                except: error += ['BAD VICTORY LINE IN MAP FILE']
                        #       ---------------------------------
                        #       Inclusion of other base map files
                        #       ---------------------------------
                        elif upword in ('USE', 'USES', 'MAP'):
                                if upword == 'MAP':
                                        if len(word) != 2: error += ['BAD ROOT MAP LINE']
                                        elif self.rootMap: error += ['TWO ROOT MAPS']
                                        else: self.rootMap = word[1].split('.')[0]
                                for newFile in word[1:]:
                                        if '.' not in newFile: newFile += '.map'
                                        if newFile not in self.files: self.load(newFile)
                                        else: error += ['FILE MULTIPLY USED: ' + newFile]
                        #       ----------------------------
                        #       FLAGS directory for this map
                        #       ----------------------------
                        elif upword == 'FLAGS':
                                if len(word) != 2: error += ['BAD FLAGS']
                                elif self.flagDir: error += ['TWO FLAGS']
                                else: self.flagDir = word[1]
                        #       ----------------------------
                        #       Game phase FLOW for this map
                        #       ----------------------------
                        elif upword == 'FLOW': 
                                if len(word) == 1: self.flow = []
                                else: self.flow += word[1:]
                        #       -----------------------------
                        #       Person to NOTIFY on gamestart
                        #       -----------------------------
                        elif upword == 'NOTIFY': self.notify += word[1:]
                        #       ---------------
                        #       Set BEGIN phase
                        #       ---------------
                        elif upword == 'BEGIN': self.phase = ' '.join(word[1:]).upper()
                        #       ----------------------------------
                        #       DPjudge RULEs specific to this map
                        #       ----------------------------------
                        elif upword == 'RULE':
                                self.directives.setdefault(variant or 'ALL', []).append(line)
                                #       ----------------------------------------------
                                #       Go ahead and add it to self.rules if this rule
                                #       applies to all variants.  Any variant-specific
                                #       rules will be added later by the Game object.
                                #       Map.rules is only for display on GM's Webpage.
                                #       ----------------------------------------------
                                if (variant or 'ALL') == 'ALL':
                                        self.rules += line.upper().split()[1:]
                        #       ---------------------------------------------------
                        #       Year(s), if any, in which new home SC's are decided
                        #       ---------------------------------------------------
                        elif upword == 'NEWHOMES': self.homeYears = word[1:]
                        #       ----------------------
                        #       Placenames and aliases
                        #       ----------------------
                        elif '=' in line:
                                token = line.upper().split('=')
                                if len(token) == 1:
                                        error += ['BAD ALIASES IN MAP FILE: ' + token[0]]
                                        token += ['']
                                oldName, name, word = 0, token[0].strip(), token[1].split()
                                parts = [x.strip() for x in name.split('->')]
                                if len(parts) == 2: oldName, name = parts
                                elif len(parts) > 2: error += ['BAD RENAME DIRECTIVE: ' + name]
                                if not (word[0][0] + word[0][-1]).isalnum() or '-' in word[0]:
                                        error += ['INVALID LOCATION ABBREVIATION: ' + name]
                                if oldName: self.rename(oldName, word[0])
                                if name in self.locName or name in self.aliases:
                                        error += ['DUPLICATE MAP LOCATION: ' + name]
                                self.locName[name] = self.aliases[
                                        name.upper().replace(' ', '+')] = word[0]
                                for alias in word[1:]:
                                        if alias[-1] == '?': self.unclear += [alias[:-1]]
                                        elif alias in self.aliases:
                                                error += ['DUPLICATE MAP ALIAS: ' + alias]
                                        else: self.aliases[alias] = word[0]
                        #       ----------------------
                        #       Alternate flag graphic
                        #       ----------------------
                        elif upword == 'FLAG':
                                if not power: error += ['FLAG BEFORE POWER: ' + ' '.join(word)]
                                elif len(word) != 2 or self.flag.has_key(power):
                                        error += ['INVALID FLAG: ' + ' '.join(word)]
                                else: self.flag[power] = word[1]
                        #       ----------------
                        #       Center ownership
                        #       ----------------
                        elif upword == 'OWNS':
                                if power: self.centers.setdefault(power, []).extend(
                                        line.upper().split()[1:])
                                else: error += ['OWNS BEFORE POWER: ' + ' '.join(word)]
                        #       -----------------------------
                        #       Clear known units for a power
                        #       -----------------------------
                        elif upword == 'UNITS':
                                if power: self.units[power] = []
                                else: error += ['UNITS BEFORE POWER']
                        #       --------------------------------
                        #       Establish reserves (extra units)
                        #       and militia (home defense units)
                        #       --------------------------------
                        elif upword in ('RESERVES', 'MILITIA'):
                                if power:
                                        try:
                                                if len(word) > 2: raise
                                                count = len(word) == 1 or int(word[1])
                                                if count < 0: raise
                                                if upword == 'RESERVES':
                                                        self.reserves = [power] * count + [x
                                                                for x in self.reserves if x != power]
                                                else: self.militia = [power] * count + [x
                                                                for x in self.militia if x != power]
                                                self.reserves += [power] * count
                                        except: error += ['INVALID %s COUNT' % upword]
                                else: error += ['%s BEFORE POWER' % upword]
                        #       -------------------------------
                        #       League affiliation and behavior
                        #       -------------------------------
                        elif upword == 'LEAGUE':
                                if not power: error += ['LEAGUE BEFORE POWER']
                                elif power not in self.leagues:
                                        self.leagues[power] = [x.upper() for x in word[1:]]
                                        if len(word) > 2:
                                                act = self.leagues[power][1]
                                                if act == 'STRICT':
                                                        if len(word) > 3: error += ['BAD STRICT LEAGUE']
                                                elif act != 'BENIGN': error += ['BAD LEAGUE BEHAVIOR']
                                else: error += ['POWER IN MULTIPLE LEAGUES']
                        #       ----------------
                        #       Unit designation
                        #       ----------------
                        elif upword in ('A', 'F'):
                                unit = ' '.join(word)
                                if not power: error += ['UNIT BEFORE POWER: ' + unit]
                                elif len(word) == 2:
                                        for units in self.units.values(): map(units.remove,
                                                [x for x in units if x[2:5] == unit[2:5]])
                                        self.units.setdefault(power, []).append(unit)
                                else: error += ['INVALID UNIT: ' + unit]
                        elif upword == 'DUMMY':
                                if len(word) > 1: power = None
                                if len(word) == 1 and not power: error += ['DUMMY BEFORE POWER']
                                else: self.dummies.extend([x for x in [y.upper().replace('+','')
                                        for y in word[1:] or [power]] if x not in self.dummies])
                        elif upword == 'DROP':
                                for place in [x.upper() for x in word[1:]]: self.drop(place)
                        #       ----------------------------------------
                        #       Dynamic map instructions to be processed
                        #       by the game only in specific game phases
                        #       ----------------------------------------
                        elif len(word) > 1 and upword == 'IN':
                                data = [x.strip() for x in ' '.join(word[1:]).split(':')]
                                if len(data) != 2: error += ['BAD DYNAMIC MAP INSTRUCTION']
                                else: self.dynamic.setdefault(data[0], []).append(data[1])
                        #       ------------------------------
                        #       Terrain type and adjacencies
                        #       (with special adjacency rules)
                        #       ------------------------------
                        elif (len(word) > 1
                        and upword in ('AMEND', 'WATER', 'LAND', 'COAST', 'PORT', 'SHUT')):
                                place, other = word[1], word[1].swapcase()
                                if other in self.locs:
                                        self.locs.remove(other)
                                        if upword == 'AMEND':
                                                self.locType[place] = self.locType[other]
                                                self.locAbut[place] = self.locAbut[other]
                                        del self.locType[other]
                                        del self.locAbut[other]
                                        if place.isupper(): [self.drop(x, 1) for x in self.locs
                                                if x.startswith(place + '/')]
                                if place in self.locs: self.locs.remove(place)
                                self.locs += [place]
                                if upword != 'AMEND':
                                        self.locType[place] = word[0]
                                        if len(word) > 2: self.locAbut[place] = []
                                elif place not in self.locType:
                                        error += ['NO DATA TO "AMEND" FOR ' + place]
                                if len(word) > 2 and word[2].upper() != 'ABUTS':
                                        error += ['NO "ABUTS" FOR ' + place]
                                for dest in word[3:]:
                                        if dest[0] == '-':
                                                for site in self.locAbut[place][:]:
                                                        if site.upper().startswith(dest[1:].upper()):
                                                                self.locAbut[place].remove(site)
                                                for rule, sites in self.abutRules.items():
                                                        for tuple in sites:
                                                                if dest[1:][:3].upper() in tuple:
                                                                        self.abutRules[rule].remove(tuple)
                                                                        if not self.abutRules[rule]:
                                                                                del self.abutRules[rule]
                                                continue
                                        rule = []
                                        #       ----------------------------------------------
                                        #       Check for power restrictions of the form R:AEG
                                        #       meaning that only a Russian unit abuts AEG.
                                        #       ----------------------------------------------
                                        if dest.count(':') == 1:
                                                who, dest = dest.split(':')
                                                rule = [who.upper() + ':']
                                        #       ---------------------------------------
                                        #       Check for SC ownership restrictions of
                                        #       the form AEG(CON) meaning that only the
                                        #       player owning CON is adjacent to AEG
                                        #       ---------------------------------------
                                        if dest.count('(') == 1 and dest[-1] == ')':
                                                dest, need = dest.split('(')
                                                rule += [need.upper()]
                                        #       ---------------------------------------------
                                        #       Check for single-character (non-alphanumeric)
                                        #       special restrictions like CON* or *CON, which
                                        #       each mean something special.
                                        #       ---------------------------------------------
                                        while dest and not dest[0].isalnum():
                                                rule += [dest[0]]
                                                dest = dest[1:]
                                        while dest and not dest[-1].isalnum():
                                                rule += [dest[-1]]
                                                dest = dest[:-1]
                                        if not dest:
                                                error += ['BAD SPECIAL ABUT FOR ' + place]
                                                break
                                        #       ----------------------------------
                                        #       Add all the adjacency restrictions
                                        #       ----------------------------------
                                        for code in rule:
                                                self.abutRules.setdefault(code, []).append(
                                                        (place.upper(), dest[:3].upper()))
                                        #       ---------------------
                                        #       Now add the adjacency
                                        #       ---------------------
                                        self.locAbut[place] += [dest]
                        #       ----------------------------
                        #       Removal of an existing power
                        #       ----------------------------
                        elif upword == 'UNPLAYED':
                                for goner in [x.upper() for x in word[1:]]:
                                        try:
                                                del self.powName[goner]
                                                del self.ownWord[goner]
                                                del self.home[goner]
                                                if goner in self.centers: del self.centers[goner]
                                                if goner in self.abbrev: del self.abbrev[goner]
                                                if goner in self.factory: del self.factory[goner]
                                                if goner in self.partisan: del self.partisan[goner]
                                                if goner in self.units: del self.units[goner]
                                                if goner in self.powers: del self.powers[goner]
                                                self.reserves = [x for x in self.reserves if x != goner]
                                                self.militia = [x for x in self.militia if x != goner]
                                        except: error += ['NO SUCH POWER TO REMOVE: ' + goner]
                                power = None
                        #       ----------------------
                        #       Power name, ownership
                        #       word, and home centers
                        #       ----------------------
                        else:
                                if upword in ('NEUTRAL', 'CENTERS'): upword = 'UNOWNED'
                                oldPower, power = 0, (0, upword)[upword != 'UNOWNED']
                                if len(word) > 2 and word[1] == '->': 
                                        oldPower = power
                                        word = word[2:]
                                        power = word[0].upper() 
                                        if power in ('NEUTRAL', 'CENTERS', 'UNOWNED'): power = 0
                                        if not oldPower or not power: error += ['RENAMING UNOWNED DIRECTIVE NOT ALLOWED']
                                        else: self.renamePower(oldPower, power)                                         
                                upword = power or 'UNOWNED'
                                if power and upword not in self.powName.values():
                                        self.powName[upword] = power = power.replace('+', '')
                                if upword != 'UNOWNED' and len(word) > 1 and word[1][0] == '(':
                                        self.ownWord[upword] = word[1][1:-1] or power
                                        if ':' in word[1]:
                                                owner, abbrev = self.ownWord[upword].split(':')
                                                self.ownWord[upword] = owner or power
                                                self.abbrev[upword] = abbrev[:1].upper()
                                                if not abbrev or self.abbrev[upword] in 'M?':
                                                        error += ['ILLEGAL POWER ABBREVIATION']
                                        del word[1]
                                else: self.ownWord.setdefault(upword, upword)
                                self.home.setdefault(upword, [])
                                for home in word[1:]:
                                        if home[0] == '-':
                                                if home[1:] in self.factory.get(upword, []):
                                                        self.factory[upword].remove(home[1:])
                                                        continue
                                                if home[1:] in self.partisan.get(upword, []):
                                                        self.partisan[upword].remove(home[1:])
                                                        continue
                                                try:
                                                        self.home[upword].remove(home[1:])
                                                        if upword != 'UNOWNED':
                                                                self.home['UNOWNED'].append(home[1:])
                                                except: pass
                                        elif home[0] == '*':
                                                self.partisan.setdefault(upword, []).append(home[1:])
                                        elif home[0] != '+': self.home[upword].append(home)
                                        else: self.factory.setdefault(upword, []).append(home[1:])
        #       ----------------------------------------------------------------------
        def rename(self, old, new):
                old = old.upper()
                if old not in self.locName.values():
                        return error.append('INVALID RENAME LOCATION: ' + `old`)
                [x.pop(y) for x in (self.locName, self.aliases)
                        for y,z in x.items() if z == old]
                if old == new: return
                for site in [x for x in self.locs if x.upper() == old]:
                        self.locs.remove(site)
                        self.locs.append((new.lower(), new)[site == old])
                for homes in [x for x in self.home.values() if old in x]:
                        homes.remove(old)
                        homes.append(new)
                for units in self.units.values():
                        for unit in [x for x in units if x.endswith(old)]:
                                units.remove(unit)
                                units.append(unit[:2] + new)
                for data in (self.locAbut, self.locType):
                        gone = (old.lower(), old)[old in data]
                        data[(new.lower(), new)[old in data]] = data[gone]
                        del data[gone]
                for one, two in [(x,y) for z in self.abutRules.values()
                                                for x,y in z if old in (x.upper(), y.upper())]:
                        abuts.remove((one, two))
                        abuts.append((  one == old and new
                                                or  one == old.lower() and new.lower()
                                                or  one == old.title() and new.title() or one,
                                                        two == old and new
                                                or  two == old.lower() and new.lower()
                                                or  two == old.title() and new.title() or two))
                for sites in self.locAbut.values():
                        for attr in ('', '.lower()', '.title()'):
                                try:
                                        sites.remove(eval('old' + attr))
                                        sites.append(eval('new' + attr))
                                except: pass
        #       ----------------------------------------------------------------------
        def renamePower(self, old, new):
                if old not in self.powName.values(): 
                        return error.append('RENAMING UNDEFINED POWER ' + old)
                [x.pop(old, None) for x in (self.powName, self.ownWord, self.abbrev)]
                if old == new: return
                for data in (self.home, self.units, self.centers, self.powers, self.factory, self.partisan):
                        try:
                                data[new] = data[old]
                                del data[old]
                        except: pass
                for data in (self.militia, self.reserves):
                        try:
                                data.remove(old)
                                data.append(new)
                        except: pass
        #       ----------------------------------------------------------------------
        def drop(self, place, deCoast = 0):
                [self.locs.remove(x) for x in self.locs if x.upper().startswith(place)]
                [x.pop(y) for x in (self.locName, self.aliases)
                        for y,z in x.items() if z.startswith(place)]
                [x.remove(place) for x in self.home.values() if place in x]
                [y.remove(x) for y in self.units.values()
                                         for x in y if x[2:5] == place[:3]]
                for sites in self.locAbut.values():
                        for site in [x for x in sites if x.upper().startswith(place)]:
                                sites.remove(site)
                                if deCoast and place[:3] not in sites: sites += [place[:3]]
                for rule, abuts in self.abutRules.items():
                        for one, two in abuts[:]:
                                if (one.upper().startswith(place)
                                or      two.upper().startswith(place)): abuts.remove((one, two))
                        if not abuts: del self.abutRules[rule]
                [y.pop(x) for y in (self.locType, self.locAbut) for x in y.keys()
                        if x.startswith(place) or x.startswith(place.lower())]
        #       ----------------------------------------------------------------------
        def alias(self, word):
                for i in range(len(word), 0, -1):
                        up = '+'.join(word[:i]).upper()
                        for key in (up, up.replace('+-+', '-')):
                                if key in self.locName.values(): return key, i
                                if key in self.aliases: return self.aliases[key], i
                return word[0].upper(), 0
        #       ----------------------------------------------------------------------
        def areatype(self, loc):
                return self.locType.get(loc.upper()) or self.locType.get(loc.lower())
        #       ----------------------------------------------------------------------
        def defaultCoast(self, word):
                #       ----------------------------------------
                #       Returns the coast for a fleet move order
                #       that can only be to a single coast.  For
                #       example, F GRE-BUL returns F GRE-BUL/SC
                #       ----------------------------------------
                if len(word) == 4 and word[0] + word[2] == 'F-' and '/' not in word[3]:
                        unitLoc, newLoc, singleCoast = word[1], word[3], None
                        for place in self.abutList(unitLoc):
                                upPlace = place.upper()
                                if newLoc == upPlace: break
                                if newLoc == upPlace[:3]:
                                        if singleCoast: break
                                        singleCoast = upPlace
                        else: word[3] = singleCoast or newLoc
                return word
        #       ----------------------------------------------------------------------
        def abuts(self, unitType, unitLoc, orderType, otherLoc):
                #       ----------------------------------------
                #       If looking at adjacencies for support,
                #       remove any coast to check the adjacency.
                #       Armies cannot otherwise affect a coast.
                #       ----------------------------------------
                unitLoc, otherLoc = unitLoc.upper(), otherLoc.upper()
                if '/' in otherLoc:
                        if orderType == 'S': otherLoc = otherLoc[:3]
                        elif unitType == 'A': return
                #       ------------------------------
                #       See if the list of adjacencies
                #       works from unitLoc to otherLoc
                #       ------------------------------
                for place in self.abutList(unitLoc):
                        upPlace = place.upper()
                        locale = upPlace[:3]
                        if otherLoc in (upPlace, locale): break
                else: return
                #       ------------------------------------
                #       Okay, the place is adjacent ... but
                #       see what terrain type is at otherLoc
                #       ------------------------------------
                otherLocType = self.areatype(otherLoc)
                if otherLocType == 'SHUT': return
                #       ---------------------------------
                #       If the unit type is unknown, then
                #       assume that the adjacency is okay
                #       ---------------------------------
                if unitType == '?': return 1
                #       --------------------------------------------
                #       Fleets cannot affect LAND and fleets are not
                #       adjacent to any location listed in lowercase
                #       (except when offering support into such an
                #       area, as in F BOT S A MOS-STP), or listed in
                #       the adjacency list in lower-case (F VEN-TUS)
                #       --------------------------------------------
                if unitType == 'F':
                        if (otherLocType == 'LAND' or place[0] != locale[0]
                        or orderType != 'S' and otherLoc not in self.locType): return
                #       ------------------------------------------------------
                #       Armies cannot move to water (unless this is a convoy).
                #       Note that the caller is responsible for determining if
                #       a fleet exists at the adjacent spot to convoy the army
                #       Also, armies can't move to spaces listed in Mixed case
                #       ------------------------------------------------------
                elif orderType != 'C' and (otherLocType == 'WATER'
                or place == place.title()): return
                #       --------------------------
                #       Good news.  It's adjacent.
                #       --------------------------
                return 1
        #       ----------------------------------------------------------------------
        def isValidUnit(self, unit, noCoastOK = 0, shutOK = 0):
                unit, locale = unit.upper().split()
                type = self.areatype(locale)
                if unit == '?': return type
                if shutOK and type == 'SHUT': return 1
                if unit == 'A': return ('/' not in locale
                        and type in ('LAND', 'COAST', 'PORT'))
                return (unit == 'F' and type in ('WATER', 'COAST', 'PORT')
                        and (noCoastOK or locale.lower() not in self.locAbut))
        #       ----------------------------------------------------------------------
        def parseAlias(self, words):
                result = []
                del words[:words[0] == 'THE']
                for word in words:
                        if word[-1] in ',.': word = word[:-1]
                        if (word in ('->', 'NO', 'SUPPORT', 'HOLD',
                                                 'CONVOY', 'DISBAND', 'WITH')
                        or len(word) > 1 and word[1] == '*'): break
                        result += [word]
                return self.locName.get(' '.join(result))
        #       ----------------------------------------------------------------------
        def abutList(self, site):
                return self.locAbut.get(site, self.locAbut.get(site.lower(), []))
        #       ----------------------------------------------------------------------
globalMapDir = os.path.dirname(os.path.abspath(os.sys.argv[0])) + '/dpfailmap/'
a = Map(os.sys.argv[1])
if len(a.error):
    print "Error: ", a.error
else:
    print eval(os.sys.argv[2])
