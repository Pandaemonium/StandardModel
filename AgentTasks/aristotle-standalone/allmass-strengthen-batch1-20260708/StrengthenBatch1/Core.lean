/-
# All-mass strengthening batch 1: instantiate the keystone on a positive sector

Proof job (Aristotle). Three targets, ordered; T1 and T2 are the critical path
(they turn the mass-budget's quadratic functional into a genuine positive mass
*in a concrete finite model*), T5 is an independent cheap win.

The keystone `sector_ground_mass` is **already proved** and provided below
(clean-room from an earlier Aristotle job). Your job is to add the three
theorems T1, T2, T5 below, kernel-clean (no `s o r r y`). State them precisely;
these docstrings fix the intended mathematics.

## T1 - Sector-compression lemma  (clean Mathlib; unblocks T2)

For a finite-dimensional inner product space `E`, a submodule `P` (with its
induced inner product), and an ordinary-self-adjoint / symmetric `S : E ->L[C] E`,
the compression `T_P := (orthogonalProjection P) . S |_P : P ->L[C] P` is
symmetric on `P`, and its Rayleigh quotient agrees with that of `S` on `P \ {0}`.
Consequently `sector_ground_mass` applies to `(P, T_P)`: if the form of `S` is
`>= c > 0` on `P`, the least eigenvalue of the compression is a genuine positive
mass. Deliver the compression lemma (symmetry + Rayleigh-quotient agreement),
and a corollary chaining it into `sector_ground_mass`.

## T2 - A two-edge carrier with a genuine J-positive positive-mass sector

This is the linchpin. A numeric oracle
(`Scripts/oracle/probe_multiedge_positive_sector.py`) has VALIDATED the
following construction; formalize it and prove the positivity.

Clifford factor `C^4 = C^2 (x) C^2`, Hermitian Cl(4) gammas
  g1 = sx(x)I, g2 = sy(x)I, g3 = sz(x)sx, g4 = sz(x)sy   (anticommuting, square I).
  omega := g1*g2  (= i sz (x) I)      closure bivector
  b     := g1     (= sx (x) I)        closure grading
  Js    := i*g3*g4 (= -I (x) sz)      Krein fundamental symmetry (Js^2 = I)
Color factor `C^3`; aperture strength `lam` (take `lam = 2`), curvature
  K := (E01 - E10) on C^3 (skew-Hermitian).
Blocks on `C^12 = C^4 (x) C^3`:
  Q_A := I4 (x) (lam . I3)     (aperture; Clifford-scalar)
  Q_C := omega (x) K           (closure)
  J   := Js (x) I3             (Krein metric; J = Jᴴ, J^2 = 1)
Krein forms `H_A := J * Q_A`, `H_C := J * Q_C` are Hermitian.

Facts the probe verified (targets):
  (a) `b` anticommutes `omega` and commutes `Js`  (impossible in a 2-dim factor);
      hence `(b(x)I) H_A (b(x)I) = +H_A` (aperture FIXED) and
      `(b(x)I) H_C (b(x)I) = -H_C` (closure BALANCED).
  (b) Let `P` be the `J`-positive spectral subspace (`dim = 6`; `J` has inertia
      `(6,6)`). On `P`, the compressed total form `Pᴴ (H_A + H_C) P` is
      **positive-definite** (`Matrix.PosDef`) for `lam = 2`.
  (c) Chaining (b) with T1 + `sector_ground_mass` (via the J-inner product on
      `P`, under which `Q_A + Q_C` is ordinary-self-adjoint): the least
      eigenvalue of the compressed `D^#D`-form on `P` is a genuine positive
      squared mass. Deliver this end-to-end conclusion for the explicit witness.

Suggested route for (b): exhibit `P` as an explicit `12x6` isometry (columns =
`Js`-eigenvectors for eigenvalue `+1`), form the `6x6` Hermitian Gram
`M := Pᴴ (H_A + H_C) P`, and prove `M.PosDef` by `Matrix.PosDef` via positive
leading principal minors (Sylvester) with `norm_num`/`decide` on rational
(Gaussian-rational) entries, or by `M = Nᴴ N + (c) I` decomposition. Entries are
Gaussian rationals, so this is a finite exact computation.

## T5 - Gauge covariance of the four blocks  (independent; cheap)

Conjugating all transports by a unitary `u` that commutes with the Clifford
coefficients, the chirality `Gamma`, and the turn field `phi`, sends the
soldered operator `D` to `u D u⁻¹` and each Krein block to its `u`-conjugate:
`Q_X(u nabla u⁻¹) = u Q_X(nabla) u⁻¹` for `X in {A,C,T,#}`. Hence block
expectations in `u`-covariant states are gauge-invariant. State and prove a
clean version (it suffices to prove it for the assembled square: the master
identity is preserved under `nabla_e ↦ u nabla_e u⁻¹` for such `u`). This
removes the standard referee objection "is your decomposition gauge-invariant?".

## Provenance

Targets + validated numeric construction: all-mass overnight run 2026-07-08,
`STRENGTHENING_ROADMAP.md` (T1/T2/T5), `T2_MULTIEDGE_ESCAPE_FINDING.md`.
`sector_ground_mass`: earlier Aristotle job 4bf9899f, re-checked under the
pinned toolchain. [orig]/[import].
-/

import Mathlib

namespace StrengthenBatch1

open ContinuousLinearMap

/-- **The keystone (already proved; provided for T1/T2 to build on).** On a
finite-dimensional sector with a definite inner product, a symmetric `T` whose
real quadratic form is bounded below by `c > 0` has its Rayleigh-quotient
infimum attained as a genuine eigenvalue that is `> 0`. -/
theorem sector_ground_mass
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] [Nontrivial H]
    (T : H →L[ℂ] H) (hT : (T : H →ₗ[ℂ] H).IsSymmetric)
    (c : ℝ) (hc : 0 < c)
    (hpos : ∀ x : H, c * ‖x‖ ^ 2 ≤ T.reApplyInnerSelf x) :
    Module.End.HasEigenvalue (T : H →ₗ[ℂ] H)
        (((⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ)) : ℂ)
      ∧ 0 < (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
  haveI : Nonempty { x : H // x ≠ 0 } := by
    obtain ⟨y, hy⟩ := exists_ne (0 : H); exact ⟨⟨y, hy⟩⟩
  have hbound : c ≤ (⨅ x : {x : H // x ≠ 0}, T.rayleighQuotient x : ℝ) := by
    apply le_ciInf
    intro x
    have hx2 : (0 : ℝ) < ‖(x : H)‖ ^ 2 := by
      have := norm_ne_zero_iff.mpr x.2; positivity
    rw [ContinuousLinearMap.rayleighQuotient, le_div_iff₀ hx2]
    simpa [mul_comm] using hpos x
  exact ⟨hT.hasEigenvalue_iInf_of_finiteDimensional, lt_of_lt_of_le hc hbound⟩

/- T1, T2, T5 to be added and proved here (see the module docstring). -/

end StrengthenBatch1
