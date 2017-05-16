function launchSite {
    set loc to ship:geoposition.
    if (loc:lat > -0.1 and loc:lat < -.09 and loc:lng > -74.6 and loc:lng < -74.5) {
        return "KLP". //KSC Launch Pad.
    }
    // if (data is true) {
    //     return "KRW". //KSC RunWay.
    // }
    return 0.
}
//Can also use this file for all geo constants in the future I suppose.
