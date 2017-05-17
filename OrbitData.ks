function getEccentricity{
    return ship:orbit:eccentricity.
}
function getSemiMajorAxis{
    return ship:orbit:semimajoraxis.
}
function getInclination{
    return ship:orbit:inclination.
}
function getArgumentOfPeriapsis{
    return ship:orbit:argumentofperiapsis.
}
function getLongitudeOfAscendingNode{
    return ship:orbit:LAN.
}
function getPeriod{
    return ship:orbit:period.
}
function getTrueAnomaly{
    return ship:orbit:trueanomaly.
}
function getSGP{     //StandardGravitationalParameter
    return constant:G * Kerbin:Mass.
    //assume kerbin orbit
}
//Standard orbit list notation
//list size 3.
//(apoapsis, periapsis, inclination)

function tranferData{
    parameter desiredorbit.
    //assume transfer starts at current periapsis/apoapsis
    if (desiredorbit(0) > ship:orbit:apoapsis) {
        //increasing radius
        set transSMA to (ship:orbit:periapsis + desiredorbit(0))/2.
        set initV to sqrt(getSGP/periapsis).
        set finalV to sqrt(getSGP/desiredorbit(0)).
        set transV1 to sqrt(getSGP*((2/ship:orbit:periapsis) - (1/transSMA)).
        set transV2 to sqrt(getSGP*((2/desiredorbit(0)) - (1/transSMA)).
        set delV1 to (transV1 - initV).
        set delV2 to (finalV - transV2).
        set TotalDeltaV to (delV2 + delV1).
    }
    else {
        //decreasing radius

    }
}
