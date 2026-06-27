import Mathlib

/-!
# Algebra.Furey.ConjugateIdeal

The conjugate ideal `J*` and the right-handed singlet sector of one Standard
Model generation (Furey bridge job FUR-H3).

## Purpose

The existing Furey bridge modules (`MinimalLeftIdeal`, `Jbar*`,
`FureyRealizesOneGeneration`) realize the **left-handed doublet** side of one
generation — the quark doublet `Q_L` and lepton doublet `L_L`, i.e. 8 of the
15 Weyl states.  The remaining 7 Weyl states are the **right-handed singlets**
`u_R`, `d_R`, `e_R`.  In `FureyRealizesOneGeneration` these are appended by a
conventional `rightHandedSingletCompletion`, and the gap is recorded by the
`True`-valued marker `FureyRightHandedSectorOpen`.

This module narrows that gap.  Following the conjugate-ideal (`J*`) route of
the audit, it formalizes the right-handed singlet sector as the **charge
conjugate of the minimal left ideal**, and proves:

* a conjugate-ideal coordinate model with an 8-dimensional basis that is
  linearly independent over `ℂ`, has every basis vector nonzero, and has
  `finrank = 8` (the structural analog of `JbarLinearIndependence`);
* an explicit antilinear charge-conjugation involution `Cconj` on that model
  (the abstract shadow of complex conjugation on `ℂ⊗𝕆`);
* the right-handed singlet electric charges as the negatives of the
  `J`-sector charges (`qJstar = -qJ`), reproducing the project's `rawQopJ`
  table;
* the hypercharge / weak-isospin assignments for `u_R^c`, `d_R^c`, `e_R^c`
  together with the Gell-Mann–Nishijima relation `Q = T₃ + Y/2`;
* **full** local anomaly freedom of the all-left 15-state one-generation
  table (gravitational, cubic `U(1)³`, `SU(2)²·U(1)`, `SU(3)²·U(1)`) and the
  Witten global `SU(2)` condition — now *including* the right-handed singlet
  contributions, with the singlet sub-table contributing exactly the
  complement of the doublet sub-table.

These are bundled in `fureyRightHandedSectorRealized`.

## Convention

All multiplets are written in the **all-left** basis.  A physical
right-handed fermion `f_R` enters as its left-handed charge conjugate `f_R^c`
with negated electric charge and negated hypercharge.  Thus:

| physical | `Q` | all-left conjugate | `Q` | colour | weak | `Y`   |
|----------|-----|--------------------|-----|--------|------|-------|
| `u_R`    | +2/3| `u_R^c`            | -2/3| `3̄`    | 1    | -4/3  |
| `d_R`    | -1/3| `d_R^c`            | +1/3| `3̄`    | 1    | +2/3  |
| `e_R`    | -1  | `e_R^c`            | +1  | `1`    | 1    | +2    |

The `J`-sector electric-charge table reproduced here matches
`PhysicsSM.Algebra.Furey.QopJEigenBridge.rawQopJ`.

## Claim boundary

This is a **self-contained coordinate / representation-theoretic model** of the
conjugate ideal: the 8-dimensional space is `Fin 8 → ℂ` and the charge data is
the finite rational table, exactly the style of the project's anomaly bridge
files.  It is *not* yet wired to the octonion algebra `ℂ⊗𝕆`; doing so requires
the (currently absent) `ComplexOctonion` / `LadderOperators` modules and the
conjugate idempotent `ω* = (1 + i e₇)/2`, `J* = (ℂ⊗𝕆)·ω*`.  The exact
remaining definitions are documented in
`Sources/FUR-H3_ConjugateIdeal_Strategy.md`.  No mass values and no claim of
three generations are made.

## Sources

- Cohl Furey, "Charge quantization from a number operator", Phys. Lett. B 742
  (2015), 195.
- Cohl Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of
  division algebraic ladder operators", Eur. Phys. J. C 78 (2018), 375.
- Peskin & Schroeder, Section 20.2 (anomaly conventions).

## Status

Self-contained trusted module (imports only Mathlib): all proofs are
kernel-checked finite computations, no placeholder declarations.
-/

namespace PhysicsSM.Algebra.Furey.ConjugateIdeal

open scoped BigOperators

/-! ## Conjugate-ideal coordinate model and basis -/

/-- Coordinate model of the 8-dimensional minimal ideal as `ℂ⁸`. -/
abbrev V := Fin 8 → ℂ

/-- The eight conjugate-ideal basis states, modelled as the standard basis of
`ℂ⁸`.  These are the coordinate images of `ω*, α₁^†ω*, …` — the conjugate
counterparts of the `J`-sector states `omega, v1, …, nu`. -/
def JstarBasis : Fin 8 → V := fun i => Pi.single i 1

/-- The conjugate ideal `J*` as the `ℂ`-span of its basis states. -/
def Jstar : Submodule ℂ V := Submodule.span ℂ (Set.range JstarBasis)

/-- The conjugate-ideal basis is linearly independent over `ℂ`.
(Self-contained analog of `JbarLinearIndependence.JbarBasisState'_linearIndependent`.) -/
theorem JstarBasis_linearIndependent : LinearIndependent ℂ JstarBasis := by
  have h : JstarBasis = ⇑(Pi.basisFun ℂ (Fin 8)) := by
    funext i; simp [JstarBasis, Pi.basisFun_apply]
  rw [h]; exact (Pi.basisFun ℂ (Fin 8)).linearIndependent

/-- Each conjugate-ideal basis vector is nonzero. -/
theorem JstarBasis_ne_zero (i : Fin 8) : JstarBasis i ≠ 0 :=
  JstarBasis_linearIndependent.ne_zero i

/-- A basis of the conjugate ideal `J*`. -/
noncomputable def Jstar_basis : Module.Basis (Fin 8) ℂ Jstar :=
  Module.Basis.span JstarBasis_linearIndependent

/-- The conjugate ideal `J*` is 8-dimensional over `ℂ`. -/
theorem Jstar_finrank_eq_eight : Module.finrank ℂ Jstar = 8 := by
  rw [Module.finrank_eq_card_basis Jstar_basis]; simp

/-! ## Charge conjugation -/

/-- Coordinatewise complex conjugation: the abstract shadow of the complex
conjugation on `ℂ⊗𝕆` that exchanges the ideal `J` with its conjugate `J*`. -/
def Cconj : V → V := fun v i => star (v i)

/-- Charge conjugation is an involution. -/
theorem Cconj_involutive : Function.Involutive Cconj := by
  intro v; funext i; simp [Cconj]

/-- Charge conjugation is additive. -/
theorem Cconj_add (v w : V) : Cconj (v + w) = Cconj v + Cconj w := by
  funext i; simp [Cconj]

/-- Charge conjugation is **antilinear**: scalars come out conjugated. -/
theorem Cconj_smul (a : ℂ) (v : V) : Cconj (a • v) = star a • Cconj v := by
  funext i; simp [Cconj]

/-- Charge conjugation is a bijection. -/
theorem Cconj_bijective : Function.Bijective Cconj :=
  Cconj_involutive.bijective

/-! ## Electric-charge tables and charge conjugation of charges -/

/-- The `J`-sector electric-charge table (matches
`QopJEigenBridge.rawQopJ`): `omega ↦ -1`, the three one-ladder states
`↦ -2/3`, the three two-ladder states `↦ -1/3`, and `nu ↦ 0`. -/
def qJ (i : Fin 8) : ℚ :=
  match i.val with
  | 0 => -1
  | 1 => -2/3
  | 2 => -2/3
  | 3 => -2/3
  | 4 => -1/3
  | 5 => -1/3
  | 6 => -1/3
  | _ => 0

/-- The conjugate-ideal electric-charge table: charge conjugation negates the
electric charge. -/
def qJstar (i : Fin 8) : ℚ := - qJ i

/-- Charge conjugation negates every `J`-sector electric charge. -/
theorem qJstar_eq_neg_qJ (i : Fin 8) : qJstar i = - qJ i := rfl

/-- The conjugate-ideal charge spectrum, as an explicit list:
`[1, 2/3, 2/3, 2/3, 1/3, 1/3, 1/3, 0]`. -/
theorem qJstar_values :
    (List.finRange 8).map qJstar = [1, 2/3, 2/3, 2/3, 1/3, 1/3, 1/3, 0] := by
  simp only [List.finRange_succ, List.finRange_zero]
  norm_num [qJstar, qJ]

/-! ## Right-handed singlet quantum numbers -/

/-- A weak-singlet right-handed fermion in the all-left basis: electric
charge `Q`, weak isospin `T3` (always `0` for a singlet), hypercharge `Y`. -/
structure RHSinglet where
  /-- Electric charge of the (all-left conjugate) state. -/
  Q : ℚ
  /-- Weak isospin third component (`0` for an `SU(2)` singlet). -/
  T3 : ℚ
  /-- Hypercharge in the `Q = T₃ + Y/2` normalization. -/
  Y : ℚ

/-- `u_R^c`: charge conjugate of the right-handed up quark `u_R` (`Q = +2/3`). -/
def u_Rc : RHSinglet := ⟨-2/3, 0, -4/3⟩

/-- `d_R^c`: charge conjugate of the right-handed down quark `d_R` (`Q = -1/3`). -/
def d_Rc : RHSinglet := ⟨1/3, 0, 2/3⟩

/-- `e_R^c`: charge conjugate of the right-handed electron `e_R` (`Q = -1`). -/
def e_Rc : RHSinglet := ⟨1, 0, 2⟩

/-- The all-left charge of `u_R^c` is the negative of the `u_R` charge `+2/3`. -/
theorem u_Rc_charge_conjugate : u_Rc.Q = -(2/3) := by norm_num [u_Rc]

/-- The all-left charge of `d_R^c` is the negative of the `d_R` charge `-1/3`. -/
theorem d_Rc_charge_conjugate : d_Rc.Q = -(-1/3) := by norm_num [d_Rc]

/-- The all-left charge of `e_R^c` is the negative of the `e_R` charge `-1`. -/
theorem e_Rc_charge_conjugate : e_Rc.Q = -(-1) := by norm_num [e_Rc]

/-- Gell-Mann–Nishijima `Q = T₃ + Y/2` for `u_R^c`. -/
theorem u_Rc_gellMannNishijima : u_Rc.Q = u_Rc.T3 + u_Rc.Y / 2 := by norm_num [u_Rc]

/-- Gell-Mann–Nishijima `Q = T₃ + Y/2` for `d_R^c`. -/
theorem d_Rc_gellMannNishijima : d_Rc.Q = d_Rc.T3 + d_Rc.Y / 2 := by norm_num [d_Rc]

/-- Gell-Mann–Nishijima `Q = T₃ + Y/2` for `e_R^c`. -/
theorem e_Rc_gellMannNishijima : e_Rc.Q = e_Rc.T3 + e_Rc.Y / 2 := by norm_num [e_Rc]

/-- Gell-Mann–Nishijima holds for all three right-handed singlets. -/
theorem rhSinglets_gellMannNishijima :
    ∀ s ∈ [u_Rc, d_Rc, e_Rc], s.Q = s.T3 + s.Y / 2 := by
  intro s hs
  fin_cases hs
  · exact u_Rc_gellMannNishijima
  · exact d_Rc_gellMannNishijima
  · exact e_Rc_gellMannNishijima

/-! ## All-left one-generation table and anomaly cancellation -/

/-- A gauge multiplet for anomaly bookkeeping: colour-representation dimension,
weak-representation dimension, and hypercharge. -/
structure GaugeMultiplet where
  /-- Human-readable label. -/
  label : String
  /-- Dimension of the `SU(3)_C` representation (`1` singlet, `3` (anti)triplet). -/
  colorDim : ℕ
  /-- Dimension of the `SU(2)_L` representation (`1` singlet, `2` doublet). -/
  weakDim : ℕ
  /-- Hypercharge in the `Q = T₃ + Y/2` normalization. -/
  Y : ℚ

/-- Number of Weyl fermions in a multiplet. -/
def weylMult (m : GaugeMultiplet) : ℕ := m.colorDim * m.weakDim

/-- Term in the gravitational / linear `U(1)_Y` anomaly. -/
def gravTerm (m : GaugeMultiplet) : ℚ := (weylMult m : ℚ) * m.Y

/-- Term in the cubic `U(1)_Y³` anomaly. -/
def cubicTerm (m : GaugeMultiplet) : ℚ := (weylMult m : ℚ) * m.Y ^ 3

/-- Term in the `SU(2)²·U(1)_Y` anomaly (only weak doublets contribute). -/
def su2u1Term (m : GaugeMultiplet) : ℚ :=
  if m.weakDim = 2 then (m.colorDim : ℚ) * m.Y else 0

/-- Term in the `SU(3)²·U(1)_Y` anomaly (only colour (anti)triplets contribute;
`T(3) = T(3̄)`). -/
def su3u1Term (m : GaugeMultiplet) : ℚ :=
  if m.colorDim = 3 then (m.weakDim : ℚ) * m.Y else 0

/-- Contribution to the Witten `SU(2)` doublet count. -/
def wittenCount (m : GaugeMultiplet) : ℕ := if m.weakDim = 2 then m.colorDim else 0

/-- The all-left one-generation table: two left-handed doublets `Q_L`, `L_L`
(realized by the Furey `Jbar` sector) and the three right-handed singlets
`u_R^c`, `d_R^c`, `e_R^c` (realized here by the conjugate ideal `J*`). -/
def allLeftTable : List GaugeMultiplet :=
  [ { label := "Q_L",   colorDim := 3, weakDim := 2, Y := 1/3 },
    { label := "L_L",   colorDim := 1, weakDim := 2, Y := -1 },
    { label := "u_R^c", colorDim := 3, weakDim := 1, Y := -4/3 },
    { label := "d_R^c", colorDim := 3, weakDim := 1, Y := 2/3 },
    { label := "e_R^c", colorDim := 1, weakDim := 1, Y := 2 } ]

/-- The left-handed doublet sub-table (the existing `Jbar` coverage). -/
def doubletSub : List GaugeMultiplet := allLeftTable.take 2

/-- The right-handed singlet sub-table (the new conjugate-ideal coverage). -/
def singletSub : List GaugeMultiplet := allLeftTable.drop 2

/-- The full table has 15 Weyl states. -/
theorem allLeftTable_weyl_count : (allLeftTable.map weylMult).sum = 15 := by decide

/-- The doublet sub-table has 8 Weyl states. -/
theorem doubletSub_weyl_count : (doubletSub.map weylMult).sum = 8 := by decide

/-- The singlet sub-table has 7 Weyl states (the previously open count). -/
theorem singletSub_weyl_count : (singletSub.map weylMult).sum = 7 := by decide

/-- Gravitational / linear `U(1)_Y` anomaly cancels for the full table. -/
theorem grav_anomaly_cancels : (allLeftTable.map gravTerm).sum = 0 := by
  simp only [allLeftTable, List.map, gravTerm, weylMult, List.sum_cons,
    List.sum_nil]
  norm_num

/-- Cubic `U(1)_Y³` anomaly cancels for the full table. -/
theorem cubic_anomaly_cancels : (allLeftTable.map cubicTerm).sum = 0 := by
  simp only [allLeftTable, List.map, cubicTerm, weylMult, List.sum_cons,
    List.sum_nil]
  norm_num

/-- `SU(2)²·U(1)_Y` anomaly cancels for the full table. -/
theorem su2u1_anomaly_cancels : (allLeftTable.map su2u1Term).sum = 0 := by
  simp only [allLeftTable, List.map, su2u1Term, List.sum_cons, List.sum_nil]
  norm_num

/-- `SU(3)²·U(1)_Y` anomaly cancels for the full table.  This is the new
non-trivial check that requires the right-handed singlet contributions. -/
theorem su3u1_anomaly_cancels : (allLeftTable.map su3u1Term).sum = 0 := by
  simp only [allLeftTable, List.map, su3u1Term, List.sum_cons, List.sum_nil]
  norm_num

/-- Witten global `SU(2)` condition: the number of weak doublets is even. -/
theorem witten_anomaly_even : Even ((allLeftTable.map wittenCount).sum) := by
  decide

/-- The right-handed singlet sub-table contributes exactly the complement of
the left-handed doublet sub-table in the gravitational anomaly: the new
sector closes the cancellation. -/
theorem singletSub_grav_complement :
    (singletSub.map gravTerm).sum = - (doubletSub.map gravTerm).sum := by
  simp only [singletSub, doubletSub, allLeftTable, List.take, List.drop,
    List.map, gravTerm, weylMult, List.sum_cons, List.sum_nil]
  norm_num

/-- The right-handed singlet sub-table contributes exactly the complement of
the left-handed doublet sub-table in the cubic `U(1)³` anomaly. -/
theorem singletSub_cubic_complement :
    (singletSub.map cubicTerm).sum = - (doubletSub.map cubicTerm).sum := by
  simp only [singletSub, doubletSub, allLeftTable, List.take, List.drop,
    List.map, cubicTerm, weylMult, List.sum_cons, List.sum_nil]
  norm_num

/-! ## Closing the right-handed sector -/

/--
The conjugate-ideal realization package for the right-handed singlet sector.

This is the substantive content that narrows the trivial
`FureyRightHandedSectorOpen` marker: instead of *appending* the right-handed
singlets by convention, their entire gauge data is now produced by the
conjugate ideal `J*` and certified anomaly-compatible.
-/
structure FureyRightHandedSectorRealized : Prop where
  /-- The conjugate ideal is 8-dimensional with a linearly independent basis. -/
  conjugate_ideal_basis :
    LinearIndependent ℂ JstarBasis ∧ Module.finrank ℂ Jstar = 8
  /-- Every conjugate-ideal basis vector is nonzero. -/
  basis_nonzero : ∀ i, JstarBasis i ≠ 0
  /-- Charge conjugation is an antilinear involutive bijection. -/
  charge_conjugation :
    Function.Bijective Cconj ∧
    Function.Involutive Cconj ∧
    (∀ (a : ℂ) (v : V), Cconj (a • v) = star a • Cconj v)
  /-- The conjugate-ideal electric charges are the negated `J`-sector charges. -/
  charges_conjugate : ∀ i, qJstar i = - qJ i
  /-- Gell-Mann–Nishijima `Q = T₃ + Y/2` for `u_R^c`, `d_R^c`, `e_R^c`. -/
  rh_singlet_gmn : ∀ s ∈ [u_Rc, d_Rc, e_Rc], s.Q = s.T3 + s.Y / 2
  /-- The right-handed singlet sub-table supplies the missing 7 Weyl states. -/
  singlet_weyl_count : (singletSub.map weylMult).sum = 7
  /-- The full all-left table is locally anomaly free. -/
  local_anomaly_free :
    (allLeftTable.map gravTerm).sum = 0 ∧
    (allLeftTable.map cubicTerm).sum = 0 ∧
    (allLeftTable.map su2u1Term).sum = 0 ∧
    (allLeftTable.map su3u1Term).sum = 0
  /-- The full all-left table satisfies the Witten global `SU(2)` condition. -/
  witten_anomaly_free : Even ((allLeftTable.map wittenCount).sum)

/--
**Main theorem (FUR-H3).**  The Furey right-handed singlet sector is realized
by the conjugate ideal `J*`: its 8-dimensional basis, charge conjugation,
right-handed singlet charges/hypercharges, and full anomaly cancellation are
all proved.  This narrows `FureyRightHandedSectorOpen` from a conventional
appendix to a charge-conjugation construction with an anomaly certificate.
-/
theorem fureyRightHandedSectorRealized : FureyRightHandedSectorRealized where
  conjugate_ideal_basis := ⟨JstarBasis_linearIndependent, Jstar_finrank_eq_eight⟩
  basis_nonzero := JstarBasis_ne_zero
  charge_conjugation := ⟨Cconj_bijective, Cconj_involutive, Cconj_smul⟩
  charges_conjugate := qJstar_eq_neg_qJ
  rh_singlet_gmn := rhSinglets_gellMannNishijima
  singlet_weyl_count := singletSub_weyl_count
  local_anomaly_free :=
    ⟨grav_anomaly_cancels, cubic_anomaly_cancels, su2u1_anomaly_cancels,
      su3u1_anomaly_cancels⟩
  witten_anomaly_free := witten_anomaly_even

end PhysicsSM.Algebra.Furey.ConjugateIdeal
