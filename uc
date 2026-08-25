#!/usr/bin/env bash
help_text="
NAME
    unicode - Search and find Unicode characters and icons.

USAGE
    unicode [options] <search-terms>

OPTIONS
    -e|--exact
        Perform exact matching of search terms.

    -h|--help
        Show help text.

DESCRIPTION
    Search through Unicode character sets including arrows, mathematical operators,
    miscellaneous technical symbols, box drawing, geometric shapes, miscellaneous
    symbols, and dingbats. Provide one to three search terms to filter results.

AUTHOR
    mjnurse.github.io - 2026
"
help_line="Search and find Unicode characters and icons"
web_desc_line="Search and find Unicode characters and icons"

tmpfile="/tmp/uc.tmp"
rm -f $tmpfile

# Terminal Colours
cdef="\x1b[39m" # default colour
cbla="\x1b[30m"; cgra="\x1b[90m"; clgra="\x1b[37m"; cwhi="\x1b[97m"
cred="\x1b[31m"; cgre="\x1b[32m"; cyel="\x1b[33m"; cblu="\x1b[34m"; cmag="\x1b[35m"; ccya="\x1b[36m";
clred="\x1b[91m"; clgre="\x1b[92m"; clyel="\x1b[93m"; clblu="\x1b[94m"; clmag="\x1b[95m"; clcya="\x1b[96m"

try="Try ${0##*/} -h for more information"
tmp="${help_text##*USAGE}"
usage=$(echo "Usage: ${tmp%%OPTIONS*}" | tr -d "\n" | sed "s/  */ /g")

if [[ "$1" == "" ]]; then
    echo "${usage}"
    echo "${try}"
    exit 1
fi

exact=false
while [[ "$1" != "" ]]; do
    case $1 in
        -h|--help)
            echo "$help_text"
            exit
            ;;
        -e|--exact)
            exact=true
            ;;
        ?*)
            break
            ;;
    esac
    shift
done

if [[ $exact == true ]]; then
    sp=" "
fi
p1="${sp}${1}${sp}"
p2="${sp}${2:-$1}${sp}"
p3="${sp}${3:-$1}${sp}"

n=1
cat $0 | sed 's/$/ /; s/:/ : /' | \
    egrep "^## |^# [^:]*:.*${p1}" | \
    egrep "^## |.*:.*${p2}" | \
    egrep "^## |.*:.*${p3}" | \
    sed '/^##/{N;/\n# /!d}' | \
    sed '/^##/{$d;N;/\n#/!D}' | \
    sed -E "
        s/^# //; 
        s/^## (.*)$/#${clcya}\1${cdef}/; 
        s/(.*:.*)(${p1})/\1${clmag}\2${cdef}/g;
        s/(.*:.*)(${p2})/\1${clmag}\2${cdef}/g;
        s/(.*:.*)(${p3})/\1${clmag}\2${cdef}/g;
    " | \
while read -r line; do
    if [[ "${line:0:1}" == "#" ]]; then
        echo -e "\n${line:1}"
    else
        echo -e "$n) $line"
        tmp="${line/ */}"
        echo -e "${tmp:-1}" >> "$tmpfile"
        ((n++))
    fi
done

echo
printf "${clcya}Select a character by number of view enlarged/copy (blank to exit): ${cdef}"
read n
if [[ -z "$n" ]]; then
    exit
fi
echo
char=$(sed -n "$((n))p" $tmpfile)
printf "$char" | iconv -f UTF-8 -t UTF-16LE | clip.exe

echo -e '
from PIL import Image, ImageDraw, ImageFont
import sys

char = "'$char'"
size = 100
img = Image.new("1", (size, size), 0)
draw = ImageDraw.Draw(img)
font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 40)
draw.text((10, 0), char, 1, font=font)

for y in range(0, int(size/2)-2, 2):  # Process two rows at a time
    for x in range(0, int(size/2), 1):
        top = img.getpixel((x, y))
        bottom = img.getpixel((x, y+1)) if y+1 < size else 0
        if top and bottom: print("█", end="")
        elif top: print("▀", end="")
        elif bottom: print("▄", end="")
        else: print("⋅", end="")
    print()
' | python3

echo
echo "(copied to clipboard)"

## Arrows
# \u2190:left arrow
# \u2191:up arrow
# \u2192:right arrow
# \u2193:down arrow
# \u2194:left right arrow
# \u2195:up down arrow
# \u2196:up left arrow
# \u2197:up right arrow
# \u2198:down right arrow
# \u2199:down left arrow
# \u219A:left arrow stroke
# \u219B:right arrow stroke
# \u219C:left wave arrow
# \u219D:right wave arrow
# \u219E:left two head arrow
# \u219F:up two head arrow
# \u21A0:right two head arrow
# \u21A1:down two head arrow
# \u21A2:left arrow tail
# \u21A3:right arrow tail
# \u21A4:left arrow bar
# \u21A5:up arrow bar
# \u21A6:right arrow bar
# \u21A7:down arrow bar
# \u21A8:up down arrow base
# \u21A9:left arrow hook
# \u21AA:right arrow hook
# \u21AB:left arrow loop
# \u21AC:right arrow loop
# \u21AD:left right wave arrow
# \u21AE:left right arrow stroke
# \u21AF:down zigzag arrow
# \u21B0:up arrow corner left
# \u21B1:up arrow corner right
# \u21B2:down arrow corner left
# \u21B3:down arrow corner right
# \u21B4:right arrow corner down
# \u21B5:down arrow corner left
# \u21B6:anticlockwise top arc
# \u21B7:clockwise top arc
# \u21B8:nw arrow long bar
# \u21B9:left right arrow bar
# \u21BA:anticlockwise circle
# \u21BB:clockwise circle
# \u21BC:left harpoon up
# \u21BD:left harpoon down
# \u21BE:up harpoon right
# \u21BF:up harpoon left
# \u21C0:right harpoon up
# \u21C1:right harpoon down
# \u21C2:down harpoon right
# \u21C3:down harpoon left
# \u21C4:right arrow over left
# \u21C5:up arrow beside down
# \u21C6:left arrow over right
# \u21C7:left paired arrows
# \u21C8:up paired arrows
# \u21C9:right paired arrows
# \u21CA:down paired arrows
# \u21CB:left harpoon over right
# \u21CC:right harpoon over left
# \u21CD:left dbl arrow stroke
# \u21CE:left right dbl arrow stroke
# \u21CF:right dbl arrow stroke
# \u21D0:left double arrow
# \u21D1:up double arrow
# \u21D2:right double arrow
# \u21D3:down double arrow
# \u21D4:left right double arrow
# \u21D5:up down double arrow
# \u21D6:nw double arrow
# \u21D7:ne double arrow
# \u21D8:se double arrow
# \u21D9:sw double arrow
# \u21DA:left triple arrow
# \u21DB:right triple arrow
# \u21DC:left squiggle arrow
# \u21DD:right squiggle arrow
# \u21DE:up arrow dbl stroke
# \u21DF:down arrow dbl stroke
# \u21E0:left dashed arrow
# \u21E1:up dashed arrow
# \u21E2:right dashed arrow
# \u21E3:down dashed arrow
# \u21E4:left arrow to bar
# \u21E5:right arrow to bar
# \u21E6:left white arrow
# \u21E7:up white arrow
# \u21E8:right white arrow
# \u21E9:down white arrow
# \u21EA:up white arrow bar
# \u21EB:up white arrow on bar
# \u21EC:up white dbl arrow
# \u21ED:up white arrow on bar dbl
# \u21EE:up white dbl arrow 2
# \u21EF:up white arrow dbl bar
# \u21F0:right white arrow wall
# \u21F1:nw arrow corner
# \u21F2:se arrow corner
# \u21F3:up down white arrow
# \u21F4:right arrow small circle
# \u21F5:down arrow beside up
# \u21F6:three right arrows
# \u21F7:left arrow vert stroke
# \u21F8:right arrow vert stroke
# \u21F9:left right arrow vert stroke
# \u21FA:left arrow dbl vert stroke
# \u21FB:right arrow dbl vert stroke
# \u21FC:left right arrow dbl vert stroke
# \u21FD:left open head arrow
# \u21FE:right open head arrow
# \u21FF:left right open head arrow
## Mathematical Operators
# \u2200:for all
# \u2201:complement
# \u2202:partial differential
# \u2203:there exists
# \u2204:not exists
# \u2205:empty set
# \u2206:increment
# \u2207:nabla 
# \u2208:element of
# \u2209:not element of
# \u220A:small element of
# \u220B:contains
# \u220C:not contains
# \u220D:small contains
# \u220E:end of proof
# \u220F:n ary product 
# \u2210:n ary coproduct
# \u2211:n ary summation
# \u2212:minus
# \u2213:minus or plus
# \u2214:dot plus
# \u2215:division slash
# \u2216:set minus
# \u2217:asterisk operator 
# \u2218:ring operator
# \u2219:bullet operator
# \u221A:square root
# \u221B:cube root
# \u221C:fourth root
# \u221D:proportional to
# \u221E:infinity
# \u221F:right angle 
# \u2220:angle
# \u2221:measured angle
# \u2222:spherical angle
# \u2223:divides
# \u2224:not divides
# \u2225:parallel to
# \u2226:not parallel to
# \u2227:logical and 
# \u2228:logical or
# \u2229:intersection
# \u222A:union
# \u222B:integral
# \u222C:double integral
# \u222D:triple integral
# \u222E:contour integral
# \u222F:surface integral 
# \u2230:volume integral
# \u2231:clockwise integral
# \u2232:clockwise contour integral
# \u2233:anticlockwise contour integral
# \u2234:therefore
# \u2235:because
# \u2236:ratio
# \u2237:proportion 
# \u2238:dot minus
# \u2239:excess
# \u223A:geometric proportion
# \u223B:homothetic
# \u223C:tilde operator
# \u223D:reversed tilde
# \u223E:inverted lazy s
# \u223F:sine wave 
# \u2240:wreath product
# \u2241:not tilde
# \u2242:minus tilde
# \u2243:asymptotically equal
# \u2244:not asymptotically equal
# \u2245:approximately equal
# \u2246:approx not equal
# \u2247:not approx equal 
# \u2248:almost equal
# \u2249:not almost equal
# \u224A:almost equal or equal
# \u224B:triple tilde
# \u224C:all equal to
# \u224D:equivalent to
# \u224E:geometrically equivalent
# \u224F:difference between 
# \u2250:approaches limit
# \u2251:geometrically equal
# \u2252:approximately equal or image
# \u2253:image or approximately equal
# \u2254:colon equals
# \u2255:equals colon
# \u2256:ring in equal
# \u2257:ring equal 
# \u2258:corresponds to
# \u2259:estimates
# \u225A:equiangular
# \u225B:star equals
# \u225C:delta equal
# \u225D:equal by definition
# \u225E:measured by
# \u225F:questioned equal 
# \u2260:not equal
# \u2261:identical to
# \u2262:not identical
# \u2263:strictly equivalent
# \u2264:less or equal
# \u2265:greater or equal
# \u2266:less over equal
# \u2267:greater over equal 
# \u2268:less not equal
# \u2269:greater not equal
# \u226A:much less than
# \u226B:much greater than
# \u226C:between
# \u226D:not equivalent
# \u226E:not less than
# \u226F:not greater than 
# \u2270:not less or equal
# \u2271:not greater or equal
# \u2272:less or equivalent
# \u2273:greater or equivalent
# \u2274:not less or equivalent
# \u2275:not greater or equivalent
# \u2276:less or greater
# \u2277:greater or less 
# \u2278:not less or greater
# \u2279:not greater or less
# \u227A:precedes
# \u227B:succeeds
# \u227C:precedes or equal
# \u227D:succeeds or equal
# \u227E:precedes or equivalent
# \u227F:succeeds or equivalent 
# \u2280:not precedes
# \u2281:not succeeds
# \u2282:subset of
# \u2283:superset of
# \u2284:not subset
# \u2285:not superset
# \u2286:subset or equal
# \u2287:superset or equal 
# \u2288:not subset or equal
# \u2289:not superset or equal
# \u228A:subset not equal
# \u228B:superset not equal
# \u228C:multiset
# \u228D:multiset multiply
# \u228E:multiset union
# \u228F:square image of 
# \u2290:square original of
# \u2291:square image or equal
# \u2292:square original or equal
# \u2293:square cap
# \u2294:square cup
# \u2295:circled plus
# \u2296:circled minus
# \u2297:circled times 
# \u2298:circled division slash
# \u2299:circled dot
# \u229A:circled ring
# \u229B:circled asterisk
# \u229C:circled equals
# \u229D:circled dash
# \u229E:squared plus
# \u229F:squared minus 
# \u22A0:squared times
# \u22A1:squared dot
# \u22A2:right tack
# \u22A3:left tack
# \u22A4:down tack
# \u22A5:up tack/perpendicular
# \u22A6:assertion
# \u22A7:models 
# \u22A8:true
# \u22A9:forces
# \u22AA:triple vert right turnstile
# \u22AB:dbl vert dbl right turnstile
# \u22AC:not proves
# \u22AD:not true
# \u22AE:not forces
# \u22AF:negated dbl vert dbl right 
# \u22B0:precedes under relation
# \u22B1:succeeds under relation
# \u22B2:normal subgroup
# \u22B3:contains normal subgroup
# \u22B4:normal subgroup or equal
# \u22B5:contains normal subgroup or equal
# \u22B6:original of
# \u22B7:image of 
# \u22B8:multimap
# \u22B9:hermitian conjugate
# \u22BA:intercalate
# \u22BB:xor
# \u22BC:nand
# \u22BD:nor
# \u22BE:right angle arc
# \u22BF:right triangle 
# \u22C0:n ary logical and
# \u22C1:n ary logical or
# \u22C2:n ary intersection
# \u22C3:n ary union
# \u22C4:diamond operator
# \u22C5:dot operator
# \u22C6:star operator
# \u22C7:division times 
# \u22C8:bowtie
# \u22C9:left normal factor
# \u22CA:right normal factor
# \u22CB:left semidirect product
# \u22CC:right semidirect product
# \u22CD:reversed tilde equals
# \u22CE:curly logical or
# \u22CF:curly logical and 
# \u22D0:double subset
# \u22D1:double superset
# \u22D2:double intersection
# \u22D3:double union
# \u22D4:pitchfork
# \u22D5:equal and parallel
# \u22D6:less than dot
# \u22D7:greater than dot 
# \u22D8:very much less than
# \u22D9:very much greater than
# \u22DA:less equal or greater
# \u22DB:greater equal or less
# \u22DC:equal or less
# \u22DD:equal or greater
# \u22DE:equal or precedes
# \u22DF:equal or succeeds 
# \u22E0:not precedes or equal
# \u22E1:not succeeds or equal
# \u22E2:not square image or equal
# \u22E3:not square original or equal
# \u22E4:square image not equal
# \u22E5:square original not equal
# \u22E6:less not equivalent
# \u22E7:greater not equivalent 
# \u22E8:precedes not equivalent
# \u22E9:succeeds not equivalent
# \u22EA:not normal subgroup
# \u22EB:not contains normal subgroup
# \u22EC:not normal subgroup or equal
# \u22ED:not contains normal or equal
# \u22EE:vertical ellipsis
# \u22EF:midline horizontal ellipsis 
# \u22F0:up right diagonal ellipsis
# \u22F1:down right diagonal ellipsis
# \u22F2:element of long horiz stroke
# \u22F3:element of vert bar at end
# \u22F4:small element of vert bar
# \u22F5:element of dot above
# \u22F6:element of overbar
# \u22F7:small element of overbar 
# \u22F8:element of underbar
# \u22F9:element of two horiz strokes
# \u22FA:contains long horiz stroke
# \u22FB:contains vert bar at end
# \u22FC:small contains vert bar
# \u22FD:contains overbar
# \u22FE:small contains overbar
# \u22FF:z notation bag 
## Miscellaneous Technical
# \u2300:diameter
# \u2301:electric arrow
# \u2302:house
# \u2303:up arrowhead
# \u2304:down arrowhead
# \u2305:projective
# \u2306:perspective
# \u2307:wavy line 
# \u2308:left ceiling
# \u2309:right ceiling
# \u230A:left floor
# \u230B:right floor
# \u230C:bottom right crop
# \u230D:bottom left crop
# \u230E:top right crop
# \u230F:top left crop 
# \u2310:reversed not
# \u2311:square lozenge
# \u2312:arc
# \u2313:segment
# \u2314:sector
# \u2315:telephone recorder
# \u2316:position indicator
# \u2317:viewdata square 
# \u2318:command key
# \u2319:turned not
# \u231A:watch
# \u231B:hourglass
# \u231C:top left corner
# \u231D:top right corner
# \u231E:bottom left corner
# \u231F:bottom right corner 
# \u2320:top half integral
# \u2321:bottom half integral
# \u2322:frown
# \u2323:smile
# \u2324:up arrowhead between bars
# \u2325:option key
# \u2326:erase to right
# \u2327:x in rectangle 
# \u2328:keyboard
# \u232B:erase to left
# \u232C:benzene ring
# \u232D:cylindricity
# \u232E:all around profile
# \u232F:symmetry 
# \u2330:total runout
# \u2331:dimension origin
# \u2332:conical taper
# \u2333:slope
# \u2334:counterbore
# \u2335:countersink
# \u2336:apl i beam
# \u2337:apl squish quad 
# \u2338:apl quad equal
# \u2339:apl quad divide
# \u233A:apl quad diamond
# \u233B:apl quad jot
# \u233C:apl quad circle
# \u233D:apl circle stile
# \u233E:apl circle jot
# \u233F:apl slash bar 
# \u2340:apl backslash bar
# \u2341:apl quad slash
# \u2342:apl quad backslash
# \u2343:apl quad less
# \u2344:apl quad greater
# \u2345:apl left vane
# \u2346:apl right vane
# \u2347:apl quad left arrow 
# \u2348:apl quad right arrow
# \u2349:apl circle backslash
# \u234A:apl down tack underbar
# \u234B:apl delta stile
# \u234C:apl quad down caret
# \u234D:apl quad delta
# \u234E:apl down tack jot
# \u234F:apl upwards vane 
# \u2350:apl quad up arrow
# \u2351:apl up tack overbar
# \u2352:apl del stile
# \u2353:apl quad up caret
# \u2354:apl quad del
# \u2355:apl up tack jot
# \u2356:apl downwards vane
# \u2357:apl quad down arrow 
# \u2358:apl quote underbar
# \u2359:apl delta underbar
# \u235A:apl diamond underbar
# \u235B:apl jot underbar
# \u235C:apl circle underbar
# \u235D:apl up shoe jot
# \u235E:apl quad quote
# \u235F:apl circle star 
# \u2360:apl quad colon
# \u2361:apl up tack diaeresis
# \u2362:apl del diaeresis
# \u2363:apl star diaeresis
# \u2364:apl jot diaeresis
# \u2365:apl circle diaeresis
# \u2366:apl down shoe stile
# \u2367:apl left shoe stile 
# \u2368:apl tilde diaeresis
# \u2369:apl greater diaeresis
# \u236A:apl comma bar
# \u236B:apl del tilde
# \u236C:apl zilde
# \u236D:apl stile tilde
# \u236E:apl semicolon underbar
# \u236F:apl quad not equal 
# \u2370:apl quad question
# \u2371:apl down caret tilde
# \u2372:apl up caret tilde
# \u2373:apl iota
# \u2374:apl rho
# \u2375:apl omega
# \u2376:apl alpha underbar
# \u2377:apl epsilon underbar 
# \u2378:apl iota underbar
# \u2379:apl omega underbar
# \u237A:apl alpha
# \u237B:not check mark
# \u237C:right angle with downward zigzag
# \u237D:shouldered open box
# \u237E:bell
# \u237F:vertical line with middle dot 
# \u2380:insertion
# \u2381:continuous underline
# \u2382:discontinuous underline
# \u2383:emphasis
# \u2384:composition
# \u2385:white square with centre dot
# \u2386:enter
# \u2387:alt key 
# \u2388:helm
# \u2389:circled horizontal bar
# \u238A:circled triangle down
# \u238B:broken circle nw arrow
# \u238C:undo
# \u238D:monostable
# \u238E:hysteresis
# \u238F:open circuit output h type 
# \u2390:open circuit output l type
# \u2391:passive pull down output
# \u2392:passive pull up output
# \u2393:direct current form two
# \u2394:software function
# \u2395:apl quad
# \u2396:decimal separator
# \u2397:previous page 
# \u2398:next page
# \u2399:print screen
# \u239A:clear screen
# \u239B:left paren upper
# \u239C:left paren extension
# \u239D:left paren lower
# \u239E:right paren upper
# \u239F:right paren extension 
# \u23A0:right paren lower
# \u23A1:left bracket upper
# \u23A2:left bracket extension
# \u23A3:left bracket lower
# \u23A4:right bracket upper
# \u23A5:right bracket extension
# \u23A6:right bracket lower
# \u23A7:left curly upper 
# \u23A8:left curly middle
# \u23A9:left curly lower
# \u23AA:curly bracket extension
# \u23AB:right curly upper
# \u23AC:right curly middle
# \u23AD:right curly lower
# \u23AE:integral extension
# \u23AF:horizontal line extension 
# \u23B0:upper left curly
# \u23B1:lower right curly
# \u23B2:summation top
# \u23B3:summation bottom
# \u23B4:top square bracket
# \u23B5:bottom square bracket
# \u23B6:bottom square bracket over top
# \u23B7:radical bottom 
# \u23B8:left vertical box line
# \u23B9:right vertical box line
# \u23BA:horizontal scan line 1
# \u23BB:horizontal scan line 3
# \u23BC:horizontal scan line 7
# \u23BD:horizontal scan line 9
# \u23BE:dentistry mirror
# \u23BF:dentistry light vertical down 
# \u23C0:dentistry light down right
# \u23C1:dentistry light down left
# \u23C2:dentistry light vertical up
# \u23C3:dentistry light up right
# \u23C4:dentistry light up left
# \u23C5:dentistry light down right left
# \u23C6:dentistry light up right left
# \u23C7:dentistry light wave 
# \u23C8:dentistry light vertical wave
# \u23C9:top parenthesis
# \u23CA:bottom parenthesis
# \u23CB:top curly bracket
# \u23CC:bottom curly bracket
# \u23CD:square foot
# \u23CE:return
# \u23CF:eject 
# \u23D0:vertical line extension
# \u23D1:metrical breve
# \u23D2:metrical long over short
# \u23D3:metrical short over long
# \u23D4:metrical long over two shorts
# \u23D5:metrical two shorts over long
# \u23D6:metrical two shorts joined
# \u23D7:metrical triseme 
# \u23D8:metrical tetraseme
# \u23D9:metrical pentaseme
# \u23DA:earth ground
# \u23DB:fuse
# \u23DC:top parenthesis ornament
# \u23DD:bottom parenthesis ornament
# \u23DE:top curly bracket ornament
# \u23DF:bottom curly bracket ornament 
# \u23E0:top tortoise bracket
# \u23E1:bottom tortoise bracket
# \u23E2:white trapezium
# \u23E3:benzene with circle
# \u23E4:straightness
# \u23E5:flatness
# \u23E6:ac current
# \u23E7:electrical intersection 
# \u23E8:decimal exponent
# \u23E9:fast forward
# \u23EA:rewind
# \u23EB:fast up
# \u23EC:fast down
# \u23ED:next track
# \u23EE:prev track
# \u23EF:play or pause 
# \u23F0:alarm clock
# \u23F1:stopwatch
# \u23F2:timer clock
# \u23F3:hourglass flowing
# \u23F4:medium left triangle
# \u23F5:medium right triangle
# \u23F6:medium up triangle
# \u23F7:medium down triangle 
# \u23F8:pause
# \u23F9:stop
# \u23FA:record
# \u23FB:power
# \u23FC:power on off
# \u23FD:power on
# \u23FE:sleep
# \u23FF:observer eye 
## Box Drawing
# \u2500:light horizontal
# \u2501:heavy horizontal
# \u2502:light vertical
# \u2503:heavy vertical
# \u2504:light triple dash horizontal
# \u2505:heavy triple dash horizontal
# \u2506:light triple dash vertical
# \u2507:heavy triple dash vertical 
# \u2508:light quadruple dash horizontal
# \u2509:heavy quadruple dash horizontal
# \u250A:light quadruple dash vertical
# \u250B:heavy quadruple dash vertical
# \u250C:light down and right
# \u250D:down light right heavy
# \u250E:down heavy right light
# \u250F:heavy down and right 
# \u2510:light down and left
# \u2511:down light left heavy
# \u2512:down heavy left light
# \u2513:heavy down and left
# \u2514:light up and right
# \u2515:up light right heavy
# \u2516:up heavy right light
# \u2517:heavy up and right 
# \u2518:light up and left
# \u2519:up light left heavy
# \u251A:up heavy left light
# \u251B:heavy up and left
# \u251C:light vertical and right
# \u251D:vertical light right heavy
# \u251E:up heavy right down light
# \u251F:down heavy right up light 
# \u2520:vertical heavy right light
# \u2521:down light right up heavy
# \u2522:up light right down heavy
# \u2523:heavy vertical and right
# \u2524:light vertical and left
# \u2525:vertical light left heavy
# \u2526:up heavy left down light
# \u2527:down heavy left up light 
# \u2528:vertical heavy left light
# \u2529:down light left up heavy
# \u252A:up light left down heavy
# \u252B:heavy vertical and left
# \u252C:light down and horizontal
# \u252D:left heavy right down light
# \u252E:right heavy left down light
# \u252F:down light horizontal heavy 
# \u2530:down heavy horizontal light
# \u2531:right light left down heavy
# \u2532:left light right down heavy
# \u2533:heavy down and horizontal
# \u2534:light up and horizontal
# \u2535:left heavy right up light
# \u2536:right heavy left up light
# \u2537:up light horizontal heavy 
# \u2538:up heavy horizontal light
# \u2539:right light left up heavy
# \u253A:left light right up heavy
# \u253B:heavy up and horizontal
# \u253C:light vertical and horizontal
# \u253D:left heavy right vertical light
# \u253E:right heavy left vertical light
# \u253F:vertical light horizontal heavy 
# \u2540:up heavy down horizontal light
# \u2541:down heavy up horizontal light
# \u2542:vertical heavy horizontal light
# \u2543:left up heavy right down light
# \u2544:right up heavy left down light
# \u2545:left down heavy right up light
# \u2546:right down heavy left up light
# \u2547:down light up horizontal heavy 
# \u2548:up light down horizontal heavy
# \u2549:right light left vertical heavy
# \u254A:left light right vertical heavy
# \u254B:heavy vertical and horizontal
# \u254C:light double dash horizontal
# \u254D:heavy double dash horizontal
# \u254E:light double dash vertical
# \u254F:heavy double dash vertical 
# \u2550:double horizontal
# \u2551:double vertical
# \u2552:down single right double
# \u2553:down double right single
# \u2554:double down and right
# \u2555:down single left double
# \u2556:down double left single
# \u2557:double down and left 
# \u2558:up single right double
# \u2559:up double right single
# \u255A:double up and right
# \u255B:up single left double
# \u255C:up double left single
# \u255D:double up and left
# \u255E:vertical single right double
# \u255F:vertical double right single 
# \u2560:double vertical and right
# \u2561:vertical single left double
# \u2562:vertical double left single
# \u2563:double vertical and left
# \u2564:down single horizontal double
# \u2565:down double horizontal single
# \u2566:double down and horizontal
# \u2567:up single horizontal double 
# \u2568:up double horizontal single
# \u2569:double up and horizontal
# \u256A:vertical single horizontal double
# \u256B:vertical double horizontal single
# \u256C:double vertical and horizontal
# \u256D:light arc down right
# \u256E:light arc down left
# \u256F:light arc up left 
# \u2570:light arc up right
# \u2571:light diagonal upper right
# \u2572:light diagonal upper left
# \u2573:light diagonal cross
# \u2574:light left
# \u2575:light up
# \u2576:light right
# \u2577:light down 
# \u2578:heavy left
# \u2579:heavy up
# \u257A:heavy right
# \u257B:heavy down
# \u257C:light left heavy right
# \u257D:light up heavy down
# \u257E:heavy left light right
# \u257F:heavy up light down 
## Block Elements
# \u2580:upper half block
# \u2581:lower one eighth block
# \u2582:lower one quarter block
# \u2583:lower three eighths block
# \u2584:lower half block
# \u2585:lower five eighths block
# \u2586:lower three quarters block
# \u2587:lower seven eighths block 
# \u2588:full block
# \u2589:left seven eighths block
# \u258A:left three quarters block
# \u258B:left five eighths block
# \u258C:left half block
# \u258D:left three eighths block
# \u258E:left one quarter block
# \u258F:left one eighth block 
# \u2590:right half block
# \u2591:light shade
# \u2592:medium shade
# \u2593:dark shade
# \u2594:upper one eighth block
# \u2595:right one eighth block
# \u2596:quadrant lower left
# \u2597:quadrant lower right 
# \u2598:quadrant upper left
# \u2599:quadrant upper left lower left lower right
# \u259A:quadrant upper left lower right
# \u259B:quadrant upper left upper right lower left
# \u259C:quadrant upper left upper right lower right
# \u259D:quadrant upper right
# \u259E:quadrant upper right lower left
# \u259F:quadrant upper right lower left lower right 
## Geometric Shapes
# \u25A0:black square
# \u25A1:white square
# \u25A2:white square rounded
# \u25A3:white square containing black small
# \u25A4:square horizontal fill
# \u25A5:square vertical fill
# \u25A6:square orthogonal crosshatch
# \u25A7:square upper left diagonal 
# \u25A8:square upper right diagonal
# \u25A9:square diagonal crosshatch
# \u25AA:black small square
# \u25AB:white small square
# \u25AC:black rectangle
# \u25AD:white rectangle
# \u25AE:black vertical rectangle
# \u25AF:white vertical rectangle 
# \u25B0:black parallelogram
# \u25B1:white parallelogram
# \u25B2:black up triangle
# \u25B3:white up triangle
# \u25B4:black up small triangle
# \u25B5:white up small triangle
# \u25B6:black right triangle
# \u25B7:white right triangle 
# \u25B8:black right small triangle
# \u25B9:white right small triangle
# \u25BA:black right pointer
# \u25BB:white right pointer
# \u25BC:black down triangle
# \u25BD:white down triangle
# \u25BE:black down small triangle
# \u25BF:white down small triangle 
# \u25C0:black left triangle
# \u25C1:white left triangle
# \u25C2:black left small triangle
# \u25C3:white left small triangle
# \u25C4:black left pointer
# \u25C5:white left pointer
# \u25C6:black diamond
# \u25C7:white diamond 
# \u25C8:white diamond containing black small
# \u25C9:fisheye
# \u25CA:lozenge
# \u25CB:white circle
# \u25CC:dotted circle
# \u25CD:circle vertical half fill
# \u25CE:bullseye
# \u25CF:black circle 
# \u25D0:circle left half black
# \u25D1:circle right half black
# \u25D2:circle bottom half black
# \u25D3:circle top half black
# \u25D4:circle upper right quadrant black
# \u25D5:circle all but upper left quadrant
# \u25D6:left half black circle
# \u25D7:right half black circle 
# \u25D8:inverse bullet
# \u25D9:inverse white circle
# \u25DA:upper half inverse white circle
# \u25DB:lower half inverse white circle
# \u25DC:upper left quadrant arc
# \u25DD:upper right quadrant arc
# \u25DE:lower right quadrant arc
# \u25DF:lower left quadrant arc 
# \u25E0:upper half circle
# \u25E1:lower half circle
# \u25E2:black lower right triangle
# \u25E3:black lower left triangle
# \u25E4:black upper left triangle
# \u25E5:black upper right triangle
# \u25E6:white bullet
# \u25E7:square left half black 
# \u25E8:square right half black
# \u25E9:square upper left diagonal half black
# \u25EA:square lower right diagonal half black
# \u25EB:white square vertical bisecting
# \u25EC:white up triangle dot
# \u25ED:up triangle left half black
# \u25EE:up triangle right half black
# \u25EF:large circle 
# \u25F0:white square upper left quadrant
# \u25F1:white square lower left quadrant
# \u25F2:white square lower right quadrant
# \u25F3:white square upper right quadrant
# \u25F4:white circle upper left quadrant
# \u25F5:white circle lower left quadrant
# \u25F6:white circle lower right quadrant
# \u25F7:white circle upper right quadrant 
# \u25F8:upper left triangle
# \u25F9:upper right triangle
# \u25FA:lower left triangle
# \u25FB:white medium square
# \u25FC:black medium square
# \u25FD:white medium small square
# \u25FE:black medium small square
# \u25FF:lower right triangle 
## Miscellaneous Symbols
# \u2600:sun
# \u2601:cloud
# \u2602:umbrella
# \u2603:snowman
# \u2604:comet
# \u2605:black star
# \u2606:white star
# \u2607:lightning 
# \u2608:thunderstorm
# \u2609:sun symbol
# \u260A:ascending node
# \u260B:descending node
# \u260C:conjunction
# \u260D:opposition
# \u260E:black telephone
# \u260F:white telephone 
# \u2610:ballot box
# \u2611:ballot box check
# \u2612:ballot box x
# \u2613:saltire
# \u2614:umbrella rain
# \u2615:hot beverage
# \u2616:white shogi piece
# \u2617:black shogi piece 
# \u2618:shamrock
# \u2619:reversed rotated floral heart
# \u261A:black left pointing index
# \u261B:black right pointing index
# \u261C:white left pointing index
# \u261D:white up pointing index
# \u261E:white right pointing index
# \u261F:white down pointing index 
# \u2620:skull crossbones
# \u2621:caution
# \u2622:radioactive
# \u2623:biohazard
# \u2624:caduceus
# \u2625:ankh
# \u2626:orthodox cross
# \u2627:chi rho 
# \u2628:cross of lorraine
# \u2629:cross of jerusalem
# \u262A:star and crescent
# \u262B:farsi
# \u262C:adi shakti
# \u262D:hammer and sickle
# \u262E:peace
# \u262F:yin yang 
# \u2630:trigram heaven
# \u2631:trigram lake
# \u2632:trigram fire
# \u2633:trigram thunder
# \u2634:trigram wind
# \u2635:trigram water
# \u2636:trigram mountain
# \u2637:trigram earth 
# \u2638:wheel of dharma
# \u2639:frowning face
# \u263A:smiling face
# \u263B:black smiling face
# \u263C:sun with rays
# \u263D:first quarter moon
# \u263E:last quarter moon
# \u263F:mercury 
# \u2640:female
# \u2641:earth
# \u2642:male
# \u2643:jupiter
# \u2644:saturn
# \u2645:uranus
# \u2646:neptune
# \u2647:pluto 
# \u2648:aries
# \u2649:taurus
# \u264A:gemini
# \u264B:cancer
# \u264C:leo
# \u264D:virgo
# \u264E:libra
# \u264F:scorpius 
# \u2650:sagittarius
# \u2651:capricorn
# \u2652:aquarius
# \u2653:pisces
# \u2654:white chess king
# \u2655:white chess queen
# \u2656:white chess rook
# \u2657:white chess bishop 
# \u2658:white chess knight
# \u2659:white chess pawn
# \u265A:black chess king
# \u265B:black chess queen
# \u265C:black chess rook
# \u265D:black chess bishop
# \u265E:black chess knight
# \u265F:black chess pawn 
# \u2660:black spade
# \u2661:white heart
# \u2662:white diamond suit
# \u2663:black club
# \u2664:white spade
# \u2665:black heart
# \u2666:black diamond suit
# \u2667:white club 
# \u2668:hot springs
# \u2669:quarter note
# \u266A:eighth note
# \u266B:beamed eighth notes
# \u266C:beamed sixteenth notes
# \u266D:music flat
# \u266E:music natural
# \u266F:music sharp 
# \u2670:west syriac cross
# \u2671:east syriac cross
# \u2672:universal recycling
# \u2673:recycling type 1
# \u2674:recycling type 2
# \u2675:recycling type 3
# \u2676:recycling type 4
# \u2677:recycling type 5 
# \u2678:recycling type 6
# \u2679:recycling type 7
# \u267A:recycling generic
# \u267B:black universal recycling
# \u267C:recycled paper
# \u267D:partially recycled paper
# \u267E:permanent paper
# \u267F:wheelchair 
# \u2680:die face 1
# \u2681:die face 2
# \u2682:die face 3
# \u2683:die face 4
# \u2684:die face 5
# \u2685:die face 6
# \u2686:white circle dot right
# \u2687:white circle two dots 
# \u2688:black circle white dot right
# \u2689:black circle two white dots
# \u268A:monogram yang
# \u268B:monogram yin
# \u268C:digram greater yang
# \u268D:digram lesser yin
# \u268E:digram lesser yang
# \u268F:digram greater yin 
# \u2690:white flag
# \u2691:black flag
# \u2692:hammer and pick
# \u2693:anchor
# \u2694:crossed swords
# \u2695:staff of aesculapius
# \u2696:scales
# \u2697:alembic 
# \u2698:flower
# \u2699:gear
# \u269A:staff of hermes
# \u269B:atom
# \u269C:fleur de lis
# \u269D:outlined white star
# \u269E:three lines converging right
# \u269F:three lines converging left 
# \u26A0:warning
# \u26A1:high voltage
# \u26A2:doubled female
# \u26A3:doubled male
# \u26A4:interlocked male female
# \u26A5:male and female
# \u26A6:male with stroke
# \u26A7:transgender 
# \u26A8:vertical male with stroke
# \u26A9:horizontal male with stroke
# \u26AA:medium white circle
# \u26AB:medium black circle
# \u26AC:medium small white circle
# \u26AD:marriage
# \u26AE:divorce
# \u26AF:unmarried partnership 
# \u26B0:coffin
# \u26B1:funeral urn
# \u26B2:neuter
# \u26B3:ceres
# \u26B4:pallas
# \u26B5:juno
# \u26B6:vesta
# \u26B7:chiron 
# \u26B8:black moon lilith
# \u26B9:sextile
# \u26BA:semisextile
# \u26BB:quincunx
# \u26BC:sesquiquadrate
# \u26BD:soccer ball
# \u26BE:baseball
# \u26BF:squared key 
# \u26C0:white draughts man
# \u26C1:white draughts king
# \u26C2:black draughts man
# \u26C3:black draughts king
# \u26C4:snowman without snow
# \u26C5:sun behind cloud
# \u26C6:rain
# \u26C7:black snowman 
# \u26C8:thunder cloud rain
# \u26C9:turned white shogi piece
# \u26CA:turned black shogi piece
# \u26CB:white diamond in square
# \u26CC:crossing lanes
# \u26CD:disabled car
# \u26CE:ophiuchus
# \u26CF:pick 
# \u26D0:car sliding
# \u26D1:rescue worker helmet
# \u26D2:circled crossing lanes
# \u26D3:chains
# \u26D4:no entry
# \u26D5:alternate one way left
# \u26D6:black two way left
# \u26D7:white two way left 
# \u26D8:black left lane merge
# \u26D9:white left lane merge
# \u26DA:drive slow
# \u26DB:heavy white down triangle
# \u26DC:left closed entry
# \u26DD:squared saltire
# \u26DE:falling diagonal in white circle
# \u26DF:black truck 
# \u26E0:restricted left entry 1
# \u26E1:restricted left entry 2
# \u26E2:astronomical uranus
# \u26E3:heavy circle with stroke and two dots
# \u26E4:pentagram
# \u26E5:right handed pentagram
# \u26E6:left handed pentagram
# \u26E7:inverted pentagram 
# \u26E8:black cross on shield
# \u26E9:shinto shrine
# \u26EA:church
# \u26EB:castle
# \u26EC:historic site
# \u26ED:gear without hub
# \u26EE:gear with handles
# \u26EF:map symbol lighthouse 
# \u26F0:mountain
# \u26F1:umbrella on ground
# \u26F2:fountain
# \u26F3:flag in hole
# \u26F4:ferry
# \u26F5:sailboat
# \u26F6:square four corners
# \u26F7:skier 
# \u26F8:ice skate
# \u26F9:person bouncing ball
# \u26FA:tent
# \u26FB:japanese bank
# \u26FC:headstone graveyard
# \u26FD:fuel pump
# \u26FE:cup on black square
# \u26FF:white flag with horizontal bar 
## Dingbats
# \u2700:black safety scissors
# \u2701:upper blade scissors
# \u2702:black scissors
# \u2703:lower blade scissors
# \u2704:white scissors
# \u2705:white heavy check mark
# \u2706:telephone location
# \u2707:tape drive 
# \u2708:airplane
# \u2709:envelope
# \u270A:raised fist
# \u270B:raised hand
# \u270C:victory hand
# \u270D:writing hand
# \u270E:lower right pencil
# \u270F:pencil 
# \u2710:upper right pencil
# \u2711:white nib
# \u2712:black nib
# \u2713:check mark
# \u2714:heavy check mark
# \u2715:multiplication x
# \u2716:heavy multiplication x
# \u2717:ballot x 
# \u2718:heavy ballot x
# \u2719:outlined greek cross
# \u271A:heavy greek cross
# \u271B:open centre cross
# \u271C:heavy open centre cross
# \u271D:latin cross
# \u271E:shadowed latin cross
# \u271F:outlined latin cross 
# \u2720:maltese cross
# \u2721:star of david
# \u2722:four teardrop spoked asterisk
# \u2723:four balloon spoked asterisk
# \u2724:heavy four balloon spoked asterisk
# \u2725:four club spoked asterisk
# \u2726:black four pointed star
# \u2727:white four pointed star 
# \u2728:sparkles
# \u2729:stress outlined white star
# \u272A:circled white star
# \u272B:open centre black star
# \u272C:black centre white star
# \u272D:outlined black star
# \u272E:heavy outlined black star
# \u272F:pinwheel star 
# \u2730:shadowed white star
# \u2731:heavy asterisk
# \u2732:open centre asterisk
# \u2733:eight spoked asterisk
# \u2734:eight pointed black star
# \u2735:eight pointed pinwheel star
# \u2736:six pointed black star
# \u2737:eight pointed rectilinear star 
# \u2738:heavy eight pointed rectilinear star
# \u2739:twelve pointed black star
# \u273A:sixteen pointed asterisk
# \u273B:teardrop spoked asterisk
# \u273C:open centre teardrop spoked asterisk
# \u273D:heavy teardrop spoked asterisk
# \u273E:six petalled black florette
# \u273F:black florette 
# \u2740:white florette
# \u2741:eight petalled outlined black florette
# \u2742:circled open centre eight pointed star
# \u2743:heavy teardrop spoked pinwheel asterisk
# \u2744:snowflake
# \u2745:tight trifoliate snowflake
# \u2746:heavy chevron snowflake
# \u2747:sparkle 
# \u2748:heavy sparkle
# \u2749:balloon spoked asterisk
# \u274A:eight teardrop spoked propeller asterisk
# \u274B:heavy eight teardrop spoked propeller asterisk
# \u274C:cross mark
# \u274D:shadowed white circle
# \u274E:negative squared cross mark
# \u274F:lower right drop shadowed white square 
# \u2750:upper right drop shadowed white square
# \u2751:lower right shadowed white square
# \u2752:upper right shadowed white square
# \u2753:black question mark ornament
# \u2754:white question mark ornament
# \u2755:white exclamation mark ornament
# \u2756:black diamond minus white x
# \u2757:heavy exclamation mark 
# \u2758:light vertical bar
# \u2759:medium vertical bar
# \u275A:heavy vertical bar
# \u275B:heavy single turned comma quote
# \u275C:heavy single comma quote
# \u275D:heavy double turned comma quote
# \u275E:heavy double comma quote
# \u275F:heavy low single comma quote 
# \u2760:heavy low double comma quote
# \u2761:curved stem paragraph
# \u2762:heavy exclamation ornament
# \u2763:heavy heart exclamation
# \u2764:heavy black heart
# \u2765:rotated heavy black heart bullet
# \u2766:floral heart
# \u2767:rotated floral heart bullet 
# \u2768:medium left parenthesis
# \u2769:medium right parenthesis
# \u276A:medium flattened left parenthesis
# \u276B:medium flattened right parenthesis
# \u276C:medium left angle bracket
# \u276D:medium right angle bracket
# \u276E:heavy left angle quote
# \u276F:heavy right angle quote 
# \u2770:heavy left angle bracket
# \u2771:heavy right angle bracket
# \u2772:light left tortoise shell bracket
# \u2773:light right tortoise shell bracket
# \u2774:medium left curly bracket
# \u2775:medium right curly bracket
# \u2776:dingbat negative circled 1
# \u2777:dingbat negative circled 2 
# \u2778:dingbat negative circled 3
# \u2779:dingbat negative circled 4
# \u277A:dingbat negative circled 5
# \u277B:dingbat negative circled 6
# \u277C:dingbat negative circled 7
# \u277D:dingbat negative circled 8
# \u277E:dingbat negative circled 9
# \u277F:dingbat negative circled 10 
# \u2780:dingbat circled sans serif 1
# \u2781:dingbat circled sans serif 2
# \u2782:dingbat circled sans serif 3
# \u2783:dingbat circled sans serif 4
# \u2784:dingbat circled sans serif 5
# \u2785:dingbat circled sans serif 6
# \u2786:dingbat circled sans serif 7
# \u2787:dingbat circled sans serif 8 
# \u2788:dingbat circled sans serif 9
# \u2789:dingbat circled sans serif 10
# \u278A:dingbat negative circled sans serif 1
# \u278B:dingbat negative circled sans serif 2
# \u278C:dingbat negative circled sans serif 3
# \u278D:dingbat negative circled sans serif 4
# \u278E:dingbat negative circled sans serif 5
# \u278F:dingbat negative circled sans serif 6 
# \u2790:dingbat negative circled sans serif 7
# \u2791:dingbat negative circled sans serif 8
# \u2792:dingbat negative circled sans serif 9
# \u2793:dingbat negative circled sans serif 10
# \u2794:heavy wide headed right arrow
# \u2795:heavy plus
# \u2796:heavy minus
# \u2797:heavy division 
# \u2798:heavy se arrow
# \u2799:heavy right arrow
# \u279A:heavy ne arrow
# \u279B:drafting point right arrow
# \u279C:heavy round tipped right arrow
# \u279D:triangle headed right arrow
# \u279E:heavy triangle headed right arrow
# \u279F:dashed triangle headed right arrow 
# \u27A0:heavy dashed triangle headed right arrow
# \u27A1:black right arrow
# \u27A2:3d top lighted right arrowhead
# \u27A3:3d bottom lighted right arrowhead
# \u27A4:black right arrowhead
# \u27A5:heavy black curved down right arrow
# \u27A6:heavy black curved up right arrow
# \u27A7:squat black right arrow 
# \u27A8:heavy concave pointed black right arrow
# \u27A9:right shaded white right arrow
# \u27AA:left shaded white right arrow
# \u27AB:back tilted shadowed white right arrow
# \u27AC:front tilted shadowed white right arrow
# \u27AD:heavy lower right shadowed white right arrow
# \u27AE:heavy upper right shadowed white right arrow
# \u27AF:notched lower right shadowed white right arrow 
# \u27B0:curly loop
# \u27B1:notched upper right shadowed white right arrow
# \u27B2:circled heavy white right arrow
# \u27B3:white feathered right arrow
# \u27B4:black feathered se arrow
# \u27B5:black feathered right arrow
# \u27B6:black feathered ne arrow
# \u27B7:heavy black feathered se arrow 
# \u27B8:heavy black feathered right arrow
# \u27B9:heavy black feathered ne arrow
# \u27BA:teardrop barbed right arrow
# \u27BB:heavy teardrop shanked right arrow
# \u27BC:wedge tailed right arrow
# \u27BD:heavy wedge tailed right arrow
# \u27BE:open outlined right arrow
# \u27BF:double curly loop
