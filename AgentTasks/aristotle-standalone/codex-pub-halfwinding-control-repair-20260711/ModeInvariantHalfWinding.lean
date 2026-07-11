import Mathlib

/-!
# The mode-pinning engine for derived sign-wall walks (C rung 6) — typechecking statements

Companion Lean file for `MODE_INVARIANT_DESIGN.md`.  This is a **design /
typechecking** artifact (holes allowed, no large builds).  It is deliberately
self-contained (`import Mathlib` only) and does **not** import or modify any of
the four landed modules (`ChiralFlipMode`, `ChiralZeroModeParity`,
`SignWallDefectRouteB`, `SignWallDefectRouteBConcrete`); the concrete
definitions it needs are reproduced locally, exactly as the landed concrete
module reproduces the abstract ones.

## What differs between the two-wall walk and the zero-wall control

The det-based routes are closed at both levels: the global determinant is `+1`
for every derived walk (`signWalk_det_eq_one`), and **every** reflection-sector
compressed determinant is `+1` too, wall or no wall (`sector_dets_all_one`).
The Asboth–Obuse global index and the naive reflection-sector chiral indices
`(tr Γ ± tr(Γ R))/2` all vanish (oracle: `tr Γ = 0`, `tr(Γ R) = 0`, and the
`Γ`-signature of each pinned pair is balanced `+1,−1`).

The invariant that actually differs is **not** a `W`-independent trace/Lefschetz
count (any such count is shared by wall and control — they carry the *same*
`Γ, R` and the same symmetry algebra, so no `tr(Γ R')` can separate them; this is
precisely why the determinant routes were blind).  The distinguishing datum is a
**`W`-dependent, kernel-checkable** fact:

> the compression of `W` to the reflection-**fixed** sub-sector
> `V_fix = span{ e_(1,·), e_(3,·) }` is a **self-adjoint** unitary, hence an
> **involution** `M² = 1`, in the two-wall walk — and is *not* self-adjoint in
> the zero-wall control (nor in the reflection-symmetric four-wall walk).

A self-adjoint unitary has spectrum `⊆ {±1}`, so **all** `dim V_fix = 4` legs
are exact `±1` modes; the split is `(4 + tr M)/2` at `+1` and `(4 − tr M)/2` at
`−1`, and here `tr M = 0`, giving `2` and `2` — the observed
`dim ker(W−1) = dim ker(W+1) = 2`.  The `det` of this block is `+1` in *both*
configurations (matching `sector_dets_all_one`); the determinant is blind, the
self-adjointness/involution is the discriminator.

This is candidate **(e)** (a spectral restriction to an `R`-isotypic block cut by
the commuting pair `(Γ,R)`) sharpened from "determinant" to "self-adjointness",
with the **count** read off as candidate **(d)** (the fixed-leg dimension), and
the *protecting parameter* being candidate **(b)**: a half-winding parity —
`(wall count)/2 mod 2`, **not** the plain wall-count-mod-2 (see the memo, Q4/Q5).

Provenance: C rung 6.  Invariant identified by Aristotle design project
`b4619977` (from Fable's vanishing-index oracle data); all holes closed by
Aristotle project `f25bbd64-18f9-45f5-b1be-d8f5d4a34888` (run `14cefe28`),
engine and statements unchanged; integrated with local kernel re-check.
THE RESULT: the mode-pinning invariant for derived sign-wall walks is the
SELF-ADJOINTNESS of the compression to the reflection-fixed legs (an
involutive compression), which reads the derived field as a Z2 HALF-WINDING
- exact protected +-1 modes iff the wall count is 2 mod 4 - with zero-wall
and four-wall in-class NO-mode controls.  Determinants and naive trace
indices are provably blind to it (SignWallDefectRouteBConcrete,
trace-index oracle).  Axioms: standard three for the abstract engine and
counting lemmas; documented native_decide (draft-trust) on the explicit
rational K6 facts, consistent with the sibling modules.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

open Matrix

/-! ## 1.  The abstract engine (fully proved, no holes)

Style: `ChiralFlipMode`.  No diagonalizability hypothesis; explicit witnesses;
a genuine zero-invariant control (§4).  The engine reads only *value-level*
matrix data (`W, B, M`); the discriminating hypothesis is the **discrete**
self-adjointness `M = Mᴴ`. -/

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- A **self-adjoint (involutive) compression** of `W`.  `B` is an isometry onto
an invariant subspace (`W * B = B * M`, `M = Bᴴ W B`), and the compressed
operator `M` is self-adjoint.  For unitary `W` this forces `M² = 1`
(`compression_involution`). -/
structure InvolutiveCompression {k : ℕ} (W : Matrix m m ℂ)
    (B : Matrix m (Fin k) ℂ) (M : Matrix (Fin k) (Fin k) ℂ) : Prop where
  /-- `B` is an isometry: `Bᴴ B = 1`. -/
  iso        : Bᴴ * B = 1
  /-- the sector is `W`-invariant and `M` is its honest compression. -/
  intertwine : W * B = B * M
  /-- the compressed operator is self-adjoint (**the discriminating datum**). -/
  selfadj    : M = Mᴴ
  /-- `W` is unitary. -/
  unit       : Wᴴ * W = 1

/-- The compression of a unitary onto an invariant subspace is unitary. -/
theorem compression_unitary {k : ℕ} {W : Matrix m m ℂ}
    {B : Matrix m (Fin k) ℂ} {M : Matrix (Fin k) (Fin k) ℂ}
    (h : InvolutiveCompression W B M) : Mᴴ * M = 1 := by
  have hMeq : Bᴴ * W * B = M := by
    rw [Matrix.mul_assoc, h.intertwine, ← Matrix.mul_assoc, h.iso, Matrix.one_mul]
  have hPW : B * Bᴴ * (W * B) = W * B := by
    rw [h.intertwine, ← Matrix.mul_assoc, Matrix.mul_assoc B Bᴴ B, h.iso, Matrix.mul_one]
  have hMH : Mᴴ = Bᴴ * Wᴴ * B := by
    rw [← hMeq]
    simp only [Matrix.conjTranspose_mul, Matrix.conjTranspose_conjTranspose, Matrix.mul_assoc]
  rw [hMH, ← hMeq]
  rw [show (Bᴴ*Wᴴ*B) * (Bᴴ*W*B) = Bᴴ * Wᴴ * (B*Bᴴ*(W*B)) from by
        simp only [Matrix.mul_assoc], hPW]
  rw [show Bᴴ * Wᴴ * (W*B) = Bᴴ * (Wᴴ*W) * B from by simp only [Matrix.mul_assoc],
      h.unit, Matrix.mul_one, h.iso]

/-- **Engine core.**  A self-adjoint compression of a unitary is an
**involution**: `M * M = 1`.  (`M` unitary from `compression_unitary`, then
`M * M = Mᴴ * M = 1` by self-adjointness.)  This is the whole mechanism: an
involution has spectrum `⊆ {±1}`, so the sector is *fully pinned*. -/
theorem compression_involution {k : ℕ} {W : Matrix m m ℂ}
    {B : Matrix m (Fin k) ℂ} {M : Matrix (Fin k) (Fin k) ℂ}
    (h : InvolutiveCompression W B M) : M * M = 1 := by
  have hU := compression_unitary h
  rwa [← h.selfadj] at hU

/-- An involution `M ≠ 1` has an exact `−1` eigenvector (witness `(M−1)·w`). -/
theorem involution_neg_mode {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) (hne : M ≠ 1) : ∃ v : Fin k → ℂ, v ≠ 0 ∧ M.mulVec v = -v := by
  have hsub : M - 1 ≠ 0 := sub_ne_zero.mpr hne
  obtain ⟨w, hw⟩ : ∃ w, (M - 1).mulVec w ≠ 0 := by
    by_contra hc; push_neg at hc
    exact hsub (by ext i j; simpa using congrFun (hc (Pi.single j 1)) i)
  refine ⟨(M - 1).mulVec w, hw, ?_⟩
  rw [Matrix.mulVec_mulVec]
  have h2 : M * (M - 1) = -(M - 1) := by rw [Matrix.mul_sub, hM, Matrix.mul_one]; noncomm_ring
  rw [h2, Matrix.neg_mulVec]

/-- An involution `M ≠ −1` has an exact `+1` eigenvector (witness `(M+1)·w`). -/
theorem involution_pos_mode {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) (hne : M ≠ -1) : ∃ v : Fin k → ℂ, v ≠ 0 ∧ M.mulVec v = v := by
  have hsub : M + 1 ≠ 0 := fun h => hne (eq_neg_of_add_eq_zero_left h)
  obtain ⟨w, hw⟩ : ∃ w, (M + 1).mulVec w ≠ 0 := by
    by_contra hc; push_neg at hc
    exact hsub (by ext i j; simpa using congrFun (hc (Pi.single j 1)) i)
  refine ⟨(M + 1).mulVec w, hw, ?_⟩
  rw [Matrix.mulVec_mulVec]
  have h2 : M * (M + 1) = (M + 1) := by rw [Matrix.mul_add, hM, Matrix.mul_one, add_comm]
  rw [h2]

/-- Lift a sector `−1` mode of `M` to a genuine `−1` mode of `W` via the
isometry (`v ↦ B·v`). -/
theorem lift_neg_mode {k : ℕ} {W : Matrix m m ℂ} {B : Matrix m (Fin k) ℂ}
    {M : Matrix (Fin k) (Fin k) ℂ} (h : InvolutiveCompression W B M)
    {v : Fin k → ℂ} (hv : v ≠ 0) (hMv : M.mulVec v = -v) :
    B.mulVec v ≠ 0 ∧ W.mulVec (B.mulVec v) = -(B.mulVec v) := by
  refine ⟨?_, ?_⟩
  · intro hc
    apply hv
    have hbw : Bᴴ.mulVec (B.mulVec v) = v := by
      rw [Matrix.mulVec_mulVec, h.iso, Matrix.one_mulVec]
    rw [← hbw, hc, Matrix.mulVec_zero]
  · rw [Matrix.mulVec_mulVec, h.intertwine, ← Matrix.mulVec_mulVec, hMv, Matrix.mulVec_neg]

/-- Lift a sector `+1` mode of `M` to a genuine `+1` mode of `W`. -/
theorem lift_pos_mode {k : ℕ} {W : Matrix m m ℂ} {B : Matrix m (Fin k) ℂ}
    {M : Matrix (Fin k) (Fin k) ℂ} (h : InvolutiveCompression W B M)
    {v : Fin k → ℂ} (hv : v ≠ 0) (hMv : M.mulVec v = v) :
    B.mulVec v ≠ 0 ∧ W.mulVec (B.mulVec v) = B.mulVec v := by
  refine ⟨?_, ?_⟩
  · intro hc
    apply hv
    have hbw : Bᴴ.mulVec (B.mulVec v) = v := by
      rw [Matrix.mulVec_mulVec, h.iso, Matrix.one_mulVec]
    rw [← hbw, hc, Matrix.mulVec_zero]
  · rw [Matrix.mulVec_mulVec, h.intertwine, ← Matrix.mulVec_mulVec, hMv]

/-- **Engine T-flip.**  A self-adjoint compression that is not `+1` forces a
genuine `−1` eigenvector of `W` living in the sector.  (No `det = −1`
hypothesis: the determinant is blind here — `det M = +1` in the target.) -/
theorem involutive_compression_flip_mode {k : ℕ} {W : Matrix m m ℂ}
    {B : Matrix m (Fin k) ℂ} {M : Matrix (Fin k) (Fin k) ℂ}
    (h : InvolutiveCompression W B M) (hne : M ≠ 1) :
    ∃ V : m → ℂ, V ≠ 0 ∧ W.mulVec V = -V := by
  obtain ⟨v, hv, hMv⟩ := involution_neg_mode (compression_involution h) hne
  obtain ⟨h1, h2⟩ := lift_neg_mode h hv hMv
  exact ⟨B.mulVec v, h1, h2⟩

/-- **Engine T-fix.**  A self-adjoint compression that is not `−1` forces a
genuine `+1` eigenvector of `W` in the sector — the partner mode. -/
theorem involutive_compression_fixed_mode {k : ℕ} {W : Matrix m m ℂ}
    {B : Matrix m (Fin k) ℂ} {M : Matrix (Fin k) (Fin k) ℂ}
    (h : InvolutiveCompression W B M) (hne : M ≠ -1) :
    ∃ V : m → ℂ, V ≠ 0 ∧ W.mulVec V = V := by
  obtain ⟨v, hv, hMv⟩ := involution_pos_mode (compression_involution h) hne
  obtain ⟨h1, h2⟩ := lift_pos_mode h hv hMv
  exact ⟨B.mulVec v, h1, h2⟩

/-! ## 2.  The exact count (holed; the honest "how many" statement)

For an involution `M` on `Fin k` the spectrum is fully pinned to `{±1}`:
`#(+1) + #(−1) = k` and `#(+1) − #(−1) = tr M`.  Hence
`#(+1) = (k + tr M)/2`, `#(−1) = (k − tr M)/2`.  In the target `k = 4`,
`tr M = 0`, so `#(+1) = #(−1) = 2`.  (Route: `M² = 1 ⇒ minpoly ∣ X²−1`, the
roots of `charpoly` are `±1`, and `sum of roots = tr`.) -/

/-- Every characteristic root of an involution is `±1`: if `r` is a root then
`det (r•I - M) = 0`, while `(r•I - M)(r•I + M) = (r²-1)•I`, forcing `r² = 1`. -/
theorem involution_root_pm {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) {r : ℂ} (hr : r ∈ M.charpoly.roots) : r = 1 ∨ r = -1 := by
  have hne : M.charpoly ≠ 0 := (Matrix.charpoly_monic M).ne_zero
  rw [Polynomial.mem_roots hne] at hr
  have hroot : (Matrix.scalar (Fin k) r - M).det = 0 := by
    have h0 : M.charpoly.eval r = 0 := hr
    rwa [Matrix.eval_charpoly] at h0
  set s := Matrix.scalar (Fin k) r with hs
  have hcomm : Commute s M := Matrix.scalar_commute r (fun _ => Commute.all _ _) M
  have key : (s - M) * (s + M) = Matrix.scalar (Fin k) (r^2 - 1) := by
    have e1 : (s - M) * (s + M) = s * s - M * M := by
      rw [mul_add, sub_mul, sub_mul, hcomm.eq]; abel
    rw [e1, hM, hs, ← map_mul, ← sq, ← map_one (Matrix.scalar (Fin k)), ← map_sub]
  have hdet : ((s - M) * (s + M)).det = 0 := by rw [Matrix.det_mul, hroot, zero_mul]
  rw [key, Matrix.scalar_apply, Matrix.det_diagonal, Finset.prod_const,
      Finset.card_univ, Fintype.card_fin] at hdet
  rcases Nat.eq_zero_or_pos k with hk | hk
  · simp [hk] at hdet
  · have hz : r^2 - 1 = 0 := (pow_eq_zero_iff hk.ne').mp hdet
    have hrr : r * r = 1 := by rw [← sq]; linear_combination hz
    exact mul_self_eq_one_iff.mp hrr

/-- The root multiset of an involution splits as `count(+1)` copies of `1` plus
`count(-1)` copies of `-1` (there are no other roots). -/
theorem involution_roots_eq {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) :
    M.charpoly.roots = Multiset.replicate (M.charpoly.roots.count 1) 1
      + Multiset.replicate (M.charpoly.roots.count (-1)) (-1) := by
  ext a
  rw [Multiset.count_add, Multiset.count_replicate, Multiset.count_replicate]
  rcases eq_or_ne a 1 with h1 | h1
  · subst h1; rw [if_pos rfl, if_neg (by norm_num), add_zero]
  · rcases eq_or_ne a (-1) with h2 | h2
    · subst h2; rw [if_neg (by norm_num), if_pos rfl, zero_add]
    · rw [if_neg (Ne.symm h1), if_neg (Ne.symm h2), add_zero,
          Multiset.count_eq_zero.mpr]
      intro hmem; rcases involution_root_pm hM hmem with h | h
      · exact h1 h
      · exact h2 h

/-- Full pinning: an involution's characteristic roots are all `±1`. -/
theorem involution_full_pinning {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) :
    M.charpoly.roots.count 1 + M.charpoly.roots.count (-1) = k := by
  have hcard : Multiset.card M.charpoly.roots = k := by
    have hnd := (IsAlgClosed.splits (M.charpoly)).natDegree_eq_card_roots
    rw [Matrix.charpoly_natDegree_eq_dim, Fintype.card_fin] at hnd
    omega
  have h2 := congrArg Multiset.card (involution_roots_eq hM)
  rw [Multiset.card_add, Multiset.card_replicate, Multiset.card_replicate] at h2
  omega

/-- The `±1`-multiplicity split is read by the trace. -/
theorem involution_trace_split {k : ℕ} {M : Matrix (Fin k) (Fin k) ℂ}
    (hM : M * M = 1) :
    M.trace = (M.charpoly.roots.count 1 : ℂ) - (M.charpoly.roots.count (-1) : ℂ) := by
  rw [Matrix.trace_eq_sum_roots_charpoly]
  have h2 := congrArg Multiset.sum (involution_roots_eq hM)
  rw [Multiset.sum_add, Multiset.sum_replicate, Multiset.sum_replicate] at h2
  rw [h2]; simp [nsmul_eq_mul]; ring

/-! ## 3.  Concrete instantiation on the K6 two-wall register (holes = `native_decide`)

The register is `V8 = Fin 4 × Fin 2` of `SignWallDefect.Concrete`, so the
`Sectoring` machinery of the landed modules is reusable.  All facts below are
**exact rational** identities (verified numerically) that discharge by
`native_decide` over `ℚ` and transport to `ℂ` via the entrywise `algebraMap`
(exactly the `toC` pattern of `SignWallDefectRouteBConcrete`).  They are left as
holes here per the design-job discipline (no large builds). -/

abbrev V8 := Fin 4 × Fin 2

/-- Conditional shift on `Fin 4` (reproduced from `Concrete`). -/
def shiftQ : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.2 = j.2 then
    (if i.1 = (if j.2 = 0 then (![1,2,3,0] : Fin 4 → Fin 4) j.1
               else (![3,0,1,2] : Fin 4 → Fin 4) j.1) then (1 : ℚ) else 0) else 0

/-- Rotation coin with cosine field `c` and sine field `s`. -/
def coinQ (c s : Fin 4 → ℚ) : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = j.1 then (if i.2 = j.2 then c i.1 else (if i.2 = 0 then - s i.1 else s i.1)) else 0

/-- The palindromic walk `W = S · C · S`. -/
def walkQ (c s : Fin 4 → ℚ) : Matrix V8 V8 ℚ := shiftQ * coinQ c s * shiftQ

/-- The `3-4-5` cosine field. -/
def cW : Fin 4 → ℚ := fun _ => 4 / 5
/-- The derived **two-wall** sine field `[+,+,−,+]` (sign flip at the wall site `2`). -/
def sWall : Fin 4 → ℚ := ![3 / 5, 3 / 5, -3 / 5, 3 / 5]
/-- The **zero-wall control** sine field `[+,+,+,+]`. -/
def sZero : Fin 4 → ℚ := fun _ => 3 / 5
/-- A reflection-symmetric **four-wall** field `[+,−,+,−]` (the in-class kill, §5). -/
def sFour : Fin 4 → ℚ := ![3 / 5, -3 / 5, 3 / 5, -3 / 5]

/-- The derived two-wall walk. -/
def Wwall : Matrix V8 V8 ℚ := walkQ cW sWall
/-- The zero-wall control walk. -/
def Wzero : Matrix V8 V8 ℚ := walkQ cW sZero
/-- The four-wall walk. -/
def Wfour : Matrix V8 V8 ℚ := walkQ cW sFour

/-- Isometry onto the reflection-**fixed** sub-sector `V_fix = span{e_(1,·), e_(3,·)}`
(the two reflection-fixed sites `1, 3`, both chiralities): the "fixed legs". -/
def Bfix : Matrix V8 (Fin 4) ℚ := Matrix.of fun x j =>
  if x = (![(1,0),(1,1),(3,0),(3,1)] : Fin 4 → V8) j then 1 else 0

/-- **The compressed two-wall walk on the fixed legs** (`M = Bfixᵀ Wwall Bfix`), a
`4×4` symmetric orthogonal **involution** (verified: `A = Aᵀ`, `A·A = 1`,
`tr A = 0`, `det A = 1`). -/
def Afix : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, -3/5, 4/5, 0; -3/5, 0, 0, 4/5; 4/5, 0, 0, 3/5; 0, 4/5, 3/5, 0]

/-- **The compressed control walk on the same legs** — orthogonal but **not**
self-adjoint (`A0 ≠ A0ᵀ`), and with `det(A0 ∓ 1) = 36/25 ≠ 0`: no `±1` modes. -/
def Afix0 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, -3/5, 4/5, 0; 3/5, 0, 0, 4/5; 4/5, 0, 0, -3/5; 0, 4/5, 3/5, 0]

/-- **The compressed four-wall walk on the same legs** — orthogonal, `tr = 0`,
`det = 1`, but **not** an involution (`det(A4 ∓ 1) = 36/25 ≠ 0`): the in-class
control (§5).  (Numerically it coincides with `Afix0`.) -/
def Afix4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, -3/5, 4/5, 0; 3/5, 0, 0, 4/5; 4/5, 0, 0, -3/5; 0, 4/5, 3/5, 0]

/-! ### The kernel-checkable facts (all verified over `ℚ`; holes = `native_decide`) -/

/-- `Bfix` is an isometry. -/
theorem Bfix_iso : Bfixᵀ * Bfix = 1 := by native_decide

/-- The fixed sub-sector is `Wwall`-invariant with compression `Afix`. -/
theorem Wwall_Bfix : Wwall * Bfix = Bfix * Afix := by native_decide

/-- **The discriminating datum, two-wall: the compression is self-adjoint.** -/
theorem Afix_selfadj : Afix = Afixᵀ := by native_decide

/-- Consequently `Afix` is an involution (also directly `native_decide`). -/
theorem Afix_involution : Afix * Afix = 1 := by native_decide

/-- `Afix` is neither `+1` nor `−1`, so **both** pinned modes fire. -/
theorem Afix_ne_one : Afix ≠ 1 := by native_decide
theorem Afix_ne_neg_one : Afix ≠ -1 := by native_decide

/-- The compression is `+1`-balanced (`tr Afix = 0`) — the split is `2` and `2`. -/
theorem Afix_trace : Afix.trace = 0 := by native_decide

/-- **Control:** the compression is *not* self-adjoint — the engine hypothesis
fails, and indeed no `±1` mode exists (`det(Afix0 ∓ 1) = 36/25 ≠ 0`). -/
theorem Afix0_not_selfadj : Afix0 ≠ Afix0ᵀ := by native_decide
theorem Afix0_no_neg_mode : (Afix0 + 1).det ≠ 0 := by native_decide
theorem Afix0_no_pos_mode : (Afix0 - 1).det ≠ 0 := by native_decide

/-- **Four-wall in-class control (§5):** reflection-symmetric, `det = +1`, `Γ` a
genuine chiral involution — yet **not** an involution on the fixed legs, and no
`±1` mode.  This separates the true invariant from "even walls / reflection
symmetry alone". -/
theorem Afix4_not_involution : Afix4 * Afix4 ≠ 1 := by native_decide
theorem Afix4_no_neg_mode : (Afix4 + 1).det ≠ 0 := by native_decide
theorem Afix4_no_pos_mode : (Afix4 - 1).det ≠ 0 := by native_decide

/-! ### Transport to `ℂ` and firing the engine (the composed instantiation)

`toC` is the entrywise `algebraMap ℚ ℂ` on matrices (the landed `toC`).  Over
`ℂ` one assembles `InvolutiveCompression (toC Wwall) (toC Bfix) (toC Afix)` from
the four `ℚ`-facts above plus `Wwall` unitarity (the landed `Wwall_unitary`), and
fires `involutive_compression_flip_mode` / `_fixed_mode` to obtain the exact
`−1` and `+1` eigenvectors of the derived two-wall walk. -/

/-- The entrywise `ℚ → ℂ` matrix ring hom (as in `SignWallDefectRouteBConcrete`). -/
def toC {p q : Type*} [Fintype p] [Fintype q] : Matrix p q ℚ → Matrix p q ℂ :=
  fun A => A.map (algebraMap ℚ ℂ)

/-- `toC` is multiplicative (`RingHom.mapMatrix` functoriality). -/
theorem toC_mul {p q r : Type*} [Fintype p] [Fintype q] [Fintype r]
    (A : Matrix p q ℚ) (B : Matrix q r ℚ) : toC (A * B) = toC A * toC B := by
  unfold toC; exact Matrix.map_mul

/-- `toC` preserves the identity. -/
theorem toC_one {p : Type*} [Fintype p] [DecidableEq p] :
    toC (1 : Matrix p p ℚ) = 1 := by
  unfold toC; ext i j; simp [Matrix.map_apply, Matrix.one_apply, apply_ite]

/-- `toC` intertwines conjugate-transpose with transpose (the image is real). -/
theorem toC_conjTranspose {p q : Type*} [Fintype p] [Fintype q] (A : Matrix p q ℚ) :
    (toC A)ᴴ = toC Aᵀ := by
  unfold toC; ext i j
  simp [Matrix.conjTranspose_apply, Matrix.map_apply, Matrix.transpose_apply]

/-- `toC` is injective (`algebraMap ℚ ℂ` is injective, entrywise). -/
theorem toC_injective {p q : Type*} [Fintype p] [Fintype q] {A B : Matrix p q ℚ}
    (h : toC A = toC B) : A = B := by
  unfold toC at h; ext i j
  have := congrFun (congrFun h i) j
  simpa [Matrix.map_apply] using this

/-- `toC` negates. -/
theorem toC_neg {p q : Type*} [Fintype p] [Fintype q] (A : Matrix p q ℚ) :
    toC (-A) = - toC A := by
  unfold toC; ext i j; simp [Matrix.map_apply]

/-- `Wwall` is orthogonal over `ℚ` (a product of orthogonal factors). -/
theorem Wwall_orthogonal : Wwallᵀ * Wwall = 1 := by native_decide

/-- **The assembled self-adjoint compression for the derived two-wall walk.**
(Assembled from the `ℚ`-facts via `toC`; the four fields discharge as in the
landed `sectoring_wall` transport.) -/
theorem involutiveCompression_wall :
    InvolutiveCompression (toC Wwall) (toC Bfix) (toC Afix) where
  iso := by rw [toC_conjTranspose, ← toC_mul, Bfix_iso, toC_one]
  intertwine := by rw [← toC_mul, ← toC_mul, Wwall_Bfix]
  selfadj := by rw [toC_conjTranspose, ← Afix_selfadj]
  unit := by rw [toC_conjTranspose, ← toC_mul, Wwall_orthogonal, toC_one]

/-- **The main C-rung-6 conclusion (composed).**  The derived two-wall walk has
an exact `−1` mode *and* an exact `+1` mode, forced by the self-adjointness of
its fixed-leg compression — with `det = +1` throughout (the determinant routes
stay closed).  The zero-wall control and the four-wall walk carry no such
compression, hence no forced mode. -/
theorem twoWall_protected_modes :
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC Wwall).mulVec V = -V) ∧
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC Wwall).mulVec V = V) := by
  refine ⟨?_, ?_⟩
  · exact involutive_compression_flip_mode involutiveCompression_wall
      (fun h => Afix_ne_one (toC_injective (by rw [h, toC_one])))
  · exact involutive_compression_fixed_mode involutiveCompression_wall
      (fun h => Afix_ne_neg_one (toC_injective (by rw [toC_neg, toC_one, h])))

end PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
