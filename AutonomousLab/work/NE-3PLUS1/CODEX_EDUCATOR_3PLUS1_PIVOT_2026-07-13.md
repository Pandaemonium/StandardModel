# A new route to three-dimensional lightlike dynamics

The 3+1 problem has been difficult for a precise reason. On an ordinary
periodic lattice, a low-energy chiral particle almost never appears alone. A
second low-energy copy appears elsewhere in momentum space. Removing that copy
without also damaging locality, probability conservation, or the desired
Dirac behavior is the familiar doubling problem.

Our new approach stops demanding that a discrete-time theory behave like a
static lattice Hamiltonian. A full update period can contain several ordered
local steps. Two update schedules can end at exactly the same final matrix but
follow different routes during the period. We have now proved this elementary
but essential fact in Lean. It means that the topology of the full motion can
contain information that the one-period spectrum alone forgets.

Published Floquet models use exactly this extra information to support a single
bulk Weyl crossing. The missing balancing charge is carried by the topology of
the motion through the period, rather than by a second low-energy bulk particle.
Our task is to reconstruct that mechanism using only the project's permitted
primitive lightlike shifts and local channel turns.

## What about the boundary?

Our open-diamond simulations found modes concentrated near the outer surface.
At first this looked like another failure. The better interpretation is that
these may be the required surface response of a topologically nontrivial bulk,
similar in structure to anomaly inflow. Trying to eliminate them with a clever
boundary rule may therefore be the wrong goal.

The physically relevant question is whether those surface modes can affect a
fixed experiment deep inside before a signal has time to reach the surface.
The numerical answer is encouraging: for two different unitary coin families,
a fixed four-step interior amplitude agreed across radii 2 through 6 to about
`3e-17`. Once the radius reached 5, no probability reached the boundary during
those four steps.

We then proved the exact finite statement. If two update rules agree throughout
the backward causal cone of an observation, they give the same finite-time
interior amplitude even when they differ arbitrarily outside that cone. An
explicit two-site example proves that the global updates can genuinely differ.

## What this changes

We no longer need one finite box to have both a single bulk species and a
completely empty surface spectrum. The new target is a controlled sequence of
larger open regions:

1. the bulk update has one Weyl crossing because its full-period motion has
   nonzero topology;
2. the required partner information resides in micromotion and surface modes,
   not in a second light bulk species;
3. every microscopic translation remains lightlike;
4. fixed interior experiments stabilize before their causal cones reach the
   boundary;
5. those stabilized amplitudes converge to the desired continuum propagator.

Items 1, 3, and 5 remain open for the same explicit construction. We have
landed the finite micromotion API and the exact causal-exhaustion theorem, not a
complete 3+1 theory. The decisive next result is a nonzero loop invariant for a
primitive-null schedule together with a complete zero/pi crossing census.
