#!/usr/bin/python

import sys

class PostScriptMap:
    #   ----------------------------------------------------------------------
    def __init__(self, mapFile, inFile = 0, outFile = 0, viewer = 0):
        try: lines = (inFile and open(inFile) or sys.stdin).readlines()
        except: raise CannotOpenResultsFile
        try: self.outFile = outFile and open(outFile, 'w') or sys.stdout
        except: raise CannotOpenOutputFile
        self.owner, self.adj, self.units = {}, {}, {}
        self.map, self.retreats, self.pages, self.sc, show = [], [], 0, '', 1
        self.started = section = lastSection = power = blind = None
        season = year = None
        self.startDoc(mapFile)
        for line in lines:
            word = line.upper().split()
            if not word or line[0] in ' \t' and section != 'O': continue
            if word[0] == 'SHOW':
                show = not (word[1:] and viewer) or viewer in word[1:]
                blind = viewer != 'MASTER'
                continue
            if not show: continue
            copy = ' '.join(word)

            #   -------------------------------------------
            #   Check if this is the beginning of a section
            #   -------------------------------------------
            if ' '.join(word[:2]) in (  'STARTING POSITION', 'STATUS OF',
                                        'ADJUSTMENT ORDERS', 'RETREAT ORDERS',
                                        'MOVEMENT RESULTS'    ):
                where, section = word[1] == 'OF' and 5 or 2, word[0][0]
                lastSection = section
            elif word[0] == 'OWNERSHIP':
                section, self.sc, self.owner, where = 'OWN', '', {}, 0
            elif section: where = 0
            else: continue

            if where:
                #   --------------------------------------------------------
                #   Determine the page title (game name, season, year, etc.)
                #   --------------------------------------------------------
                lastSeason, lastYear = season, year
                orders, graphics, scList, season = [], [], '', ''
                lowWord = line.split()
                if lowWord[where] == 'for':
                    name = lowWord[-1][1:-1].split('.')[0]
                    title = name + ', '
                    if section == 'S' and not self.pages:
                        if lowWord[-1][0] + lowWord[-1][-1] != '()': title = ''
                        title += 'Game Start'
                    else:
                        season, year = lowWord[where + 1:where + 3]
                        if year == 'of': year = lowWord[where + 3]
                        year = int(float(year))  # "year" has a period at end
                        if lowWord[-1][0] == '(' and lowWord[-1][-1] == ')':
                            title += season + ' ' + `year`
                #   ------------
                #   Prepare page
                #   ------------
                if section in 'MS':
                    if self.started:
                        self.endPage()
                        if blind and lastSeason:
                            self.positions(name, lastSeason, lastYear)
                    self.units = {}
                    self.startPage(title)
                #   -----------------------------
                #   Page begun.  Go to next line.
                #   -----------------------------
                continue

            #   -------------------
            #   Lines to be ignored
            #   -------------------
            if (copy[:13] == 'THE FOLLOWING'
            or  'PENDING' in copy       or  'INVALID' in copy
            or  'REORDER' in copy       or  'NO VALID' in copy
            or  'DESTROYED.' in copy    or  'DEPARTS' in copy
            or  'LOST' in copy          or  'INCOME HAS' in copy): continue

            #   -------------------------------------------
            #   See if we're reading orders for a new power
            #   -------------------------------------------
            if word[0][-1] == ':' and power != word[0][:-1].replace('.', ''):
                power = word[0][:-1].replace('.', '')
                if section != 'O':
                    if section != 'R': self.outFile.write(power + '\n')
                    if section in 'MS': orders += [power]
                else: self.sc += power + 'CENTER\n'

            #   --------------------------------------------
            #   Lines signaling the end of the phase results
            #   --------------------------------------------
            if filter(line.upper().startswith,
                ('THE ', 'DEADLINE ', 'ORDERS ', 'END')): section = None

            #   ------------------------------
            #   Check if the section has ended
            #   ------------------------------
            if section in ('OWN', None):
                #   ---------------------
                #   Write the information
                #   ---------------------
                if orders:
                    self.outFile.write('OrderReport\n')
                    for order in orders:
                        self.outFile.write('(%s) WriteOrder\n' % order)
                for graphic in graphics: self.outFile.write(graphic + '\n')
                power = orders = None
                if section: section = 'O'
                continue

            #   ----------------
            #   Center ownership
            #   ----------------
            if section == 'O':
                if 'SUPPLY' in word: power = section = None
                else:
                    scList += ' ' + ' '.join(word[line[0] != ' ':])
                    if scList[-1] == '.':
                        self.owner[power], scList = [], scList[:-1]
                        for loc in scList.split(','):
                            if loc.strip()[-2:] != 'SC':
                                where = self.lookup(loc.strip())
                                if where['nick'] not in self.owner[power]:
                                    self.owner[power] += [where['nick']]
                                    self.sc += where['nick'] + ' supply\n'
                        scList = ''
                continue

            #   -------------------------------------------------------
            #   Adjustment orders (modify the units list for final map)
            #   -------------------------------------------------------
            if word[1] in ('DEFAULTS,', 'REMOVES', 'BUILDS', 'BUILD'):
                self.adj.setdefault(power,
                    [word[1][0] == 'B' and 'BUILDS ' or 'REMOVES'])
                if word[2][:5] == 'WAIVE':
                    self.adj[power] += ['WAIVED']
                    continue
                which = 3 + (word[1][0] == 'D')
                unit = word[which][0]
                which += 2
                where = ' '.join(word[which + (word[which] == 'THE'):])
                where = self.lookup(where.split('.')[0])
                if word[1][0] != 'B':
                    for piece in self.units.get(power, [])[:]:
                        if piece['loc']['nick'] == where['nick']:
                            self.units[power].remove(piece)
                else: self.addUnit(power, unit, where)
                self.adj[power] += [unit + ' ' + where['nick']]
                continue
                
            #   ------------------------------------------------------
            #   Determine if the order failed (presence of annotation)
            #   ------------------------------------------------------
            message, msg = copy.split('(*'), ''
            if len(message) > 1:
                copy, msg = message[0], message[1].split('*)')[0]
                word = copy.split()
            copy, word[-1] = copy.strip()[:-1], word[-1][:-1]

            #   --------------------------------------------------------
            #   Find the order type (and where in the order it is given)
            #   Detect the word 'NO' from "NO ORDER PROCESSED" ==> HOLD.
            #   --------------------------------------------------------
            for order in (  'SUPPORT', 'CONVOY', '->', 'HOLD', 'DISBAND', 'NO',
                            'ARRIVES', 'FOUND'    ):
                try: orderWord = word.index(order)
                except: continue
                if order == 'NO': word[orderWord - 1] = word[orderWord - 1][:-1]
                break
            else: order, orderWord = '.', len(word)
            arrives = order == 'ARRIVES'

            #   -----------------------
            #   Determine unit location
            #   -----------------------
            unit, si = word[1][0], self.lookup(' '.join(word[2:orderWord]))

            #   ----------------------------------------------------
            #   Dislodged units will not be listed in the unit list.
            #   ----------------------------------------------------
            if 'DISLODGED' in msg: msg = 'DISLODGED'
            elif order[0] != 'D': self.addUnit(power, unit, si)

            #   -------------
            #   Draw the unit
            #   -------------
            if section != 'R' or order[0] in 'FA':
                self.outFile.write("\t%d %d Draw%s\n" %
                    (si['x'], si['y'], ('Fleet', 'Army')[unit == 'A']))

            #   --------------------------------------------
            #   Determine order text and graphical depiction
            #   --------------------------------------------

            #   ----
            #   HOLD
            #   ----
            if order[0] in 'NH': order, graph = 'H', ''
            #   ------
            #   CONVOY
            #   ------
            elif order[0] == 'C':
                mover, which = word.index('->'), ('ARMY', 'FLEET')[unit == 'A']
                di = self.lookup(' '.join(word[word.index(which) + 1:mover]))
                di2 = self.lookup(' '.join(word[mover + 1:]))
                order = "C %.3s - %-6.6s" % (di['nick'], di2['nick'])
                graph = ("%d %d %d %d ArrowConvoy" %
                    (di['x'], di['y'], di2['x'], di2['y']))
            #   -------
            #   SUPPORT
            #   -------
            elif order[0] == 'S':
                if 'ARMY' in word[orderWord:] or 'FLEET' in word[orderWord:]:
                    try: where = word[orderWord:].index('ARMY')
                    except: where = word[orderWord:].index('FLEET')
                else: continue
                where += orderWord + 1
                mover = None
                try:
                    move = word.index('->')
                    mover, where = ' '.join(word[where:move]), move + 1
                except: pass
                di = self.lookup(' '.join(word[where:]))
                if not mover:
                    order = "S %.3s" % di['nick']
                    graph = '%d %d ArrowHold' % (di['x'], di['y'])
                else:
                    di2 = self.lookup(mover)
                    order = "S %.3s - %-6.6s" % (di2['nick'], di['nick'])
                    graph = ("%d %d %d %d ArrowSupport" %
                        (di2['x'], di2['y'], di['x'], di['y']))
            #   ----
            #   MOVE
            #   ----
            elif order[0] == '-':
                where = 0
                while 1:
                    try: where += word[where:].index('->') + 1
                    except: break
                di = self.lookup(' '.join(word[where:]))
                order = "- %-6.6s" % di['nick']
                graph = ("%d %d Arrow" %
                    (di['x'], di['y']) + ('Move', 'Retreat')[section == 'R'])
                if section == 'R': self.retreats += ['%-10s %s %s - ' %
                    (power, unit, si['nick']) + di['nick']]
                if not msg: self.units[power][-1]['loc'] = di
                elif section == 'R':
                    graph = 'FailedOrder %s OkOrder' % graph
                    self.retreats[-1] += ' DESTROYED'
                    del self.units[power][-1]
            #   -------
            #   Disband
            #   -------
            elif order[0] == 'D':
                order = graph = ''
                self.retreats += ['%-10s %s %s DISBAND' %
                    (power, unit, si['nick'])]
            #   -------
            #   Arrives
            #   -------
            elif arrives:
                order, graph = '- %.3s' % si['nick'], ''
                if section == 'R': self.retreats += ['%-10s%s ??? - ' %
                    (power, unit) + di['nick']]
            #   -------------------------------
            #   Found, and simple unit position
            #   -------------------------------
            else:
                graph = ''
                if order[0] != 'F': order = ''
                elif section == 'R':
                    self.retreats += ['%-10s%s ' % (power, unit) + si['nick']]

            #   ----------------------------------------------------
            #   Add information (order and graphic arrow) to the map
            #   ----------------------------------------------------
            if section in 'MS': orders += [' %c %.3s %-15s ' %
                (unit, (si['nick'], '???')[arrives], order) + msg]
            if graph and section in 'MR': graphics += ['%s%d %d ' %
                (msg and 'FailedOrder ' or '', si['x'], si['y']) + graph +
                (msg and ' OkOrder' or '')]

        #   ------------------------------------------------------
        #   Finished reading the map.  Display any unfinished page
        #   ------------------------------------------------------
        if self.pages:
            #   ---------------------------
            #   Display any unfinished page
            #   ---------------------------
            if self.started: self.endPage()
            #   ---------------------------------------------------------------
            #   If the last page was movement, add final page showing positions
            #   ---------------------------------------------------------------
            if lastSection != 'S' and self.units:
                self.positions(name, season, year)
            #   -------------------
            #   Finish the document
            #   -------------------
            self.endDoc()
    #   ----------------------------------------------------------------------
    def addUnit(self, power, unit, where):
        self.units.setdefault(power, []).append({'type': unit, 'loc': where})
    #   ----------------------------------------------------------------------
    def startDoc(self, mapFile):
        try: file = open(mapFile + '.ps')
        except: raise CannotOpenPostScriptFile
        info = 0
        for line in file.readlines():
            word = line.strip().upper().split()
            if word[:2] == ['%', 'MAP']: info = 0
            elif word[:2] == ['%', 'INFO']: info = 1
            elif info:
                try: self.map += [{ 'x': int(word[1]), 'y': int(word[2]),
                                    'nick': word[3], 'name': ' '.join(word[4:])
                                 }]
                except: raise BadSiteInfoLine
            else: self.outFile.write(line)
        file.close()
        self.outFile.write('/DrawNames {\n')
        for data in [x for x in self.map if '/' not in x['nick']]:
            self.outFile.write('%(x)d %(y)d (%(nick)s) DrawName\n' % data)
        self.outFile.write('} bind def\n')
        self.pages, self.started = 0, None
    #   ----------------------------------------------------------------------
    def endDoc(self):
        self.outFile.write(
            '%%%%Trailer\n'
            '%%%%Pages: %d 1\n' % self.pages)
    #   ----------------------------------------------------------------------
    def startPage(self, title = None):
        self.pages += 1
        self.started = 1
        self.outFile.write(
            "%%%%Page: %d %d\n"
            "DrawMap\nDrawNames\n" % (self.pages, self.pages))
        if title: self.outFile.write('(%s) DrawTitle\n' % title)
    #   ----------------------------------------------------------------------
    def endPage(self):
        #   --------------
        #   Retreat report
        #   --------------
        if self.retreats:
            self.outFile.write('RetreatReport\n')
            for order in sorted(self.retreats):
                self.outFile.write('(%s) WriteRetreat\n' % order)
            self.retreats = []
        #   -----------------
        #   Adjustment report
        #   -----------------
        if self.adj:
            self.outFile.write('AdjustReport\n')
            seq = sorted(self.adj.keys())
            for power in seq: self.outFile.write(
                '(%-10s %s %s) WriteAdjust\n' %
                (power, self.adj[power][0], ', '.join(self.adj[power][1:])))
            self.adj = {}
        #   -------------------
        #   SC ownership report
        #   -------------------
        if self.owner:
            self.outFile.write('OwnerReport\n')
            seq = self.owner.keys()
            if 'UNOWNED' in seq:
                seq.remove('UNOWNED')
                seq += ['UNOWNED']
            for power in seq:
                if self.units.get(power) or self.owner.get(power):
                    status = power == 'UNOWNED' and ' ' or ('(%d/%d)' %
                        (len(self.units.get(power, [])),
                        len(self.owner.get(power, []))))
                    self.outFile.write('(%-10s%-7s %s) WriteOwner\n' %
                        (power, status, ' '.join(self.owner[power])))
        #   ---------------------------------
        #   SC coloration and page terminator
        #   ---------------------------------
        self.outFile.write(
            "%s\nBlack\n"
            "ShowPage\n"
            "%%%%PageTrailer\n" % self.sc)
        self.started = 0
    #   ----------------------------------------------------------------------
    def lookup(self, name):
        for loc in self.map:
            #   ----------------------------------------------------------
            #   Check for "XXX" and also for "THE XXX" in case a placename
            #   starts with the word "THE" (all the "THE"s are taken out).
            #   ----------------------------------------------------------
            if name in loc.values() or 'THE ' + name in loc.values():
                return loc
        sys.stderr.write('CANNOT LOOKUP %s\n' % name)
        raise OhCrap
    #   ----------------------------------------------------------------------
    def positions(self, name, season, year):
        self.startPage('%s, After %s %d' % (name, season, year))
        seq = sorted(self.units.keys())
        for time in (0, 1):
            if time: self.outFile.write('OrderReport\n')
            for power in [x for x in seq if self.units[x]]:
                self.outFile.write(
                    (time and '(%s) WriteOrder\n' or '%s\n') % power)
                for unit in self.units[power]:
                    if time: self.outFile.write('( %c %s) WriteOrder\n' %
                        (unit['type'], unit['loc']['nick']))
                    else: self.outFile.write('\t%d %d Draw%s\n' %
                        (unit['loc']['x'], unit['loc']['y'],
                        ('Fleet', 'Army')[unit['type'] == 'A']))
        self.endPage()
    #   ----------------------------------------------------------------------

if __name__ == '__main__':
    import os
    if len(sys.argv) == 1:
        sys.argv += [os.path.dirname(sys.argv[0]) + '/dpmap/standard']
    if len(sys.argv) > 2 or sys.argv[1] == '-?': sys.stderr.write(
        'Usage: %s [../mapDir/mapName] < resultsFile > outputPSfile\n' %
        os.path.basename(sys.argv[0]))
    else: PostScriptMap(sys.argv[1])

