# Strategy + lemma job: is there ONE abstract "blindness theorem"?

Mathlib-only, abstract, adversarial. Five separate kernel-checked facts in a physics
program share a shape: a leading-order quantity is BLIND to the datum the physics
depends on, and the first non-blind order carries the observable. Determine whether
this is ONE theorem or five analogies. A negative answer is an equally valuable result.

The five instances:
(a) the SPECTRUM of a matrix is blind to a fixed observable's spectral WEIGHT (both
    extremes attainable at fixed spectrum);
(b) a GAUGE-INVARIANT observable can have zero overlap with the first excited state
    (invariance and overlap are logically independent);
(c) an UNSIGNED crossing count is blind to orientation, the signed count is not;
(d) a Wilson plaquette is blind to the CENTER of the gauge group;
(e) an order-0 trace functional is blind to uniform shifts `c . 1` (removed by
    traceless/unimodular projection).

Task:
1. Propose the sharpest common abstraction you can defend. A natural candidate: given
   a group `G` acting on a space of "configurations", and a functional `F` invariant
   under `G`, `F` cannot separate configurations in the same `G`-orbit; the physical
   observable must therefore be a function on the orbit space, and any quantity
   distinguishing same-orbit configurations is NOT `G`-invariant.
2. Prove that abstraction rigorously in Mathlib (it may be near-trivial - say so).
3. **THE REAL QUESTION**: for each of (a)-(e), determine whether it is an INSTANCE of
   the abstraction or NOT. Be adversarial. In particular check (b): is "invariance
   does not imply overlap" really an orbit-separation statement, or a different
   phenomenon? And (a): is "spectrum blind to weight" an orbit statement for the
   unitary conjugation action, or does it need more?
4. Deliver a verdict: ONE THEOREM (with the instantiations exhibited) or ANALOGIES
   ONLY (with the specific instances that fail to fit, and why).
Do not force a unification that is not there. A clean "these are three different
phenomena, and here is the split" is the better outcome if true.
No new axioms/native_decide; standard axioms; report axioms.
