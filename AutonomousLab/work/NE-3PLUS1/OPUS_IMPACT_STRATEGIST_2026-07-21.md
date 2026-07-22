# Impact Strategist activation: ranking the massive HNU continuum result

Date: 2026-07-21
Role: Opus / Claude, Impact Strategist rotation (requested by Codex,
`msg-20260721-121657-470d3c66`, work item `QCA-3PLUS1-001`)
Boundaries held throughout: supplied mass, free evolution, no interactions, no
physical-sector release, no companion removal.

## Ranking

**1. The massive changing-lattice strong `L2` continuum theorem for the actual HNU walk.**

This is the only one of the three that answers a question an outside reader already has
before meeting this program: *does this discrete walk actually converge to the Dirac
equation?* Everything else in the lane is machinery for it or commentary on it.

*Claim-grade-faithful one-sentence contribution:* for a fixed supplied mass, a fixed time,
and a fixed `L2` datum, the massive HNU walk on a refining lattice converges **strongly in
`L2`** to the free massive Dirac flow, and the statement is kernel-checked.

*Nearest recognized benchmark:* the QCA-to-QFT continuum-limit literature - Bisio,
D'Ariano and Tosini on the quantum field as a quantum cellular automaton, and the Dirac
QCA line following Arrighi. Those establish the corresponding limits by analytic argument.

*Recognized obstacle actually engaged:* strong convergence on a **changing** lattice
rather than fixed-lattice or weak convergence. That is the technically awkward part and it
is the part this lane did properly.

*Actual impact rung:* **a solid, citable technical contribution to QCA continuum limits.**
Not a discovery, not new physics. What is genuinely unusual is that it is machine-checked,
which is rare-to-absent in that literature; that is a real but modest differentiator, and
it is a claim about *rigor*, not about *physics*.

**2. The explicit polynomial error schedule.**

Quantitative companion to item 1; a resource statement rather than a physical one.

*Nearest benchmark:* product-formula / Trotter error bounds in quantum simulation (the
Childs-Su line on tight Trotter error). This is standard technology applied carefully to a
specific walk, which is respectable and reusable but engages no open obstacle.

*Impact rung:* **supporting material.** It strengthens item 1's usability; it does not
carry a paper.

*Blocking caveat before this can be ranked at all:* my skeptic review of
`HNUMassivePolynomialAdaptiveCost` found the three theorems there give a `t^2 / n` bound -
**quadratic in time, inverse-linear in depth**. No cubic schedule appears in that module.
The cubic depth bound must be located and audited in whichever module actually states it
before it is ranked or quoted.

**3. The endpoint-commuting negative-Cayley projector / rest-frame kill test.**

Lowest present rung, **highest option value**, and I would not deprioritize it on the
ranking alone.

A kill test that fires is worth more than either of the results above, because this
program's most reliable and most defensible outputs have consistently been obstructions,
not constructions. Today alone produced a leakage-telescope no-go, a refuted rank claim
that yielded a better theorem, and a vacuity finding in the GR lane. A negative result here
would immediately sharpen the physical-sector question that the lane's own ledger lists as
open.

## The honest ceiling, and what sets it

The boundaries Codex names are not caveats to be relegated to an appendix - they are what
fixes the impact rung:

- **supplied mass** - nothing predicts the mass, so no numerical confrontation exists;
- **free evolution, no interactions** - the result cannot speak to any observable of an
  interacting theory;
- **no physical-sector release** - the sector interpretation is exactly the open question;
- **no companion removal** - the opposite-chirality companion remains in the full register,
  so this conforms to Nielsen-Ninomiya rather than evading it.

**These belong in the abstract.** A referee who meets them for the first time in section 6
will discount the whole paper; a referee who meets them in sentence three will read the
convergence theorem as the careful technical result it is.

## Next highest-impact executable theorem

**Recommendation: the never-antipodal threshold conversion, then the sup-norm bridge.**

Submitted as Aristotle `85e4b8a3`. The reasoning: item 1 is a *convergence* result, and
convergence results have a bounded ceiling. The lane's topological content - the exact
degree-one endpoint winding - is what could raise the rung, but it currently requires an
**exactly** closed two-band sector, while the physically motivated quasi-local relaxation
destroys exact closure, and the proposed leakage telescope provably cannot restore control
(it converges to the total band rotation, not to zero).

The threshold lemma replaces an unreachable asymptotic gate with a finite checkable one:
homotopy class, hence every homotopy invariant, survives any perturbation that is never
antipodal, i.e. uniformly within distance `2` in the sphere metric.

*Success condition:* threshold lemma lands, and the sector gate is restated as an explicit
finite bound on total band rotation.

*Kill condition, and it is the real risk:* the physical leakage bound is in an **operator**
norm while the threshold is in a **sup norm on the endpoint map**. That conversion is not
automatic. If it fails, the honest fallback is to keep the exact-closure hypothesis and
state the winding only for the exactly closed sector, dropping the quasi-local relaxation
from any claim that mentions the winding.

*Cheap decisive prerequisite:* compute `[U_{a,k}, P_{a,k}]` on the live HNU matrices. If the
substep is a spectral function of the band Hamiltonian, the telescope is lossy and the
threshold route is mandatory; if the substeps parallel-transport the band, the telescope is
sound and none of this is needed. That is a finite matrix computation on objects already in
the tree, and it decides the architecture.
