# Lemma job: the inertial/gravitational equivalence finite core (gate A6)

Type: self-contained Mathlib-only theorem. AFPL gate A6 (the one untouched mass
gate). Tests whether the SAME finite response operator that produces a mass gap
also produces a matching inertial response and a channel-blind gravitational
source, kept as a SEPARATE grade from continuum GR (which is out of scope).

## Target (finite equivalence core)

Model a finite physical sector by a Hermitian "mass response" operator
`M : Matrix (Fin m) (Fin m) ℂ`, `M ≥ 0`, with gap observable = its smallest
positive eigenvalue. Define:
- the inertial response as the quadratic form `I(v) = ⟨v, M v⟩` (energy cost of
  the state `v`);
- a channel-blind gravitational source as the trace pairing
  `S(A) = Tr(M A)` against a symmetric probe `A` (blind to which eigen-channel
  carries the mass: it depends only on `M` through the trace).

Prove:
1. **Positivity / inertia.** `I(v) ≥ 0` for all `v`, and `I(v) = 0` iff `v` is in
   the kernel of `M` (massless directions have no inertia).
2. **Equivalence identity.** `I(v) = S(v v^†)` (the inertial response equals the
   gravitational source evaluated on the state's rank-one projector) - a finite
   equivalence-principle identity: the same `M` supplies both.
3. **Channel-blindness.** If `M` and `M'` have the same eigenvalues (unitarily
   equivalent), the total gravitational source `Tr M = Tr M'` agrees even though
   the eigen-channels differ - the source sees only the spectrum, not the
   channel decomposition. Contrast with `gap_does_not_fix_pole`: the total
   source is channel-blind, but the physical POLE is not - state this distinction
   precisely.

Continuum GR, the coframe variation, and phenomenology are OUT OF SCOPE and named
as separate grades.

## Constraints

Mathlib only; standard axioms; no new `axiom`/`opaque`/`unsafe`/`native_decide`.
Report axioms. Success: the three facts proved, with the equivalence identity #2
the headline; name the continuum-GR bridge as the separate grade.
