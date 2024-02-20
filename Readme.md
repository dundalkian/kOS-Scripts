# Kerbal Operating System Scripts

<details>

<summary>Finding manuever burn time.</summary>

(This is probably wrong somewhere)

### Finding propellant mass

We can find the total burn time by finding a way to relate the mass used as propellant to the (assumed) constant flow rate of that mass. This solves the problem of acceleration not being constant by using the constant thrust instead.

Starting with the rocket equation: https://en.wikipedia.org/wiki/Tsiolkovsky_rocket_equation
$$\Delta V = I_{sp}g_0ln\frac{m_0}{m_f}$$

$$\frac{\Delta V}{I_{sp}g_0} = ln\frac{m_0}{m_f}$$

$$e^{\frac{\Delta V}{I_{sp}g_0}} = e^{ln\frac{m_0}{m_f}}$$

$$e^{\frac{\Delta V}{I_{sp}g_0}} = \frac{m_0}{m_f}$$

Put in terms of final mass for substitution:

$$m_f = m_0 e^{\frac{-\Delta V}{I_{sp}g_0}}$$

Propellant mass used during the burn is the initial mass minus the remaining mass: $m_p = m_0 - m_f$. Substitute and put in terms of initial mass:

$$m_p = m_0 \left( 1 - e\frac{-\Delta V}{I_{sp}g_o}\right)$$


---
### Finding mass flow rate

Knowing the mass of our propellant, we now need the rate of mass flow to give us the total burn time: $\frac{kg}{kg/s} = s$

Mass flow rate means mass changes with respect to time. $F = m*a $ can't save us so easily.

... Skipping some very important steps (https://www1.grc.nasa.gov/beginners-guide-to-aeronautics/thrust-force/) ... We generally can relate these equations:

$$F = ma = m \dot v = \dot m v_{exhaust} = F_{thrust}$$

$$ \dot m = \frac{F_{thrust}}{v_{exhaust}}$$

and with $v_{exhaust} = I_{sp}g_0$ from the rocket equation this starts to look manageable:

$$ \dot m = \frac{F_{thrust}}{I_{sp}g_0}$$
---
### Finding burn time

We now have the total mass burned, and the mass flow rate, putting them together we finally see our total time:

$$T = \frac{m_p}{\dot m}$$

$$T = \frac{m_0 \left( 1 - e\frac{-\Delta V}{I_{sp}g_o}\right)}{\frac{F_{thrust}}{I_{sp}g_0}}$$

$$T = \frac{m_0 I_{sp}g_0\left( 1 - e\frac{-\Delta V}{I_{sp}g_o}\right)}{F_{thrust}}$$

And all of these terms we can find using kOS assuming the maneuver node has already been created.

```KerboScript
function burnTime {
	Parameter maneuver_node.

	local dV is maneuver_node:deltav:mag.
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

	return m_0*Isp*g_0*(1-e^((-1*dV)/(Isp*g_0)))/F_t.
}
```
</details>
