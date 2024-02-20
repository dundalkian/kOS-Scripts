runOncePath("lib/lib_lazcalc.ks").

// #############################################
//       Prelaunch Checks
// #############################################
// Could extend this into a generic AVM mode for better reboots
if ship:status = "PRELAUNCH" {
    set state to 0. // Prelaunch
}

// Prelaunch checks. Checking staging would be good (check twr, connection status, stage ready, etc)
if ship:status = "PRELAUNCH" {
    set state to 1. // Ready for launch
}

// #############################################
//       Launch
// #############################################
function launch {
    sas off.
    rcs off.
    lock throttle to 1.
    //lock steering to heading(90,90).

    countdown().
}

launch().
triggerStaging().
wait until ship:verticalspeed > 10.

function countdown {
    set numberOfSeconds to 3.
    print("Countdown started.").
    wait 1.
    from {local myCounter is numberOfSeconds.}
    until myCounter = 0
    step {set myCounter to myCounter - 1. if myCounter = 1 {stage. print("Ignition !").}}
    do {
        hudText(myCounter, 1, 2, 30, rgb(1,0.498,0.208), false).
        wait 1.
    }
}

// #############################################
//       Gravity Turn
// #############################################
gravityTurn(80_000, 0).

global function gravityTurn{
    parameter targetAltitude, targetInc.
    parameter startAngle is 85.

    set traj_roll to 0.
    set traj_pitch to 90.
    //set traj_pitch to 90-(5/(100/ship:verticalspeed)).
    print("Launch Azimuth" + LAZcalc(LAZcalc_init(targetAltitude,targetInc))).
    set traj_azimuth to LAZcalc(LAZcalc_init(targetAltitude,targetInc)).
    local directionTilt is heading(traj_azimuth, traj_pitch).

    lock steering to heading(traj_azimuth, traj_pitch).
    until ship:verticalspeed > 100 {
        set traj_pitch to 90-(5/(100/ship:verticalspeed)).
        showInfo(targetAltitude, "Orbital").
        wait 0.
    }
    hudText("Gravity turn started.", 1, 2, 25, rgb(1,0.498,0.208), false).
    // until vAng(facing:vector,directionTilt:vector) < 1{
    //     print("Attempted to have Facing vector same as expected tilt") at (0, 23).
    //     print(vAng(facing:vector,directionTilt:vector)) at (0, 24).
    // }
    // until vAng(srfPrograde:vector, facing:vector) < 1{
    //     print("Attempted to bring Facing vector same as surface PRGRADE") at (0, 23).
    //     print(vAng(srfPrograde:vector, facing:vector)) at (0, 24).
    // }

    until apoapsis >= 0.98*targetAltitude {
        set traj_pitch to 90 - vAng(up:vector, srfPrograde:vector).
        showInfo(targetAltitude, "Orbital").
        wait 0.
    }
    local throt is max(0.1, 30/ship:maxthrust).
    lock throttle to throt.
    print ("Throttle down to " + round((throt * 100),2) + " %.") at (0,25).
    until apoapsis >= targetAltitude {
        lock steering to heading(90 - targetInc,90 - vAng(up:vector, Prograde:vector)).
        showInfo(targetAltitude, "Orbital").
        wait 0.
    }
    lock throttle to 0.
    print ("MECO.                  ") at (0,25).
    set kuniverse:timewarp:mode to "PHYSICS".
    set kuniverse:timewarp:rate to 3.
    until ship:altitude >= ship:body:atm:height {
        lock steering to heading(90 - targetInc,90 - vAng(up:vector, Prograde:vector)).
        showInfo(targetAltitude, "Orbital").
        wait 0.
    }
    clearScreen.
    set kuniverse:timewarp:rate to 1.
}


function showInfo {
    parameter showValue.
    parameter vectorLocked is "Surface".
    parameter N is 2.
    print vectorLocked + (" prograde locked.              ") at (0,N).
    print ("    Actual altitude: ") + round(ship:altitude, 2) + (" m        ") at (0,N+2).
    print ("   Surface velocity: ") + round(ship:velocity:surface:mag, 2) + (" m/s        ") at (0,N+3).
    print ("Angle above horizon: ") + round(90 - vAng(up:vector, facing:vector), 1) + ("°   ") at (0,N+4).
    print ("    Target apoapsis: ") + showValue + (" m") at (0,N+6).
    print ("    Actual apoapsis: ") + round(ship:orbit:apoapsis, 2) + (" m        ") at (0,N+7).
    print ("   Actual periapsis: ") + round(ship:orbit:periapsis, 2) + (" m        ") at (0,N+8).
    print ("   Launch azimuth: ") + round(traj_azimuth, 4) + (" deg        ") at (0,N+9).
    wait 0.01.
}

global function triggerStaging{
  global oldThrust is ship:availableThrust.
  global canStage is true.
  print ("Autostage system operational.").
  print " ".
  when ship:availableThrust < oldThrust - 10 AND canStage = true then {
    until false {
      wait until stage:ready.
      stage.
      hudText("STAGE", 1, 2, 30, rgb(1,0.498,0.208), false).
      wait 0.1.
      if ship:maxThrust > 0 or stage:number = 0 { 
        break.
      }
    }
    set oldThrust to ship:availableThrust.
    if stage:number > 0 {preserve.}
  }
}

// #############################################
//       Circularization
// #############################################
goToFrom(ship:orbit:apoapsis, "AP").
wait 1.
exeMnv().
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
// COMPUTE VELOCITY AT A GIVEN ALTITUDE OF AN ORBIT
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

global function computeVelocity {
  parameter per, apo, shipAlt.
  local bMu is ship:body:mu.
  local bRadius is ship:body:radius.
  local SA is shipAlt + bRadius.
  local RP is bRadius + per.
  local RA is bRadius + apo.
  local SMA is (RP + RA) / 2.

  return sqrt(bMu * (2 / SA - 1 / SMA)).
}

//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
// HOHMANN TRANSFER
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

global function hTrans {
  parameter shipAlt, targetAlt.
  local initialVel is 0.
  local finalVel is 0.
  local deltaVneeded is 0.

  set initialVel to computeVelocity(ship:orbit:periapsis, ship:orbit:apoapsis, shipAlt).
  if shipAlt < targetAlt {
    set finalVel to computeVelocity(shipAlt, targetAlt, shipAlt).
  }
  else {
    set finalVel to computeVelocity(targetAlt, shipAlt, shipAlt).
  }

  set deltaVneeded to finalVel - initialVel.

  print "---".
  print "initial vel: " + round(initialVel, 2) + " m/s ".
  print "  final vel: " + round(finalVel, 2) + " m/s ".
  print "    delta-v: " + round(deltaVneeded, 2) + " m/s ".
  print "---".

  return deltaVneeded.
}

//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
// GO TO FROM AP or PE
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

global function goToFrom {
  parameter targetAlt.
  parameter fromAlt is "AP".
  local newDV is 0.
  local newNode is node(0,0,0,0).

  if fromAlt = "AP" {
    set newDV to hTrans(ship:orbit:apoapsis, targetAlt).
    set newNode to node(time:seconds + ETA:apoapsis, 0, 0, newDV).
  }
  else {
    set newDV to hTrans(ship:orbit:periapsis, targetAlt).
    set newNode to node(time:seconds + ETA:periapsis, 0, 0, newDV).
  }
  add newNode.
}

//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
// EXECUTE MANEUVER
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

global function exeMnv { 
  parameter deltaTime is 20. 
  if hasNode {
    set myNode to nextNode.
    set tset to 0.
    lock throttle to tset.

    set max_acc to ship:maxthrust/ship:mass.
    set burn_duration to burnTime(myNode).

    kuniverse:timewarp:warpto(time:seconds + myNode:ETA - burn_duration - deltaTime).
    wait until kuniverse:timewarp:issettled.

    lock steering to myNode:deltav.
    wait until vAng(ship:facing:vector, myNode:deltaV) < 1.

    until myNode:eta <= (burn_duration)
      {print "Maneuver in: " + round(myNode:ETA - burn_duration, 2) + " s      " at (0,6).}

    set done to False.
    //initial deltav
    set dv0 to myNode:deltav.
    until done
    {
      set max_acc to ship:maxthrust/ship:mass.
      set tset to min(myNode:deltav:mag/max_acc, 1).
      if vdot(dv0, myNode:deltav) < 0
      {
          print "End burn, remain dv " + round(myNode:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, myNode:deltav),1).
          lock throttle to 0.
          break.
      }
      if myNode:deltav:mag < 0.1
      {
          print "Finalizing burn".
          wait until vdot(dv0, myNode:deltav) < 0.5.

          lock throttle to 0.
          print "End burn".
          set done to True.
      }
    }
  wait 0.
  remove myNode.
  }
  else {
    print("No existing maneuver").
  }

  unlock steering.
  unlock throttle.
  wait 0.
  set ship:control:pilotMainThrottle to 0.
}

function burnTime {
	Parameter maneuver_node.

	local dV is maneuver_node:deltav:mag/2.
	local F_t is ship:availablethrust.
	local m_0 is ship:mass.
	local e is constant:e.
	local g_0 is constant:g0.
	
	// effective ISP
    list engines in engine_list. 
	local Isp is 0.
	for eng in engine_list {
		set Isp to Isp + eng:availablethrust / ship:availablethrust * eng:vacuumisp.
	}	

    local burn_time is m_0*Isp*g_0*(1-e^((-1*dV)/(Isp*g_0)))/F_t.
    print(burn_time + "s").
    print(dV).
    print(F_t).
    print(m_0).
    print(e).
    print(g_0).
    print(Isp).
	return burn_time.
}
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
// CHANGE ENGINE'S THRUST LIMIT
//_________________________________________________
//‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

global function limitThrust {
  parameter perc.
  for eng in ship:engines {
    if eng:stage = stage:number {set eng:thrustLimit to perc.}
  }
  print ("Thrust power at ") + perc + (" %.            ") at (0,25).
}

