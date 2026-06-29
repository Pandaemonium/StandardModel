import Mathlib

/-!
# Null-Edge Overlap — Gate C1 Hermitian kernel API (kernel-validity)

This module is a **kernel-validity** draft for the Null-Edge Overlap route of the
StandardModel Gate C1 program.  It proves *only* the Hermiticity /
`gamma5`-Hermiticity statements that follow from the explicitly stated
structural assumptions on the operators.  It is **not** the full Gate C1 release:
no spectral, locality, or chiral-anomaly content is claimed here.

## Setting

We work entirely inside an abstract real `*`-algebra `A`:

* `[Ring A] [StarRing A]` — an associative unital ring with an involution `star`
  (`star (a * b) = star b * star a`, `star (a + b) = star a + star b`,
  `star (star a) = a`).  This is the abstract stand-in for "operators with a
  Hermitian adjoint `†`".
* `[Algebra ℝ A] [StarModule ℝ A]` — lets us form the *real scalar identity*
  `m • (1 : A)` and gives `star (m • 1) = m • 1` (a real multiple of the
  identity is automatically self-adjoint and central).

With this, `star` plays the role of `†`, `star x = x` means "Hermitian /
self-adjoint", and `star x = -x` means "anti-Hermitian / anti-self-adjoint".

## Physical dictionary (target 3)

| abstract symbol            | null-edge object                                  |
| -------------------------- | ------------------------------------------------- |
| `g`                        | `gamma5`                                           |
| `D`                        | `D_ne^0 = Σ_A B_A (T_A - T_A^†)/(2a)`              |
| `E`                        | `W_ne + M_br`                                      |
| `W` , `Mbr`                | `W_ne` , `M_br`                                    |
| `m • (1 : A)`              | `(rho/a) • I`                                      |
| `g * (D + E - m • 1)`      | `H_ne = gamma5 (D_ne^0 + W_ne + M_br - rho/a)`     |

The physics-facing restatement is `H_ne_isHermitian` at the bottom.

## Exact assumptions used (no hidden hypotheses)

* `hg  : star g = g`            — `gamma5` is Hermitian.
* `hg2 : g * g = 1`             — `gamma5` is involutive.
* `hD  : star D = -D`           — `D_ne^0` is anti-Hermitian.
* `hDodd : g * D = -(D * g)`    — `{D_ne^0, gamma5} = 0` (`g`-odd).
* `hE  : star E = E`            — `E` is Hermitian.
* `hEeven : g * E = E * g`      — `[E, gamma5] = 0` (`g`-even).

In the split version, `E = W + Mbr` with `W`, `Mbr` each Hermitian and `g`-even.

**Remark on `hg2`.**  The bare self-adjointness of `H = g (D + E - m·1)` does not
actually require `g * g = 1` (see `H_isSelfAdjoint`).  The involutivity `hg2` is
genuinely needed only for the *conjugation* identities
`star D = g D g` and `star A_ne = g A_ne g` (`D_conj_eq`, `A_ne_conj_eq`).  We
nonetheless keep `hg2` as a hypothesis everywhere it is requested, because the
user listed `gamma5` involutive among the standing assumptions.

## Notes / warnings (target 5)

* **Scalar field.**  We use `ℝ` only to express the *real* scalar `rho/a`.  The
  result is field-agnostic: nothing forces `ℂ`.  If you instantiate `A` with
  complex matrices `Matrix (Fin n) (Fin n) ℂ`, take `Algebra ℝ (Matrix …)` and
  everything below applies verbatim.  Using `ℝ` keeps `star (m • 1) = m • 1`
  immediate (`star_trivial` on `ℝ`); with a complex scalar you would instead
  need the scalar to be *real* (`conj c = c`).
* **Matrices vs. Hilbert space.**  The abstract `StarRing` statement is the
  cheapest and most reusable.  Finite-dimensional matrices
  (`Matrix (Fin n) (Fin n) ℂ` with `Matrix.instStarRing`) instantiate it for
  free and are easier than `ContinuousLinearMap`/unbounded Hilbert-space
  operators (where `†` is only densely defined and `star` is unavailable for
  unbounded operators).  Recommendation: keep the kernel theorem abstract,
  instantiate to matrices when a concrete lattice model is plugged in.
* **Mathlib star-algebra API.**  It is exactly the right tool here and need not
  be avoided.  Only `star_mul`, `star_add`, `star_sub`, `star_neg`, `star_one`,
  `star_smul`, `star_trivial` are used.

## Lean import / module dependencies (target 4)

`import Mathlib` suffices.  The minimal relevant pieces are:

* `Mathlib.Algebra.Star.Basic`     — `StarRing`, `star_mul`, `star_add`, …
* `Mathlib.Algebra.Star.SelfAdjoint` — `IsSelfAdjoint` (optional, idiomatic).
* `Mathlib.Algebra.Algebra.Basic`  — `Algebra ℝ A`, `smul`/`algebraMap`.
* `Mathlib.Algebra.Star.Module`    — `StarModule`, `star_smul`.
* (For a matrix instantiation) `Mathlib.LinearAlgebra.Matrix.Hermitian` /
  `Mathlib.Data.Matrix.Basic`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace NullEdgeOverlapKernel

variable {A : Type*} [Ring A] [StarRing A] [Algebra ℝ A] [StarModule ℝ A]

/-- A real multiple of the identity is self-adjoint. -/
theorem star_real_smul_one (m : ℝ) : star (m • (1 : A)) = m • (1 : A) := by
  rw [ star_smul, star_one, star_trivial ]

omit [StarRing A] [StarModule ℝ A] in
/-- A real multiple of the identity is central: it commutes with `g`. -/
theorem real_smul_one_comm (m : ℝ) (g : A) :
    g * (m • (1 : A)) = (m • (1 : A)) * g := by
  rw [ mul_smul_comm, smul_mul_assoc, mul_one, one_mul ]

omit [StarRing A] [Algebra ℝ A] [StarModule ℝ A] in
/-- **`g`-odd ⇒ conjugation negates.**  If `g` is involutive and `D`
anticommutes with `g`, then `g D g = -D`. -/
theorem gammaConj_odd (g D : A) (hg2 : g * g = 1) (hDodd : g * D = -(D * g)) :
    g * D * g = -D := by
  rw [ hDodd, neg_mul, mul_assoc, hg2, mul_one ]

omit [StarRing A] [Algebra ℝ A] [StarModule ℝ A] in
/-- **`g`-even ⇒ conjugation fixes.**  If `g` is involutive and `E` commutes
with `g`, then `g E g = E`. -/
theorem gammaConj_even (g E : A) (hg2 : g * g = 1) (hEeven : g * E = E * g) :
    g * E * g = E := by
  rw [ hEeven, mul_assoc, hg2, mul_one ]

omit [Algebra ℝ A] [StarModule ℝ A] in
/-- **Intermediate result `(D_ne^0)^† = -D_ne^0` and `= gamma5 D_ne^0 gamma5`.**
For a `g`-odd, anti-self-adjoint `D` (with `g` involutive),
`star D = g * D * g`.  Both sides equal `-D`. -/
theorem D_conj_eq (g D : A) (hg2 : g * g = 1) (hD : star D = -D)
    (hDodd : g * D = -(D * g)) :
    star D = g * D * g := by
  grind +suggestions

/-- **`A_ne^† = gamma5 A_ne gamma5`.**  For `A = D + E - m·1` with `D` `g`-odd
anti-self-adjoint, `E` `g`-even self-adjoint, `m` real, and `g` involutive, the
adjoint of `A` equals its `g`-conjugate.  (Note: this conjugation identity does
not need `gamma5` Hermitian; only `g * g = 1` plus the parity/adjoint data.) -/
theorem A_ne_conj_eq (g D E : A) (m : ℝ)
    (hg2 : g * g = 1)
    (hD : star D = -D) (hDodd : g * D = -(D * g))
    (hE : star E = E) (hEeven : g * E = E * g) :
    star (D + E - m • (1 : A)) = g * (D + E - m • (1 : A)) * g := by
  simp_all +decide [ mul_add, add_mul, mul_sub, sub_mul, mul_assoc ]

/-- **Abstract kernel theorem (target 1).**
If `g` is self-adjoint and involutive, `D` is `g`-odd and anti-self-adjoint,
`E` is `g`-even and self-adjoint, and `m` is a real scalar, then
`H = g (D + E - m·1)` is self-adjoint. -/
theorem H_isSelfAdjoint (g D E : A) (m : ℝ)
    (hg : star g = g) (hg2 : g * g = 1)
    (hD : star D = -D) (hDodd : g * D = -(D * g))
    (hE : star E = E) (hEeven : g * E = E * g) :
    star (g * (D + E - m • (1 : A))) = g * (D + E - m • (1 : A)) := by
  rw [ star_mul, A_ne_conj_eq g D E m hg2 hD hDodd hE hEeven, hg, mul_assoc, hg2, mul_one ]

/-- **Split version (target 2): `E = W + M_br`.**
If `g` is self-adjoint and involutive, `D` is `g`-odd anti-self-adjoint, and
both `W` and `Mbr` are `g`-even self-adjoint, then
`H = g (D + W + Mbr - m·1)` is self-adjoint. -/
theorem H_isSelfAdjoint_split (g D W Mbr : A) (m : ℝ)
    (hg : star g = g) (hg2 : g * g = 1)
    (hD : star D = -D) (hDodd : g * D = -(D * g))
    (hW : star W = W) (hWeven : g * W = W * g)
    (hM : star Mbr = Mbr) (hMeven : g * Mbr = Mbr * g) :
    star (g * (D + W + Mbr - m • (1 : A))) = g * (D + W + Mbr - m • (1 : A)) := by
  -- Apply the theorem H_isSelfAdjoint with E := W + Mbr.
  have := H_isSelfAdjoint g D (W + Mbr) m hg hg2 hD hDodd (by
  rw [ star_add, hW, hM ]) (by
  rw [ mul_add, add_mul, hWeven, hMeven ]);
  simp_all +decide [ add_assoc ]

/-- **Physics-facing restatement (target 3): `H_ne` is Hermitian.**

`H_ne = gamma5 (D_ne^0 + W_ne + M_br - (rho/a)·I)` is self-adjoint, given:
`gamma5` Hermitian (`hg5_sa`) and involutive (`hg5_inv`); `D_ne^0` anti-Hermitian
(`hDne0_anti`) and `{D_ne^0, gamma5} = 0` (`hDne0_odd`); `W_ne` Hermitian
(`hWne_sa`) with `[W_ne, gamma5] = 0` (`hWne_even`); `M_br` Hermitian (`hMbr_sa`)
with `[M_br, gamma5] = 0` (`hMbr_even`). -/
theorem H_ne_isHermitian (g5 Dne0 Wne Mbr : A) (rhoa : ℝ)
    (hg5_sa : star g5 = g5) (hg5_inv : g5 * g5 = 1)
    (hDne0_anti : star Dne0 = -Dne0) (hDne0_odd : g5 * Dne0 = -(Dne0 * g5))
    (hWne_sa : star Wne = Wne) (hWne_even : g5 * Wne = Wne * g5)
    (hMbr_sa : star Mbr = Mbr) (hMbr_even : g5 * Mbr = Mbr * g5) :
    star (g5 * (Dne0 + Wne + Mbr - rhoa • (1 : A)))
      = g5 * (Dne0 + Wne + Mbr - rhoa • (1 : A)) :=
  H_isSelfAdjoint_split g5 Dne0 Wne Mbr rhoa hg5_sa hg5_inv hDne0_anti hDne0_odd
    hWne_sa hWne_even hMbr_sa hMbr_even

section GinspargWilsonAlgebra

variable {B : Type*} [Ring B]

/--
The purely algebraic normalized Ginsparg-Wilson identity.

In the intended application, `epsilon` is `sign(H_ne)` after the Hermitian
kernel has been proved gapped. This theorem does not construct `epsilon`; it
only records the algebra that follows from two involution hypotheses.
-/
theorem normalized_ginspargWilson_of_involutions
    {gamma epsilon : B}
    (hgamma_sq : gamma * gamma = 1)
    (hepsilon_sq : epsilon * epsilon = 1) :
    (1 + gamma * epsilon) * gamma
        + gamma * (1 + gamma * epsilon)
      =
    (1 + gamma * epsilon) * gamma * (1 + gamma * epsilon) := by
  have hge : gamma * (gamma * epsilon) = epsilon := by
    rw [← mul_assoc, hgamma_sq, one_mul]
  calc
    (1 + gamma * epsilon) * gamma + gamma * (1 + gamma * epsilon)
        = 2 • gamma + (gamma * (epsilon * gamma) + gamma * (gamma * epsilon)) := by
          noncomm_ring
    _ = 2 • gamma + (gamma * (epsilon * gamma) + epsilon) := by
          rw [hge]
    _ = gamma + (gamma * (epsilon * gamma) + (epsilon + gamma)) := by
          abel
    _ = gamma + (gamma * (epsilon * gamma) +
          (gamma * (gamma * epsilon) + gamma * (epsilon * (gamma * (gamma * epsilon))))) := by
          rw [hge, hepsilon_sq, mul_one]
    _ = (1 + gamma * epsilon) * gamma * (1 + gamma * epsilon) := by
          symm
          noncomm_ring

end GinspargWilsonAlgebra

end NullEdgeOverlapKernel
end GateC1
end NullEdge
end Draft
end PhysicsSM
