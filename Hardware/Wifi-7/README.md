## Wifi 7 shopping list and options
Pros and cons list as more devices get wifi 7 embeded for when I upgrade main ap


## Bananapi R-4 ~ $350

pros:
1. Learn arm architexture
2. Save pcie lanes
3. proper wireless hardware + npu
4. commandline
cons:
1. Likely overkill, not enough ram to push full opnsense to; don't think installing a hypervisor underneath would work with pcie passthrough on the board, Would be running opnwrt bare metal + maybe some docker containers

## Asia RF AP7988-001 (compared to r-4) ~ $450
pros:
1. Be 19 vs 14
2. more focused hardware
cons:
1. $100
2. No extra m2's slots for cellualar extension or storage

neutral:
1. - 3gb ram, absolutley couldn't do anything else besides ap

## PCIE Modules on main server ~ $250 - 300 (Antennas and pcie adapter)

pros: 
1. potentially the fastest (4x 6ghz on one module 2x 2.4 + 2x 5ghz on the other; max theoretical speed approx 16 gbs safely assuming only 1 pcie lane per module.
2. Managability
3. Scaleability

cons:
1. PCIE lanes waste, besides free m2 key e on motherboard, would need to use either both x4 gen 3 lanes or get a bifurcated riser; very niche for ideally a x4 to 2x x2.
2. Hunt for a connected x2 pcie e key or mpcie, nobody advertises the speciification
3. Individual modules seem to be as expensive as a combined module 
4. Not many examples of an Access point vm
5. Not sure how well wireless ap software works with x86 machines

## Brand name AP $ 200 - 400
Pros:
1. Cheapest Access point option
2. Can buy on amazon
Cons:
1. Money saved here will need to be invested into an sfp+ to rj45 adapter and potentially a poe injector, should just get a switch lol
2. Potential to brick, would like to familiarize opnwrt on open hardware prior to forcing on closed hardware
3. Loose out on weeks worth of troubleshooting



