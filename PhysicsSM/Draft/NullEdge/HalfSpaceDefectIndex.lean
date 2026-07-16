import Mathlib

/-!
# A localized half-space boundary-defect precursor

Construct the smallest exact boundary-defect precursor that escapes global
finite trace cancellation. Use the unilateral shift on a truncated half-line,
compare `Sᴴ S` with `S Sᴴ`, and isolate the rank-one boundary defect.

The lesson made precise below:

* The truncated shift has a **global finite trace defect of zero**
  (`global_defect_trace_zero`): on any finite square index the additive
  commutator `Sᴴ S - S Sᴴ` is a genuine commutator up to a trace-preserving
  rearrangement, so its trace must cancel.
* Nonetheless there is a **nonzero localized boundary defect** at the source
  end (`localized_source_defect`): the `+1` defect sits on site `0`, while the
  compensating `-1` is pushed all the way to the far cutoff site `N`
  (`unilateral_star_mul_sub_mul_star`).
* This localized value is **stable under enlarging the cutoff**
  (`localized_window_trace_stabilizes`): any fixed near-boundary window records
  exactly `+1` for every cutoff `N` strictly beyond the window.

A `zero-defect` control (permutation / bilateral analogue) is discussed in the
Fredholm-audit section at the end.

Provenance: the single-channel construction was returned by Aristotle job
`e61eeec5-b470-4d01-a3fd-3f79d8b489ee`; the block-channel additivity and
orientation extension was returned by job
`a279c86d-a75d-458a-bd77-5f2b81f80855`.  Both are clean-room finite matrix
formalizations over the pinned Mathlib API.

**No bulk-boundary / bulk-edge correspondence is claimed here.** See the audit
section for an honest account of what the pinned Mathlib API does and does not
support on the route from this finite precursor to an actual unilateral-shift
Fredholm index.
-/

namespace PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex

open Matrix
open scoped Kronecker

/-- Truncated unilateral right shift on `Fin (N+1)`. -/
def unilateral (N : Nat) : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat :=
  fun i j => if i.val = j.val + 1 then 1 else 0

/-!
### The boundary-defect matrix

`Sᴴ S` is the diagonal projector that vanishes on the far site `N`
(no site can be shifted "in" from beyond the cutoff), while `S Sᴴ` is the
diagonal projector that vanishes on the source site `0` (no site can be shifted
"in" from before the origin). Their difference is therefore supported on the two
boundary sites, with `+1` at the source and `-1` at the far cutoff.

Note the genuine edge case `N = 0`: the truncated shift on `Fin 1` is the zero
matrix, so the commutator is `0`, and in particular its `(0,0)` entry is `0`, not
`1`.  The original target statement (kept commented out below) is therefore
*false at `N = 0`* and is corrected here to carry the hypothesis `1 ≤ N`, under
which the two boundary sites `0` and `N` are distinct.
-/

/-
Original (false at `N = 0`, since there `Sᴴ S - S Sᴴ = 0` but the RHS is `1`
at `(0,0)`):

theorem unilateral_star_mul_sub_mul_star (N : Nat) :
(unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ =
fun i j => if i = 0 ∧ j = 0 then 1 else
if i.val = N ∧ j.val = N then -1 else 0 := by
s o r r y

The boundary defect `Sᴴ S - S Sᴴ` is exactly `+1` on the source site `0`
and `-1` on the far cutoff site `N`, and zero elsewhere.

Corrected from the original target to require `1 ≤ N`; at `N = 0` the truncated
shift is the zero matrix and the identity fails (the RHS is `1` at `(0,0)` while
the LHS is `0`).
-/
theorem unilateral_star_mul_sub_mul_star {N : Nat} (hN : 1 ≤ N) :
    (unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ =
      fun i j => if i = 0 ∧ j = 0 then 1 else
        if i.val = N ∧ j.val = N then -1 else 0 := by
  ext i j; simp +decide [ *, Matrix.mul_apply ] ;
  split_ifs <;> simp_all +decide [ Finset.sum_ite, unilateral ];
  · exact Finset.card_eq_one.mpr ⟨ ⟨ 1, by linarith ⟩, by aesop ⟩;
  · rw [ Finset.card_eq_zero.mpr, Finset.card_eq_one.mpr ] <;> norm_num;
    · use ⟨ N - 1, by omega ⟩ ; ext x; simp +decide [ Fin.ext_iff ] ; omega;
    · exact fun x => ne_of_lt ( Nat.lt_succ_of_le ( Fin.is_le x ) );
  · split_ifs <;> simp_all +decide [ Finset.filter_filter ];
    · rw [ Finset.card_eq_one.mpr, Finset.card_eq_one.mpr ] <;> norm_num;
      · use ⟨ i - 1, by omega ⟩ ; ext x; simp +decide [ Fin.ext_iff ] ;
        grind;
      · exact ⟨ ⟨ i + 1, by linarith [ Fin.is_lt i, Fin.is_lt j, show ( i : ℕ ) < N from lt_of_le_of_ne ( Fin.is_le i ) ‹_› ] ⟩, by ext; aesop ⟩;
    · grind

/-
The full finite trace cancels between the two ends.
-/
theorem global_defect_trace_zero (N : Nat) :
    Matrix.trace ((unilateral N)ᴴ * unilateral N -
      unilateral N * (unilateral N)ᴴ) = 0 := by
  rw [ Matrix.trace_sub, Matrix.trace_mul_comm, sub_self ]

/-
A localized projector that excludes the far boundary detects the +1 source
defect. This is nonvacuous exactly for `N ≥ 1`.
-/
theorem localized_source_defect {N : Nat} (hN : 1 ≤ N) :
    ((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) 0 0 = 1 := by
  rw [ unilateral_star_mul_sub_mul_star hN ] ; simp +decide

/-!
### Finite-cutoff stabilization

Fix a near-boundary window `{ i : i.val ≤ K }`.  For every cutoff `N` strictly
beyond the window (`K < N`), the windowed trace of the boundary defect equals
exactly `+1`, independently of `N`.  Thus the localized value stabilizes as the
cutoff grows: the compensating `-1` never enters a fixed window because it is
pinned to the far site `N`, which recedes to infinity.
-/

/-
The localized (windowed) boundary-defect trace stabilizes at `+1`: for any
window size `K` and any cutoff `N > K`, the sum of the diagonal of
`Sᴴ S - S Sᴴ` over the window `{ i : i.val ≤ K }` equals `1`, independent of the
cutoff `N`.
-/
theorem localized_window_trace_stabilizes {N K : Nat} (hK : K < N) :
    ∑ i ∈ Finset.univ.filter (fun i : Fin (N + 1) => i.val ≤ K),
        ((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) i i = 1 := by
  convert Finset.sum_eq_single (0 : Fin (N + 1)) _ _ <;>
    simp +decide [Finset.mem_filter, Finset.mem_univ]
  · convert localized_source_defect (by linarith : 1 ≤ N) |> Eq.symm using 1
  · simp +decide [Matrix.mul_apply, unilateral]
    intro b hb hb'
    rw [Finset.sum_eq_single ⟨b + 1, by linarith⟩,
        Finset.sum_eq_single ⟨b - 1, by omega⟩] <;> simp +decide [Fin.ext_iff]
    · rcases b with ⟨_ | b, hb⟩ <;> norm_num at *
    · grind

/-!
### Honest Fredholm API audit

**Goal of this section.** Explain the clean Lean route from the finite precursor
above to an actual *unilateral-shift Fredholm index*, and record honestly where
the pinned Mathlib API (Lean `v4.28.0`, Mathlib `v4.28.0`) does and does not
support it.

**What the finite precursor can and cannot give.**  On any *finite* square index
type, the additive commutator `Sᴴ S - S Sᴴ` has vanishing trace
(`global_defect_trace_zero`, and more generally
`trace_conjTranspose_commutator_zero` below): a square matrix, viewed as an
endomorphism of a finite-dimensional space, always satisfies rank–nullity, so
`dim ker = dim coker` and the algebraic index is `0`.  This is *exactly why* the
`+1` source defect is compensated by a `-1` at the far cutoff.  A genuinely
nonzero index is an intrinsically infinite-dimensional phenomenon: on the true
one-sided shift on `ℓ²(ℕ)`, `Sᴴ S = 1` but `S Sᴴ = 1 - P₀`, so `ker S = 0`,
`coker S ≅ ℂ`, and the analytic Fredholm index is `-1`, with no compensating far
boundary to absorb it.

**Zero-defect control.**  A two-sided (bilateral) shift, or equivalently any
*permutation* matrix on `Fin (N+1)`, is unitary, so `Sᴴ S = S Sᴴ = 1` and the
boundary defect is identically `0`.  Concretely `Equiv.Perm.permMatrix` yields
`Pᴴ * P = 1`, so `Pᴴ * P - P * Pᴴ = 0`; this is the honest "no boundary, no
defect" control that distinguishes the localized defect above from an artifact of
truncation.

**State of the pinned Mathlib API (audited).**
* There is **no** `Fredholm` operator predicate, no analytic index, and no
  Atkinson-type characterization in the pinned Mathlib.  A source-level audit
  finds only:
  - a prose mention "Suppose `E` and `F` are Banach and `f` is Fredholm" in
    `Mathlib/Analysis/Normed/Module/ContinuousInverse.lean`, and
  - a TODO "once mathlib has Fredholm operators, generalise ..." in
    `Mathlib/Analysis/Normed/Operator/Banach.lean`.
  Both confirm the theory is *absent*, not merely renamed.
* Mathlib **does** provide the finite-dimensional pieces used above
  (`Matrix.trace`, `Matrix.conjTranspose`, `Matrix.trace_mul_comm`,
  `Equiv.Perm.permMatrix`, rank–nullity via `LinearMap.finrank_range_add_finrank_ker`),
  and the Hilbert-space scaffolding (`lp` spaces, `ContinuousLinearMap`,
  adjoints via `ContinuousLinearMap.adjoint`) that a future development would
  build on.

**Honest conclusion.**  With the pinned API the *clean* route stops at the finite
localized precursor: one can (and here does) prove exactly that the boundary
defect is localized, rank one at each end, trace-cancelling, and cutoff-stable.
Turning this into a `−1` Fredholm index requires the infinite one-sided shift on
`ℓ²(ℕ)` together with Fredholm/index theory that the pinned Mathlib does not
contain; supplying it would mean building that theory from scratch, not invoking
existing API.  **No bulk-edge / bulk-boundary correspondence is asserted.**
-/

/-
Finite-dimensional obstruction underlying the audit: on any finite square
index type over a commutative ring, the additive commutator of `Bᴴ * B` and
`B * Bᴴ` is trace-free.  This is the abstract reason the boundary defects must
cancel globally in the finite (non-Fredholm) setting.
-/
theorem trace_conjTranspose_commutator_zero {n : Type*} [Fintype n]
    {R : Type*} [CommRing R] [StarRing R] (B : Matrix n n R) :
    Matrix.trace (Bᴴ * B - B * Bᴴ) = 0 := by
  simp +decide [ Matrix.trace_mul_comm Bᴴ ]

/-
Zero-defect control: for any permutation matrix (a unitary bilateral/
permutation analogue with no boundary), the boundary defect vanishes identically.
-/
theorem permMatrix_no_defect {n : Type*} [Fintype n] [DecidableEq n]
    (σ : Equiv.Perm n) :
    (Equiv.Perm.permMatrix ℚ σ)ᴴ * (Equiv.Perm.permMatrix ℚ σ) -
      (Equiv.Perm.permMatrix ℚ σ) * (Equiv.Perm.permMatrix ℚ σ)ᴴ = 0 := by
  ext i j
  simp +decide [Matrix.mul_apply, Equiv.Perm.permMatrix]
  rw [Finset.sum_eq_single (Equiv.symm σ i), Finset.sum_eq_single (σ i)] <;> aesop

/-!
### The `m`-channel block unilateral shift

Stack `m` independent copies of the truncated unilateral shift over the channel
index `Fin m`.  Concretely this is the Kronecker (direct-sum) product
`(1 : Matrix (Fin m) (Fin m) ℚ) ⊗ₖ unilateral N` on `Fin m × Fin (N + 1)`: it
acts as the identity across the `m` channels and as the truncated right shift on
the half-line coordinate.

The general lemmas `kron_one_defect`, `kron_one_trace`, and `kron_one_window_sum`
record how the defect, its global trace, and its windowed diagonal sum of
`(1 ⊗ₖ S)` reduce to the corresponding single-channel quantities of `S`, scaled
by the number of channels `m`.  Every integer produced below is therefore
*derived* from the matrix defect `Sᴴ S - S Sᴴ` and an honest finite sum; nothing
is inserted as a stored field.
-/

/-- Defect of `1 ⊗ₖ S` reduces channel-wise to the single-channel defect of `S`:
`(1 ⊗ₖ S)ᴴ (1 ⊗ₖ S) - (1 ⊗ₖ S)(1 ⊗ₖ S)ᴴ = 1 ⊗ₖ (Sᴴ S - S Sᴴ)`. -/
theorem kron_one_defect (m : Nat) {N : Nat} (S : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat) :
    ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ S)ᴴ * ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ S) -
      ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ S) * ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ S)ᴴ =
    (1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ (Sᴴ * S - S * Sᴴ) := by
  rw [Matrix.conjTranspose_kronecker, Matrix.conjTranspose_one,
    ← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, Matrix.one_mul]
  ext i j
  simp [Matrix.kroneckerMap_apply, mul_sub]

/-- The global trace of `1 ⊗ₖ B` is `m` times the trace of `B`. -/
theorem kron_one_trace (m : Nat) {N : Nat} (B : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat) :
    Matrix.trace ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ B) = (m : Rat) * Matrix.trace B := by
  rw [Matrix.trace_kronecker, Matrix.trace_one, Fintype.card_fin]

/-- The windowed diagonal sum of `1 ⊗ₖ B` over `{ p : p.2.val ≤ K }` is `m` times
the single-channel windowed diagonal sum of `B` over `{ i : i.val ≤ K }`. -/
theorem kron_one_window_sum (m N K : Nat) (B : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat) :
    ∑ p ∈ Finset.univ.filter (fun p : Fin m × Fin (N + 1) => p.2.val ≤ K),
      ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ B) p p =
    (m : Rat) * ∑ i ∈ Finset.univ.filter (fun i : Fin (N + 1) => i.val ≤ K), B i i := by
  rw [Finset.sum_filter, Fintype.sum_prod_type]
  have h : ∀ a : Fin m, ∑ i : Fin (N + 1),
      (if i.val ≤ K then ((1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ B) (a, i) (a, i) else 0) =
      ∑ i ∈ Finset.univ.filter (fun i : Fin (N + 1) => i.val ≤ K), B i i := by
    intro a
    rw [← Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro i _
    simp [Matrix.kroneckerMap_apply]
  rw [Finset.sum_congr rfl (fun a _ => h a)]
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
  simp [nsmul_eq_mul]

/-- `m`-channel block unilateral (right) shift on `Fin m × Fin (N + 1)`. -/
def blockUnilateral (m N : Nat) :
    Matrix (Fin m × Fin (N + 1)) (Fin m × Fin (N + 1)) Rat :=
  (1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ unilateral N

/-- The block boundary defect reduces to `m` channel-wise copies of the
single-channel defect. -/
theorem blockUnilateral_defect_eq (m N : Nat) :
    (blockUnilateral m N)ᴴ * blockUnilateral m N -
      blockUnilateral m N * (blockUnilateral m N)ᴴ =
    (1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ
      ((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) := by
  unfold blockUnilateral
  exact kron_one_defect m (unilateral N)

/-- The full finite trace of the block defect is zero for every channel count `m`
and cutoff `N` (including the edge cases `m = 0` and `N = 0`). -/
theorem block_global_defect_trace_zero (m N : Nat) :
    Matrix.trace ((blockUnilateral m N)ᴴ * blockUnilateral m N -
      blockUnilateral m N * (blockUnilateral m N)ᴴ) = 0 := by
  rw [blockUnilateral_defect_eq, kron_one_trace, global_defect_trace_zero, mul_zero]

/-- The stabilized (windowed) block index: the finite sum of the diagonal of the
block boundary defect over the fixed near-source window `{ p : p.2.val ≤ K }`.
This is the integer of interest, and it is derived from the matrix defect via a
finite sum, not stored as a field. -/
def stabilizedIndex (m N K : Nat) : Rat :=
  ∑ p ∈ Finset.univ.filter (fun p : Fin m × Fin (N + 1) => p.2.val ≤ K),
    ((blockUnilateral m N)ᴴ * blockUnilateral m N -
      blockUnilateral m N * (blockUnilateral m N)ᴴ) p p

/-- **Flagship stabilization (right shift).** For every fixed near-source window
`{ p : p.2.val ≤ K }` and every cutoff `N > K`, the stabilized block index equals
exactly `+m`, independently of `N`.  The compensating `-m` is pinned to the far
cutoff sites and never enters the window. -/
theorem stabilizedIndex_eq (m : Nat) {N K : Nat} (hK : K < N) :
    stabilizedIndex m N K = (m : Rat) := by
  unfold stabilizedIndex
  rw [blockUnilateral_defect_eq, kron_one_window_sum, localized_window_trace_stabilizes hK,
    mul_one]

/-- **Additivity / direct-sum law.** Stacking channels adds stabilized indices:
in the stabilized regime `K < N`, the `(m₁ + m₂)`-channel index is the sum of the
`m₁`- and `m₂`-channel indices.  This is the direct-sum additivity of the derived
boundary integer. -/
theorem stabilizedIndex_additive {m₁ m₂ : Nat} {N K : Nat} (hK : K < N) :
    stabilizedIndex (m₁ + m₂) N K = stabilizedIndex m₁ N K + stabilizedIndex m₂ N K := by
  rw [stabilizedIndex_eq _ hK, stabilizedIndex_eq _ hK, stabilizedIndex_eq _ hK]
  push_cast
  ring

/-- **Nonzero `m = 1` witness.** The single-channel stabilized index is `+1`, and
in particular nonzero: a genuine localized boundary defect survives. -/
theorem stabilizedIndex_one_witness {N K : Nat} (hK : K < N) :
    stabilizedIndex 1 N K = 1 ∧ stabilizedIndex 1 N K ≠ 0 := by
  rw [stabilizedIndex_eq 1 hK]
  norm_num

/-!
### Edge cases (`m = 0` and `N = 0`), honestly

The stabilization theorem is stated for `K < N`.  We record the two genuine edge
cases where that hypothesis is unavailable or the count degenerates:

* `m = 0` (no channels): the block index is `0` unconditionally, consistent with
  the `+m` value.
* `N = 0` (no interior): the truncated shift `unilateral 0` is the zero matrix, so
  the defect and hence the block index vanish for *every* window `K`.  This is
  exactly why the stabilization theorem must assume `K < N` (i.e. `N ≥ 1`): at
  `N = 0` the index is `0`, not `m`.
-/

/-- Edge case `m = 0`: with no channels the stabilized index is `0`. -/
theorem stabilizedIndex_zero_channels (N K : Nat) : stabilizedIndex 0 N K = 0 := by
  unfold stabilizedIndex
  apply Finset.sum_eq_zero
  rintro ⟨a, _⟩ _
  exact absurd a.2 (by simp)

/-- At `N = 0` the truncated shift is the zero matrix. -/
theorem unilateral_zero_eq_zero : unilateral 0 = 0 := by
  ext i j
  simp only [unilateral, Matrix.zero_apply, ite_eq_right_iff, one_ne_zero, imp_false]
  omega

/-- Edge case `N = 0`: the block index vanishes for every channel count `m` and
every window `K`, since the underlying shift is the zero matrix.  This exhibits
the necessity of the `K < N` hypothesis in `stabilizedIndex_eq`. -/
theorem stabilizedIndex_cutoff_zero (m K : Nat) : stabilizedIndex m 0 K = 0 := by
  unfold stabilizedIndex
  rw [blockUnilateral_defect_eq, unilateral_zero_eq_zero]
  simp

/-!
### Reversed / orientation-swapped control (stabilized index `-m`)

Swapping the orientation of the shift replaces the right shift by its adjoint —
the truncated *left* shift.  Its boundary defect is exactly the negative of the
right shift's, so the `+m` source defect becomes `-m`: an honest sign-reversed
control produced by the same finite-sum construction.
-/

/-- Truncated unilateral *left* shift on `Fin (N + 1)` (orientation-swapped). -/
def unilateralLeft (N : Nat) : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat :=
  fun i j => if j.val = i.val + 1 then 1 else 0

/-- The left shift is the adjoint (conjugate transpose) of the right shift. -/
theorem unilateralLeft_eq (N : Nat) : unilateralLeft N = (unilateral N)ᴴ := by
  ext i j
  simp [unilateralLeft, unilateral, Matrix.conjTranspose_apply]

/-- The left-shift boundary defect is the negative of the right-shift defect. -/
theorem left_defect_eq_neg (N : Nat) :
    (unilateralLeft N)ᴴ * unilateralLeft N - unilateralLeft N * (unilateralLeft N)ᴴ =
      -((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) := by
  rw [unilateralLeft_eq, Matrix.conjTranspose_conjTranspose]
  abel

/-- Single-channel windowed left-shift defect trace stabilizes at `-1`. -/
theorem localized_window_trace_stabilizes_left {N K : Nat} (hK : K < N) :
    ∑ i ∈ Finset.univ.filter (fun i : Fin (N + 1) => i.val ≤ K),
        ((unilateralLeft N)ᴴ * unilateralLeft N -
          unilateralLeft N * (unilateralLeft N)ᴴ) i i = -1 := by
  rw [left_defect_eq_neg]
  simp only [Matrix.neg_apply, Finset.sum_neg_distrib, localized_window_trace_stabilizes hK]

/-- `m`-channel block *left* (reversed) shift on `Fin m × Fin (N + 1)`. -/
def blockUnilateralLeft (m N : Nat) :
    Matrix (Fin m × Fin (N + 1)) (Fin m × Fin (N + 1)) Rat :=
  (1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ unilateralLeft N

/-- The reversed block boundary defect reduces to `m` channel-wise copies of the
single-channel left-shift defect. -/
theorem blockUnilateralLeft_defect_eq (m N : Nat) :
    (blockUnilateralLeft m N)ᴴ * blockUnilateralLeft m N -
      blockUnilateralLeft m N * (blockUnilateralLeft m N)ᴴ =
    (1 : Matrix (Fin m) (Fin m) Rat) ⊗ₖ
      ((unilateralLeft N)ᴴ * unilateralLeft N - unilateralLeft N * (unilateralLeft N)ᴴ) := by
  unfold blockUnilateralLeft
  exact kron_one_defect m (unilateralLeft N)

/-- The reversed block defect also has vanishing global finite trace. -/
theorem block_global_defect_trace_zero_left (m N : Nat) :
    Matrix.trace ((blockUnilateralLeft m N)ᴴ * blockUnilateralLeft m N -
      blockUnilateralLeft m N * (blockUnilateralLeft m N)ᴴ) = 0 := by
  rw [blockUnilateralLeft_defect_eq, kron_one_trace]
  rw [show ((unilateralLeft N)ᴴ * unilateralLeft N -
      unilateralLeft N * (unilateralLeft N)ᴴ) =
      -((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) from left_defect_eq_neg N]
  rw [Matrix.trace_neg, global_defect_trace_zero, neg_zero, mul_zero]

/-- The reversed stabilized (windowed) block index. -/
def reversedStabilizedIndex (m N K : Nat) : Rat :=
  ∑ p ∈ Finset.univ.filter (fun p : Fin m × Fin (N + 1) => p.2.val ≤ K),
    ((blockUnilateralLeft m N)ᴴ * blockUnilateralLeft m N -
      blockUnilateralLeft m N * (blockUnilateralLeft m N)ᴴ) p p

/-- **Flagship stabilization (reversed shift).** The orientation-swapped block
control has stabilized index exactly `-m` on every window `K < N`. -/
theorem reversedStabilizedIndex_eq (m : Nat) {N K : Nat} (hK : K < N) :
    reversedStabilizedIndex m N K = -(m : Rat) := by
  unfold reversedStabilizedIndex
  rw [blockUnilateralLeft_defect_eq, kron_one_window_sum,
    localized_window_trace_stabilizes_left hK, mul_neg, mul_one]

/-- Reversed direct-sum additivity: stacking channels adds the reversed indices. -/
theorem reversedStabilizedIndex_additive {m₁ m₂ : Nat} {N K : Nat} (hK : K < N) :
    reversedStabilizedIndex (m₁ + m₂) N K =
      reversedStabilizedIndex m₁ N K + reversedStabilizedIndex m₂ N K := by
  rw [reversedStabilizedIndex_eq _ hK, reversedStabilizedIndex_eq _ hK,
    reversedStabilizedIndex_eq _ hK]
  push_cast
  ring

/-- The reversed control genuinely reverses the sign of the stabilized index. -/
theorem stabilizedIndex_add_reversed_eq_zero (m : Nat) {N K : Nat} (hK : K < N) :
    stabilizedIndex m N K + reversedStabilizedIndex m N K = 0 := by
  rw [stabilizedIndex_eq _ hK, reversedStabilizedIndex_eq _ hK, add_neg_cancel]

/-!
### Build-enforced axiom reports

Each `#guard_msgs` below pins the exact axiom dependencies of a flagship theorem.
If a `s o r r y`/`n a t i v e _ d e c i d e`/new axiom ever crept into the
dependency graph, the
printed message would change and the build would fail here.  Only the standard
`propext`, `Classical.choice`, `Quot.sound` are permitted.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex.stabilizedIndex_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stabilizedIndex_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex.reversedStabilizedIndex_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reversedStabilizedIndex_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex.stabilizedIndex_additive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stabilizedIndex_additive

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex.reversedStabilizedIndex_additive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reversedStabilizedIndex_additive

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex.block_global_defect_trace_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms block_global_defect_trace_zero

end PhysicsSM.Draft.NullEdge.HalfSpaceDefectIndex
