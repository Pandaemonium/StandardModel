# Gate F2 (Koide) pre-registration, first falsification result, and rescope

Status: pre-registration + executed cheapest-falsification, 2026-07-03
(claude). Provenance: Round 7 parameter audit
(`Sources/nrqg-round7-parameters.md`, section 3) proposed Gate F2; Round 8
(`Sources/nrqg-round8-adversarial-synthesis.md`) mandated the scheme clause
(Attack 1.6) and the gate lifecycle "propose -> pilot (cheapest falsification
first) -> verify -> publish or file the null". This document executes that
lifecycle for F2's first round. Claim grades per the Round 8 calculus.

**Same-day update:** F2.1's family, criticality notion, success and kill
criteria, and forbidden-edit rules are now FROZEN (per Codex review) in
`AgentTasks/nerd-gate-f2.1-preregistration-freeze-2026-07-03.md`. That freeze
supersedes the informal sketch in section 4/5 below as the authoritative F2.1
specification; no F2.1 computation has been run as of the freeze.

## 1. The datum (unchanged from Round 7)

Koide (1981): `Q = (m_e + m_mu + m_tau) / (sqrt(m_e) + sqrt(m_mu) +
sqrt(m_tau))^2 = 2/3`, satisfied by POLE masses at relative deviation
`9.2e-6`; as a `m_tau` prediction it sits at `+0.9 sigma` today and predated
precision data (discovered externally, 1981). Geometric content: the vector
`(sqrt(m_e), sqrt(m_mu), sqrt(m_tau))` makes exactly 45 degrees with the
democratic axis `(1,1,1)`; equivalently, of the three Jordan invariants of
the sqrt-mass matrix, two are locked (`(tr X)^2 = (3/2) tr(X^2)`) and the
cubic norm is the residual dial. *(Verification debt: the original Koide
citation and the running-mass literature must be source-verified before any
paper use; per Round 8 no unverified import reaches a paper.)*

## 2. Pre-registered canonical construction

Real form first. `X` is the positive-semidefinite element of `Herm_3(R)`
with spectrum `(sqrt(m_e), sqrt(m_mu), sqrt(m_tau))`; the flavor structure
lives in the relative orientation of `X`'s eigenframe and the democratic
projector `d = (1/3) * (all-ones matrix)` (rank-one, `d^2 = d`, `tr d = 1`).
The Koide condition is the fully invariant lock

```text
K(X) :  (tr X)^2 = (3/2) * tr(X^2),
```

i.e. the 45-degree cone between `X` and the identity direction in the trace
inner product. The exceptional continuation (octonionic `J_3(O)`, Round 4
R4-2) inherits the same invariant formulation via its cubic-norm/trace
polynomials.

## 3. Mandatory scheme clause (Round 8, Attack 1.6)

The empirical lock holds for POLE masses. Any F2 mechanism must (i) declare
its scale `Lambda_F` and scheme (MS-bar assumed) where the orbit condition is
imposed, and (ii) identify the mechanism by which the condition survives at
(or emerges for) pole masses - the only respectable candidate class being
infrared fixed points of the mass-matrix RG flow. A mechanism without a
scheme clause is pre-declared INADMISSIBLE as an F2 success. (It is known in
the literature that the running-mass `Q` at conventional scales deviates from
`2/3` by more than the pole-mass deviation; exact figures are part of the
verification-debt sprint and are deliberately not quoted here.)

## 4. F2.0 - the naive formulation - and its executed falsification

**F2.0 (as proposed in Round 7, strongest natural reading):** the physical
Koide configuration is a critical point of some nontrivial
conjugation-invariant potential `V` on `Herm_3` (equivalently on `J_3`),
possibly subject to invariant constraints (Lagrange form), for an open set of
couplings.

**Cheapest falsification, pre-registered and EXECUTED today.** Analysis
(claude, 2026-07-03): a conjugation-invariant `V` is a function
`F(s_1, s_2, s_3)` of the elementary symmetric functions of the eigenvalues;
invariance makes orbit directions flat, so criticality reduces to the
eigenvalue directions, where the chain rule gives the gradient components

```text
dV/dx = f_1 + f_2 (y + z) + f_3 (y z)    (and cyclically),
```

with `f_i = dF/ds_i` the SAME constants across the three equations (Lagrange
multipliers against invariant constraints only shift the constants). The
algebraic core - any solution with `(f_1, f_2, f_3) != 0` has a repeated
eigenvalue; equivalently three DISTINCT eigenvalues force
`f_1 = f_2 = f_3 = 0` - is now a kernel-checked Lean theorem:

```text
PhysicsSM/Draft/NullEdge/GateF2/InvariantPotentialNogo.lean
  distinct_spectrum_kills_invariant_gradient
  invariant_critical_point_has_repeated_eigenvalue
```

(built 2026-07-03, 8026 jobs green, axioms
`[propext, Classical.choice, Quot.sound]`; the calculus reduction from matrix
space to eigenvalue coordinates is standard and recorded in prose in the
module docstring - the Lean content is the algebraic core.)

Since `m_e, m_mu, m_tau` are pairwise distinct, the physical Koide point has
three distinct eigenvalues. **Therefore F2.0 is DEAD: the kill-condition
fired, by proof, on the gate's first day.** Filed as a null per the Round 8
lifecycle - a deliverable, not a failure. Round 4's R4-2 (the exceptional
continuation) takes the corresponding wound: whatever selects the Koide orbit,
it is NOT criticality of an invariant potential.

Scope of the kill, stated precisely (grade M for the Lean core, T|H for the
calculus reduction):

- KILLED: "Koide point = critical point (full or invariant-Lagrange-
  constrained) of a nontrivial invariant potential," over `Herm_3(R)`,
  `Herm_3(C)`, or `J_3(O)` alike (same invariant/spectral structure).
- NOT killed (and now the only admissible F2 readings):
  1. **F2.1 (spurion class):** potentials invariant only under the stabilizer
     of the democratic direction `d` - the class containing terms
     `tr(X d)`, `tr(X^2 d)`, `tr(X d X d)`, mixed with the invariants. This
     is where the "democratic texture" flavor literature implicitly lives
     (citations = verification debt).
  2. **F2.0' (directional/orbit extremality):** `V` restricted to the
     constraint sphere, extremal in the Koide ANGLE direction only (not a
     full critical point). Weaker and less natural; admissible only with a
     pre-registered statement of which directions and why.

## 5. Next pre-registration step (F2.1 freeze - not yet frozen)

Before any F2.1 computation is run, a follow-up freeze must fix: the exact
minimal coupling family (proposal: `V = a tr(X^2) + b (tr X)^2 + c N(X) +
e_1 tr(X d) tr(X) + e_2 tr(X d)^2 + e_3 tr(X^2 d)`), the criticality notion
(full criticality in eigenvalue + orientation variables), and the success
criterion (the 45-degree lock critical for an OPEN coupling set, with the
angle a genuine output). Kill-condition: if the frozen family yields the lock
only on measure-zero coupling sets, F2.1 dies and Koide returns to the
coincidence bin. The Brannen phase observation (`delta ~ 2/9`) remains
quarantined in the recorded-coincidence file and is not part of any F2
formulation.

## 6. Disposition

- No Aristotle job was needed for the falsification (self-proved in-repo,
  small). F2.1 is NOT submitted anywhere: its family is not yet frozen, and
  premature submission would violate the pre-registration discipline.
- This document plus the Lean module constitute the F2 round-1 record:
  proposed, piloted, verified, null filed - one day.
- Program effects: Round 7 scorecard row "Koide Q = 2/3 | C | 45-degree
  orbit in J_3 - Gate F2" should be annotated "F2.0 killed by proof
  2026-07-03; F2.1/F2.0' rescope pending freeze"; R4-2 confidence
  unchanged-to-slightly-down (the pincer and Jordan-cap arguments are
  untouched; the potential-selection mechanism is constrained).
