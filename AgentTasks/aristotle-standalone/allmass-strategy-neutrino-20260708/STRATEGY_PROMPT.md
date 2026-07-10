# Strategy: is a finite mass-VALUE map constructible? (the neutrino-ratio gap)

STRATEGY + NO-GO job (a landed kernel lemma is a bonus). Standalone; the facts are
stated below.

## Situation (finite mathematical-physics program: mass = obstruction to null transport)

The program kernel-proves mass GAPS and RATIOS of a structural kind: on the carrier
sector block `B(lam,kappa)` the squared-mass spectrum is `{lam-kappa, lam,
lam+kappa}` and the gap is `lam - kappa` (aperture - closure). But it has NO map
from these structural quantities to physical mass VALUES or dimensionless mass
RATIOS of Standard-Model particles. The open §10 item is the **neutrino mass ratio**
(e.g. a normal-ordering `m2/m3` or `Delta m^2` ratio): the program cannot predict it
because it lacks a **mass-value map** - a rule assigning the couplings `(lam,kappa,
...)` of a given carrier to a specific particle's mass.

## Your task - decide whether this is constructible or a category error

1. **State precisely what a "mass-value map" would be.** A function from finite
   carrier data (which couplings? which sector? a discrete label for the particle?)
   to a real number (a mass, or a dimensionless ratio). What finite input does the
   program actually have that could distinguish, say, the three neutrino mass
   eigenstates? Is there ANY discrete/combinatorial invariant of the carrier (edge
   count, Clifford dimension, sector multiplicity, a graded index) that could carry
   generation structure, or is generation simply not present in the current data?
2. **The sharpest honest verdict.** Is a mass-value map (a) constructible in
   principle from richer carrier decorations the program could add (say which), (b)
   constructible only with an external input (a Yukawa-like texture) that is not
   derived - so the ratio is an INPUT not a prediction, or (c) a category error at
   this generality (the finite structural theory fixes ratios of the FORM
   `lam-kappa : lam : lam+kappa` within one carrier, but has no cross-carrier /
   cross-generation scale)? Argue for one.
3. **What CAN be predicted (the honest positive).** Within a single carrier, the
   program DOES fix structural ratios (e.g. the three sector levels are in ratio
   `(lam-kappa) : lam : (lam+kappa)`). State the sharpest dimensionless RATIO the
   program can honestly claim as a prediction (with its kill condition), vs the
   neutrino ratio which it cannot. If a small kernel lemma captures a genuine
   within-carrier ratio prediction, deliver it (Mathlib-only, from `B`'s spectrum).
4. **No-go honesty.** If the neutrino ratio is NOT predictable, say so plainly and
   identify exactly the missing ingredient (the generation/scale structure), so the
   manuscript can state it as an honest boundary, not a pending calculation.

Output: the mass-value-map definition; the verdict (constructible / input-only /
category error) with argument; the sharpest honest within-carrier ratio prediction
(+ Lean if cheap); the precise missing ingredient for cross-generation ratios.
A correct sharp no-go (with the exact missing ingredient) is as valuable as a lemma.
