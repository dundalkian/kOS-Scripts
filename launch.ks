run launchSites.
function launchOptions{
    if (launchSite() = 0){
        print "Something is up fam".
        print "I Would Consider Looking At Yo Damn Code..... Rebooting"
        wait 3.
        reboot.
    }
    if (launchSite() = "KLP"){
        print "Launching from KSC Launch Pad 1A".
    }
}


lock throttle to 1.0.
print "Booster Ignition in 10".

from {local countdown is 10.} until countdown = 0 step {set countdown to countdown - 1.} do{

    print "..." + countdown.

    wait 1.

}

stage.





set phi to 80.

LOCK STEERING to HEADING (90,90).



wait until airspeed > 110.

LOCK STEERING to HEADING(0, phi).

print "Beginning Gravity Turn".

wait 1.



until altitude > 60000{

  set phi to 90 * (1 - ((altitude / 80000) ^ .4)).

  wait 0.

  print phi.

}
//wait until altidude > 60000.

// from {local i is 1.} until i = 13 step {set i to i + 1.} do{
//     set phi to phi - 7.
//     print "Pitching to " + phi.
//     wait until altitude > (i*5000) .
// }

// unlock STEERING.
// set SASMODE TO "".
// if (SAS) {
//   print "SAS already engaged".
//   set SASMODE TO "".
// }.
// else {
//   SAS on.
//   wait 0.
//   set SASMODE TO "".
//   print "SAS engaged".
// }.
// wait 0.
// SET SASMODE TO "PROGRADE".
// print "Holding to PROGRADE".
// wait 10000.
// from {local i is }



//PRINT "There is " + STAGE:LIQUIDFUEL + " liquid fuel in this stage."

// wait 10.
// LOCK STEERING TO HEADING(180, 30).
// wait 1.
// print "Oh".
// print "Shit".
// print "RIP".
// wait 1.
// stage.
// print "LAUNCH ESCAPE SYSTEM ACTIVATED".
// wait 1.
//
// wait until maxthrust = 0.
// print "Clear of Danger, Ditching LAS".
// stage.
// unlock STEERING.
//
// wait until altitude < 300 .
// print "Opening Parachutes".
// stage.
//
//
// print "Another Happy Landing!".
//
// wait 120.
