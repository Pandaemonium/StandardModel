import Mathlib

/-!
# Gate YM3 (scaffold): Wilson-weight kernel positivity - the RP engine, Route B

DRAFT SCAFFOLD authored by the 2026-07-03 overnight-run planning session.
Contains the definitional layer and statement skeletons for the
character-theory-FREE route ("Route B") to the reflection-positivity
engine, with documented handoff `s o r r y` markers. The overnight agents
(or Aristotle) own the proofs; the statements below were designed against
the freeze document (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`,
sections 5-6) and the oracle (`Scripts/oracle/validate_lgt_core.py` v0.2,
36/36; section [8] checks the kernel PSD claim numerically for Z2, Z16, S3,
section [9] pins the C-5 conventions).

## The mathematical point

RP-LINK (freeze section 6) needs exactly one nontrivial input: for a
finite group `G` and Wilson weight `w(h) = exp(beta * Re chi(h))` with
`beta >= 0` and `chi` the character of a UNITARY representation, the
kernel `K(g, h) = w(g * h^{-1})` on `G x G` is positive semidefinite.

Route A (freeze Theorem 3) proves this via the character expansion
(`w_hat_R >= 0` for all irreducible `R`, then finite Bochner). Route B
(this file) bypasses character theory entirely:

1. `M(g, h) := Re chi(g * h^{-1}) = Re tr(rho g * (rho h)^H)` is a REAL
   GRAM kernel (Hilbert-Schmidt inner products of the unitary matrices
   `rho g`), hence PSD. Unitarity is exactly where the
   `design:ym3-unitarity` hypothesis (option 1, explicit hypothesis)
   enters.
2. `K = exp(beta * M)` ENTRYWISE is a series of Hadamard powers of `M`
   with nonnegative coefficients `beta^k / k!`; each Hadamard power is
   PSD by the Schur product theorem (`Matrix.PosSemidef.hadamard`,
   VERIFIED present in Mathlib by the planning session), and PSD survives
   the limit through each fixed quadratic form (`tsum_nonneg`).

Route A is still wanted on its own (it is the statement the YM3 paper
narrates, it feeds the 2D exact solution's fusion lemma, and it gives the
Bochner CONVERSE); Route B exists so that RP-LINK does not wait for
character-theory bookkeeping.

## Conventions (normative, oracle-pinned)

* C-4: weight per plaquette `w(h) = exp(beta * Re chi_f(h))`, `beta >= 0`.
* Kernel argument order: `K(g, h) = w(g * h^{-1})` (freeze Corollary 3a).
  Note `reChar rho (g * h^{-1})` is symmetric in `g, h` once `rho` is
  unitary (`reChar_inv_of_unitary` below), so this matches the oracle's
  `w(g h^{-1})` fixture in section [8] either way; the LEMMA making that
  swap legitimate is part of this file, not an assumption.
* The representation is carried as an explicit function
  `rho : G -> Matrix (Fin n) (Fin n) C` with explicit multiplicativity /
  identity / unitarity hypotheses (design decision `design:ym3-unitarity`
  option 1: smallest Lean surface, physically free since Wilson actions
  use unitary representations by construction; see the freeze section 15
  for why Mathlib's `char_dual`/`char_conj` do NOT supply this).

Draft-trust status: SCAFFOLD - contains documented handoff `s o r r y`
markers (listed per-declaration below); `reChar_one` is proved. No
`n a t i v e _ d e c i d e`. Not wired into any trusted target.
Claim label: **finite identity** (once proved).
Prerequisites: Mathlib only. Successors: `TransferPositivity` (Cor 3b:
tensor kernels via `Matrix.PosSemidef.kronecker`, V^(1/2) conjugation via
`Matrix.PosSemidef.mul_mul_conjTranspose_same`, Gauss compression via
`Matrix.PosSemidef.submatrix`-style lemmas) and
`ReflectionPositivityLink` (RP-LINK proper).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonWeightPositivity

open scoped ComplexConjugate Matrix

variable {G : Type*} [Group G] [Fintype G]
variable {n : ℕ}

/-- Real part of the character of `rho` at `g`: `Re tr(rho g)`. For the
Wilson weight this is the `Re chi_f` of convention C-4. Carried on a bare
function `rho`; multiplicativity/unitarity enter as explicit hypotheses on
each theorem (design decision `design:ym3-unitarity`, option 1). -/
noncomputable def reChar (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  (Matrix.trace (rho g)).re

/-- The Wilson per-link kernel `K(g, h) = exp(beta * Re chi(g * h^{-1}))`
on `G x G` - the object whose positive semidefiniteness is the entire
engine of link-reflection positivity (freeze sections 5-6). -/
noncomputable def wilsonKernel (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : Matrix G G ℝ :=
  Matrix.of fun g h : G => Real.exp (beta * reChar rho (g * h⁻¹))

omit [Fintype G] in
/-- Sanity anchor (PROVED): at the identity the character real part is the
dimension `n`. Pins that `reChar` reads the trace, not something else. -/
theorem reChar_one (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hone : rho 1 = 1) : reChar rho 1 = n := by
  simp [reChar, hone, Matrix.trace_one]

/-
Proof handoff (`reChar_inv_of_unitary`):
Current goal: `reChar rho g⁻¹ = reChar rho g` under multiplicativity,
identity, and unitarity hypotheses.
Plan: `rho g⁻¹ = (rho g)⁻¹` (from `hmul`/`hone` via
`rho g * rho g⁻¹ = rho 1 = 1` and uniqueness of inverses in the matrix
monoid - or directly: `rho g⁻¹ * rho g = 1` and use it below without
naming the inverse). Unitarity gives `(rho g)ᴴ * rho g = 1`, so
`rho g⁻¹ = (rho g)ᴴ` by cancellation (`Matrix.inv_eq_left_inv` /
`Matrix.inv_eq_right_inv` circle of lemmas). Then
`trace ((rho g)ᴴ) = conj (trace (rho g))` (`Matrix.trace_conjTranspose`)
and `Complex.conj_re` closes it.
Likely missing lemma: none - all pieces named above exist; the work is
the cancellation bookkeeping.
-/
omit [Fintype G] in
/-- For a unitary representation, `Re chi(g^{-1}) = Re chi(g)`. This is
the lemma that (i) makes the Wilson weight inversion-symmetric (so the
freeze s4 fusion argument order is valid for it - see oracle v0.2
section [9] and PREP_NOTES section 1), and (ii) makes `wilsonKernel`
symmetric. It is exactly the `conj(chi(g)) = chi(g^{-1})` bridge that
Mathlib does not package (freeze section 15). -/
theorem reChar_inv_of_unitary (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) : reChar rho g⁻¹ = reChar rho g := by
  sorry

/-
Proof handoff (`reCharGram_posSemidef`):
Current goal: PSD of the real matrix `M(g, h) = Re chi(g * h^{-1})`.
Plan (the Gram computation): `rho (g * h⁻¹) = rho g * (rho h)ᴴ` (from
`hmul` + `reChar_inv_of_unitary`'s inner step `rho h⁻¹ = (rho h)ᴴ`). For
`x : G → ℝ`, the quadratic form is
`sum_{g,h} x g * x h * Re tr (rho g * (rho h)ᴴ)
  = Re tr (A * Aᴴ)` with `A = sum_g x g • rho g`
(bilinearity of trace; pull the real scalars through). `tr (A * Aᴴ) =
sum of |entries|^2 >= 0` - use `Matrix.trace_mul_conjTranspose` if
present, else expand with `Matrix.trace` + `Matrix.mul_apply` and
`Complex.mul_conj`. IsHermitian part: symmetry of the entries via
`reChar_inv_of_unitary` (real matrix, so `conjTranspose = transpose`).
Note `Matrix.PosSemidef` over ℝ tests against `x : G → ℝ` with
`star x = x` - no complex test vectors needed.
Potential issue with statement: none known; the oracle checks the S3
instance of the resulting kernel PSD directly (section [8]).
-/
-- `Matrix.PosSemidef` pulls its `Fintype` through `Finite`-derived
-- instances here, so the explicit `[Fintype G]` reads as unused to the
-- linter; it is semantically intended (finite gauge group), so we keep
-- it and silence the lint rather than weaken the statement's context.
set_option linter.unusedFintypeInType false in
/-- Route B step 1: the character real part is a real GRAM kernel, hence
`M(g, h) = Re chi(g * h^{-1})` is positive semidefinite for any unitary
representation. -/
theorem reCharGram_posSemidef (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (Matrix.of fun g h : G => reChar rho (g * h⁻¹)).PosSemidef := by
  sorry

/-
Proof handoff (`wilsonKernel_posSemidef`):
Current goal: PSD of the entrywise exponential of `beta * M`, `M` PSD.
Plan (Schur-product route): entrywise,
`exp (beta * M g h) = tsum (fun k => (beta * M g h)^k / k!)`
(`Real.exp_eq_tsum` or `NormedSpace.exp_eq_tsum_div`; check exact name).
For a fixed vector `x`, the quadratic form of the kernel is the tsum over
`k` of `(beta^k / k!) * (quadratic form of the k-th Hadamard power of M)`
- swapping the FINITE sums over `G x G` with the `tsum` is
`tsum_sum`/`Summable` bookkeeping (everything is absolutely convergent:
finitely many exponential series). Each Hadamard power is PSD by
induction with `Matrix.PosSemidef.hadamard` (VERIFIED present; base case
`k = 0` is the all-ones matrix = Gram of constant vectors, or
`Matrix.posSemidef_one`-adjacent - the all-ones matrix needs its own tiny
lemma, `fun _ _ => 1` PSD via the rank-one Gram of the constant-1
vector). Coefficients `beta^k / k!` nonneg from `hbeta`. Close with
`tsum_nonneg`. IsHermitian: entrywise from `M`'s symmetry.
Alternative if tsum bookkeeping resists: partial sums `S_N` are PSD
(finite nonneg combination), quadratic form of the limit = limit of
quadratic forms (finite-dimensional continuity), PSD closed under limits
- both routes are standard; pick whichever lands.
Likely missing lemma: "PSD of the all-ones matrix" and possibly
"entrywise-exp preserves PSD" as a standalone (worth PROVING as the
reusable statement `Matrix.PosSemidef.entrywiseExp`-style, since the
Measure-Problem track wants it too).
-/
set_option linter.unusedFintypeInType false in
/-- Route B conclusion (THE RP engine): for `beta >= 0` and a unitary
representation, the Wilson kernel `K(g, h) = exp(beta * Re chi(g h^{-1}))`
is positive semidefinite. Freeze Corollary 3a's PSD direction for Wilson
weights, without character theory. Oracle section [8] checks Z2, Z16, S3
instances at `beta` in {0.1, 0.5, 1, 2}. -/
theorem wilsonKernel_posSemidef (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (wilsonKernel beta rho).PosSemidef := by
  sorry

end WilsonWeightPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
