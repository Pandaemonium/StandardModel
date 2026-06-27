import Mathlib

/-!
# Standard Model one-generation anomaly package (self-contained)

This module provides the *combinatorial* Standard Model anomaly-cancellation
package used by the null-edge internal-spectrum bridge.

## Reconstruction note

In the checkout this file is built from, the foundational Furey / octonion
modules (`PhysicsSM.Algebra.Octonion.*`, `PhysicsSM.Algebra.Furey.LadderOperators`,
`PhysicsSM.Algebra.Furey.OperatorRepresentations`, …) and the original
`PhysicsSM.StandardModel.AnomalyPackage` were **not present**.  Several draft
modules (in particular `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`) import
this package, so it is reconstructed here as a *self-contained, Mathlib-only,
pure list/rational* development.  It deliberately contains **no** octonionic or
kinetic content: it is charge / representation bookkeeping only.

The content is the conventional anomaly arithmetic for one all-left-handed
generation of Standard Model fermions in the convention `Q = T₃ + Y`
(so `Y_{Q_L} = 1/6`).  Right-handed fields are stored as their left-handed
charge conjugates with the hypercharge sign flipped (`u_R^c`, `d_R^c`, `e_R^c`).

## What is recorded

* `ChiralMultiplet` — a left-handed Weyl multiplet `(label, colour, weak, Y,
  colourIndex)`, where `colourIndex ∈ {+1, -1, 0}` is the `SU(3)` cubic-anomaly
  index (`+1` triplet, `-1` antitriplet, `0` singlet).
* the five perturbative anomaly functionals and the Witten doublet count,
* `LocalAnomalyFree` / `WittenSU2AnomalyFree`,
* the canonical `standardModelOneGeneration` table and proofs that it is anomaly
  free,
* an `nCopies` family wrapper and its inherited anomaly-freedom.
-/

namespace PhysicsSM.StandardModel.AnomalyPackage

/-- A left-handed Weyl chiral multiplet.

* `label`       — a human-readable name (`"Q_L"`, `"u_R^c"`, …);
* `colour`      — `SU(3)_c` multiplicity (dimension of the colour rep);
* `weak`        — `SU(2)_L` multiplicity (dimension of the weak rep);
* `Y`           — weak hypercharge in the convention `Q = T₃ + Y`;
* `colourIndex` — `SU(3)` cubic-anomaly index: `+1` for a triplet `3`,
  `-1` for an antitriplet `3̄`, `0` for a colour singlet.

All-left convention: right-handed Standard Model fields are stored as their
left-handed charge conjugates with the hypercharge sign flipped. -/
structure ChiralMultiplet where
  /-- Human-readable particle label. -/
  label : String
  /-- `SU(3)_c` multiplicity. -/
  colour : ℕ
  /-- `SU(2)_L` multiplicity. -/
  weak : ℕ
  /-- Weak hypercharge (`Q = T₃ + Y`). -/
  Y : ℚ
  /-- `SU(3)` cubic-anomaly index (`+1` triplet, `-1` antitriplet, `0` singlet). -/
  colourIndex : ℤ
  deriving DecidableEq, Repr

/-- Number of Weyl components in a multiplet, `colour · weak`. -/
def ChiralMultiplet.mult (m : ChiralMultiplet) : ℕ := m.colour * m.weak

/-! ## Anomaly functionals -/

/-- Gravitational–`U(1)_Y` mixed anomaly `Σ mult · Y`. -/
def gravitationalU1Anomaly (l : List ChiralMultiplet) : ℚ :=
  (l.map (fun m => (m.mult : ℚ) * m.Y)).sum

/-- `U(1)_Y³` cubic anomaly `Σ mult · Y³`. -/
def u1CubedAnomaly (l : List ChiralMultiplet) : ℚ :=
  (l.map (fun m => (m.mult : ℚ) * m.Y ^ 3)).sum

/-- `SU(2)_L²–U(1)_Y` mixed anomaly `Σ_{weak doublets} colour · Y`. -/
def su2SquaredU1Anomaly (l : List ChiralMultiplet) : ℚ :=
  ((l.filter (fun m => m.weak = 2)).map (fun m => (m.colour : ℚ) * m.Y)).sum

/-- `SU(3)_c²–U(1)_Y` mixed anomaly `Σ_{colour triplets} weak · Y`. -/
def su3SquaredU1Anomaly (l : List ChiralMultiplet) : ℚ :=
  ((l.filter (fun m => m.colour = 3)).map (fun m => (m.weak : ℚ) * m.Y)).sum

/-- `SU(3)_c³` cubic anomaly `Σ colourIndex · weak`. -/
def su3CubedAnomaly (l : List ChiralMultiplet) : ℤ :=
  (l.map (fun m => m.colourIndex * (m.weak : ℤ))).sum

/-- Total `SU(2)_L` doublet count (with colour multiplicity). -/
def weakDoubletCount (l : List ChiralMultiplet) : ℕ :=
  ((l.filter (fun m => m.weak = 2)).map (fun m => m.colour)).sum

/-! ## Anomaly-freedom predicates -/

/-- All five perturbative anomaly coefficients vanish. -/
def LocalAnomalyFree (l : List ChiralMultiplet) : Prop :=
  gravitationalU1Anomaly l = 0 ∧ u1CubedAnomaly l = 0 ∧
  su2SquaredU1Anomaly l = 0 ∧ su3SquaredU1Anomaly l = 0 ∧ su3CubedAnomaly l = 0

/-- Witten's global `SU(2)` anomaly condition: the doublet count is even. -/
def WittenSU2AnomalyFree (l : List ChiralMultiplet) : Prop :=
  Even (weakDoubletCount l)

/-! ## The canonical one-generation table -/

/-- One generation, all-left-handed, in the convention `Q = T₃ + Y`:
`Q_L(3,2,1/6)`, `L_L(1,2,-1/2)`, `u_R^c(3̄,1,-2/3)`, `d_R^c(3̄,1,1/3)`,
`e_R^c(1,1,1)`. -/
def standardModelOneGeneration : List ChiralMultiplet :=
  [ ⟨"Q_L",   3, 2,  1/6,  1⟩,
    ⟨"L_L",   1, 2, -1/2,  0⟩,
    ⟨"u_R^c", 3, 1, -2/3, -1⟩,
    ⟨"d_R^c", 3, 1,  1/3, -1⟩,
    ⟨"e_R^c", 1, 1,  1,    0⟩ ]

/-- The one-generation table is locally (perturbatively) anomaly free. -/
theorem standardModelOneGeneration_localAnomalyFree :
    LocalAnomalyFree standardModelOneGeneration := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    simp only [gravitationalU1Anomaly, u1CubedAnomaly, su2SquaredU1Anomaly,
      su3SquaredU1Anomaly, su3CubedAnomaly, standardModelOneGeneration,
      ChiralMultiplet.mult, List.map, List.filter, List.sum] <;> norm_num

/-- The one-generation table satisfies Witten's global `SU(2)` anomaly
condition (the doublet count is `4`, which is even). -/
theorem standardModelOneGeneration_wittenAnomalyFree :
    WittenSU2AnomalyFree standardModelOneGeneration := by
  unfold WittenSU2AnomalyFree weakDoubletCount standardModelOneGeneration
  norm_num [List.filter, List.map, List.sum]

/-! ## Multi-generation scaling -/

/-- `n` identical copies of a multiplet list (the `n`-generation family). -/
def nCopies (n : ℕ) (l : List ChiralMultiplet) : List ChiralMultiplet :=
  (List.replicate n l).flatten

theorem gravitationalU1Anomaly_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    gravitationalU1Anomaly (nCopies n l) = n * gravitationalU1Anomaly l := by
  induction n with
  | zero => simp [nCopies, gravitationalU1Anomaly]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [gravitationalU1Anomaly, List.map_append, List.sum_append] at *
      rw [ih]; push_cast; ring

theorem u1CubedAnomaly_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    u1CubedAnomaly (nCopies n l) = n * u1CubedAnomaly l := by
  induction n with
  | zero => simp [nCopies, u1CubedAnomaly]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [u1CubedAnomaly, List.map_append, List.sum_append] at *
      rw [ih]; push_cast; ring

theorem su2SquaredU1Anomaly_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    su2SquaredU1Anomaly (nCopies n l) = n * su2SquaredU1Anomaly l := by
  induction n with
  | zero => simp [nCopies, su2SquaredU1Anomaly]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [su2SquaredU1Anomaly, List.filter_append, List.map_append,
        List.sum_append] at *
      rw [ih]; push_cast; ring

theorem su3SquaredU1Anomaly_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    su3SquaredU1Anomaly (nCopies n l) = n * su3SquaredU1Anomaly l := by
  induction n with
  | zero => simp [nCopies, su3SquaredU1Anomaly]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [su3SquaredU1Anomaly, List.filter_append, List.map_append,
        List.sum_append] at *
      rw [ih]; push_cast; ring

theorem su3CubedAnomaly_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    su3CubedAnomaly (nCopies n l) = n * su3CubedAnomaly l := by
  induction n with
  | zero => simp [nCopies, su3CubedAnomaly]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [su3CubedAnomaly, List.map_append, List.sum_append] at *
      rw [ih]; push_cast; ring

theorem weakDoubletCount_nCopies (n : ℕ) (l : List ChiralMultiplet) :
    weakDoubletCount (nCopies n l) = n * weakDoubletCount l := by
  induction n with
  | zero => simp [nCopies, weakDoubletCount]
  | succ k ih =>
      simp only [nCopies, List.replicate_succ, List.flatten_cons] at *
      simp only [weakDoubletCount, List.filter_append, List.map_append,
        List.sum_append] at *
      rw [ih]; ring

/-- **Family scaling.** If `l` is locally anomaly free, so is any number of
identical copies of it. -/
theorem nCopies_localAnomalyFree (n : ℕ) (l : List ChiralMultiplet)
    (h : LocalAnomalyFree l) : LocalAnomalyFree (nCopies n l) := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [gravitationalU1Anomaly_nCopies, h1, mul_zero]
  · rw [u1CubedAnomaly_nCopies, h2, mul_zero]
  · rw [su2SquaredU1Anomaly_nCopies, h3, mul_zero]
  · rw [su3SquaredU1Anomaly_nCopies, h4, mul_zero]
  · rw [su3CubedAnomaly_nCopies, h5, mul_zero]

end PhysicsSM.StandardModel.AnomalyPackage
