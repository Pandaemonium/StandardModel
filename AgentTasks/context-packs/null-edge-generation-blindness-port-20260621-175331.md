# Aristotle semantic context pack

Generated: 2026-06-21T17:53:54
Query: `generation blindness port trusted PluckerMass finPairwisePluckerMass permutation invariance canonical spinorWedge`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Twistor_Plucker_Matching_Wrapper_2026-06-21.md` [Purpose]

Score: `0.855`

```text
## Purpose

This note records the narrow twistor/Plucker matching that should sit between
the trusted finite Plucker mass theorem and any later full twistor-incidence
formalization.

The point is not to formalize twistor space in full.  The point is to isolate
the finite-dimensional invariant-theory calculation that the null-edge program
needs:

```text
two-twistor spinor mass invariant
  =
squared Plucker wedge of the two visible null spinors.
```

Once this is separated, later work can add incidence data, projective twistor
quotients, conformal covariance, and convention bridges without disturbing the
finite mass theorem.
```

### 2. `PhysicsSM/Spinor/TwistorPluckerMass.lean`

Score: `0.853`

```text
import PhysicsSM.Spinor.PluckerMass

/-!
# Spinor.TwistorPluckerMass

Trusted finite twistor-chart wrappers for the Pluecker mass identities.

This module packages the spinor chart used by the null-edge causal graph
program:

```text
Z = (omega^A, pi_A')
```

Only the `pi` spinor is used in the finite mass identities.  The `omega`
field is retained so later incidence wrappers can extend the chart without
changing this mass-facing API.

Convention and claim boundary:
* dotted spinors use the same concrete carrier `Fin 2 -> ℂ` as visible
  spinors in `PhysicsSM.Spinor.PluckerMass`;
* `infinityTwistorPairing Z W` is defined as the Pluecker wedge of `Z.pi`
  and `W.pi`;
* determinant and trace-pairing normalizations are kept as separate explicit
  definitions;
* this is not a formalization of projective twistor space, twistor cohomology,
  the Penrose transform, or incidence geometry.

Sources and provenance:
* `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
* `AgentTasks/null-edge-overnight-synthesis-aristotle-2026-06-21.md`
* Promoted from the no-s o r r y draft modules
  `PhysicsSM.Draft.TwistorPluckerMass` and
  `PhysicsSM.Draft.NullEdgeOvernightSynthesisAristotle` after semantic review.

Status: trusted, no `s o r r y`.
-/
```

### 3. `AgentTasks/null-edge-generation-blindness-core-aristotle-2026-06-21.md` [Theorem targets]

Score: `0.852`

```text
## Theorem targets

```lean
complexAbsSq_spinorWedge_comm
finPairwisePluckerMass_perm
visiblePluckerMass_generationBlind
```
```

### 4. `PhysicsSM/Draft/TwistorPluckerMass.lean`

Score: `0.851`

```text
import PhysicsSM.Spinor.PluckerMass

/-!
# Draft.TwistorPluckerMass

A narrow twistor/Plucker matching wrapper for the null-edge causal graph
program.

This module is intentionally modest.  It does not formalize projective twistor
space, twistor cohomology, the Penrose transform, or the incidence equation.
It only packages the spinor chart used by two-twistor and multi-twistor mass
models:

```text
Z = (omega^A, pi_{A'})
```

and records that the spinor part of the infinity-twistor pairing,

```text
I(Z,W) = epsilon^{A'B'} pi_{A'} eta_{B'},
```

is exactly the two-spinor Plucker wedge.  Therefore its squared modulus is
the two-edge determinant mass already proved in
`PhysicsSM.Spinor.PluckerMass`.

Convention note:
- we model dotted spinors by the same concrete carrier `Fin 2 -> ℂ` used for
  visible spinors in `PhysicsSM.Spinor.PluckerMass`;
- `pi` is the spinor that contributes to visible momentum;
- `omega` is carried only as chart/incidence data and is not used in the
  finite mass theorem;
- possible factors of `2`, signs, or complex conjugations in the physics
  literature are outside this wrapper and should be handled by separate
  convention-bridge lemmas.

Status: draft-facing convention wrapper, no `s o r r y`.
-/
```

### 5. `AgentTasks/null-edge-spinor-geometry-aristotle-2026-06-21.md` [Why this target]

Score: `0.846`

```text
## Why this target

The finite Pluecker identity says determinant mass is the sum of squared
pairwise spinor wedges.  The next physics-facing layer is to prove that this
quantity is the projective spinor angular spread and is invariant under the
proper spinor frame changes.

The key upgrades are:

- the two-spinor Lagrange identity;
- covariance of the spinor wedge under `GL(2,C)`;
- invariance of the finite Pluecker mass under determinant-one spinor changes;
- chart-level matching with the two-twistor/massive spinor-helicity mass.
```

### 6. `AgentTasks/null-edge-plucker-bargmann-phase-core-aristotle-2026-06-21.md` [Why this matters]

Score: `0.845`

```text
## Why this matters

The trusted Plucker mass theorem keeps the squared modulus of the wedge.  The
Dirac/operator critique says that squared invariants lose first-order data.
This target formalizes the nearby complex phase algebra: the Lagrange identity
relates Plucker spread to Hermitian overlap, while the Bargmann triple trace is
the finite Pancharatnam/Berry phase carrier for three spinor directions.
```

### 7. `PhysicsSM/Draft/NullEdgePluckerGeneralAristotle.lean` [fin_bundle_plucker_mass_identity]

Score: `0.844`

```text
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  have hentry : ∀ a b : Fin 2, finBundleMomentum psi a b
      = ∑ i, psi i a * (starRingEnd ℂ) (psi i b) := by
    intro a b
    simp [finBundleMomentum, rankOneHermitian, Matrix.sum_apply, Matrix.vecMulVec]
  set f : Fin n → Fin n → ℂ := fun i j =>
    (psi i 0 * (starRingEnd ℂ) (psi i 0)) * (psi j 1 * (starRingEnd ℂ) (psi j 1))
      - (psi i 0 * (starRingEnd ℂ) (psi i 1))
        * (psi j 1 * (starRingEnd ℂ) (psi j 0)) with hf
  have hdet : (finBundleMomentum psi).det = ∑ i, ∑ j, f i j := by
    rw [Matrix.det_fin_two, hentry, hentry, hentry, hentry]
    rw [Finset.sum_mul_sum, Finset.sum_mul_sum, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro i _
    rw [← Finset.sum_sub_distrib]
  rw [hdet, sum_pairs_offdiag f (by intro i; simp [hf]; ring)]
  rw [finPairwisePluckerMass]
  apply Finset.sum_congr rfl
  intro p _
  simp only [hf, complexAbsSq, spinorWedge, map_sub, map_mul]
  ring

/-! ## Equality and collinearity criteria -/

/-- All members of a spinor family have zero pairwise Pluecker wedge. -/
```

### 8. `PhysicsSM/Spinor/PluckerMass.lean` [is]

Score: `0.842`

```text
import Mathlib

/-!
# Spinor.PluckerMass

Trusted finite Pluecker-mass identities for visible complex null spinors.

This module packages the algebraic keystone of the null-edge causal graph
program in a non-draft namespace.  A visible null edge is represented by a
complex two-spinor `psi : Fin 2 -> ℂ` and the rank-one Hermitian momentum
matrix `psi psi^dagger`.  The determinant of a finite sum of such null
momenta is exactly the total pairwise squared Pluecker spread

```text
det(sum_i psi_i psi_i^dagger)
  =
sum_{i<j} |psi_i wedge psi_j|^2.
```

The theorem is purely finite-dimensional linear algebra.  It does not assert
a continuum limit, a quantum-measure construction, or a twistor incidence
```

## Scoped paper hits

### 1. Massive twistor particle with spin generated by Souriau-Wess-Zumino term and its quantization

Score: `0.746`
Zotero key: `arxiv:1403.4127`
arXiv: `1403.4127`
DOI: `10.1016/j.physletb.2014.04.059`
URL: http://arxiv.org/abs/1403.4127

Abstract:

Two-twistor action for a massive spinning particle with Souriau-Wess-Zumino spin term; includes spin-dependent twistor shift modifying standard Penrose incidence relations.

### 2. Gauged twistor formulation of a massive spinning particle in four dimensions

Score: `0.743`
Zotero key: `arxiv:1512.07740`
arXiv: `1512.07740`
DOI: `10.1103/PhysRevD.93.045016`
URL: http://arxiv.org/abs/1512.07740

Abstract:

Gauged generalized Shirafuji action for a massive spinning particle with local U(1) and SU(2) symmetries, constraints, and Penrose transform to massive spinor fields.

### 3. Spin on a 4D Feynman Checkerboard

Score: `0.718`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
