import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexSplitting
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.ProjectiveGeometry

/-!
# Algebra.Jordan.DVTAction

The first coordinate-level DVT/Yokota action on the `h₃(C) ⊕ complement`
splitting of the exceptional Jordan algebra `h₃(O)`.

## Mathematical context

The splitting `O = C ⊕ C³` from `ComplexSplitting.lean` induces a
decomposition of `h₃(O)` into two summands:

- **The `h₃(C)` part**: diagonal entries `α, β, γ` and the complex-line
  projections of the three off-diagonal entries `x, y, z`.
- **The complement part**: the three `C_⊥ ≅ C³` components of the
  off-diagonal entries (with zero diagonal).

In the Dubois-Violette–Todorov (DVT) / Yokota framework, a pair `(g, h)` of
3×3 complex-linear maps acts on `h₃(O)` by acting on the `h₃(C)` summand
via `g` and on the complement summand via `h`. The full unitary group
infrastructure is too heavy to formalize in one pass, so this module provides
a **scoped trusted coordinate scaffold**: all definitions compile without
`s o r r y`, using conservative hypotheses on the action data.

## Sources

- Dubois-Violette and Todorov, "Exceptional quantum geometry and particle
  physics II", Nuclear Physics B 938 (2019), 751–761.
- Yokota, "Exceptional Lie Groups", arXiv:0902.0431, Chapter 3.
- Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ## Complement coordinate model

The complement of `h₃(C)` inside `h₃(O)` consists of elements with zero
diagonal entries and off-diagonal entries in `C_⊥`. Each off-diagonal
octonion entry `x, y, z` projects to a `ComplexTriple` (three complex
coordinates = six reals). So the full complement has `3 × 6 = 18` real
degrees of freedom.
-/

/-- The complement of `h₃(C)` inside `h₃(O)`, represented as three
    `ComplexTriple` values — one for each off-diagonal slot `x, y, z`. -/
@[ext]
structure H3OComplement where
  /-- Complement part of the (2,3) off-diagonal entry `x`. -/
  cx : ComplexTriple
  /-- Complement part of the (3,1) off-diagonal entry `y`. -/
  cy : ComplexTriple
  /-- Complement part of the (1,2) off-diagonal entry `z`. -/
  cz : ComplexTriple
  deriving Inhabited

instance : Zero H3OComplement := ⟨⟨0, 0, 0⟩⟩

instance : Add H3OComplement :=
  ⟨fun a b => ⟨a.cx + b.cx, a.cy + b.cy, a.cz + b.cz⟩⟩

instance : Neg H3OComplement :=
  ⟨fun a => ⟨-a.cx, -a.cy, -a.cz⟩⟩

instance : SMul ℝ H3OComplement :=
  ⟨fun r a => ⟨r • a.cx, r • a.cy, r • a.cz⟩⟩

@[simp] theorem H3OComplement.smul_cx (r : ℝ) (w : H3OComplement) :
    (r • w).cx = r • w.cx := rfl
@[simp] theorem H3OComplement.smul_cy (r : ℝ) (w : H3OComplement) :
    (r • w).cy = r • w.cy := rfl
@[simp] theorem H3OComplement.smul_cz (r : ℝ) (w : H3OComplement) :
    (r • w).cz = r • w.cz := rfl

/-- Embed the complement into `h₃(O)` as an element with zero diagonal
    and off-diagonal entries in `C_⊥`. -/
def H3OComplement.toH3O (w : H3OComplement) : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := w.cx.toOctonion
  y := w.cy.toOctonion
  z := w.cz.toOctonion

/-- Extract the complement from an `H3O` element by projecting each
    off-diagonal entry onto `C_⊥`. -/
def extractComplement (a : H3O) : H3OComplement where
  cx := a.x.toComplexTriple
  cy := a.y.toComplexTriple
  cz := a.z.toComplexTriple

@[simp] theorem H3OComplement.toH3O_alpha (w : H3OComplement) :
    w.toH3O.alpha = 0 := rfl
@[simp] theorem H3OComplement.toH3O_beta (w : H3OComplement) :
    w.toH3O.beta = 0 := rfl
@[simp] theorem H3OComplement.toH3O_gamma (w : H3OComplement) :
    w.toH3O.gamma = 0 := rfl
@[simp] theorem H3OComplement.toH3O_x (w : H3OComplement) :
    w.toH3O.x = w.cx.toOctonion := rfl
@[simp] theorem H3OComplement.toH3O_y (w : H3OComplement) :
    w.toH3O.y = w.cy.toOctonion := rfl
@[simp] theorem H3OComplement.toH3O_z (w : H3OComplement) :
    w.toH3O.z = w.cz.toOctonion := rfl

/-- Round-trip: extracting and re-embedding the complement is the identity. -/
theorem H3OComplement.roundtrip (w : H3OComplement) :
    extractComplement w.toH3O = w := by
  simp [extractComplement, H3OComplement.toH3O, ComplexTriple.roundtrip]

/-- The complement embedding lands in the complement of `h₃(C)`:
    all off-diagonal entries lie in `C_⊥`. -/
theorem H3OComplement.toH3O_complement_entries (w : H3OComplement) :
    InChosenComplexComplement w.toH3O.x ∧
    InChosenComplexComplement w.toH3O.y ∧
    InChosenComplexComplement w.toH3O.z :=
  ⟨w.cx.toOctonion_inComplement,
   w.cy.toOctonion_inComplement,
   w.cz.toOctonion_inComplement⟩

/-- Zero complement embeds to zero H3O. -/
theorem H3OComplement.toH3O_zero :
    H3OComplement.toH3O 0 = 0 := by
  ext <;> rfl

/-- Scalar multiplication commutes with embedding. -/
theorem H3OComplement.toH3O_smul (r : ℝ) (w : H3OComplement) :
    (r • w).toH3O = r • w.toH3O := by
  ext <;> simp [H3OComplement.toH3O, ComplexTriple.toOctonion,
    HSMul.hSMul, SMul.smul]

/-! ## Projection maps -/

/-- Project an `H3O` element onto its `h₃(C)` part by keeping the diagonal
    and projecting each off-diagonal entry onto the chosen complex line. -/
def toStandardBPart (a : H3O) : H3O where
  alpha := a.alpha
  beta := a.beta
  gamma := a.gamma
  x := a.x.toChosenComplex.toOctonion
  y := a.y.toChosenComplex.toOctonion
  z := a.z.toChosenComplex.toOctonion

/-- Project an `H3O` element onto its complement part by keeping only the
    complement projections of each off-diagonal entry. -/
def toComplementPart (a : H3O) : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := a.x.toComplexTriple.toOctonion
  y := a.y.toComplexTriple.toOctonion
  z := a.z.toComplexTriple.toOctonion

/-- The complement projection equals embedding the extracted complement. -/
theorem toComplementPart_eq_extractComplement (a : H3O) :
    toComplementPart a = (extractComplement a).toH3O := rfl

/-! ### Projection lands in the right summand -/

/-- The `h₃(C)` projection lands in `InStandardB`. -/
theorem toStandardBPart_inStandardB (a : H3O) :
    InStandardB (toStandardBPart a) :=
  ⟨⟨rfl, rfl, rfl, rfl, rfl, rfl⟩,
   ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩,
   ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩⟩

/-- The complement projection has zero diagonal. -/
theorem toComplementPart_zero_diag (a : H3O) :
    (toComplementPart a).alpha = 0 ∧
    (toComplementPart a).beta = 0 ∧
    (toComplementPart a).gamma = 0 := ⟨rfl, rfl, rfl⟩

/-- Each off-diagonal entry of the complement projection lies in `C_⊥`. -/
theorem toComplementPart_inComplement (a : H3O) :
    InChosenComplexComplement (toComplementPart a).x ∧
    InChosenComplexComplement (toComplementPart a).y ∧
    InChosenComplexComplement (toComplementPart a).z :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-! ## Decomposition theorem -/

/-- Every `H3O` element decomposes as its `h₃(C)` part plus its complement
    part. This is the coordinate-level direct sum
    `h₃(O) = h₃(C) ⊕ complement`. -/
theorem h3o_decomposition (a : H3O) :
    a = toStandardBPart a + toComplementPart a := by
  ext <;> simp [toStandardBPart, toComplementPart,
    ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- The projections are idempotent: projecting twice gives the same result. -/
theorem toStandardBPart_idem (a : H3O) :
    toStandardBPart (toStandardBPart a) = toStandardBPart a := by
  ext <;> simp [toStandardBPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

/-- The complement projection is idempotent. -/
theorem toComplementPart_idem (a : H3O) :
    toComplementPart (toComplementPart a) = toComplementPart a := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-- Cross-projection: projecting the `h₃(C)` part onto the complement gives
    zero. -/
theorem toStandardBPart_complement_zero (a : H3O) :
    toComplementPart (toStandardBPart a) = 0 := by
  ext <;> simp [toStandardBPart, toComplementPart,
    ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- Cross-projection: projecting the complement part onto `h₃(C)` part
    gives zero. -/
theorem toComplementPart_standardB_zero (a : H3O) :
    toStandardBPart (toComplementPart a) = 0 := by
  ext <;> simp [toStandardBPart, toComplementPart,
    ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- The decomposition is direct: if both projections are zero, then the
    element is zero. -/
theorem h3o_decomposition_directness (a : H3O)
    (hB : toStandardBPart a = 0) (hC : toComplementPart a = 0) :
    a = 0 := by
  have hab := h3o_decomposition a
  rw [hB, hC] at hab
  rw [hab]
  ext <;> simp

/-! ## Predicate: element lies in the complement -/

/-- An `H3O` element lies in the complement of `h₃(C)` when its diagonal
    entries are zero and each off-diagonal entry lies in `C_⊥`. -/
def InH3OComplement (a : H3O) : Prop :=
  a.alpha = 0 ∧ a.beta = 0 ∧ a.gamma = 0 ∧
  InChosenComplexComplement a.x ∧
  InChosenComplexComplement a.y ∧
  InChosenComplexComplement a.z

theorem zero_inH3OComplement : InH3OComplement (0 : H3O) :=
  ⟨rfl, rfl, rfl, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

theorem H3OComplement.toH3O_inH3OComplement (w : H3OComplement) :
    InH3OComplement w.toH3O :=
  ⟨rfl, rfl, rfl,
   w.cx.toOctonion_inComplement,
   w.cy.toOctonion_inComplement,
   w.cz.toOctonion_inComplement⟩

theorem toComplementPart_inH3OComplement (a : H3O) :
    InH3OComplement (toComplementPart a) :=
  ⟨rfl, rfl, rfl, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- The `h₃(C)` and complement summands are disjoint: an element in both
    must be zero. -/
theorem standardB_inter_complement_eq_zero (a : H3O)
    (hB : InStandardB a) (hC : InH3OComplement a) :
    a = 0 := by
  obtain ⟨ha, hb, hg, ⟨hx0, hx7⟩, ⟨hy0, hy7⟩, ⟨hz0, hz7⟩⟩ := hC
  obtain ⟨⟨hx1, hx2, hx3, hx4, hx5, hx6⟩,
          ⟨hy1, hy2, hy3, hy4, hy5, hy6⟩,
          ⟨hz1, hz2, hz3, hz4, hz5, hz6⟩⟩ := hB
  ext <;> assumption

/-! ## DVT block action scaffold

The DVT/Yokota action on `h₃(O)` is given by a pair of linear maps:
- `actB : H3O → H3O` acts on the `h₃(C)` summand.
- `actC : H3OComplement → H3OComplement` acts on the complement summand.

In the full DVT theory, `actB` comes from the adjoint action of `SU(3)` on
`h₃(C)` and `actC` comes from the fundamental × fundamental action of
`SU(3) × SU(3)` on `(C_⊥)³ ≅ (C³)³`. Here we use conservative hypotheses:
the maps are assumed to preserve their respective summands and compose
well, without requiring full unitary group infrastructure.
-/

/-- A DVT block action datum: a pair of self-maps on the two summands
    with compatibility hypotheses. -/
structure DVTBlockAction where
  /-- Action on the `h₃(C)` summand. -/
  actB : H3O → H3O
  /-- Action on the complement summand. -/
  actC : H3OComplement → H3OComplement
  /-- The B-action preserves `InStandardB`. -/
  actB_preserves : ∀ a, InStandardB a → InStandardB (actB a)
  /-- The B-action fixes zero. -/
  actB_zero : actB 0 = 0
  /-- The C-action fixes zero. -/
  actC_zero : actC 0 = 0

/-- The composite action on `h₃(O)`: apply `actB` to the `h₃(C)` part and
    `actC` to the complement part, then reassemble.

    `σ · a = actB(toStandardBPart a) + (actC(extractComplement a)).toH3O`
-/
def DVTBlockAction.act (σ : DVTBlockAction) (a : H3O) : H3O :=
  σ.actB (toStandardBPart a) + (σ.actC (extractComplement a)).toH3O

/-! ### Helper: complement vanishes for InStandardB elements -/

theorem extractComplement_of_standardB {a : H3O} (ha : InStandardB a) :
    extractComplement a = 0 := by
  obtain ⟨⟨hx1, hx2, hx3, hx4, hx5, hx6⟩,
          ⟨hy1, hy2, hy3, hy4, hy5, hy6⟩,
          ⟨hz1, hz2, hz3, hz4, hz5, hz6⟩⟩ := ha
  have hx : a.x.toComplexTriple = ⟨0, 0, 0, 0, 0, 0⟩ := by
    ext <;> simp [Octonion.toComplexTriple, *]
  have hy : a.y.toComplexTriple = ⟨0, 0, 0, 0, 0, 0⟩ := by
    ext <;> simp [Octonion.toComplexTriple, *]
  have hz : a.z.toComplexTriple = ⟨0, 0, 0, 0, 0, 0⟩ := by
    ext <;> simp [Octonion.toComplexTriple, *]
  change (⟨a.x.toComplexTriple, a.y.toComplexTriple, a.z.toComplexTriple⟩ : H3OComplement) = 0
  rw [hx, hy, hz]; rfl

/-- Helper: standardBPart vanishes for complement elements -/
theorem toStandardBPart_of_complement {a : H3O} (ha : InH3OComplement a) :
    toStandardBPart a = 0 := by
  obtain ⟨hα, hβ, hγ, ⟨hx0, hx7⟩, ⟨hy0, hy7⟩, ⟨hz0, hz7⟩⟩ := ha
  ext <;> simp [toStandardBPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex, *]

/-! ### Preservation theorems -/

/-- The DVT action preserves the `h₃(C)` summand: if `a ∈ h₃(C)`, then
    the action result lies in `h₃(C)`. -/
theorem dvtBlockAction_preserves_standardB (σ : DVTBlockAction) (a : H3O)
    (ha : InStandardB a) :
    InStandardB (σ.act a) := by
  have hcomp := extractComplement_of_standardB ha
  unfold DVTBlockAction.act
  rw [hcomp, σ.actC_zero, H3OComplement.toH3O_zero]
  change InStandardB (σ.actB (toStandardBPart a) + 0)
  rw [show σ.actB (toStandardBPart a) + (0 : H3O) =
    σ.actB (toStandardBPart a) from by ext <;> simp]
  exact σ.actB_preserves (toStandardBPart a) (toStandardBPart_inStandardB a)

/-- The DVT action preserves the complement summand: if `a` lies in the
    complement, then the action result lies in the complement. -/
theorem dvtBlockAction_preserves_complement (σ : DVTBlockAction) (a : H3O)
    (ha : InH3OComplement a) :
    InH3OComplement (σ.act a) := by
  have hbpart := toStandardBPart_of_complement ha
  unfold DVTBlockAction.act
  rw [hbpart, σ.actB_zero]
  change InH3OComplement ((0 : H3O) + (σ.actC (extractComplement a)).toH3O)
  rw [show (0 : H3O) + (σ.actC (extractComplement a)).toH3O =
    (σ.actC (extractComplement a)).toH3O from by ext <;> simp]
  exact (σ.actC (extractComplement a)).toH3O_inH3OComplement

/-! ### Identity and composition -/

/-- The identity DVT block action. -/
def dvtBlockAction_identity : DVTBlockAction where
  actB := id
  actC := id
  actB_preserves := fun _ h => h
  actB_zero := rfl
  actC_zero := rfl

/-- The identity action acts trivially. -/
theorem dvtBlockAction_identity_act (a : H3O) :
    dvtBlockAction_identity.act a = a := by
  unfold dvtBlockAction_identity DVTBlockAction.act
  simp only [id]
  -- Goal: toStandardBPart a + (extractComplement a).toH3O = a
  rw [← toComplementPart_eq_extractComplement]
  exact (h3o_decomposition a).symm

/-- Compose two DVT block actions. -/
def DVTBlockAction.comp (σ τ : DVTBlockAction) : DVTBlockAction where
  actB := σ.actB ∘ τ.actB
  actC := σ.actC ∘ τ.actC
  actB_preserves := fun a h => σ.actB_preserves _ (τ.actB_preserves a h)
  actB_zero := by simp [Function.comp, τ.actB_zero, σ.actB_zero]
  actC_zero := by simp [Function.comp, τ.actC_zero, σ.actC_zero]

/-! ## Compatibility with `standardOctonionicLineProjection`

The standard octonionic line projection `diag(1,1,0)` lies entirely in `h₃(C)`
(it has zero off-diagonal entries), so the DVT action on it reduces to the
B-action alone.
-/

/-- The standard octonionic line projection has trivial complement part. -/
theorem standardOctonionicLineProjection_complement_zero :
    extractComplement standardOctonionicLineProjection = 0 :=
  extractComplement_of_standardB standardOctonionicLineProjection_inStandardB

/-- The standard octonionic line projection lies in `h₃(C)`. -/
theorem standardOctonionicLineProjection_inStandardB_dvt :
    InStandardB standardOctonionicLineProjection :=
  standardOctonionicLineProjection_inStandardB

/-! ## Central-kernel scaffold

A **scalar phase pair** acts as identity on `h₃(C)` and by overall scalar
multiplication on the complement. When the scalar is `1`, the action is
trivial. This is the seed of the Z₃ kernel in the `(SU(3) × SU(3))/Z₃`
quotient: a cube root of unity `ω` satisfies `ω³ = 1`, and the pair
`(ωI, ω²I)` acts trivially on `h₃(O)` because `ω · ω² = ω³ = 1`.
-/

/-- A DVT block action is a scalar phase pair when the B-action is the
    identity and the C-action is multiplication by a common real scalar. -/
def DVTBlockAction.isScalarPhasePair (σ : DVTBlockAction) : Prop :=
  (∀ a, σ.actB a = a) ∧
  ∃ s : ℝ, ∀ w : H3OComplement, σ.actC w = s • w

/-- A scalar phase pair preserves both summands (follows from the general
    preservation theorems). -/
theorem scalarPhasePair_preserves_summands (σ : DVTBlockAction)
    (_hsp : σ.isScalarPhasePair) :
    (∀ a, InStandardB a → InStandardB (σ.act a)) ∧
    (∀ a, InH3OComplement a → InH3OComplement (σ.act a)) :=
  ⟨dvtBlockAction_preserves_standardB σ,
   dvtBlockAction_preserves_complement σ⟩

/-- A scalar phase pair with scalar `1` acts as the identity. -/
theorem scalarPhasePair_one_is_identity (σ : DVTBlockAction)
    (hB : ∀ a, σ.actB a = a)
    (hC : ∀ w : H3OComplement, σ.actC w = (1 : ℝ) • w) :
    ∀ a, σ.act a = a := by
  intro a
  unfold DVTBlockAction.act
  rw [hB, hC]
  show toStandardBPart a + ((1 : ℝ) • extractComplement a).toH3O = a
  rw [show (1 : ℝ) • extractComplement a = extractComplement a from by
    ext <;> simp [extractComplement, HSMul.hSMul, SMul.smul]]
  rw [← toComplementPart_eq_extractComplement]
  exact (h3o_decomposition a).symm

/-!
## Roadmap for full DVT/Yokota action

The scaffold above provides the coordinate-level decomposition and action
framework needed for the DVT stabilizer theorem. The following pieces remain
for the full `(SU(3) × SU(3)) / Z₃` action:

1. **Unitary group infrastructure**: Define `SU(3)` as a subtype of `Matrix
   (Fin 3) (Fin 3) ℂ` with `U * Uᴴ = 1` and `det U = 1`. This requires
   Mathlib's `Matrix.unitaryGroup` and `Matrix.SpecialLinearGroup`.

2. **Adjoint action on `h₃(C)`**: For `g ∈ SU(3)`, define
   `actB(X) = g * X * g⁻¹` on `h₃(C) ≅ {X : Matrix 3 3 ℂ | Xᴴ = X}`.

3. **Fundamental action on complement**: For `h ∈ SU(3)`, define
   `actC(M) = h * M` on each `C³` component of the complement.

4. **Z₃ kernel**: Prove that `(ω·I, ω²·I)` acts trivially for `ω = e^{2πi/3}`.

5. **Jordan-product preservation**: Prove the combined action preserves the
   Jordan product on `h₃(O)`.
-/

end PhysicsSM.Algebra.Jordan.DVTAction
