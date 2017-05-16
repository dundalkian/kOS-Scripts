clearscreen.

lock throttle to 1.0.

print "Booster Ignition in 10".
from {local countdown is 10.} until countdown = 0 step {set countdown to countdown - 1.} do{
    print "..." + countdown.
    wait 1.
}
stage.
wait 10.
LOCK STEERING TO HEADING(180, 30).
wait 1.
print "Oh".
print "Shit".
print "RIP".
wait 1.
stage.
print "LAUNCH ESCAPE SYSTEM ACTIVATED".
wait 1.

wait until maxthrust = 0.
print "Clear of Danger, Ditching LAS".
stage.
unlock STEERING.

wait until altitude < 300 .
print "Opening Parachutes".
stage.


print "Another Happy Landing!".

wait 120.
