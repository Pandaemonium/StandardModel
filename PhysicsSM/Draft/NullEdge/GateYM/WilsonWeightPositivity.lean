import Mathlib

/-!
# Gate YM3: Wilson-weight kernel positivity - the RP engine, Route B

Originally scaffolded by the 2026-07-03 overnight-run planning session as
a statement skeleton for the character-theory-FREE route ("Route B") to
the reflection-positivity engine; all three handoffs CLOSED in-repo
(2026-07-04, claude, T1) - no `s o r r y`, no `n a t i v e _ d e c i d e`,
axiom footprint `[propext, Classical.choice, Quot.sound]` throughout
(verified via `lean_verify` on every theorem below). Designed against the
freeze document (`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`,
sections 5-6) and the oracle (`Scripts/oracle/validate_lgt_core.py` v0.2,
36/36; section [8] checks the kernel PSD claim numerically for Z2, Z16, S3,
section [9] pins the C-5 conventions).

## The mathematical point

RP-LINK (freeze section 6) needs exactly one nontrivial input: for a
finite group `G` and Wilson weight `w(h) = exp(beta * Re chi(h))` with
`beta >= 0` and `chi` the character of a UNITARY representation, the
kernel `K(g, h) = w(g * h^{-1})` on `G x G` is positive semidefinite.
That input is `wilsonKernel_posSemidef` below.

Route A (freeze Theorem 3) proves this via the character expansion
(`w_hat_R >= 0` for all irreducible `R`, then finite Bochner). Route B
(this file) bypasses character theory entirely:

1. `M(g, h) := Re chi(g * h^{-1}) = Re tr(rho g * (rho h)^H)` is a REAL
   GRAM kernel (Hilbert-Schmidt inner products of the unitary matrices
   `rho g`), hence PSD (`reCharGram_posSemidef`). Unitarity is exactly
   where the `design:ym3-unitarity` hypothesis (option 1, explicit
   hypothesis) enters.
2. `K = exp(beta * M)` ENTRYWISE is a tsum of Hadamard powers of `M` with
   nonnegative coefficients `beta^k / k!`; each Hadamard power is PSD by
   the Schur product theorem, proved here as `hadamard_posSemidef` (NOT
   present in this repo's pinned Mathlib despite an earlier lean-explore
   hit claiming otherwise - see the handoff note above
   `hadamard_posSemidef` and PREP_NOTES.md's correction; derived from
   `Matrix.PosSemidef.kronecker` + `Matrix.PosSemidef.submatrix` along
   the diagonal embedding, both genuinely present), and PSD survives the
   tsum via `tsum_nonneg` (unconditional: every term is nonneg, so the
   tsum is regardless of convergence status - though convergence itself,
   `Real.summable_pow_div_factorial`, is what makes the defining equality
   to `Real.exp` hold in the first place).

Route A is still wanted on its own (it is the statement the YM3 paper
narrates, it feeds the 2D exact solution's fusion lemma, and it gives the
Bochner CONVERSE); Route B lands RP-LINK's PSD engine without waiting for
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

Draft-trust status: all declarations kernel-checked, zero `s o r r y`,
zero `n a t i v e _ d e c i d e`, axiom footprint
`[propext, Classical.choice, Quot.sound]`. Still draft (not wired into
any trusted target) pending the user's morning semantic review of the
statements against the freeze document. Claim label: **finite identity**.
Prerequisites: Mathlib only. Successors: `TransferPositivity` (Cor 3b:
tensor kernels via `Matrix.PosSemidef.kronecker`, V^(1/2) conjugation via
`Matrix.PosSemidef.mul_mul_conjTranspose_same`, Gauss compression via
`Matrix.PosSemidef.submatrix`-style lemmas) and
`ReflectionPositivityLink` (RP-LINK proper, consuming
`wilsonKernel_posSemidef` directly).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonWeightPositivity

open scoped ComplexConjugate Matrix ComplexOrder Kronecker Nat

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
/-- For a unitary representation, `rho g^{-1} = (rho g)^H`: the group
inverse and the conjugate transpose agree. Cancellation bookkeeping only
(`rho g * rho g⁻¹ = 1` from multiplicativity, `(rho g)ᴴ * rho g = 1` from
unitarity, then associativity identifies the two one-sided inverses). The
reusable step behind `reChar_inv_of_unitary` and the Gram identification
in `reCharGram_posSemidef`. -/
theorem rho_inv_eq_conjTranspose (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) : rho g⁻¹ = (rho g)ᴴ := by
  have h1 : rho g * rho g⁻¹ = 1 := by rw [← hmul, mul_inv_cancel, hone]
  have h2 : (rho g)ᴴ * rho g = 1 := hunit g
  calc rho g⁻¹ = 1 * rho g⁻¹ := by rw [one_mul]
  _ = ((rho g)ᴴ * rho g) * rho g⁻¹ := by rw [h2]
  _ = (rho g)ᴴ * (rho g * rho g⁻¹) := by rw [mul_assoc]
  _ = (rho g)ᴴ := by rw [h1, mul_one]

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
  simp [reChar, rho_inv_eq_conjTranspose rho hmul hone hunit g, Matrix.trace_conjTranspose]

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
  -- Flatten each `rho g : Matrix (Fin n) (Fin n) ℂ` into a row vector over
  -- `Fin n × Fin n`, so `A * Aᴴ` is exactly the complex Gram kernel
  -- `C g h := trace (rho g * (rho h)ᴴ)` (Mathlib's ready-made
  -- `posSemidef_self_mul_conjTranspose` supplies its complex PSD).
  set A : Matrix G (Fin n × Fin n) ℂ := Matrix.of fun g p => rho g p.1 p.2 with hA
  set C : Matrix G G ℂ := Matrix.of fun g h => Matrix.trace (rho g * (rho h)ᴴ) with hCdef
  have hAC : A * Aᴴ = C := by
    ext g h
    simp only [hA, hCdef, Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.of_apply,
      Matrix.trace, Matrix.diag_apply]
    rw [Fintype.sum_prod_type]
  have hCposSemi : C.PosSemidef := hAC ▸ Matrix.posSemidef_self_mul_conjTranspose A
  -- `M g h = reChar rho (g * h⁻¹) = (C g h).re` via `hmul` and
  -- `rho_inv_eq_conjTranspose`.
  have hM : (Matrix.of fun g h : G => reChar rho (g * h⁻¹))
      = Matrix.of fun g h : G => (C g h).re := by
    ext g h
    simp only [Matrix.of_apply, reChar, hCdef]
    rw [hmul g h⁻¹, rho_inv_eq_conjTranspose rho hmul hone hunit h]
  rw [hM]
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
  · -- Hermitian: real matrix, symmetric via `C`'s Hermitian-ness.
    have hCherm : C.IsHermitian := hCposSemi.isHermitian
    ext g h
    have hswap : C h g = starRingEnd ℂ (C g h) := by
      have hcong := congrArg (fun M : Matrix G G ℂ => M h g) hCherm
      simpa [Matrix.conjTranspose_apply] using hcong.symm
    simp [Matrix.conjTranspose_apply, hswap]
  · -- Quadratic form nonneg: specialize the complex quadratic form of `C`
    -- (PSD) to the real-cast test vector, then take real parts.
    intro x
    have hx := hCposSemi.re_dotProduct_nonneg (fun g => (x g : ℂ))
    have hexpand : star (fun g => (x g : ℂ)) ⬝ᵥ (C *ᵥ (fun g => (x g : ℂ)))
        = ∑ g : G, ∑ h : G, (x g : ℂ) * ((x h : ℂ) * C g h) := by
      simp only [dotProduct, Matrix.mulVec, Pi.star_apply, Finset.mul_sum,
        Complex.star_def, Complex.conj_ofReal]
      exact Finset.sum_congr rfl fun g _ => Finset.sum_congr rfl fun h _ => by ring
    have hre : RCLike.re (star (fun g => (x g : ℂ)) ⬝ᵥ (C *ᵥ (fun g => (x g : ℂ))))
        = ∑ g : G, ∑ h : G, x g * (x h * (C g h).re) := by
      show Complex.re _ = _
      rw [hexpand]
      simp only [Complex.re_sum, Complex.re_ofReal_mul]
    have hrhs : star x ⬝ᵥ ((Matrix.of fun g h : G => (C g h).re) *ᵥ x)
        = ∑ g : G, ∑ h : G, x g * (x h * (C g h).re) := by
      simp only [dotProduct, Matrix.mulVec, Matrix.of_apply, Pi.star_apply, star_trivial,
        Finset.mul_sum]
      exact Finset.sum_congr rfl fun g _ => Finset.sum_congr rfl fun h _ => by ring
    rw [hrhs, ← hre]
    exact hx

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
induction with `hadamard_posSemidef` (below - NOT `Matrix.PosSemidef.hadamard`:
the planning session's PREP_NOTES claimed that lemma "VERIFIED present" via
lean-explore, but a direct check of THIS repo's pinned Mathlib
(`mathlib4` commit `8f9d9cf`, 2026-02-16) found the Schur product theorem
absent under any name - lean-explore's index reaches a different/newer
snapshot than what this repo vendors; see PREP_NOTES.md's correction.
`hadamard_posSemidef` below derives it in two lines from what IS present:
`Matrix.PosSemidef.kronecker` + `Matrix.PosSemidef.submatrix` along the
diagonal embedding). Base case `k = 0` is the all-ones matrix, PSD via
`Matrix.posSemidef_vecMulVec_self_star` at the constant-1 vector.
Coefficients `beta^k / k!` nonneg from `hbeta`. Close with `tsum_nonneg`.
IsHermitian: entrywise from `M`'s symmetry.
Alternative if tsum bookkeeping resists: partial sums `S_N` are PSD
(finite nonneg combination), quadratic form of the limit = limit of
quadratic forms (finite-dimensional continuity), PSD closed under limits
- both routes are standard; pick whichever lands.
-/

omit [Fintype G] in
set_option linter.unusedFintypeInType false in
/-- Hadamard (entrywise) product of two PSD real matrices is PSD - the
Schur product theorem. NOT in this repo's pinned Mathlib (see the handoff
note above); derived here from `Matrix.PosSemidef.kronecker` (present) via
the identity `A ⊙ B = (A ⊗ₖ B).submatrix diag diag` for the diagonal
embedding `diag i := (i, i)`, and `Matrix.PosSemidef.submatrix` (present,
holds for any reindexing function, no injectivity needed). Genuinely
reusable - a candidate for upstreaming. -/
theorem hadamard_posSemidef {ι : Type*} [Fintype ι] {A B : Matrix ι ι ℝ}
    (hA : A.PosSemidef) (hB : B.PosSemidef) : (A ⊙ B).PosSemidef := by
  have hK : (A ⊗ₖ B).PosSemidef := hA.kronecker hB
  have hSub := hK.submatrix (fun i : ι => (i, i))
  have hEq : (A ⊗ₖ B).submatrix (fun i : ι => (i, i)) (fun i : ι => (i, i)) = A ⊙ B := by
    ext i j
    simp [Matrix.submatrix_apply, Matrix.kroneckerMap_apply, Matrix.hadamard_apply]
  rwa [hEq] at hSub

omit [Fintype G] in
set_option linter.unusedFintypeInType false in
/-- The `k`-th Hadamard (entrywise) power of a PSD real matrix is PSD, by
induction on `hadamard_posSemidef`; the `k = 0` base case is the all-ones
matrix, the outer product of the constant-`1` vector with itself. -/
theorem hadamard_pow_posSemidef {ι : Type*} [Fintype ι] {M : Matrix ι ι ℝ}
    (hM : M.PosSemidef) (k : ℕ) :
    (Matrix.of fun i j : ι => (M i j) ^ k).PosSemidef := by
  induction k with
  | zero =>
    have : (Matrix.of fun i j : ι => (M i j) ^ 0) = Matrix.vecMulVec (fun _ => (1:ℝ)) (fun _ => 1) := by
      ext i j
      simp [Matrix.vecMulVec_apply]
    rw [this]
    simpa using Matrix.posSemidef_vecMulVec_self_star (fun _ : ι => (1:ℝ))
  | succ k ih =>
    have hcast : (Matrix.of fun i j : ι => (M i j) ^ (k + 1))
        = (Matrix.of fun i j : ι => (M i j) ^ k) ⊙ M := by
      ext i j
      simp [Matrix.hadamard_apply, pow_succ]
    rw [hcast]
    exact hadamard_posSemidef ih hM

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
  have hMPSD : (Matrix.of fun g h : G => reChar rho (g * h⁻¹)).PosSemidef :=
    reCharGram_posSemidef rho hmul hone hunit
  set M : Matrix G G ℝ := Matrix.of fun g h : G => reChar rho (g * h⁻¹) with hMdef
  have hwilson : wilsonKernel beta rho = Matrix.of fun g h : G => Real.exp (beta * M g h) := rfl
  have hMsymm : ∀ g h : G, M h g = M g h := by
    intro g h
    show reChar rho (h * g⁻¹) = reChar rho (g * h⁻¹)
    have : h * g⁻¹ = (g * h⁻¹)⁻¹ := by group
    rw [this, reChar_inv_of_unitary rho hmul hone hunit]
  -- Entrywise exponential series: `exp(beta * M g h) = tsum` of Hadamard powers.
  have hexpseries : ∀ g h : G,
      Real.exp (beta * M g h) = ∑' k : ℕ, (beta ^ k / k !) * (M g h) ^ k := by
    intro g h
    rw [Real.exp_eq_exp_ℝ, NormedSpace.exp_eq_tsum_div]
    refine tsum_congr fun k => ?_
    rw [mul_pow]; ring
  rw [hwilson]
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
  · ext g h
    show star (Real.exp (beta * M h g)) = Real.exp (beta * M g h)
    rw [star_trivial, hMsymm g h]
  · intro x
    have hrow : ∀ p : G × G, Summable (fun k : ℕ => x p.1 * x p.2 * ((beta ^ k / k !) * (M p.1 p.2) ^ k)) := by
      intro p
      apply Summable.mul_left
      apply (Real.summable_pow_div_factorial (beta * M p.1 p.2)).congr
      intro k; rw [mul_pow]; ring
    have hquad : star x ⬝ᵥ ((Matrix.of fun g h : G => Real.exp (beta * M g h)) *ᵥ x)
        = ∑' k : ℕ, ∑ p : G × G, x p.1 * x p.2 * ((beta ^ k / k !) * (M p.1 p.2) ^ k) := by
      show (∑ g : G, star (x g) *
          ∑ h : G, (Matrix.of fun g h : G => Real.exp (beta * M g h)) g h * x h) = _
      simp only [star_trivial, Matrix.of_apply, Finset.mul_sum]
      rw [← Fintype.sum_prod_type (f := fun p : G × G => x p.1 * (Real.exp (beta * M p.1 p.2) * x p.2))]
      have hterm : ∀ p : G × G,
          x p.1 * (Real.exp (beta * M p.1 p.2) * x p.2)
          = ∑' k : ℕ, x p.1 * x p.2 * ((beta ^ k / k !) * (M p.1 p.2) ^ k) := by
        intro p
        rw [hexpseries, ← tsum_mul_right, ← tsum_mul_left]
        refine tsum_congr fun k => by ring
      simp only [hterm]
      exact (Summable.tsum_finsetSum (fun p _ => hrow p)).symm
    rw [hquad]
    refine tsum_nonneg fun k => ?_
    have hQk : 0 ≤ ∑ p : G × G, x p.1 * x p.2 * (M p.1 p.2) ^ k := by
      have hpsd := (hadamard_pow_posSemidef hMPSD k).dotProduct_mulVec_nonneg x
      have heq : star x ⬝ᵥ ((Matrix.of fun i j : G => (M i j) ^ k) *ᵥ x)
          = ∑ p : G × G, x p.1 * x p.2 * (M p.1 p.2) ^ k := by
        show (∑ g : G, star (x g) * ∑ h : G, (M g h) ^ k * x h) = _
        simp only [star_trivial, Finset.mul_sum]
        rw [← Fintype.sum_prod_type (f := fun p : G × G => x p.1 * ((M p.1 p.2) ^ k * x p.2))]
        refine Finset.sum_congr rfl fun p _ => by ring
      rwa [heq] at hpsd
    have hcoef : 0 ≤ beta ^ k / (k ! : ℝ) := by positivity
    calc (0:ℝ) ≤ (beta ^ k / k !) * ∑ p : G × G, x p.1 * x p.2 * (M p.1 p.2) ^ k :=
          mul_nonneg hcoef hQk
    _ = ∑ p : G × G, x p.1 * x p.2 * ((beta ^ k / k !) * (M p.1 p.2) ^ k) := by
          rw [Finset.mul_sum]; refine Finset.sum_congr rfl fun p _ => by ring

end WilsonWeightPositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
