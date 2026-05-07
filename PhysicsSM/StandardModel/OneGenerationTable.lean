import Mathlib.Tactic
import PhysicsSM.StandardModel.AnomalyPackage

/-!
# Full one-generation handedness table

This module makes the right-handed-fermion issue impossible to hide by defining
both the physical chirality table and the all-left-handed charge-conjugate
convention side by side. It proves:

- matching Weyl-state degree counts (15 without ν_R, 16 with ν_R);
- correct hypercharge sign conversion under charge conjugation;
- the Gell-Mann–Nishijima relation `Q = T₃ + Y/2` for every component.

## Claim boundary

**This is conventional Standard Model bookkeeping.** It does not claim that the
Krasnov/Baez `O²` construction, or any other octonionic realization, explains
the right-handed sector. The purpose is to establish a trusted reference table
so that any future octonionic bridge must honestly match it.

## Conventions

- Hypercharge: `Q = T₃ + Y/2` (Weinberg, Peskin–Schroeder).
- All fermions in the "all-left-handed" table are left-handed Weyl spinors.
  Physical right-handed fermions enter as charge conjugates with flipped `Y`.
- Colour representations: `3` = fundamental, `3̄` = antifundamental, `1` = singlet.
- SU(2)_L representations: `2` = doublet, `1` = singlet.

## Sources

- M. Peskin and D. Schroeder, *An Introduction to Quantum Field Theory*, §20.2.
- S. Weinberg, *The Quantum Theory of Fields*, Vol. 2, Ch. 21–22.

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.StandardModel.OneGenerationTable

/-! ## Chirality -/

/-- The chirality (handedness) of a fermion field. -/
inductive Chirality where
  | left
  | right
deriving DecidableEq, Repr

/-! ## Physical multiplet type

This enumerates the physical one-generation Standard Model fermion multiplets,
preserving their natural chirality. Each variant carries its physical handedness.
-/

/--
Physical one-generation Standard Model fermion multiplets.

- `Q_L`: left-handed quark doublet `(u_L, d_L)`, rep `(3, 2, +1/3)`
- `L_L`: left-handed lepton doublet `(ν_L, e_L)`, rep `(1, 2, −1)`
- `u_R`: right-handed up quark, rep `(3, 1, +4/3)`
- `d_R`: right-handed down quark, rep `(3, 1, −2/3)`
- `e_R`: right-handed electron, rep `(1, 1, −2)`
- `nu_R`: right-handed neutrino (optional/BSM), rep `(1, 1, 0)`
-/
inductive PhysicalMultiplet where
  | Q_L   -- left-handed quark doublet
  | L_L   -- left-handed lepton doublet
  | u_R   -- right-handed up quark
  | d_R   -- right-handed down quark
  | e_R   -- right-handed electron
  | nu_R  -- right-handed neutrino (optional)
deriving DecidableEq, Repr

namespace PhysicalMultiplet

/-- The chirality of each physical multiplet. -/
def chirality : PhysicalMultiplet → Chirality
  | Q_L  => .left
  | L_L  => .left
  | u_R  => .right
  | d_R  => .right
  | e_R  => .right
  | nu_R => .right

/-- The SU(3)_c representation dimension of each multiplet. -/
def colorDim : PhysicalMultiplet → ℕ
  | Q_L  => 3
  | L_L  => 1
  | u_R  => 3
  | d_R  => 3
  | e_R  => 1
  | nu_R => 1

/-- The SU(2)_L representation dimension of each multiplet. -/
def weakDim : PhysicalMultiplet → ℕ
  | Q_L  => 2
  | L_L  => 2
  | u_R  => 1
  | d_R  => 1
  | e_R  => 1
  | nu_R => 1

/-- Physical hypercharge of each multiplet (under `Q = T₃ + Y/2`). -/
def hypercharge : PhysicalMultiplet → ℚ
  | Q_L  => 1 / 3
  | L_L  => -1
  | u_R  => 4 / 3
  | d_R  => -2 / 3
  | e_R  => -2
  | nu_R => 0

/-- The number of Weyl-spinor degrees of freedom in a multiplet. -/
def weylCount : PhysicalMultiplet → ℕ
  | m => m.colorDim * m.weakDim

end PhysicalMultiplet

/-! ## All-left-handed (charge-conjugate) multiplet type

In the all-left-handed convention, every multiplet is a left-handed Weyl spinor.
Physical right-handed fields are replaced by their charge conjugates, which
are left-handed and carry negated hypercharge.
-/

/--
All-left-handed one-generation Standard Model fermion multiplets.

Physical right-handed fields are replaced by their left-handed charge
conjugates. Charge conjugation flips the sign of hypercharge and replaces
the colour representation by its conjugate (3 ↔ 3̄).

- `Q_L`: left-handed quark doublet, rep `(3, 2, +1/3)`
- `L_L`: left-handed lepton doublet, rep `(1, 2, −1)`
- `u_Rc`: charge conjugate of `u_R`, rep `(3̄, 1, −4/3)`
- `d_Rc`: charge conjugate of `d_R`, rep `(3̄, 1, +2/3)`
- `e_Rc`: charge conjugate of `e_R`, rep `(1, 1, +2)`
- `nu_Rc`: charge conjugate of `nu_R`, rep `(1, 1, 0)`
-/
inductive AllLeftMultiplet where
  | Q_L    -- same as physical
  | L_L    -- same as physical
  | u_Rc   -- charge conjugate of u_R
  | d_Rc   -- charge conjugate of d_R
  | e_Rc   -- charge conjugate of e_R
  | nu_Rc  -- charge conjugate of nu_R
deriving DecidableEq, Repr

namespace AllLeftMultiplet

/-- The SU(3)_c representation dimension of each all-left multiplet. -/
def colorDim : AllLeftMultiplet → ℕ
  | Q_L   => 3
  | L_L   => 1
  | u_Rc  => 3
  | d_Rc  => 3
  | e_Rc  => 1
  | nu_Rc => 1

/-- The SU(2)_L representation dimension of each all-left multiplet. -/
def weakDim : AllLeftMultiplet → ℕ
  | Q_L   => 2
  | L_L   => 2
  | u_Rc  => 1
  | d_Rc  => 1
  | e_Rc  => 1
  | nu_Rc => 1

/-- All-left-handed hypercharge. For charge conjugates, this is the
negation of the physical hypercharge. -/
def hypercharge : AllLeftMultiplet → ℚ
  | Q_L   => 1 / 3
  | L_L   => -1
  | u_Rc  => -(4 / 3)
  | d_Rc  => 2 / 3
  | e_Rc  => 2
  | nu_Rc => 0

/-- The number of Weyl-spinor degrees of freedom in a multiplet.
For antitriplets the colour dimension is still 3. -/
def weylCount : AllLeftMultiplet → ℕ
  | m => m.colorDim * m.weakDim

end AllLeftMultiplet

/-! ## Correspondence between tables -/

/-- Map from physical multiplets to all-left multiplets.
Left-handed multiplets map to themselves; right-handed multiplets map
to their charge conjugates. -/
def toAllLeft : PhysicalMultiplet → AllLeftMultiplet
  | .Q_L  => .Q_L
  | .L_L  => .L_L
  | .u_R  => .u_Rc
  | .d_R  => .d_Rc
  | .e_R  => .e_Rc
  | .nu_R => .nu_Rc

/-- `toAllLeft` is injective: distinct physical multiplets map to
distinct all-left multiplets. -/
theorem toAllLeft_injective : Function.Injective toAllLeft := by
  intro a b h
  cases a <;> cases b <;> simp_all [toAllLeft]

/-! ## Hypercharge conversion under charge conjugation

For left-handed multiplets the hypercharge is preserved. For right-handed
multiplets (which become charge conjugates) the hypercharge is negated.
-/

/-- Hypercharge conversion: for left-handed physical multiplets, the
all-left hypercharge agrees; for right-handed ones, it is negated. -/
theorem hypercharge_conversion (m : PhysicalMultiplet) :
    (toAllLeft m).hypercharge =
      if m.chirality = .left then m.hypercharge
      else -m.hypercharge := by
  cases m <;> simp [toAllLeft, AllLeftMultiplet.hypercharge,
    PhysicalMultiplet.hypercharge, PhysicalMultiplet.chirality]
  all_goals norm_num

/-- Direct form: charge conjugation negates hypercharge for right-handed
fields. -/
theorem hypercharge_negation_right (m : PhysicalMultiplet)
    (h : m.chirality = .right) :
    (toAllLeft m).hypercharge = -m.hypercharge := by
  cases m <;> simp_all [toAllLeft, AllLeftMultiplet.hypercharge,
    PhysicalMultiplet.hypercharge, PhysicalMultiplet.chirality]
  all_goals norm_num

/-- Direct form: left-handed fields keep their hypercharge. -/
theorem hypercharge_preserved_left (m : PhysicalMultiplet)
    (h : m.chirality = .left) :
    (toAllLeft m).hypercharge = m.hypercharge := by
  cases m <;> simp_all [toAllLeft, AllLeftMultiplet.hypercharge,
    PhysicalMultiplet.hypercharge, PhysicalMultiplet.chirality]

/-! ## Weyl-state degree counts match between tables -/

/-- The Weyl-count of each multiplet is preserved by the correspondence. -/
theorem weylCount_preserved (m : PhysicalMultiplet) :
    (toAllLeft m).weylCount = m.weylCount := by
  cases m <;> simp [toAllLeft, AllLeftMultiplet.weylCount,
    AllLeftMultiplet.colorDim, AllLeftMultiplet.weakDim,
    PhysicalMultiplet.weylCount,
    PhysicalMultiplet.colorDim, PhysicalMultiplet.weakDim]

/-! ## Finite lists of multiplets -/

/-- The minimal (15-state) Standard Model physical multiplet list, without ν_R. -/
def physicalList15 : List PhysicalMultiplet :=
  [.Q_L, .L_L, .u_R, .d_R, .e_R]

/-- The full (16-state) Standard Model physical multiplet list, with ν_R. -/
def physicalList16 : List PhysicalMultiplet :=
  [.Q_L, .L_L, .u_R, .d_R, .e_R, .nu_R]

/-- The minimal all-left multiplet list, without ν_R^c. -/
def allLeftList15 : List AllLeftMultiplet :=
  [.Q_L, .L_L, .u_Rc, .d_Rc, .e_Rc]

/-- The full all-left multiplet list, with ν_R^c. -/
def allLeftList16 : List AllLeftMultiplet :=
  [.Q_L, .L_L, .u_Rc, .d_Rc, .e_Rc, .nu_Rc]

/-- The all-left list is the image of the physical list under `toAllLeft`. -/
theorem allLeftList15_eq_map :
    allLeftList15 = physicalList15.map toAllLeft := by
  simp [allLeftList15, physicalList15, toAllLeft]

theorem allLeftList16_eq_map :
    allLeftList16 = physicalList16.map toAllLeft := by
  simp [allLeftList16, physicalList16, toAllLeft]

/-! ## Total Weyl-state counts -/

/-- Total Weyl count for a list of physical multiplets. -/
def totalWeylCount (ms : List PhysicalMultiplet) : ℕ :=
  (ms.map PhysicalMultiplet.weylCount).sum

/-- Total Weyl count for a list of all-left multiplets. -/
def totalWeylCountLeft (ms : List AllLeftMultiplet) : ℕ :=
  (ms.map AllLeftMultiplet.weylCount).sum

/--
**15 Weyl states** per generation without the right-handed neutrino.

This is the minimal anomaly-free fermion content:
- Q_L: 3 × 2 = 6
- L_L: 1 × 2 = 2
- u_R: 3 × 1 = 3
- d_R: 3 × 1 = 3
- e_R: 1 × 1 = 1
- Total: 6 + 2 + 3 + 3 + 1 = 15
-/
theorem weylCount_15 : totalWeylCount physicalList15 = 15 := by decide

/--
**16 Weyl states** per generation with the right-handed neutrino.

Adding ν_R (a colour-singlet, SU(2)-singlet) contributes one more Weyl state.
-/
theorem weylCount_16 : totalWeylCount physicalList16 = 16 := by decide

/-- The all-left table has the same Weyl count (15) as the physical table. -/
theorem weylCountLeft_15 : totalWeylCountLeft allLeftList15 = 15 := by decide

/-- The all-left table has the same Weyl count (16) as the physical table. -/
theorem weylCountLeft_16 : totalWeylCountLeft allLeftList16 = 16 := by decide

/-- The Weyl counts match between physical and all-left tables (15-state). -/
theorem weylCount_match_15 :
    totalWeylCount physicalList15 = totalWeylCountLeft allLeftList15 := by decide

/-- The Weyl counts match between physical and all-left tables (16-state). -/
theorem weylCount_match_16 :
    totalWeylCount physicalList16 = totalWeylCountLeft allLeftList16 := by decide

/-! ## Gell-Mann–Nishijima relation: Q = T₃ + Y/2

For each component of every multiplet we verify `Q = T₃ + Y/2`.

In an SU(2) doublet the upper component has `T₃ = +1/2` and the lower
component has `T₃ = −1/2`. In an SU(2) singlet, `T₃ = 0`.
-/

/-- A component-level record: the quantum numbers of a single Weyl fermion
component (e.g. "up quark in Q_L doublet"). -/
structure ComponentCharge where
  /-- Human-readable label (not used in proofs). -/
  label : String
  /-- The third component of weak isospin. -/
  t3 : ℚ
  /-- Hypercharge. -/
  hypercharge : ℚ
  /-- Electric charge. -/
  charge : ℚ
deriving Repr, DecidableEq

/-- Predicate: the Gell-Mann–Nishijima relation holds for a component. -/
def gellMannNishijima (c : ComponentCharge) : Prop :=
  c.charge = c.t3 + c.hypercharge / 2

instance (c : ComponentCharge) : Decidable (gellMannNishijima c) :=
  inferInstanceAs (Decidable (c.charge = c.t3 + c.hypercharge / 2))

/-- The component charges for every fermion in one generation (physical basis).

Each doublet is split into its upper and lower components.
Singlets have T₃ = 0. -/
def oneGenerationComponents : List ComponentCharge :=
  [ -- Q_L doublet
    ⟨"u_L",  1/2,  1/3,  2/3⟩,
    ⟨"d_L", -1/2,  1/3, -1/3⟩,
    -- L_L doublet
    ⟨"ν_L",  1/2,   -1,    0⟩,
    ⟨"e_L", -1/2,   -1,   -1⟩,
    -- Right-handed singlets (physical hypercharges)
    ⟨"u_R",    0,  4/3,  2/3⟩,
    ⟨"d_R",    0, -2/3, -1/3⟩,
    ⟨"e_R",    0,   -2,   -1⟩ ]

/-- The component charges in the all-left convention.
Right-handed fields become charge conjugates: Y is negated, Q is negated. -/
def oneGenerationComponentsLeft : List ComponentCharge :=
  [ -- Q_L doublet (unchanged)
    ⟨"u_L",    1/2,  1/3,   2/3⟩,
    ⟨"d_L",   -1/2,  1/3,  -1/3⟩,
    -- L_L doublet (unchanged)
    ⟨"ν_L",    1/2,   -1,     0⟩,
    ⟨"e_L",   -1/2,   -1,    -1⟩,
    -- Charge conjugates (T₃ = 0 for singlets, Y negated, Q negated)
    ⟨"u_R^c",    0, -4/3,  -2/3⟩,
    ⟨"d_R^c",    0,  2/3,   1/3⟩,
    ⟨"e_R^c",    0,    2,     1⟩ ]

/--
**Gell-Mann–Nishijima verified for every component** (physical basis).

Each fermion component in `oneGenerationComponents` satisfies `Q = T₃ + Y/2`.
This is checked by exact rational arithmetic.
-/
theorem gellMannNishijima_all_physical :
    ∀ c ∈ oneGenerationComponents, gellMannNishijima c := by
  simp only [oneGenerationComponents, List.mem_cons,
    List.mem_nil_iff, or_false]
  intro c hc
  rcases hc with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp [gellMannNishijima] <;> norm_num

/--
**Gell-Mann–Nishijima verified for every component** (all-left-handed basis).

The charge-conjugate components also satisfy `Q = T₃ + Y/2` with
their negated hypercharge and negated electric charge.
-/
theorem gellMannNishijima_all_left :
    ∀ c ∈ oneGenerationComponentsLeft, gellMannNishijima c := by
  simp only [oneGenerationComponentsLeft, List.mem_cons,
    List.mem_nil_iff, or_false]
  intro c hc
  rcases hc with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp [gellMannNishijima] <;> norm_num

/-! ## Connection to AnomalyPackage

We show that the all-left-handed list, when converted to `ChiralMultiplet`
data used in `AnomalyPackage`, reproduces the same table.
-/

open PhysicsSM.StandardModel.AnomalyPackage

/-- Convert an `AllLeftMultiplet` to the `ChiralMultiplet` record used by
the anomaly cancellation package. -/
def AllLeftMultiplet.toChiralMultiplet : AllLeftMultiplet → ChiralMultiplet
  | .Q_L   => ⟨"Q_L",   .triplet,     .doublet, 1/3⟩
  | .L_L   => ⟨"L_L",   .singlet,     .doublet, -1⟩
  | .u_Rc  => ⟨"u_R^c", .antiTriplet, .singlet, -(4/3)⟩
  | .d_Rc  => ⟨"d_R^c", .antiTriplet, .singlet, 2/3⟩
  | .e_Rc  => ⟨"e_R^c", .singlet,     .singlet, 2⟩
  | .nu_Rc => ⟨"nu_R^c", .singlet,    .singlet, 0⟩

/-- The all-left list (without ν_R^c) maps to the same anomaly-package table
used in `standardModelOneGeneration`. -/
theorem allLeftList15_toChiralMultiplet_eq :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration := by
  simp only [allLeftList15, standardModelOneGeneration,
    AllLeftMultiplet.toChiralMultiplet, List.map_cons, List.map_nil]
  norm_num

/-! ## Octonionic realization boundary

The following section explicitly documents what the Krasnov/Baez `O²`
construction does and does not cover, as a checked proposition rather
than a comment.
-/

/-- The subset of multiplets that are left-handed in the physical table. -/
def leftHandedMultiplets : List PhysicalMultiplet :=
  physicalList16.filter (fun m => decide (m.chirality = .left))

/-- The subset of multiplets that are right-handed in the physical table. -/
def rightHandedMultiplets : List PhysicalMultiplet :=
  physicalList16.filter (fun m => decide (m.chirality = .right))

/-- There are exactly 2 left-handed multiplets (Q_L and L_L). -/
theorem leftHanded_count : leftHandedMultiplets.length = 2 := by decide

/-- There are exactly 4 right-handed multiplets (u_R, d_R, e_R, ν_R). -/
theorem rightHanded_count : rightHandedMultiplets.length = 4 := by decide

/-- Left-handed Weyl-state count: 6 + 2 = 8. -/
theorem leftHanded_weylCount :
    (leftHandedMultiplets.map PhysicalMultiplet.weylCount).sum = 8 := by decide

/-- Right-handed Weyl-state count: 3 + 3 + 1 + 1 = 8. -/
theorem rightHanded_weylCount :
    (rightHandedMultiplets.map PhysicalMultiplet.weylCount).sum = 8 := by decide

/-- The left- and right-handed sectors have equal Weyl-state counts. -/
theorem leftRight_weylCount_balanced :
    (leftHandedMultiplets.map PhysicalMultiplet.weylCount).sum =
    (rightHandedMultiplets.map PhysicalMultiplet.weylCount).sum := by decide

end PhysicsSM.StandardModel.OneGenerationTable
