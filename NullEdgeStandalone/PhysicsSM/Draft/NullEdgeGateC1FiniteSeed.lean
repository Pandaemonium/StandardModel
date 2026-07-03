import Mathlib

/-!
# Null-edge Gate C1 finite seed — draft promotion package (from C145)

This module is the project-facing integration package for the **C145 kernel-only
branch × flavor × qutrit finite seed**.  It is deliberately structured so that the
trusted *finite-algebra* content is fully separated from the *draft physical
interpretation*, in line with the round style requirement
("keep finite algebra, analytic hypotheses, and physics imports separate").

## What is imported from C145

The C145 report describes the overlap construction on a finite native seed:

```text
H_ne   = Gamma_K (D_ne + W_branch - m0 R)      -- Hermitian kernel
T_br   = sign(H_ne)                            -- branch transfer, an involution
D_ov,ne = rho (1 + Gamma_K T_br)               -- overlap (null-edge) Dirac operator
```

The *only* mathematically load-bearing facts behind the C145 "kernel-only exact
symbolic" claim are purely algebraic:

* the chirality `Gamma_K` is an involution (`Gamma_K^2 = 1`);
* the branch transfer `T_br = sign(H_ne)` is an involution (`T_br^2 = 1`)
  — this is exactly what `sign` of a gapped Hermitian operator delivers, and is
  the place where the analytic "no propagator-zero / inverse-gap" hypothesis
  (C153) is discharged on the finite seed by exhibiting `T_br` symbolically;
* from these two involution facts alone, the overlap operator
  `D_ov,ne = rho (1 + Gamma_K T_br)` satisfies the **Ginsparg–Wilson relation**.

Everything else in the C145 narrative (that `W_branch` is a null-edge
flavored/species-splitting Wilson term, that the seed models a Standard-Model
internal sector, etc.) is *interpretation* and is confined to the `Draft`
section below with **no proof obligations**, so that promoting this module does
**not** accidentally promote any physics claim.

## Module layout

1. `Trusted` — unconditional ring identities (Ginsparg–Wilson, ρ-scaled form,
   involution closure under Kronecker product).  Safe for a trusted hierarchy.
2. `Seed` — the concrete exact-over-`ℚ` `branch ⊗ qutrit` instantiation; the
   involution properties are checked symbolically and the Ginsparg–Wilson
   relation is *inherited* from the trusted layer.
3. `Draft` — the physical dictionary, as definitions/docstrings only.

## Provenance

* C145: kernel-only branch × flavor × qutrit finite seed (source of the seed).
* C150: `W_branch` read as null-edge flavored/species-splitting Wilson term.
* C153: no propagator-zero ghost rule (motivates the involution `T_br^2 = 1`).
* Standard overlap/Ginsparg–Wilson algebra (Neuberger; Ginsparg–Wilson).
-/

open Matrix Kronecker
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeGateC1FiniteSeed

/-! ## Part 1 — Trusted finite algebra

These are unconditional identities in an arbitrary (noncommutative) ring.  They
carry no physics content and are suitable for a trusted module. -/

namespace Trusted

variable {R : Type*} [Ring R]

/-- The overlap operator at `ρ = 1`: `overlapOp g T = 1 + g * T`.

In the physics reading `g = Gamma_K` (chirality) and `T = T_br` (branch
transfer); see the `Draft` section. -/
def overlapOp (g T : R) : R := 1 + g * T

/-- **Ginsparg–Wilson relation (ρ = 1).**  For any two involutions `g` and `T`
in a ring (`g² = 1`, `T² = 1`), the overlap operator `D = 1 + g T` satisfies
`g D + D g = D g D`.

This is the algebraic heart of the C145 finite seed: lattice chiral symmetry of
the overlap operator follows from the two involution facts *alone*, with no
further analytic input. -/
theorem ginsparg_wilson (g T : R) (hg : g * g = 1) (hT : T * T = 1) :
    g * overlapOp g T + overlapOp g T * g
      = overlapOp g T * g * overlapOp g T := by
  unfold overlapOp
  have lhs : g * (1 + g * T) + (1 + g * T) * g = 2 • g + T + g * T * g := by
    have : g * (1 + g * T) + (1 + g * T) * g = g + g * g * T + g + g * T * g := by
      noncomm_ring
    rw [this, hg]; noncomm_ring
  have rhs : (1 + g * T) * g * (1 + g * T) = 2 • g + T + g * T * g := by
    have : (1 + g * T) * g * (1 + g * T)
        = g + g * g * T + g * T * g + g * T * (g * g) * T := by noncomm_ring
    rw [this, hg]
    have : g * T * (1 : R) * T = g * (T * T) := by noncomm_ring
    rw [this, hT]; noncomm_ring
  rw [lhs, rhs]

end Trusted

section TrustedScaled

variable {k R : Type*} [CommRing k] [Ring R] [Algebra k R]

/-- **Ginsparg–Wilson relation, ρ-scaled form.**  With the physical overlap
operator `D = ρ (1 + g T)` (`ρ` a central scalar), the involution facts
`g² = 1`, `T² = 1` give `ρ (g D + D g) = D g D`, i.e. the standard
`g D + D g = (1/ρ) D g D` once `ρ` is invertible. -/
theorem ginsparg_wilson_scaled
    (rho : k) (g T : R) (hg : g * g = 1) (hT : T * T = 1) :
    rho • (g * (rho • (1 + g * T)) + (rho • (1 + g * T)) * g)
      = (rho • (1 + g * T)) * g * (rho • (1 + g * T)) := by
  have base : g * (1 + g * T) + (1 + g * T) * g
      = (1 + g * T) * g * (1 + g * T) := by
    have lhs : g * (1 + g * T) + (1 + g * T) * g = 2 • g + T + g * T * g := by
      have : g * (1 + g * T) + (1 + g * T) * g = g + g * g * T + g + g * T * g := by
        noncomm_ring
      rw [this, hg]; noncomm_ring
    have rhs : (1 + g * T) * g * (1 + g * T) = 2 • g + T + g * T * g := by
      have : (1 + g * T) * g * (1 + g * T)
          = g + g * g * T + g * T * g + g * T * (g * g) * T := by noncomm_ring
      rw [this, hg]
      have : g * T * (1 : R) * T = g * (T * T) := by noncomm_ring
      rw [this, hT]; noncomm_ring
    rw [lhs, rhs]
  simp only [mul_smul_comm, smul_mul_assoc, smul_smul]
  rw [← smul_add, base, smul_smul]

end TrustedScaled

namespace Trusted

/-- Involution property is closed under Kronecker product: if `A² = 1` and
`B² = 1` then `(A ⊗ₖ B)² = 1`.  This is what lets the `branch × flavor × qutrit`
seed be assembled from factor-wise involutions while keeping everything exact
and symbolic. -/
theorem kronecker_involution {α m n : Type*} [CommRing α]
    [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]
    (A : Matrix m m α) (B : Matrix n n α) (hA : A * A = 1) (hB : B * B = 1) :
    (A ⊗ₖ B) * (A ⊗ₖ B) = 1 := by
  rw [← Matrix.mul_kronecker_mul, hA, hB, Matrix.one_kronecker_one]

end Trusted

/-! ## Part 2 — Concrete finite seed (`branch ⊗ qutrit`, exact over `ℚ`)

A minimal faithful instantiation of the C145 seed.  The branch factor carries
the chirality grading and the (null-edge) branch transfer; the qutrit factor
rides along as a spectator identity.  All entries are exact rationals, so the
seed is genuinely "kernel-only / exact symbolic".  The involution facts are
checked by symbolic computation, and the Ginsparg–Wilson relation is inherited
from `Trusted.ginsparg_wilson`. -/

namespace Seed

/-- Branch index (the null-edge two-valued grading). -/
abbrev Branch := Fin 2
/-- Qutrit index (the three-dimensional internal/spectator factor). -/
abbrev Qutrit := Fin 3

/-- Chirality on the branch factor (`σ₃`). -/
def branchChirality : Matrix Branch Branch ℚ := !![1, 0; 0, -1]

/-- Null-edge branch transfer on the branch factor: `sign(H_ne)` evaluated on the
seed, here the off-diagonal involution `σ₁`. -/
def branchTransfer : Matrix Branch Branch ℚ := !![0, 1; 1, 0]

theorem branchChirality_involution :
    branchChirality * branchChirality = 1 := by
  unfold branchChirality
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ]

theorem branchTransfer_involution :
    branchTransfer * branchTransfer = 1 := by
  unfold branchTransfer
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ]

/-- Chirality `Γ_K` on the full `branch ⊗ qutrit` seed. -/
def Gamma_K : Matrix (Branch × Qutrit) (Branch × Qutrit) ℚ :=
  branchChirality ⊗ₖ (1 : Matrix Qutrit Qutrit ℚ)

/-- Branch transfer `T_br` on the full `branch ⊗ qutrit` seed. -/
def T_br : Matrix (Branch × Qutrit) (Branch × Qutrit) ℚ :=
  branchTransfer ⊗ₖ (1 : Matrix Qutrit Qutrit ℚ)

theorem Gamma_K_involution : Gamma_K * Gamma_K = 1 :=
  Trusted.kronecker_involution _ _ branchChirality_involution (one_mul _)

theorem T_br_involution : T_br * T_br = 1 :=
  Trusted.kronecker_involution _ _ branchTransfer_involution (one_mul _)

/-- The overlap (null-edge) Dirac operator on the seed, at `ρ = 1`:
`D_ov,ne = 1 + Γ_K T_br`. -/
def D_ov_ne : Matrix (Branch × Qutrit) (Branch × Qutrit) ℚ :=
  Trusted.overlapOp Gamma_K T_br

/-- **Ginsparg–Wilson on the concrete seed.**  The lattice chiral-symmetry
relation `Γ_K D + D Γ_K = D Γ_K D` holds for the explicit `branch ⊗ qutrit`
overlap operator, inherited from the trusted algebra layer. -/
theorem seed_ginsparg_wilson :
    Gamma_K * D_ov_ne + D_ov_ne * Gamma_K = D_ov_ne * Gamma_K * D_ov_ne :=
  Trusted.ginsparg_wilson Gamma_K T_br Gamma_K_involution T_br_involution

end Seed

/-! ## Part 3 — Draft physical interpretation (NOT trusted)

The declarations below record the *physical dictionary* only.  They introduce no
new proof obligations and assert no physics: promoting this section does not
promote any physics claim.  Each item is a reading of the trusted/seed objects
above.

* `Seed.Gamma_K`   ↦  the chirality operator `Gamma_K`.
* `Seed.T_br`      ↦  the branch transfer `T_br = sign(H_ne)`; the involution
  `Seed.T_br_involution` is the finite-seed discharge of the C153 "no
  propagator-zero / inverse-gap" requirement (`sign` of a gapped Hermitian
  kernel squares to `1`).
* `Seed.D_ov_ne`   ↦  the null-edge overlap Dirac operator `D_ov,ne`
  (here `ρ = 1`; the general `ρ` is `Trusted.ginsparg_wilson_scaled`).
* `Seed.seed_ginsparg_wilson` ↦  exact lattice chiral symmetry of the seed.

The interpretive C145/C150 claim — that `W_branch` is a null-edge
flavored/species-splitting Wilson term and that this seed models a
Standard-Model internal sector — remains a **draft conjecture** and is *not*
formalized here. -/

namespace Draft

/-- Draft label: the finite seed realizes lattice chiral symmetry exactly.
This is a re-export of the proven `Seed.seed_ginsparg_wilson` under a
physics-facing name; no new content. -/
theorem null_edge_seed_has_exact_chiral_symmetry :
    Seed.Gamma_K * Seed.D_ov_ne + Seed.D_ov_ne * Seed.Gamma_K
      = Seed.D_ov_ne * Seed.Gamma_K * Seed.D_ov_ne :=
  Seed.seed_ginsparg_wilson

end Draft

end PhysicsSM.Draft.NullEdgeGateC1FiniteSeed
