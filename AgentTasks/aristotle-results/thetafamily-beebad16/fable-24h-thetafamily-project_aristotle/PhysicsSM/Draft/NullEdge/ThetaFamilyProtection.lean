import Mathlib
import context.ModeInvariantHalfWinding
import context.HalfPeriodInvariant
import context.PinnedMirrorChart

/-!
# θ-family involution protection (Paper C stability, rank-1 target)

Kernel-only (standard three axioms; **no** `native_decide` anywhere in this
file — the whole point is to replace the finite-fixture `native_decide`
decisions of the context modules with *symbolic* real-trigonometric identities
that hold for the **entire** coin/mass family `θ : ℝ`).

## The θ-parametrized walk

We parametrize the split-step coin by a real angle `θ`.  For a sign pattern
`b : Fin 4 → Bool` the walk is the palindromic `W(b,θ) = S · C(θ,b) · S`
(`Wth`), where `S = shiftR` is the conditional shift (context `shiftQ`,
transported to `ℝ`) and `C(θ,b) = coinR θ b` is the site-wise rotation coin
with cosine field `cos θ` and sitewise *signed* sine field
`x ↦ sign(b x) · sin θ`, `sign(b x) = ±1` (`signB`).  This is exactly the
context's `walkQ (cos θ) (fun x => sign(b x) · sin θ)` construction, but over
`ℝ` (the context `walkQ` is typed over `ℚ`, so a *literal* `walkQ (cos θ) …`
equation is ill-typed; instead we prove the faithful closed form `Wth_eq_Wexp`
so that the walk is pinned to a single explicit `8×8` matrix and nothing is
forked silently).

Every algebraic identity below reduces to the Pythagorean identity
`Real.sin_sq_add_cos_sq` (and `signB x * signB x = 1`); each negative control
fails by an explicit `2·sin θ` matrix entry.

## Theorem ladder (all quantified over ALL `θ : ℝ`)

* `T1` `block_involution_family` — the four block fields: `W(b,θ)` is symmetric
  and `W·W = 1`.
* `T2` `chart13_involution_family` — protected singletons in chart `{1,3}`:
  `M13 = Bfixᵀ W Bfix` is symmetric, `M13·M13 = 1`, `tr M13 = 0`, and
  `W·Bfix = Bfix·M13`.
* `T3` `chart02_involution_family` — blind singletons in chart `{0,2}` (with
  `Bfix0`): the same four facts.
* `T4` `modes_persist` — for every `θ` and every two-wall field, the complete
  walk `W(b,θ)` over `ℂ` has a nonzero `+1` eigenvector and a nonzero `−1`
  eigenvector.  The certified modes persist for the whole family `θ`.
* `T5` negative controls — the blind singleton `[+,+,+,-]`, the zero-wall field
  `[+,+,+,+]`, and the four-wall field `[+,-,+,-]` all have
  `(M13 − M13ᵀ)(0,1) = −2·sin θ` in the *wrong* chart `{1,3}`; hence
  self-adjointness fails there for every `θ` with `sin θ ≠ 0`.
* `T6` massless boundary — at `sin θ = 0` the controls vanish, so the
  chart-failure claims are scoped to the massive family `sin θ ≠ 0`.

The engine (`InvolutiveCompression`, `involutive_compression_fixed_mode` /
`_flip_mode`) is the landed one from `ModeInvariantHalfWinding`; only the
`ℚ → ℂ` transport is replaced by the `ℝ → ℂ` transport `toCR`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ThetaFamilyProtection

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open scoped Classical

set_option maxHeartbeats 8000000

/-! ## 0.  The register, sign function, and the θ-parametrized walk -/

/-- The eight-dimensional register `Fin 4 × Fin 2` (four sites, two chiralities),
matching the context register `ModeInvariantHalfWinding.V8`. -/
abbrev V8 := Fin 4 × Fin 2

/-- The `±1` sign of a boolean: `true ↦ 1`, `false ↦ -1`. -/
def signB (b : Bool) : ℝ := if b then 1 else -1

@[simp] lemma signB_sq (b : Bool) : signB b * signB b = 1 := by cases b <;> simp [signB]

/-- `signB x + signB y = 0` exactly when the two signs differ. -/
lemma signB_add_eq_zero_iff (x y : Bool) : signB x + signB y = 0 ↔ x ≠ y := by
  cases x <;> cases y <;> simp [signB]

/-- The conditional shift `S` over `ℝ` (the context `shiftQ`, transported). -/
def shiftR : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.2 = j.2 then
    (if i.1 = (if j.2 = 0 then (![1,2,3,0] : Fin 4 → Fin 4) j.1
               else (![3,0,1,2] : Fin 4 → Fin 4) j.1) then (1 : ℝ) else 0) else 0

/-- The θ-parametrized rotation coin `C(θ,b)` with cosine `cos θ` and sitewise
signed sine `x ↦ signB (b x) · sin θ` (the context `coinQ (cos θ) (signed sin)`
over `ℝ`). -/
def coinR (theta : ℝ) (b : Fin 4 → Bool) : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  if i.1 = j.1 then
    (if i.2 = j.2 then Real.cos theta
     else (if i.2 = 0 then - (signB (b i.1) * Real.sin theta)
           else (signB (b i.1) * Real.sin theta))) else 0

/-- **The θ-parametrized palindromic walk** `W(b,θ) = S · C(θ,b) · S`. -/
def Wth (theta : ℝ) (b : Fin 4 → Bool) : Matrix V8 V8 ℝ := shiftR * coinR theta b * shiftR

/-- The signed sine value at a site. -/
def sfun (theta : ℝ) (b : Fin 4 → Bool) (k : Fin 4) : ℝ := signB (b k) * Real.sin theta

/-- The explicit closed form of the walk (a single `8×8` matrix). -/
def Wexp (theta : ℝ) (b : Fin 4 → Bool) : Matrix V8 V8 ℝ := Matrix.of fun i j =>
  let c := Real.cos theta
  match j.2, i.2 with
  | 0, 0 => if i.1 = j.1 + 2 then c else 0
  | 0, 1 => if i.1 = j.1 then sfun theta b (j.1 + 1) else 0
  | 1, 0 => if i.1 = j.1 then - sfun theta b (j.1 + 3) else 0
  | 1, 1 => if i.1 = j.1 + 2 then c else 0

/-- **Compatibility (single closed form).**  The palindromic product
`S · C(θ,b) · S` equals the explicit matrix `Wexp`.  This is the one bridge
lemma requested by the discipline: the walk is not forked, it is pinned to a
concrete matrix so all downstream identities are trig-polynomial. -/
theorem Wth_eq_Wexp (theta : ℝ) (b : Fin 4 → Bool) : Wth theta b = Wexp theta b := by
  unfold Wth Wexp shiftR coinR sfun signB
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two]

/-! ## 1.  Fixed-leg isometries and compressions for the two charts -/

/-- Isometry onto the reflection-**fixed** legs of the `{1,3}` chart
(sites `1,3`, both chiralities), transporting the context `Bfix`. -/
def BfixR : Matrix V8 (Fin 4) ℝ := Matrix.of fun x j =>
  if x = (![(1,0),(1,1),(3,0),(3,1)] : Fin 4 → V8) j then 1 else 0

/-- Isometry onto the fixed legs of the mirror `{0,2}` chart (sites `0,2`),
transporting the context `Bfix0`. -/
def Bfix0R : Matrix V8 (Fin 4) ℝ := Matrix.of fun x j =>
  if x = (![(0,0),(0,1),(2,0),(2,1)] : Fin 4 → V8) j then 1 else 0

/-- The `{1,3}`-chart compression `M13(b,θ) = Bfixᵀ · W(b,θ) · Bfix`. -/
def M13 (theta : ℝ) (b : Fin 4 → Bool) : Matrix (Fin 4) (Fin 4) ℝ :=
  BfixRᵀ * Wth theta b * BfixR

/-- The `{0,2}`-chart compression `M02(b,θ) = Bfix0ᵀ · W(b,θ) · Bfix0`. -/
def M02 (theta : ℝ) (b : Fin 4 → Bool) : Matrix (Fin 4) (Fin 4) ℝ :=
  Bfix0Rᵀ * Wth theta b * Bfix0R

/-! ## 2.  Structural family facts (hold for **every** field `b` and every `θ`) -/

/-- `BfixR` is an isometry. -/
theorem iso13 : BfixRᵀ * BfixR = (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  unfold BfixR; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply]

/-- `Bfix0R` is an isometry. -/
theorem iso02 : Bfix0Rᵀ * Bfix0R = (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  unfold Bfix0R; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply]

/-- The `{1,3}` sector is `W`-invariant for every field: `W·Bfix = Bfix·M13`. -/
theorem intertwine13 (theta : ℝ) (b : Fin 4 → Bool) :
    Wth theta b * BfixR = BfixR * M13 theta b := by
  unfold M13 Wth shiftR coinR BfixR; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two, Fin.sum_univ_four]

/-- The `{0,2}` sector is `W`-invariant for every field: `W·Bfix0 = Bfix0·M02`. -/
theorem intertwine02 (theta : ℝ) (b : Fin 4 → Bool) :
    Wth theta b * Bfix0R = Bfix0R * M02 theta b := by
  unfold M02 Wth shiftR coinR Bfix0R; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two, Fin.sum_univ_four]

/-- **The walk is orthogonal for every field and every `θ`** (`Wᵀ W = 1`);
this is the first place the Pythagorean identity is used. -/
theorem Wth_orthogonal (theta : ℝ) (b : Fin 4 → Bool) :
    (Wth theta b)ᵀ * Wth theta b = 1 := by
  unfold Wth shiftR coinR; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type,
      Fin.sum_univ_two, Fin.sum_univ_four] <;>
    nlinarith [Real.sin_sq_add_cos_sq theta, signB_sq (b 0), signB_sq (b 1),
      signB_sq (b 2), signB_sq (b 3)]

/-- The `{1,3}` compression is orthogonal for every field (`M13ᵀ M13 = 1`). -/
theorem M13_orthogonal (theta : ℝ) (b : Fin 4 → Bool) :
    (M13 theta b)ᵀ * M13 theta b = 1 := by
  unfold M13 Wth shiftR coinR BfixR; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type,
      Fin.sum_univ_two, Fin.sum_univ_four] <;>
    nlinarith [Real.sin_sq_add_cos_sq theta, signB_sq (b 0), signB_sq (b 1),
      signB_sq (b 2), signB_sq (b 3)]

/-- The `{0,2}` compression is orthogonal for every field (`M02ᵀ M02 = 1`). -/
theorem M02_orthogonal (theta : ℝ) (b : Fin 4 → Bool) :
    (M02 theta b)ᵀ * M02 theta b = 1 := by
  unfold M02 Wth shiftR coinR Bfix0R; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type,
      Fin.sum_univ_two, Fin.sum_univ_four] <;>
    nlinarith [Real.sin_sq_add_cos_sq theta, signB_sq (b 0), signB_sq (b 1),
      signB_sq (b 2), signB_sq (b 3)]

/-- The `{1,3}` compression is traceless for every field. -/
theorem M13_trace (theta : ℝ) (b : Fin 4 → Bool) : (M13 theta b).trace = 0 := by
  unfold M13 Wth shiftR coinR BfixR
  simp [Matrix.trace, Matrix.diag, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two,
    Fin.sum_univ_four]

/-- The `{0,2}` compression is traceless for every field. -/
theorem M02_trace (theta : ℝ) (b : Fin 4 → Bool) : (M02 theta b).trace = 0 := by
  unfold M02 Wth shiftR coinR Bfix0R
  simp [Matrix.trace, Matrix.diag, Matrix.mul_apply, Fintype.sum_prod_type, Fin.sum_univ_two,
    Fin.sum_univ_four]

/-! ## 3.  Self-adjointness: the discriminating datum (the trig identity) -/

/-- **Chart `{1,3}` self-adjointness** holds exactly when the reflection-fixed
sites `0,2` carry opposite signs (`signB (b 0) + signB (b 2) = 0`, i.e.
`b 0 ≠ b 2`) — the positional protection criterion, now as a symbolic
trig-polynomial identity for all `θ`. -/
theorem M13_selfadj_of (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 0) + signB (b 2) = 0) : M13 theta b = (M13 theta b)ᵀ := by
  unfold M13 Wth shiftR coinR BfixR
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type, Fin.sum_univ_two] <;>
    first
      | linear_combination Real.sin theta * h
      | linear_combination (-Real.sin theta) * h

/-- **Chart `{0,2}` self-adjointness** holds exactly when the mirror fixed
sites `1,3` carry opposite signs (`signB (b 1) + signB (b 3) = 0`). -/
theorem M02_selfadj_of (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 1) + signB (b 3) = 0) : M02 theta b = (M02 theta b)ᵀ := by
  unfold M02 Wth shiftR coinR Bfix0R
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type, Fin.sum_univ_two] <;>
    first
      | linear_combination Real.sin theta * h
      | linear_combination (-Real.sin theta) * h

/-- **The walk itself is symmetric** exactly when both fixed axes carry opposite
signs (`b 0 ≠ b 2` and `b 1 ≠ b 3`) — the block condition. -/
theorem Wth_symm_of (theta : ℝ) (b : Fin 4 → Bool)
    (h1 : signB (b 0) + signB (b 2) = 0) (h2 : signB (b 1) + signB (b 3) = 0) :
    Wth theta b = (Wth theta b)ᵀ := by
  unfold Wth shiftR coinR
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type, Fin.sum_univ_two] <;>
    first
      | linear_combination Real.sin theta * h1
      | linear_combination (-Real.sin theta) * h1
      | linear_combination Real.sin theta * h2
      | linear_combination (-Real.sin theta) * h2

/-! ## 4.  Involution facts derived from self-adjointness + orthogonality -/

/-- A symmetric orthogonal matrix is an involution: `M13·M13 = 1`. -/
theorem M13_involution_of (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 0) + signB (b 2) = 0) : M13 theta b * M13 theta b = 1 := by
  have hsa := M13_selfadj_of theta b h
  have ho := M13_orthogonal theta b
  nth_rewrite 1 [hsa]; exact ho

/-- A symmetric orthogonal matrix is an involution: `M02·M02 = 1`. -/
theorem M02_involution_of (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 1) + signB (b 3) = 0) : M02 theta b * M02 theta b = 1 := by
  have hsa := M02_selfadj_of theta b h
  have ho := M02_orthogonal theta b
  nth_rewrite 1 [hsa]; exact ho

/-- The block walk is an involution: `W·W = 1`. -/
theorem Wth_involution_of (theta : ℝ) (b : Fin 4 → Bool)
    (h1 : signB (b 0) + signB (b 2) = 0) (h2 : signB (b 1) + signB (b 3) = 0) :
    Wth theta b * Wth theta b = 1 := by
  have hs := Wth_symm_of theta b h1 h2
  have ho := Wth_orthogonal theta b
  nth_rewrite 1 [hs]; exact ho

/-! ## T1.  Block involution family -/

/-- **T1 (general).**  For every field with both fixed axes anti-aligned
(`b 0 ≠ b 2` and `b 1 ≠ b 3` — the four block fields), the walk `W(b,θ)` is
symmetric and an involution, for **all** `θ`. -/
theorem block_involution_family (theta : ℝ) (b : Fin 4 → Bool)
    (h1 : signB (b 0) + signB (b 2) = 0) (h2 : signB (b 1) + signB (b 3) = 0) :
    Wth theta b = (Wth theta b)ᵀ ∧ Wth theta b * Wth theta b = 1 :=
  ⟨Wth_symm_of theta b h1 h2, Wth_involution_of theta b h1 h2⟩

/-- Block `++--`. -/
theorem block_involution_ppmm (theta : ℝ) :
    Wth theta ![true,true,false,false] = (Wth theta ![true,true,false,false])ᵀ ∧
    Wth theta ![true,true,false,false] * Wth theta ![true,true,false,false] = 1 :=
  block_involution_family theta _ (by simp [signB]) (by simp [signB])

/-- Block `--++`. -/
theorem block_involution_mmpp (theta : ℝ) :
    Wth theta ![false,false,true,true] = (Wth theta ![false,false,true,true])ᵀ ∧
    Wth theta ![false,false,true,true] * Wth theta ![false,false,true,true] = 1 :=
  block_involution_family theta _ (by simp [signB]) (by simp [signB])

/-- Block `+--+`. -/
theorem block_involution_pmmp (theta : ℝ) :
    Wth theta ![true,false,false,true] = (Wth theta ![true,false,false,true])ᵀ ∧
    Wth theta ![true,false,false,true] * Wth theta ![true,false,false,true] = 1 :=
  block_involution_family theta _ (by simp [signB]) (by simp [signB])

/-- Block `-++-`. -/
theorem block_involution_mppm (theta : ℝ) :
    Wth theta ![false,true,true,false] = (Wth theta ![false,true,true,false])ᵀ ∧
    Wth theta ![false,true,true,false] * Wth theta ![false,true,true,false] = 1 :=
  block_involution_family theta _ (by simp [signB]) (by simp [signB])

/-! ## T2.  Chart `{1,3}` involution family (protected singletons) -/

/-- **T2 (general).**  For every field with `b 0 ≠ b 2` (all protected fields:
protected singletons *and* blocks), the `{1,3}`-chart compression `M13(b,θ)` is
symmetric, an involution, traceless, and honestly intertwines the walk, for all
`θ`. -/
theorem chart13_involution_family (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 0) + signB (b 2) = 0) :
    M13 theta b = (M13 theta b)ᵀ ∧
    M13 theta b * M13 theta b = 1 ∧
    (M13 theta b).trace = 0 ∧
    Wth theta b * BfixR = BfixR * M13 theta b :=
  ⟨M13_selfadj_of theta b h, M13_involution_of theta b h, M13_trace theta b,
    intertwine13 theta b⟩

/-- Protected singleton: lone `−` at site `0` (`[-,+,+,+]`). -/
theorem chart13_singleton_m0 (theta : ℝ) :
    M13 theta ![false,true,true,true] = (M13 theta ![false,true,true,true])ᵀ ∧
    M13 theta ![false,true,true,true] * M13 theta ![false,true,true,true] = 1 ∧
    (M13 theta ![false,true,true,true]).trace = 0 ∧
    Wth theta ![false,true,true,true] * BfixR = BfixR * M13 theta ![false,true,true,true] :=
  chart13_involution_family theta _ (by simp [signB])

/-- Protected singleton: lone `+` at site `0` (`[+,-,-,-]`). -/
theorem chart13_singleton_p0 (theta : ℝ) :
    M13 theta ![true,false,false,false] = (M13 theta ![true,false,false,false])ᵀ ∧
    M13 theta ![true,false,false,false] * M13 theta ![true,false,false,false] = 1 ∧
    (M13 theta ![true,false,false,false]).trace = 0 ∧
    Wth theta ![true,false,false,false] * BfixR = BfixR * M13 theta ![true,false,false,false] :=
  chart13_involution_family theta _ (by simp [signB])

/-- Protected singleton: lone `−` at site `2` (`[+,+,-,+]`). -/
theorem chart13_singleton_m2 (theta : ℝ) :
    M13 theta ![true,true,false,true] = (M13 theta ![true,true,false,true])ᵀ ∧
    M13 theta ![true,true,false,true] * M13 theta ![true,true,false,true] = 1 ∧
    (M13 theta ![true,true,false,true]).trace = 0 ∧
    Wth theta ![true,true,false,true] * BfixR = BfixR * M13 theta ![true,true,false,true] :=
  chart13_involution_family theta _ (by simp [signB])

/-- Protected singleton: lone `+` at site `2` (`[-,-,+,-]`). -/
theorem chart13_singleton_p2 (theta : ℝ) :
    M13 theta ![false,false,true,false] = (M13 theta ![false,false,true,false])ᵀ ∧
    M13 theta ![false,false,true,false] * M13 theta ![false,false,true,false] = 1 ∧
    (M13 theta ![false,false,true,false]).trace = 0 ∧
    Wth theta ![false,false,true,false] * BfixR = BfixR * M13 theta ![false,false,true,false] :=
  chart13_involution_family theta _ (by simp [signB])

/-! ## T3.  Chart `{0,2}` involution family (blind singletons) -/

/-- **T3 (general).**  For every field with `b 1 ≠ b 3` (blind singletons and
blocks), the `{0,2}`-chart compression `M02(b,θ)` is symmetric, an involution,
traceless, and honestly intertwines the walk, for all `θ`. -/
theorem chart02_involution_family (theta : ℝ) (b : Fin 4 → Bool)
    (h : signB (b 1) + signB (b 3) = 0) :
    M02 theta b = (M02 theta b)ᵀ ∧
    M02 theta b * M02 theta b = 1 ∧
    (M02 theta b).trace = 0 ∧
    Wth theta b * Bfix0R = Bfix0R * M02 theta b :=
  ⟨M02_selfadj_of theta b h, M02_involution_of theta b h, M02_trace theta b,
    intertwine02 theta b⟩

/-- Blind singleton: lone `−` at site `1` (`[+,-,+,+]`). -/
theorem chart02_singleton_m1 (theta : ℝ) :
    M02 theta ![true,false,true,true] = (M02 theta ![true,false,true,true])ᵀ ∧
    M02 theta ![true,false,true,true] * M02 theta ![true,false,true,true] = 1 ∧
    (M02 theta ![true,false,true,true]).trace = 0 ∧
    Wth theta ![true,false,true,true] * Bfix0R = Bfix0R * M02 theta ![true,false,true,true] :=
  chart02_involution_family theta _ (by simp [signB])

/-- Blind singleton: lone `+` at site `1` (`[-,+,-,-]`). -/
theorem chart02_singleton_p1 (theta : ℝ) :
    M02 theta ![false,true,false,false] = (M02 theta ![false,true,false,false])ᵀ ∧
    M02 theta ![false,true,false,false] * M02 theta ![false,true,false,false] = 1 ∧
    (M02 theta ![false,true,false,false]).trace = 0 ∧
    Wth theta ![false,true,false,false] * Bfix0R = Bfix0R * M02 theta ![false,true,false,false] :=
  chart02_involution_family theta _ (by simp [signB])

/-- Blind singleton: lone `−` at site `3` (`[+,+,+,-]`). -/
theorem chart02_singleton_m3 (theta : ℝ) :
    M02 theta ![true,true,true,false] = (M02 theta ![true,true,true,false])ᵀ ∧
    M02 theta ![true,true,true,false] * M02 theta ![true,true,true,false] = 1 ∧
    (M02 theta ![true,true,true,false]).trace = 0 ∧
    Wth theta ![true,true,true,false] * Bfix0R = Bfix0R * M02 theta ![true,true,true,false] :=
  chart02_involution_family theta _ (by simp [signB])

/-- Blind singleton: lone `+` at site `3` (`[-,-,-,+]`). -/
theorem chart02_singleton_p3 (theta : ℝ) :
    M02 theta ![false,false,false,true] = (M02 theta ![false,false,false,true])ᵀ ∧
    M02 theta ![false,false,false,true] * M02 theta ![false,false,false,true] = 1 ∧
    (M02 theta ![false,false,false,true]).trace = 0 ∧
    Wth theta ![false,false,false,true] * Bfix0R = Bfix0R * M02 theta ![false,false,false,true] :=
  chart02_involution_family theta _ (by simp [signB])

/-! ## 5.  Transport `ℝ → ℂ` and fire the landed engine -/

/-- The entrywise `ℝ → ℂ` matrix map (the real analogue of the context `toC`). -/
def toCR {p q : Type*} [Fintype p] [Fintype q] : Matrix p q ℝ → Matrix p q ℂ :=
  fun A => A.map (algebraMap ℝ ℂ)

theorem toCR_mul {p q r : Type*} [Fintype p] [Fintype q] [Fintype r]
    (A : Matrix p q ℝ) (B : Matrix q r ℝ) : toCR (A * B) = toCR A * toCR B := Matrix.map_mul

theorem toCR_one {p : Type*} [Fintype p] [DecidableEq p] :
    toCR (1 : Matrix p p ℝ) = 1 := by
  unfold toCR; ext i j; simp [Matrix.map_apply, Matrix.one_apply, apply_ite]

theorem toCR_conjTranspose {p q : Type*} [Fintype p] [Fintype q] (A : Matrix p q ℝ) :
    (toCR A)ᴴ = toCR Aᵀ := by
  unfold toCR; ext i j
  simp [Matrix.conjTranspose_apply, Matrix.map_apply, Matrix.transpose_apply]

theorem toCR_injective {p q : Type*} [Fintype p] [Fintype q] {A B : Matrix p q ℝ}
    (h : toCR A = toCR B) : A = B := by
  unfold toCR at h; ext i j
  have := congrFun (congrFun h i) j
  simpa [Matrix.map_apply] using this

theorem toCR_neg {p q : Type*} [Fintype p] [Fintype q] (A : Matrix p q ℝ) :
    toCR (-A) = - toCR A := by unfold toCR; ext i j; simp [Matrix.map_apply]

theorem M13_ne_one (theta : ℝ) (b : Fin 4 → Bool) : M13 theta b ≠ 1 := by
  intro h; have := M13_trace theta b; rw [h] at this; simp [Matrix.trace_one] at this

theorem M13_ne_neg_one (theta : ℝ) (b : Fin 4 → Bool) : M13 theta b ≠ -1 := by
  intro h; have := M13_trace theta b; rw [h] at this; simp [Matrix.trace_neg, Matrix.trace_one] at this

theorem M02_ne_one (theta : ℝ) (b : Fin 4 → Bool) : M02 theta b ≠ 1 := by
  intro h; have := M02_trace theta b; rw [h] at this; simp [Matrix.trace_one] at this

theorem M02_ne_neg_one (theta : ℝ) (b : Fin 4 → Bool) : M02 theta b ≠ -1 := by
  intro h; have := M02_trace theta b; rw [h] at this; simp [Matrix.trace_neg, Matrix.trace_one] at this

/-- The assembled self-adjoint compression over `ℂ` in chart `{1,3}`. -/
def IC13 (theta : ℝ) (b : Fin 4 → Bool) (hsa : M13 theta b = (M13 theta b)ᵀ) :
    InvolutiveCompression (toCR (Wth theta b)) (toCR BfixR) (toCR (M13 theta b)) where
  iso := by rw [toCR_conjTranspose, ← toCR_mul, iso13, toCR_one]
  intertwine := by rw [← toCR_mul, ← toCR_mul, intertwine13]
  selfadj := by rw [toCR_conjTranspose, ← hsa]
  unit := by rw [toCR_conjTranspose, ← toCR_mul, Wth_orthogonal, toCR_one]

/-- The assembled self-adjoint compression over `ℂ` in chart `{0,2}`. -/
def IC02 (theta : ℝ) (b : Fin 4 → Bool) (hsa : M02 theta b = (M02 theta b)ᵀ) :
    InvolutiveCompression (toCR (Wth theta b)) (toCR Bfix0R) (toCR (M02 theta b)) where
  iso := by rw [toCR_conjTranspose, ← toCR_mul, iso02, toCR_one]
  intertwine := by rw [← toCR_mul, ← toCR_mul, intertwine02]
  selfadj := by rw [toCR_conjTranspose, ← hsa]
  unit := by rw [toCR_conjTranspose, ← toCR_mul, Wth_orthogonal, toCR_one]

/-- The certified-mode predicate for the complete walk over `ℂ`. -/
def Modes (theta : ℝ) (b : Fin 4 → Bool) : Prop :=
  (∃ V : V8 → ℂ, V ≠ 0 ∧ (toCR (Wth theta b)).mulVec V = -V) ∧
  (∃ V : V8 → ℂ, V ≠ 0 ∧ (toCR (Wth theta b)).mulVec V = V)

/-- Modes from chart `{1,3}` self-adjointness. -/
theorem modes_of_selfadj13 (theta : ℝ) (b : Fin 4 → Bool)
    (hsa : M13 theta b = (M13 theta b)ᵀ) : Modes theta b := by
  have ic := IC13 theta b hsa
  exact ⟨involutive_compression_flip_mode ic
      (fun h => M13_ne_one theta b (toCR_injective (by rw [h, toCR_one]))),
    involutive_compression_fixed_mode ic
      (fun h => M13_ne_neg_one theta b (toCR_injective (by rw [toCR_neg, toCR_one, h])))⟩

/-- Modes from chart `{0,2}` self-adjointness. -/
theorem modes_of_selfadj02 (theta : ℝ) (b : Fin 4 → Bool)
    (hsa : M02 theta b = (M02 theta b)ᵀ) : Modes theta b := by
  have ic := IC02 theta b hsa
  exact ⟨involutive_compression_flip_mode ic
      (fun h => M02_ne_one theta b (toCR_injective (by rw [h, toCR_one]))),
    involutive_compression_fixed_mode ic
      (fun h => M02_ne_neg_one theta b (toCR_injective (by rw [toCR_neg, toCR_one, h])))⟩

/-! ## T4.  The headline: modes persist for the entire family `θ` -/

/-- Every two-wall field is anti-aligned on at least one of the two fixed axes,
so at least one chart certifies it. -/
lemma two_wall_chart (b : Fin 4 → Bool)
    (hb : PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.wallCount b = 2) :
    b 0 ≠ b 2 ∨ b 1 ≠ b 3 := by
  revert hb; revert b; decide

/-- **T4 (headline).**  For **every** angle `θ : ℝ` and **every** two-wall field
`b`, the complete θ-family walk `W(b,θ)` over `ℂ` has a nonzero `+1` eigenvector
and a nonzero `−1` eigenvector.  The certified `±1` modes persist for the whole
coin/mass family — protection is an exact identity family, with no gap or
continuity hypothesis.  (Two-wall = the four blocks and the eight singletons;
protection is read in chart `{1,3}` when `b 0 ≠ b 2`, otherwise in the mirror
chart `{0,2}` where `b 1 ≠ b 3`.) -/
theorem modes_persist (theta : ℝ) (b : Fin 4 → Bool)
    (hb : PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.wallCount b = 2) :
    Modes theta b := by
  rcases two_wall_chart b hb with h | h
  · exact modes_of_selfadj13 theta b
      (M13_selfadj_of theta b ((signB_add_eq_zero_iff _ _).2 h))
  · exact modes_of_selfadj02 theta b
      (M02_selfadj_of theta b ((signB_add_eq_zero_iff _ _).2 h))

/-! ## T5.  Negative controls (exact `−2·sin θ` failure in the wrong chart) -/

/-- **T5, blind singleton `[+,+,+,-]` in the wrong chart `{1,3}`.**  The
antisymmetric part has the exact entry `(M13 − M13ᵀ)(0,1) = −2·sin θ`. -/
theorem control_blind_entry (theta : ℝ) :
    (M13 theta ![true,true,true,false] - (M13 theta ![true,true,true,false])ᵀ) 0 1
      = -2 * Real.sin theta := by
  unfold M13 Wth shiftR coinR BfixR signB
  simp [Matrix.sub_apply, Matrix.transpose_apply, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Fin.sum_univ_four]
  ring

/-- **T5, zero-wall field `[+,+,+,+]` in chart `{1,3}`.**  Same exact failure. -/
theorem control_zero_entry (theta : ℝ) :
    (M13 theta ![true,true,true,true] - (M13 theta ![true,true,true,true])ᵀ) 0 1
      = -2 * Real.sin theta := by
  unfold M13 Wth shiftR coinR BfixR signB
  simp [Matrix.sub_apply, Matrix.transpose_apply, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Fin.sum_univ_four]
  ring

/-- **T5, four-wall field `[+,-,+,-]` in chart `{1,3}`.**  Same exact failure. -/
theorem control_four_entry (theta : ℝ) :
    (M13 theta ![true,false,true,false] - (M13 theta ![true,false,true,false])ᵀ) 0 1
      = -2 * Real.sin theta := by
  unfold M13 Wth shiftR coinR BfixR signB
  simp [Matrix.sub_apply, Matrix.transpose_apply, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Fin.sum_univ_four]
  ring

/-- **Consequence:** for every massive `θ` (`sin θ ≠ 0`) the blind singleton
`[+,+,+,-]` is **not** self-adjoint in the wrong chart `{1,3}` — the engine
hypothesis genuinely fails there. -/
theorem control_blind_not_selfadj (theta : ℝ) (h : Real.sin theta ≠ 0) :
    M13 theta ![true,true,true,false] ≠ (M13 theta ![true,true,true,false])ᵀ := by
  intro hEq
  have key := control_blind_entry theta
  rw [← hEq] at key
  simp only [sub_self, Matrix.zero_apply] at key
  apply h; linarith [key]

/-- Same for the zero-wall field. -/
theorem control_zero_not_selfadj (theta : ℝ) (h : Real.sin theta ≠ 0) :
    M13 theta ![true,true,true,true] ≠ (M13 theta ![true,true,true,true])ᵀ := by
  intro hEq
  have key := control_zero_entry theta
  rw [← hEq] at key
  simp only [sub_self, Matrix.zero_apply] at key
  apply h; linarith [key]

/-- Same for the four-wall field. -/
theorem control_four_not_selfadj (theta : ℝ) (h : Real.sin theta ≠ 0) :
    M13 theta ![true,false,true,false] ≠ (M13 theta ![true,false,true,false])ᵀ := by
  intro hEq
  have key := control_four_entry theta
  rw [← hEq] at key
  simp only [sub_self, Matrix.zero_apply] at key
  apply h; linarith [key]

/-! ## T6.  Massless boundary (`sin θ = 0`) -/

/-- **T6.**  At `sin θ = 0` the control entry vanishes, so the chart-failure
claims of T5 are exactly scoped to the massive family `sin θ ≠ 0`.  (At
`sin θ = 0` the coin degenerates to `± cos θ · I = ± I` and the walk becomes a
signed shift; the wrong-chart antisymmetry is `−2·sin θ = 0`, so the controls
carry no obstruction there.) -/
theorem control_blind_massless (theta : ℝ) (h : Real.sin theta = 0) :
    (M13 theta ![true,true,true,false] - (M13 theta ![true,true,true,false])ᵀ) 0 1 = 0 := by
  rw [control_blind_entry, h]; ring

end PhysicsSM.Draft.NullEdge.ThetaFamilyProtection
