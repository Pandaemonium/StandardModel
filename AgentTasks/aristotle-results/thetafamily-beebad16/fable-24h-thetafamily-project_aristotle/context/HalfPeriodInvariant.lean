/-
Provenance: Aristotle job f4879a60 (fable-pub-halfperiod-invariant-20260711),
harvested 2026-07-11 ~07:05 PDT; design memo at
`AgentTasks/aristotle-results/halfperiod-f4879a60/.../HALFPERIOD_INVARIANT_DESIGN.md`.
Statements integrated UNCHANGED except this header and the import rewire
(context copy of ModeInvariantHalfWinding was verified byte-identical to the
landed module). Draft trust: every matrix fact here is discharged by
`native_decide` (adds `Lean.ofReduceBool`/`Lean.trustCompiler`), matching the
sibling K6 fixtures; the engine lemmas it composes with are kernel-only.
Independent oracle cross-checks (run scratchpad, sympy/numpy exact): the
sigma_x grading, the 16-field self-adjointness census, and the momentum-frame
winding table (0 / -+2) were verified before submission and at harvest.
Decision recorded: the half-period timeframe pair and mirror-graded winding
are BLIND to the 8-vs-4 positional split (advisor kill condition fired); the
separating value-only datum is fixed-leg self-adjointness = not-fixedSingleton,
and the mirror-graded candidate is ILL-DEFINED on the blind fields
(`reflR_comm_walk_iff`, `fixedSingleton_not_reflSym`). Sharpened open gate:
match this finite discriminator to the CGGSVWZ real-space symmetry index
(arXiv:1611.04439) and inherit gentle-perturbation stability.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

/-!
# Half-period / mirror-graded chiral invariants vs. the C protection law — typechecking statements

Companion Lean file for `HALFPERIOD_INVARIANT_DESIGN.md` (C gates 1–2).  This is
a **design / typechecking** artifact: exact `native_decide` facts over `ℚ`, no
large builds, `import Mathlib` only plus the landed engine of
`ModeInvariantHalfWinding`.  It does **not** modify any context module.

## The decision, encoded

For the palindromic walk `W = S·C·S` on the four-site register (register and
`InvolutiveCompression` engine imported from `ModeInvariantHalfWinding`), with

* chiral grading `Γ = I ⊗ σ_x` (`gradeX`), the unique grading making every
  fixture chiral (`gradeX_sq`, `gradeX_chiral`), and `S, C` individually chiral
  (`shift_chiral`, `coin_chiral`), so `W` is a symmetric-time-frame walk;
* reflection `R` through the `1–3` axis (`reflR`), `R² = 1`, `[R,W]=[R,Γ]=0`,

the **half-period chiral invariant** (signed `Γ`-signature on the protected
eigenspaces `ker(W∓1)`) and the **mirror-graded winding** (same, resolved by the
`R`-parity sectors) are **blind**: every trace/winding index is constant across
the whole 16-field family (`allFields_trGW_zero`, `allFields_trGWR_zero`;
determinant blindness is inherited from the landed context modules). The
momentum-space second-frame winding (memo §2) is likewise blind to defect
position — the advisor kill condition.

The datum that reproduces the observed **8-vs-4 positional split** is the
**self-adjointness of the reflection-fixed-leg compression**
`M(b) = Bfixᵀ · W(b) · Bfix`, which equals exactly the positional
`¬ fixedSingleton` criterion (`selfadj_iff_protected`).  Combined with the
always-holding structural facts (`fixedSector_isometry`,
`fixedSector_intertwine`, `allFields_unitary`, `Mfix_trace_zero`) this fires the
landed `InvolutiveCompression` engine to pin the `2+2` modes
(`protected_modes`).

All matrix facts are exact rational identities discharged by `native_decide`
(draft-trust, matching the sibling modules).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

/-! ## 1.  The chiral grading, reflection, and the derived-field family -/

/-- The chiral grading `Γ = I₄ ⊗ σ_x` (per-site chirality swap). -/
def gradeX : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = j.1 ∧ i.2 ≠ j.2 then (1 : ℚ) else 0

/-- Spatial reflection through the `1–3` axis (swap sites `0 ↔ 2`, fix `1,3`). -/
def reflR : Matrix V8 V8 ℚ := Matrix.of fun i j =>
  if i.1 = (![2, 1, 0, 3] : Fin 4 → Fin 4) j.1 ∧ i.2 = j.2 then (1 : ℚ) else 0

/-- The derived sine field of a sign pattern `b : Fin 4 → Bool` (value-only:
`+3/5` / `−3/5`). -/
def sField (b : Fin 4 → Bool) : Fin 4 → ℚ := fun i => if b i then 3 / 5 else -3 / 5

/-- The derived walk of a sign pattern (constant `3-4-5` cosine `cW`). -/
def Wof (b : Fin 4 → Bool) : Matrix V8 V8 ℚ := walkQ cW (sField b)

/-- The reflection-fixed-leg compression `M(b) = Bfixᵀ · W(b) · Bfix` (`4×4`). -/
def Mfix (b : Fin 4 → Bool) : Matrix (Fin 4) (Fin 4) ℚ := Bfixᵀ * Wof b * Bfix

/-! ## 2.  Chiral / symmetric-frame structure (exact) -/

/-- `Γ` is an involution. -/
theorem gradeX_sq : gradeX * gradeX = 1 := by native_decide

/-- Every derived field is chiral for `Γ`: `Γ W Γ = Wᵀ` (`= W†`). -/
theorem gradeX_chiral : ∀ b, gradeX * Wof b * gradeX = (Wof b)ᵀ := by native_decide

/-- **The load-bearing hypothesis, exact and field-independent:** `Γ W Γ = W⁻¹`.
Since every derived walk is orthogonal (`Wᵀ = W⁻¹`), chirality reads
`Γ W Γ · W = 1`. -/
theorem chiral_inverse : ∀ b, gradeX * Wof b * gradeX * Wof b = 1 := by native_decide

/-- The shift is individually chiral. -/
theorem shift_chiral : gradeX * shiftQ * gradeX = shiftQᵀ := by native_decide

/-- Every coin `C(cW, sField b)` is individually chiral — so `W = S·C·S` is a
genuine symmetric (palindromic) time-frame walk. -/
theorem coin_chiral : ∀ b, gradeX * coinQ cW (sField b) * gradeX = (coinQ cW (sField b))ᵀ := by
  native_decide

/-- Reflection is an involution commuting with `Γ` (field-independently). -/
theorem reflR_sq : reflR * reflR = 1 := by native_decide
theorem reflR_comm_grade : reflR * gradeX = gradeX * reflR := by native_decide

/-- A field is **reflection-symmetric** iff the two reflection-fixed sites `1, 3`
carry equal signs.  This is exactly the condition for the reflection to commute
with the walk (`reflR_comm_walk`), i.e. for the mirror-graded (`R`-sector)
winding to be *defined*. -/
def reflSym (b : Fin 4 → Bool) : Bool := b 1 == b 3

/-- **Reflection commutes with the walk iff the field is reflection-symmetric.**
So the mirror-graded winding candidate is only defined on reflection-symmetric
fields — and every fixed singleton (`fixedSingleton`) breaks this symmetry. -/
theorem reflR_comm_walk_iff :
    ∀ b, (reflR * Wof b = Wof b * reflR) ↔ reflSym b = true := by native_decide

/-! ## 3.  DECISION = NO: the half-period / mirror-graded / trace invariants are blind

All of these are constant across the whole 16-field family, hence cannot read the
`8-vs-4` split (nor the mode counts). -/

/-- The naive chiral trace index `tr(ΓW) = 0` for every derived field. -/
theorem allFields_trGW_zero : ∀ b, (gradeX * Wof b).trace = 0 := by native_decide

/-- The mirror-graded trace index `tr(ΓWR) = 0` for every derived field. -/
theorem allFields_trGWR_zero : ∀ b, (gradeX * Wof b * reflR).trace = 0 := by native_decide

/-- The bare symmetry traces vanish too (`tr Γ = tr(ΓR) = 0`). -/
theorem trace_gradeX_zero : gradeX.trace = 0 := by native_decide
theorem trace_gradeX_reflR_zero : (gradeX * reflR).trace = 0 := by native_decide

/-! ## 4.  The separating datum: fixed-leg self-adjointness = the 8-vs-4 split

`wallCount b` counts cyclic sign changes; `fixedSingleton b` is the positional
criterion (a lone flip seated on a reflection-**fixed** site `1` or `3`);
`protectedField b` is "two-wall and not a fixed singleton". -/

/-- Number of walls: cyclic adjacent sign changes of `b`. -/
def wallCount (b : Fin 4 → Bool) : ℕ :=
  (Finset.univ : Finset (Fin 4)).sum (fun i => if b i = b (i + 1) then 0 else 1)

/-- `b` is a singleton with its lone flip at site `i`. -/
def loneAt (b : Fin 4 → Bool) (i : Fin 4) : Bool :=
  (b (i + 1) == b (i + 2)) && (b (i + 2) == b (i + 3)) && (! (b i == b (i + 1)))

/-- The positional criterion: a lone flip seated on a reflection-fixed site. -/
def fixedSingleton (b : Fin 4 → Bool) : Bool := loneAt b 1 || loneAt b 3

/-- The protecting predicate: two walls and **not** a fixed singleton. -/
def protectedField (b : Fin 4 → Bool) : Bool := (wallCount b == 2) && (! fixedSingleton b)

/-- **The 8-vs-4 separation (exact).**  The reflection-fixed-leg compression is
self-adjoint iff the field is protected (two-wall, not a fixed singleton) — the
observed split of the twelve two-wall fields into `8` (engine fires) and `4`
(positionally blind). -/
theorem selfadj_iff_protected :
    ∀ b, (Mfix b = (Mfix b)ᵀ) ↔ protectedField b = true := by native_decide

/-- Every fixed singleton breaks the reflection symmetry, so the mirror-graded
(`R`-sector) winding candidate is not even defined on the 4 blind fields. -/
theorem fixedSingleton_not_reflSym :
    ∀ b, fixedSingleton b = true → reflSym b = false := by native_decide

/-! ## 5.  Structural family facts (always hold) — only self-adjointness varies -/

/-- `Bfix` is an isometry (reflection-fixed legs are orthonormal). -/
theorem fixedSector_isometry : Bfixᵀ * Bfix = 1 := by native_decide

/-- The reflection-fixed sector is `W`-invariant for **every** derived field:
`W · Bfix = Bfix · M(b)`.  (So `intertwine` never obstructs the engine.) -/
theorem fixedSector_intertwine : ∀ b, Wof b * Bfix = Bfix * Mfix b := by native_decide

/-- Every derived walk is orthogonal (`Wᵀ W = 1`). -/
theorem allFields_unitary : ∀ b, (Wof b)ᵀ * Wof b = 1 := by native_decide

/-- The fixed-leg compression is traceless for every field (`tr M(b) = 0`) — so
whenever it is an involution the split is `2 + 2`. -/
theorem Mfix_trace_zero : ∀ b, (Mfix b).trace = 0 := by native_decide

/-! ## 6.  Fixture evaluations -/

/-- The two-wall fixed-pair fixture `sWall = [+,+,−,+]` is protected. -/
theorem sWall_protected : protectedField ![true, true, false, true] = true := by native_decide
/-- The zero-wall control is not protected (no fixed-leg involution). -/
theorem sZero_not_protected : protectedField ![true, true, true, true] = false := by native_decide
/-- The four-wall walk is not protected. -/
theorem sFour_not_protected : protectedField ![true, false, true, false] = false := by native_decide
/-- A **fixed singleton** (lone flip at site `3`) is a blind two-wall field. -/
theorem fixedSingleton_blind : protectedField ![true, true, true, false] = false := by native_decide
/-- Another fixed singleton (lone flip at site `1`). -/
theorem fixedSingleton_blind' : protectedField ![true, false, true, true] = false := by native_decide

/-! ## 7.  Engine bridge: invariant (self-adjointness) ⟹ pinned `±1` modes

Assembled from the always-holding structural facts (§5) plus the discriminating
self-adjointness (§4), fed through the landed `InvolutiveCompression` engine
(imported).  `toC` and its ring-hom lemmas are reused from `ModeInvariantHalfWinding`. -/

/-- The compressed operator is `≠ 1` (it is traceless, `1` has trace `4`). -/
theorem Mfix_ne_one (b : Fin 4 → Bool) : Mfix b ≠ 1 := by
  intro h
  have := Mfix_trace_zero b
  rw [h] at this
  simp [Matrix.trace_one] at this

/-- The compressed operator is `≠ −1` (traceless, `−1` has trace `−4`). -/
theorem Mfix_ne_neg_one (b : Fin 4 → Bool) : Mfix b ≠ -1 := by
  intro h
  have := Mfix_trace_zero b
  rw [h] at this
  simp [Matrix.trace_neg, Matrix.trace_one] at this

/-- **The assembled self-adjoint compression** for a protected field, over `ℂ`. -/
theorem involutiveCompression_of_protected (b : Fin 4 → Bool)
    (hb : protectedField b = true) :
    InvolutiveCompression (toC (Wof b)) (toC Bfix) (toC (Mfix b)) where
  iso := by rw [toC_conjTranspose, ← toC_mul, fixedSector_isometry, toC_one]
  intertwine := by rw [← toC_mul, ← toC_mul, fixedSector_intertwine]
  selfadj := by
    rw [toC_conjTranspose, ← ((selfadj_iff_protected b).2 hb)]
  unit := by rw [toC_conjTranspose, ← toC_mul, allFields_unitary, toC_one]

/-- **The C-rung engine bridge (composed).**  For every protected derived field,
the walk has an exact `−1` mode *and* an exact `+1` mode, forced by the
self-adjointness of its fixed-leg compression — with `det = +1` throughout.
This is the requested "invariant nonzero ⟹ involutive-compression
self-adjointness ⟹ pinned modes" theorem; the fixed singletons and the
zero/four-wall controls fail the hypothesis. -/
theorem protected_modes (b : Fin 4 → Bool) (hb : protectedField b = true) :
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = -V) ∧
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = V) := by
  have ic := involutiveCompression_of_protected b hb
  refine ⟨?_, ?_⟩
  · exact involutive_compression_flip_mode ic
      (fun h => Mfix_ne_one b (toC_injective (by rw [h, toC_one])))
  · exact involutive_compression_fixed_mode ic
      (fun h => Mfix_ne_neg_one b (toC_injective (by rw [toC_neg, toC_one, h])))

end PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
