/-
Provenance: Aristotle job 2cc1968c (fable-24h-census), harvested
2026-07-11 ~16:55 PDT; summary in
`AgentTasks/aristotle-results/census-2cc1968c/.../ARISTOTLE_SUMMARY.md`.
Statements integrated UNCHANGED (verified by diff; proofs term-mode via
census_all). Imports were already repo-form; no rewire.
TRUST: kernel only.  Every certificate fact (products `M*N = 0`, minor
determinants, and control determinants) is discharged by ordinary
`simp`/`norm_num` elaboration -- the finite index sums are unfolded and the
determinants are evaluated by Laplace expansion (`Matrix.det_succ_row_zero`),
so no `native_decide` is used.  Consequently the four public theorems
(`census_rank_minus`, `census_rank_plus`, `census_multiplicity`,
`census_blind_same_multiplicity`) depend only on `propext`, `Classical.choice`,
and `Quot.sound` (verified via `#print axioms`).  Classification dispatch in
`census_all` is plain `decide`; helpers are ordinary proofs.
Oracle: census_oracle.py (fresh 2026-07-11), law 2/4/0 for
singleton/block/control fields, certificates embedded in docstring.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart

/-!
# The complete-walk multiplicity census for the 16-field family

Target: replace the paper's last "exact-arithmetic run record, not yet
machine-checked" caveat with kernel-grade (or documented compiled-evaluator)
theorems.  For the palindromic register walk `Wof b = S * C(b) * S`
(8x8 rational, `V8 = Fin 4 x Fin 2`) over the 16 sign fields
`b : Fin 4 -> Bool`, the exact eigenspace multiplicity law is:

* `wallCount b = 2` and `isSingleton b`  (8 fields):
    `dim ker (Wof b - 1) = 2` and `dim ker (Wof b + 1) = 2`;
* `wallCount b = 2` and `isBlock b`      (4 fields, `++--` rotations):
    `dim ker (Wof b - 1) = 4` and `dim ker (Wof b + 1) = 4`;
* `wallCount b = 0` or `4`               (4 fields):
    both kernels are trivial (`det (Wof b -+ 1) /= 0`).

Equivalently by rank-nullity: `(Wof b - 1).rank = 6 / 4 / 8` in the three
classes, and the same for `Wof b + 1`.

All statements are exact rational linear algebra on fixed 8x8 matrices.
An exact sympy oracle (run 2026-07-11, transcribing the module's own
`shiftQ/coinQ/walkQ/cW/sField` definitions) verified the law and produced
the complete certificate table below: for every field and both signs,
explicit integer kernel vectors (lower bound) and an invertible square
submatrix with its exact determinant (rank lower bound), which together
with rank-nullity pin the dimension EXACTLY:
  dim ker >= k (k independent kernel vectors)  and  rank >= 8-k (nonzero
  (8-k)-minor)  and  rank + dim ker = 8   ==>   dim ker = k, rank = 8-k.

## Proof implementation (this file)

The one-helper strategy is realised by `rank_null_cert` (singleton/block
classes) and `rank_null_full` (controls).  Concretely, for a fixed rational
`8x8` matrix `M` over `V8`:

* `rank_null_cert` takes an `8 x k` kernel-vector matrix `N` with
  `(reindex e8 e8 M) * N = 0` (columns are kernel vectors), a `k`-minor of `N`
  with nonzero determinant (so `N.rank = k`), and an `(8-k)`-minor of `M` with
  nonzero determinant (so `M.rank >= 8-k`); the lemma
  `rank_add_rank_le_card_of_mul_eq_zero` gives `M.rank <= 8-k`, and
  rank-nullity closes both `M.rank = 8-k` and `dim ker = k`.
* `rank_null_full` handles the controls from `det M /= 0` (so `M` is a unit,
  `rank = 8`, `dim ker = 0`).

`e8 : V8 ≃ Fin 8` is `finProdFinEquiv`, mapping `(site, comp) ↦ 2*site+comp`,
matching the certificate's index convention.  Every fixture fact
(`M*N = 0`, minor determinants nonzero, control determinants nonzero) is a
finite rational computation dispatched by ordinary `simp`/`norm_num`
elaboration (kernel-checkable, no `native_decide`).  The 16-field case split
(`census_all`) is done by
`cases` on the four booleans `b 0 .. b 3`, and the classification-`if`
in each branch is reduced by `decide` over `wallCount / isSingleton`.

## KILL CONDITION

If any single census entry does not match the certificate table, do NOT
weaken or generalize the statement: prove the corrected single entry,
name the mismatched field, and stop.  The table is exact arithmetic, so a
mismatch means a transcription error that must surface, not be repaired
silently.  This is *enforced by the build*: each per-field lemma proves the
concrete rank/nullity from the certificate kernel data via `simp`/`norm_num`,
and `census_all` then checks by `decide` that these concrete numbers equal
the `if wallCount/isSingleton` classification value; a genuine mismatch would
make one of those two steps fail rather than silently succeed.

## Certificate table (exact oracle output; index = site*2 + component)

Fields as `b 0, b 1, b 2, b 3` with `t = true`, `f = false`.  "minus" =
`Wof b - 1`, "plus" = `Wof b + 1`.  Minor rows/cols are 0-based indices
into `V8` ordered `(0,0),(0,1),(1,0),(1,1),(2,0),(2,1),(3,0),(3,1)`.

FULL CERTIFICATE TABLE (verbatim oracle output; 'minor6' label just
means 'invertible minor'; for blocks it is 4x4 as the row/col lists show):

  -- field b = tttt (walls 0)
     W - 1: det = 1296/625  (nonzero => no modes)
     W + 1: det = 1296/625  (nonzero => no modes)

  -- field b = tttf (walls 2)
     W - 1: dim ker = 2
        ker vec: [5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, 5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625
     W + 1: dim ker = 2
        ker vec: [-5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, -5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625

  -- field b = ttft (walls 2)
     W - 1: dim ker = 2
        ker vec: [0, 0, 5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625
     W + 1: dim ker = 2
        ker vec: [0, 0, -5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625

  -- field b = ttff (walls 2)
     W - 1: dim ker = 4
        ker vec: [5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, 5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, 5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625
     W + 1: dim ker = 4
        ker vec: [-5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, -5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, -5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625

  -- field b = tftt (walls 2)
     W - 1: dim ker = 2
        ker vec: [5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, 5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625
     W + 1: dim ker = 2
        ker vec: [-5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, -5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625

  -- field b = tftf (walls 4)
     W - 1: det = 1296/625  (nonzero => no modes)
     W + 1: det = 1296/625  (nonzero => no modes)

  -- field b = tfft (walls 2)
     W - 1: dim ker = 4
        ker vec: [5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, 5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, 5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625
     W + 1: dim ker = 4
        ker vec: [-5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, -5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, -5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625

  -- field b = tfff (walls 2)
     W - 1: dim ker = 2
        ker vec: [0, 0, 5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625
     W + 1: dim ker = 2
        ker vec: [0, 0, -5, -3, 0, 0, 4, 0]
        ker vec: [0, 0, -3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625

  -- field b = fttt (walls 2)
     W - 1: dim ker = 2
        ker vec: [0, 0, 5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625
     W + 1: dim ker = 2
        ker vec: [0, 0, -5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625

  -- field b = fttf (walls 2)
     W - 1: dim ker = 4
        ker vec: [5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, 5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, 5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625
     W + 1: dim ker = 4
        ker vec: [-5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, -5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, -5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625

  -- field b = ftft (walls 4)
     W - 1: det = 1296/625  (nonzero => no modes)
     W + 1: det = 1296/625  (nonzero => no modes)

  -- field b = ftff (walls 2)
     W - 1: dim ker = 2
        ker vec: [5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, 5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625
     W + 1: dim ker = 2
        ker vec: [-5, 3, 0, 0, 4, 0, 0, 0]
        ker vec: [3, -5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625

  -- field b = fftt (walls 2)
     W - 1: dim ker = 4
        ker vec: [5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, 5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, 5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625
     W + 1: dim ker = 4
        ker vec: [-5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, -5, 0, 0, 0, 4, 0, 0]
        ker vec: [0, 0, -5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3] cols=[0, 1, 2, 3] det=256/625

  -- field b = fftf (walls 2)
     W - 1: dim ker = 2
        ker vec: [0, 0, 5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, 5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625
     W + 1: dim ker = 2
        ker vec: [0, 0, -5, 3, 0, 0, 4, 0]
        ker vec: [0, 0, 3, -5, 0, 0, 0, 4]
        minor6 rows=[0, 1, 2, 3, 4, 5] cols=[0, 1, 2, 3, 4, 5] det=576/625

  -- field b = ffft (walls 2)
     W - 1: dim ker = 2
        ker vec: [5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, 5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625
     W + 1: dim ker = 2
        ker vec: [-5, -3, 0, 0, 4, 0, 0, 0]
        ker vec: [-3, -5, 0, 0, 0, 4, 0, 0]
        minor6 rows=[0, 1, 2, 3, 6, 7] cols=[0, 1, 2, 3, 6, 7] det=576/625

  -- field b = ffff (walls 0)
     W - 1: det = 1296/625  (nonzero => no modes)
     W + 1: det = 1296/625  (nonzero => no modes)
-/

namespace PhysicsSM.Draft.NullEdge.CensusMultiplicity

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
open PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

/-! ## Computable fixtures -/

/-- The register reindexing `V8 = Fin 4 × Fin 2 ≃ Fin 8`, `(site, comp) ↦ 2*site+comp`
(matching the certificate's `index = site*2 + component` convention). -/
def e8 : V8 ≃ Fin 8 := (finProdFinEquiv : Fin 4 × Fin 2 ≃ Fin (4 * 2))

/-- Assemble a `Fin 8 × Fin 2` kernel matrix from two column vectors. -/
def col2 (v1 v2 : Fin 8 → ℚ) : Matrix (Fin 8) (Fin 2) ℚ :=
  Matrix.of fun i j => ![v1, v2] j i

/-- Assemble a `Fin 8 × Fin 4` kernel matrix from four column vectors. -/
def col4 (v1 v2 v3 v4 : Fin 8 → ℚ) : Matrix (Fin 8) (Fin 4) ℚ :=
  Matrix.of fun i j => ![v1, v2, v3, v4] j i

/-! ### Kernel-checkable evaluation tactics

All certificate facts below are discharged by ordinary `simp`/`norm_num`
elaboration (no `native_decide`), so the resulting proofs depend only on
`propext`, `Classical.choice`, and `Quot.sound`.

* `walk_reduce` reduces an entrywise matrix identity (`M * N = 0`, or a minor
  equal to an explicit `!![...]` literal) over the concrete walk matrices to
  rational arithmetic by unfolding `Wof = shiftQ * coinQ * shiftQ`, expanding
  the finite index sums, and finishing with `norm_num`.
* `det_reduce` evaluates a determinant of a concrete rational matrix by
  Laplace expansion (`Matrix.det_succ_row_zero`) followed by `norm_num`. -/

/-- Reduce an entrywise identity over the concrete walk matrices to rational
arithmetic. -/
macro "walk_reduce" : tactic =>
  `(tactic|
    (ext i j <;>
     fin_cases i <;> fin_cases j <;>
       (simp [Matrix.mul_apply, Matrix.submatrix_apply, Wof, walkQ, coinQ, shiftQ, sField, cW,
           e8, col2, col4, Fin.sum_univ_eight, Fintype.sum_prod_type, Fin.sum_univ_two,
           finProdFinEquiv, Fin.divNat, Fin.modNat] <;>
        norm_num [Matrix.one_apply, Fin.ext_iff, Prod.ext_iff])))

/-- Evaluate a determinant of a concrete rational matrix by Laplace expansion. -/
macro "det_reduce" : tactic =>
  `(tactic|
    (simp (maxSteps := 8000000) [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, col2, col4, Matrix.submatrix_apply, Matrix.of_apply] <;> norm_num))

/-! ## The two census helpers (exact rational linear algebra) -/

/-- A nonzero `p × p` minor forces `rank ≥ p`: the submatrix is a unit
(nonzero determinant over a field), hence has rank `p`, and submatrix rank
never exceeds the full rank. -/
theorem le_rank_of_minor {ι κ : Type*} [Fintype ι] [Fintype κ] [DecidableEq ι]
    [DecidableEq κ] {p : ℕ} (A : Matrix ι κ ℚ) (r : Fin p → ι) (c : Fin p → κ)
    (h : (A.submatrix r c).det ≠ 0) : p ≤ A.rank := by
  have hu : IsUnit (A.submatrix r c) :=
    (Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.2 h)
  have hr : (A.submatrix r c).rank = p := by
    rw [Matrix.rank_of_isUnit _ hu, Fintype.card_fin]
  have hle : (A.submatrix r c).rank ≤ A.rank := by
    rw [← Matrix.eRank_toNat_eq_rank, ← Matrix.eRank_toNat_eq_rank]
    exact ENat.toNat_le_toNat (Matrix.eRank_submatrix_le A r c)
      (ne_top_of_le_ne_top (by simp) (Matrix.eRank_le_card_width A))
  omega

/-- **The census certificate helper.**  Given kernel-vector columns `N`
(with `(reindex e8 e8 M) * N = 0`), a nonzero `k`-minor of `N` (so `N.rank = k`),
and a nonzero `(8-k)`-minor of `M` (so `M.rank ≥ 8-k`), the exact rank and
kernel dimension of `M` are pinned to `8-k = q` and `k`. -/
theorem rank_null_cert (M : Matrix V8 V8 ℚ) {k q : ℕ} (hkq : k + q = 8)
    (N : Matrix (Fin 8) (Fin k) ℚ) (rN : Fin k → Fin 8)
    (rM cM : Fin q → Fin 8)
    (hMN : (M.reindex e8 e8) * N = 0)
    (hN : (N.submatrix rN id).det ≠ 0)
    (hM : ((M.reindex e8 e8).submatrix rM cM).det ≠ 0) :
    M.rank = q ∧ Module.finrank ℚ (LinearMap.ker M.mulVecLin) = k := by
  set M8 := M.reindex e8 e8 with hM8
  have hrankM8 : M8.rank = M.rank := Matrix.rank_reindex _ _ _
  have hlow : q ≤ M8.rank := le_rank_of_minor M8 rM cM hM
  have hNlow : k ≤ N.rank := le_rank_of_minor N rN id hN
  have hNhigh : N.rank ≤ k := by simpa using Matrix.rank_le_card_width N
  have hNeq : N.rank = k := le_antisymm hNhigh hNlow
  have hsum := Matrix.rank_add_rank_le_card_of_mul_eq_zero hMN
  rw [Fintype.card_fin] at hsum
  have hrank : M.rank = q := by rw [← hrankM8]; omega
  refine ⟨hrank, ?_⟩
  have hrange : M.rank = Module.finrank ℚ (LinearMap.range M.mulVecLin) := rfl
  have hrn := LinearMap.finrank_range_add_finrank_ker (M.mulVecLin)
  have hd : Module.finrank ℚ (V8 → ℚ) = 8 := by simp
  rw [hd, ← hrange] at hrn
  omega

/-- **The control helper.**  A nonzero determinant of the reindexed matrix
makes `M` a unit: full rank `8` and trivial kernel. -/
theorem rank_null_full (M : Matrix V8 V8 ℚ)
    (h : (M.reindex e8 e8).det ≠ 0) :
    M.rank = 8 ∧ Module.finrank ℚ (LinearMap.ker M.mulVecLin) = 0 := by
  set M8 := M.reindex e8 e8 with hM8
  have hu : IsUnit M8 := (Matrix.isUnit_iff_isUnit_det _).2 (isUnit_iff_ne_zero.2 h)
  have hrankM8 : M8.rank = M.rank := Matrix.rank_reindex _ _ _
  have hrank : M.rank = 8 := by
    rw [← hrankM8, Matrix.rank_of_isUnit _ hu, Fintype.card_fin]
  refine ⟨hrank, ?_⟩
  have hrange : M.rank = Module.finrank ℚ (LinearMap.range M.mulVecLin) := rfl
  have hrn := LinearMap.finrank_range_add_finrank_ker (M.mulVecLin)
  have hd : Module.finrank ℚ (V8 → ℚ) = 8 := by simp
  rw [hd, ← hrange] at hrn
  omega

/-! ## Per-field census facts (concrete numbers; certificate transcription)

Each lemma reports `((Wof b - 1).rank, (Wof b + 1).rank,
dim ker (Wof b - 1), dim ker (Wof b + 1))` for the concrete field `b`. -/

set_option maxHeartbeats 4000000
set_option maxRecDepth 12000

-- singletons (site-0 family: rN = ![0,1], M-minor rows/cols = ![0,1,2,3,6,7])

theorem cen_tttf :
    (Wof ![true, true, true, false] - 1).rank = 6 ∧
    (Wof ![true, true, true, false] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, true, false] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, true, false] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, true, true, false] - 1) (by norm_num)
    (col2 ![5,3,0,0,4,0,0,0] ![3,5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, true, false] - 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(-1:ℚ),3/5,0,0,0,0; 3/5,-1,0,0,0,0; 0,0,-1,-3/5,4/5,0; 0,0,3/5,-1,0,4/5; 0,0,4/5,0,-1,-3/5; 0,0,0,4/5,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, true, true, false] + 1) (by norm_num)
    (col2 ![-5,3,0,0,4,0,0,0] ![3,-5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, true, false] + 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(1:ℚ),3/5,0,0,0,0; 3/5,1,0,0,0,0; 0,0,1,-3/5,4/5,0; 0,0,3/5,1,0,4/5; 0,0,4/5,0,1,-3/5; 0,0,0,4/5,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_tftt :
    (Wof ![true, false, true, true] - 1).rank = 6 ∧
    (Wof ![true, false, true, true] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, true, true] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, true, true] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, false, true, true] - 1) (by norm_num)
    (col2 ![5,-3,0,0,4,0,0,0] ![-3,5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, true, true] - 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(-1:ℚ),-3/5,0,0,0,0; -3/5,-1,0,0,0,0; 0,0,-1,-3/5,4/5,0; 0,0,3/5,-1,0,4/5; 0,0,4/5,0,-1,-3/5; 0,0,0,4/5,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, false, true, true] + 1) (by norm_num)
    (col2 ![-5,-3,0,0,4,0,0,0] ![-3,-5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, true, true] + 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(1:ℚ),-3/5,0,0,0,0; -3/5,1,0,0,0,0; 0,0,1,-3/5,4/5,0; 0,0,3/5,1,0,4/5; 0,0,4/5,0,1,-3/5; 0,0,0,4/5,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_ftff :
    (Wof ![false, true, false, false] - 1).rank = 6 ∧
    (Wof ![false, true, false, false] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, false, false] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, false, false] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, true, false, false] - 1) (by norm_num)
    (col2 ![5,3,0,0,4,0,0,0] ![3,5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, false, false] - 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(-1:ℚ),3/5,0,0,0,0; 3/5,-1,0,0,0,0; 0,0,-1,3/5,4/5,0; 0,0,-3/5,-1,0,4/5; 0,0,4/5,0,-1,3/5; 0,0,0,4/5,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, true, false, false] + 1) (by norm_num)
    (col2 ![-5,3,0,0,4,0,0,0] ![3,-5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, false, false] + 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(1:ℚ),3/5,0,0,0,0; 3/5,1,0,0,0,0; 0,0,1,3/5,4/5,0; 0,0,-3/5,1,0,4/5; 0,0,4/5,0,1,3/5; 0,0,0,4/5,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_ffft :
    (Wof ![false, false, false, true] - 1).rank = 6 ∧
    (Wof ![false, false, false, true] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, false, true] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, false, true] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, false, false, true] - 1) (by norm_num)
    (col2 ![5,-3,0,0,4,0,0,0] ![-3,5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, false, true] - 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(-1:ℚ),-3/5,0,0,0,0; -3/5,-1,0,0,0,0; 0,0,-1,3/5,4/5,0; 0,0,-3/5,-1,0,4/5; 0,0,4/5,0,-1,3/5; 0,0,0,4/5,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, false, false, true] + 1) (by norm_num)
    (col2 ![-5,-3,0,0,4,0,0,0] ![-3,-5,0,0,0,4,0,0]) ![0,1]
    ![0,1,2,3,6,7] ![0,1,2,3,6,7] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, false, true] + 1).reindex e8 e8).submatrix ![0,1,2,3,6,7] ![0,1,2,3,6,7]
          = !![(1:ℚ),-3/5,0,0,0,0; -3/5,1,0,0,0,0; 0,0,1,3/5,4/5,0; 0,0,-3/5,1,0,4/5; 0,0,4/5,0,1,3/5; 0,0,0,4/5,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

-- singletons (site-2 family: rN = ![2,3], M-minor rows/cols = ![0,1,2,3,4,5])

theorem cen_ttft :
    (Wof ![true, true, false, true] - 1).rank = 6 ∧
    (Wof ![true, true, false, true] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, false, true] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, false, true] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, true, false, true] - 1) (by norm_num)
    (col2 ![0,0,5,-3,0,0,4,0] ![0,0,-3,5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, false, true] - 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(-1:ℚ),-3/5,0,0,4/5,0; 3/5,-1,0,0,0,4/5; 0,0,-1,-3/5,0,0; 0,0,-3/5,-1,0,0; 4/5,0,0,0,-1,-3/5; 0,4/5,0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, true, false, true] + 1) (by norm_num)
    (col2 ![0,0,-5,-3,0,0,4,0] ![0,0,-3,-5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, false, true] + 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(1:ℚ),-3/5,0,0,4/5,0; 3/5,1,0,0,0,4/5; 0,0,1,-3/5,0,0; 0,0,-3/5,1,0,0; 4/5,0,0,0,1,-3/5; 0,4/5,0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_tfff :
    (Wof ![true, false, false, false] - 1).rank = 6 ∧
    (Wof ![true, false, false, false] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, false, false] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, false, false] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, false, false, false] - 1) (by norm_num)
    (col2 ![0,0,5,-3,0,0,4,0] ![0,0,-3,5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, false, false] - 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(-1:ℚ),3/5,0,0,4/5,0; -3/5,-1,0,0,0,4/5; 0,0,-1,-3/5,0,0; 0,0,-3/5,-1,0,0; 4/5,0,0,0,-1,3/5; 0,4/5,0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, false, false, false] + 1) (by norm_num)
    (col2 ![0,0,-5,-3,0,0,4,0] ![0,0,-3,-5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, false, false] + 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(1:ℚ),3/5,0,0,4/5,0; -3/5,1,0,0,0,4/5; 0,0,1,-3/5,0,0; 0,0,-3/5,1,0,0; 4/5,0,0,0,1,3/5; 0,4/5,0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_fttt :
    (Wof ![false, true, true, true] - 1).rank = 6 ∧
    (Wof ![false, true, true, true] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, true, true] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, true, true] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, true, true, true] - 1) (by norm_num)
    (col2 ![0,0,5,3,0,0,4,0] ![0,0,3,5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, true, true] - 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(-1:ℚ),-3/5,0,0,4/5,0; 3/5,-1,0,0,0,4/5; 0,0,-1,3/5,0,0; 0,0,3/5,-1,0,0; 4/5,0,0,0,-1,-3/5; 0,4/5,0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, true, true, true] + 1) (by norm_num)
    (col2 ![0,0,-5,3,0,0,4,0] ![0,0,3,-5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, true, true] + 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(1:ℚ),-3/5,0,0,4/5,0; 3/5,1,0,0,0,4/5; 0,0,1,3/5,0,0; 0,0,3/5,1,0,0; 4/5,0,0,0,1,-3/5; 0,4/5,0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_fftf :
    (Wof ![false, false, true, false] - 1).rank = 6 ∧
    (Wof ![false, false, true, false] + 1).rank = 6 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, true, false] - 1).mulVecLin) = 2 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, true, false] + 1).mulVecLin) = 2 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, false, true, false] - 1) (by norm_num)
    (col2 ![0,0,5,3,0,0,4,0] ![0,0,3,5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, true, false] - 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(-1:ℚ),3/5,0,0,4/5,0; -3/5,-1,0,0,0,4/5; 0,0,-1,3/5,0,0; 0,0,3/5,-1,0,0; 4/5,0,0,0,-1,3/5; 0,4/5,0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, false, true, false] + 1) (by norm_num)
    (col2 ![0,0,-5,3,0,0,4,0] ![0,0,3,-5,0,0,0,4]) ![2,3]
    ![0,1,2,3,4,5] ![0,1,2,3,4,5] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, true, false] + 1).reindex e8 e8).submatrix ![0,1,2,3,4,5] ![0,1,2,3,4,5]
          = !![(1:ℚ),3/5,0,0,4/5,0; -3/5,1,0,0,0,4/5; 0,0,1,3/5,0,0; 0,0,3/5,1,0,0; 4/5,0,0,0,1,3/5; 0,4/5,0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

-- blocks (rN = ![0,1,2,3], M-minor rows/cols = ![0,1,2,3])

theorem cen_ttff :
    (Wof ![true, true, false, false] - 1).rank = 4 ∧
    (Wof ![true, true, false, false] + 1).rank = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, false, false] - 1).mulVecLin) = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, false, false] + 1).mulVecLin) = 4 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, true, false, false] - 1) (by norm_num)
    (col4 ![5,3,0,0,4,0,0,0] ![3,5,0,0,0,4,0,0] ![0,0,5,-3,0,0,4,0] ![0,0,-3,5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, false, false] - 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(-1:ℚ),3/5,0,0; 3/5,-1,0,0; 0,0,-1,-3/5; 0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, true, false, false] + 1) (by norm_num)
    (col4 ![-5,3,0,0,4,0,0,0] ![3,-5,0,0,0,4,0,0] ![0,0,-5,-3,0,0,4,0] ![0,0,-3,-5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, true, false, false] + 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(1:ℚ),3/5,0,0; 3/5,1,0,0; 0,0,1,-3/5; 0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_tfft :
    (Wof ![true, false, false, true] - 1).rank = 4 ∧
    (Wof ![true, false, false, true] + 1).rank = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, false, true] - 1).mulVecLin) = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, false, true] + 1).mulVecLin) = 4 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![true, false, false, true] - 1) (by norm_num)
    (col4 ![5,-3,0,0,4,0,0,0] ![-3,5,0,0,0,4,0,0] ![0,0,5,-3,0,0,4,0] ![0,0,-3,5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, false, true] - 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(-1:ℚ),-3/5,0,0; -3/5,-1,0,0; 0,0,-1,-3/5; 0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![true, false, false, true] + 1) (by norm_num)
    (col4 ![-5,-3,0,0,4,0,0,0] ![-3,-5,0,0,0,4,0,0] ![0,0,-5,-3,0,0,4,0] ![0,0,-3,-5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![true, false, false, true] + 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(1:ℚ),-3/5,0,0; -3/5,1,0,0; 0,0,1,-3/5; 0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_fttf :
    (Wof ![false, true, true, false] - 1).rank = 4 ∧
    (Wof ![false, true, true, false] + 1).rank = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, true, false] - 1).mulVecLin) = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, true, false] + 1).mulVecLin) = 4 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, true, true, false] - 1) (by norm_num)
    (col4 ![5,3,0,0,4,0,0,0] ![3,5,0,0,0,4,0,0] ![0,0,5,3,0,0,4,0] ![0,0,3,5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, true, false] - 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(-1:ℚ),3/5,0,0; 3/5,-1,0,0; 0,0,-1,3/5; 0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, true, true, false] + 1) (by norm_num)
    (col4 ![-5,3,0,0,4,0,0,0] ![3,-5,0,0,0,4,0,0] ![0,0,-5,3,0,0,4,0] ![0,0,3,-5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, true, true, false] + 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(1:ℚ),3/5,0,0; 3/5,1,0,0; 0,0,1,3/5; 0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_fftt :
    (Wof ![false, false, true, true] - 1).rank = 4 ∧
    (Wof ![false, false, true, true] + 1).rank = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, true, true] - 1).mulVecLin) = 4 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, true, true] + 1).mulVecLin) = 4 := by
  obtain ⟨hrm, hnm⟩ := rank_null_cert (Wof ![false, false, true, true] - 1) (by norm_num)
    (col4 ![5,-3,0,0,4,0,0,0] ![-3,5,0,0,0,4,0,0] ![0,0,5,3,0,0,4,0] ![0,0,3,5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, true, true] - 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(-1:ℚ),-3/5,0,0; -3/5,-1,0,0; 0,0,-1,3/5; 0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_cert (Wof ![false, false, true, true] + 1) (by norm_num)
    (col4 ![-5,-3,0,0,4,0,0,0] ![-3,-5,0,0,0,4,0,0] ![0,0,-5,3,0,0,4,0] ![0,0,3,-5,0,0,0,4]) ![0,1,2,3]
    ![0,1,2,3] ![0,1,2,3] (by walk_reduce) (by det_reduce)
    (by have hL : ((Wof ![false, false, true, true] + 1).reindex e8 e8).submatrix ![0,1,2,3] ![0,1,2,3]
          = !![(1:ℚ),-3/5,0,0; -3/5,1,0,0; 0,0,1,3/5; 0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

-- controls (walls 0 or 4: nonzero determinant, no modes)
-- The full 8×8 entrywise reduction is heavier than the 6×6/4×4 minors above,
-- so these four lemmas run with a larger heartbeat budget.
set_option maxHeartbeats 40000000

theorem cen_tttt :
    (Wof ![true, true, true, true] - 1).rank = 8 ∧
    (Wof ![true, true, true, true] + 1).rank = 8 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, true, true] - 1).mulVecLin) = 0 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, true, true, true] + 1).mulVecLin) = 0 := by
  obtain ⟨hrm, hnm⟩ := rank_null_full (Wof ![true, true, true, true] - 1)
    (by have hL : (Wof ![true, true, true, true] - 1).reindex e8 e8
          = !![(-1:ℚ),-3/5,0,0,4/5,0,0,0; 3/5,-1,0,0,0,4/5,0,0; 0,0,-1,-3/5,0,0,4/5,0; 0,0,3/5,-1,0,0,0,4/5; 4/5,0,0,0,-1,-3/5,0,0; 0,4/5,0,0,3/5,-1,0,0; 0,0,4/5,0,0,0,-1,-3/5; 0,0,0,4/5,0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_full (Wof ![true, true, true, true] + 1)
    (by have hL : (Wof ![true, true, true, true] + 1).reindex e8 e8
          = !![(1:ℚ),-3/5,0,0,4/5,0,0,0; 3/5,1,0,0,0,4/5,0,0; 0,0,1,-3/5,0,0,4/5,0; 0,0,3/5,1,0,0,0,4/5; 4/5,0,0,0,1,-3/5,0,0; 0,4/5,0,0,3/5,1,0,0; 0,0,4/5,0,0,0,1,-3/5; 0,0,0,4/5,0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_ffff :
    (Wof ![false, false, false, false] - 1).rank = 8 ∧
    (Wof ![false, false, false, false] + 1).rank = 8 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, false, false] - 1).mulVecLin) = 0 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, false, false, false] + 1).mulVecLin) = 0 := by
  obtain ⟨hrm, hnm⟩ := rank_null_full (Wof ![false, false, false, false] - 1)
    (by have hL : (Wof ![false, false, false, false] - 1).reindex e8 e8
          = !![(-1:ℚ),3/5,0,0,4/5,0,0,0; -3/5,-1,0,0,0,4/5,0,0; 0,0,-1,3/5,0,0,4/5,0; 0,0,-3/5,-1,0,0,0,4/5; 4/5,0,0,0,-1,3/5,0,0; 0,4/5,0,0,-3/5,-1,0,0; 0,0,4/5,0,0,0,-1,3/5; 0,0,0,4/5,0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_full (Wof ![false, false, false, false] + 1)
    (by have hL : (Wof ![false, false, false, false] + 1).reindex e8 e8
          = !![(1:ℚ),3/5,0,0,4/5,0,0,0; -3/5,1,0,0,0,4/5,0,0; 0,0,1,3/5,0,0,4/5,0; 0,0,-3/5,1,0,0,0,4/5; 4/5,0,0,0,1,3/5,0,0; 0,4/5,0,0,-3/5,1,0,0; 0,0,4/5,0,0,0,1,3/5; 0,0,0,4/5,0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_tftf :
    (Wof ![true, false, true, false] - 1).rank = 8 ∧
    (Wof ![true, false, true, false] + 1).rank = 8 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, true, false] - 1).mulVecLin) = 0 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![true, false, true, false] + 1).mulVecLin) = 0 := by
  obtain ⟨hrm, hnm⟩ := rank_null_full (Wof ![true, false, true, false] - 1)
    (by have hL : (Wof ![true, false, true, false] - 1).reindex e8 e8
          = !![(-1:ℚ),3/5,0,0,4/5,0,0,0; -3/5,-1,0,0,0,4/5,0,0; 0,0,-1,-3/5,0,0,4/5,0; 0,0,3/5,-1,0,0,0,4/5; 4/5,0,0,0,-1,3/5,0,0; 0,4/5,0,0,-3/5,-1,0,0; 0,0,4/5,0,0,0,-1,-3/5; 0,0,0,4/5,0,0,3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_full (Wof ![true, false, true, false] + 1)
    (by have hL : (Wof ![true, false, true, false] + 1).reindex e8 e8
          = !![(1:ℚ),3/5,0,0,4/5,0,0,0; -3/5,1,0,0,0,4/5,0,0; 0,0,1,-3/5,0,0,4/5,0; 0,0,3/5,1,0,0,0,4/5; 4/5,0,0,0,1,3/5,0,0; 0,4/5,0,0,-3/5,1,0,0; 0,0,4/5,0,0,0,1,-3/5; 0,0,0,4/5,0,0,3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

theorem cen_ftft :
    (Wof ![false, true, false, true] - 1).rank = 8 ∧
    (Wof ![false, true, false, true] + 1).rank = 8 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, false, true] - 1).mulVecLin) = 0 ∧
    Module.finrank ℚ (LinearMap.ker (Wof ![false, true, false, true] + 1).mulVecLin) = 0 := by
  obtain ⟨hrm, hnm⟩ := rank_null_full (Wof ![false, true, false, true] - 1)
    (by have hL : (Wof ![false, true, false, true] - 1).reindex e8 e8
          = !![(-1:ℚ),-3/5,0,0,4/5,0,0,0; 3/5,-1,0,0,0,4/5,0,0; 0,0,-1,3/5,0,0,4/5,0; 0,0,-3/5,-1,0,0,0,4/5; 4/5,0,0,0,-1,-3/5,0,0; 0,4/5,0,0,3/5,-1,0,0; 0,0,4/5,0,0,0,-1,3/5; 0,0,0,4/5,0,0,-3/5,-1] := by walk_reduce
        rw [hL]; det_reduce)
  obtain ⟨hrp, hnp⟩ := rank_null_full (Wof ![false, true, false, true] + 1)
    (by have hL : (Wof ![false, true, false, true] + 1).reindex e8 e8
          = !![(1:ℚ),-3/5,0,0,4/5,0,0,0; 3/5,1,0,0,0,4/5,0,0; 0,0,1,3/5,0,0,4/5,0; 0,0,-3/5,1,0,0,0,4/5; 4/5,0,0,0,1,-3/5,0,0; 0,4/5,0,0,3/5,1,0,0; 0,0,4/5,0,0,0,1,3/5; 0,0,0,4/5,0,0,-3/5,1] := by walk_reduce
        rw [hL]; det_reduce)
  exact ⟨hrm, hrp, hnm, hnp⟩

/-! ## The assembled 16-field census -/

/-- The complete rank/nullity census for both signs, packaged as
`((Wof b - 1).rank, (Wof b + 1).rank, dim ker (Wof b - 1), dim ker (Wof b + 1))`.
Proof: reduce `b` to its four boolean values, then dispatch each of the 16
concrete fields to its per-field certificate lemma; the classification-`if`
is reduced by `decide`. -/
theorem census_all (b : Fin 4 → Bool) :
    (Wof b - 1).rank =
        (if wallCount b = 2 then (if isSingleton b then 6 else 4) else 8) ∧
      (Wof b + 1).rank =
        (if wallCount b = 2 then (if isSingleton b then 6 else 4) else 8) ∧
      Module.finrank ℚ (LinearMap.ker (Wof b - 1).mulVecLin) =
        (if wallCount b = 2 then (if isSingleton b then 2 else 4) else 0) ∧
      Module.finrank ℚ (LinearMap.ker (Wof b + 1).mulVecLin) =
        (if wallCount b = 2 then (if isSingleton b then 2 else 4) else 0) := by
  have hb : b = ![b 0, b 1, b 2, b 3] := by funext i; fin_cases i <;> rfl
  rw [hb]
  set d0 := b 0 with hd0
  set d1 := b 1 with hd1
  set d2 := b 2 with hd2
  set d3 := b 3 with hd3
  clear_value d0 d1 d2 d3
  clear hd0 hd1 hd2 hd3 hb
  cases d0 <;> cases d1 <;> cases d2 <;> cases d3
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ffff; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ffft; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_fftf; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_fftt; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ftff; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ftft; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_fttf; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_fttt; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tfff; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tfft; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tftf; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tftt; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ttff; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_ttft; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tttf; rw [h1, h2, h3, h4]; decide
  · obtain ⟨h1, h2, h3, h4⟩ := cen_tttt; rw [h1, h2, h3, h4]; decide

/-- T1 (headline, minus sector): the exact rank census of `Wof b - 1`
across all 16 sign fields: `6` for the eight singletons, `4` for the four
domain blocks, `8` (invertible) for the zero- or four-wall controls. -/
theorem census_rank_minus (b : Fin 4 → Bool) :
    (Wof b - 1).rank =
      if wallCount b = 2 then (if isSingleton b then 6 else 4) else 8 :=
  (census_all b).1

/-- T2 (headline, plus sector): same census for `Wof b + 1`. -/
theorem census_rank_plus (b : Fin 4 → Bool) :
    (Wof b + 1).rank =
      if wallCount b = 2 then (if isSingleton b then 6 else 4) else 8 :=
  (census_all b).2.1

/-- T3 (paper-facing corollary): exact mode multiplicities.  Every two-wall
field carries both `+-1` eigenspaces, with dimension `2` for singletons and
`4` for domain blocks; zero- and four-wall controls carry none. -/
theorem census_multiplicity (b : Fin 4 → Bool) :
    Module.finrank ℚ (LinearMap.ker (Wof b - 1).mulVecLin) =
        (if wallCount b = 2 then (if isSingleton b then 2 else 4) else 0) ∧
      Module.finrank ℚ (LinearMap.ker (Wof b + 1).mulVecLin) =
        (if wallCount b = 2 then (if isSingleton b then 2 else 4) else 0) :=
  ⟨(census_all b).2.2.1, (census_all b).2.2.2⟩

/-- T4 (blindness persists at multiplicity level): the four
compression-blind fixed singletons have the SAME multiplicity pattern as
the certified ones - the census cannot see the positional split that the
reflection certificate detects.  (Follows from T3 + decide over the
class predicates; state it as the explicit quantified corollary.) -/
theorem census_blind_same_multiplicity :
    ∀ b : Fin 4 → Bool, wallCount b = 2 → isSingleton b →
      Module.finrank ℚ (LinearMap.ker (Wof b - 1).mulVecLin) = 2 := by
  intro b hw hs
  have h := (census_multiplicity b).1
  rw [if_pos hw, if_pos hs] at h
  exact h

end PhysicsSM.Draft.NullEdge.CensusMultiplicity
