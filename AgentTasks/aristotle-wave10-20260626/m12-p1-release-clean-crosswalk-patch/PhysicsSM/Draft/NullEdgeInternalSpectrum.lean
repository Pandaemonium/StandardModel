import Mathlib
import PhysicsSM.StandardModel.AnomalyPackage

/-!
# Null-edge internal spectrum API and anomaly inheritance

This file defines a small, reusable interface — `NullEdgeInternalSpectrum` —
for the *internal sector* of the null-edge program (Gate H), and proves an
**anomaly inheritance** theorem: any null-edge internal spectrum whose
multiplet content realizes the canonical Standard Model one-generation table
automatically inherits the full perturbative + Witten anomaly-cancellation
package, with **no rearithmetic**.

## Scope (Gate H is internal-sector only)

This API only bookkeeps internal charges, gradings, multiplets, and legal
Yukawa pairings. It is deliberately *not* a kinetic/geometric statement.
In particular it does **not** claim or use:

* null-edge kinetic geometry / the soldered Clifford-module Dirac operator,
* Gate C (branch classification) or Gate D (DEC/connection-Laplacian),
* QCD confinement/dynamics,
* the internal mass map `Phi_H` or any moduli content.

It records exactly the data needed so that `Phi_H` (defined elsewhere) is not
arbitrary: the internal charges, the `chi_E` Z/2 grading, the multiplet
structure, and which Yukawa maps are legal.

## What is inherited

For a spectrum `S` with `S.RealizesOneGeneration` (its multiplet list is the
canonical `standardModelOneGeneration` table) we inherit, verbatim from
`PhysicsSM.StandardModel.AnomalyPackage`:

1. gravitational–U(1)_Y mixed anomaly = 0,
2. U(1)_Y³ cubic anomaly = 0,
3. SU(2)_L²–U(1)_Y mixed anomaly = 0,
4. SU(3)_c²–U(1)_Y mixed anomaly = 0,
5. SU(3)_c³ cubic anomaly = 0,
6. Witten global SU(2)_L anomaly (even doublet count).

A multi-generation wrapper (`nGenerations_localAnomalyFree`) is also provided
via the existing `nCopies` scaling lemmas.

## What is *not* claimed

Nothing about kinetic terms, masses, gauge dynamics, or geometry. The
`grading` and `legalYukawa` fields are *bookkeeping only*: they play no role
in (and are not constrained by) the anomaly theorems, which depend only on the
representation/charge content of the multiplets.

## Furey is one realization, not an assumption

The Furey `Cl(6)`/octonionic construction is *one* way to populate this API
(`fureyStyleRealization` below witnesses the realization predicate using the
SM table that the Furey bridge proves it reproduces). It is included as an
example, never as a mandatory kinetic input.
-/

namespace PhysicsSM.NullEdge

open PhysicsSM.StandardModel.AnomalyPackage

/-- A `chi_E` internal Z/2 grading label for a multiplet. The internal sector
is `chi_E`-odd; this label lets a spectrum record the grading explicitly
without committing to any particular operator realization. -/
inductive InternalGrading
  | even
  | odd
  deriving DecidableEq, Repr

/--
A **null-edge internal spectrum**: the internal-sector data needed for
charge / multiplet / grading bookkeeping.

* `multiplets` — the finite list of left-handed chiral multiplets, in the
  charge-conjugate convention of `AnomalyPackage.ChiralMultiplet` (so each
  field carries its `SU(3)_c`, `SU(2)_L` representation and hypercharge `Y`).
* `grading` — the `chi_E` internal Z/2 grading attached to each multiplet.
* `legalYukawa` — a decidable relation recording which ordered pairs of
  multiplets admit a legal (gauge-compatible, Higgs-mediated) Yukawa map.

The last two fields are *structural bookkeeping*: they make `Phi_H` and the
internal grading explicit but do not enter the anomaly theorems.
-/
structure NullEdgeInternalSpectrum where
  /-- Left-handed chiral multiplets (charge-conjugate convention). -/
  multiplets : List ChiralMultiplet
  /-- The `chi_E` internal Z/2 grading on each multiplet. -/
  grading : ChiralMultiplet → InternalGrading
  /-- Which ordered multiplet pairs admit a legal Yukawa map. -/
  legalYukawa : ChiralMultiplet → ChiralMultiplet → Bool

namespace NullEdgeInternalSpectrum

/-! ### Anomaly coefficients, lifted to a spectrum

Each coefficient is just the corresponding `AnomalyPackage` coefficient applied
to the spectrum's multiplet list. These accessors exist so downstream code can
talk about a spectrum's anomalies directly. -/

/-- Gravitational–U(1)_Y mixed anomaly of the spectrum. -/
def gravitationalU1Anomaly (S : NullEdgeInternalSpectrum) : Rat :=
  PhysicsSM.StandardModel.AnomalyPackage.gravitationalU1Anomaly S.multiplets

/-- U(1)_Y³ cubic anomaly of the spectrum. -/
def u1CubedAnomaly (S : NullEdgeInternalSpectrum) : Rat :=
  PhysicsSM.StandardModel.AnomalyPackage.u1CubedAnomaly S.multiplets

/-- SU(2)_L²–U(1)_Y mixed anomaly of the spectrum. -/
def su2SquaredU1Anomaly (S : NullEdgeInternalSpectrum) : Rat :=
  PhysicsSM.StandardModel.AnomalyPackage.su2SquaredU1Anomaly S.multiplets

/-- SU(3)_c²–U(1)_Y mixed anomaly of the spectrum. -/
def su3SquaredU1Anomaly (S : NullEdgeInternalSpectrum) : Rat :=
  PhysicsSM.StandardModel.AnomalyPackage.su3SquaredU1Anomaly S.multiplets

/-- SU(3)_c³ cubic anomaly of the spectrum. -/
def su3CubedAnomaly (S : NullEdgeInternalSpectrum) : Int :=
  PhysicsSM.StandardModel.AnomalyPackage.su3CubedAnomaly S.multiplets

/-- Total `SU(2)_L` doublet count (with colour multiplicity) of the spectrum. -/
def weakDoubletCount (S : NullEdgeInternalSpectrum) : Nat :=
  PhysicsSM.StandardModel.AnomalyPackage.weakDoubletCount S.multiplets

/-! ### Anomaly-freedom predicates, lifted to a spectrum -/

/-- The spectrum satisfies all five perturbative anomaly conditions. -/
def LocalAnomalyFree (S : NullEdgeInternalSpectrum) : Prop :=
  PhysicsSM.StandardModel.AnomalyPackage.LocalAnomalyFree S.multiplets

/-- The spectrum satisfies Witten's global SU(2) anomaly condition. -/
def WittenSU2AnomalyFree (S : NullEdgeInternalSpectrum) : Prop :=
  PhysicsSM.StandardModel.AnomalyPackage.WittenSU2AnomalyFree S.multiplets

/-! ### Mapping to the canonical SM one-generation data -/

/--
The spectrum **realizes one Standard Model generation**: its multiplet list
*is* the canonical `standardModelOneGeneration` table.

This is the precise meaning of "the null-edge internal spectrum maps to the
existing one-generation data" used in the inheritance theorems. Because all
anomaly coefficients depend only on the multiplet list, equality of multiplet
lists is exactly the hypothesis needed to transport the cancellation results.
-/
def RealizesOneGeneration (S : NullEdgeInternalSpectrum) : Prop :=
  S.multiplets = standardModelOneGeneration

/-! ### Anomaly inheritance theorems

These *wrap* the already-proved arithmetic in
`PhysicsSM.StandardModel.AnomalyPackage`; no anomaly coefficient is recomputed.
-/

/-- **Inheritance (perturbative).** A spectrum that realizes one SM generation
inherits all five local anomaly-cancellation conditions. -/
theorem localAnomalyFree_of_realizesOneGeneration
    (S : NullEdgeInternalSpectrum) (h : S.RealizesOneGeneration) :
    S.LocalAnomalyFree := by
  unfold LocalAnomalyFree
  rw [h]
  exact standardModelOneGeneration_localAnomalyFree

/-- **Inheritance (Witten).** A spectrum that realizes one SM generation
inherits Witten's global SU(2) anomaly cancellation. -/
theorem wittenAnomalyFree_of_realizesOneGeneration
    (S : NullEdgeInternalSpectrum) (h : S.RealizesOneGeneration) :
    S.WittenSU2AnomalyFree := by
  unfold WittenSU2AnomalyFree
  rw [h]
  exact standardModelOneGeneration_wittenAnomalyFree

/-- **Inheritance (bundled).** A spectrum that realizes one SM generation
inherits the complete anomaly-cancellation package (all five perturbative
conditions together with the Witten global condition). -/
theorem anomalyFree_of_realizesOneGeneration
    (S : NullEdgeInternalSpectrum) (h : S.RealizesOneGeneration) :
    S.LocalAnomalyFree ∧ S.WittenSU2AnomalyFree :=
  ⟨localAnomalyFree_of_realizesOneGeneration S h,
   wittenAnomalyFree_of_realizesOneGeneration S h⟩

/-- **Inheritance (n generations).** If a spectrum's multiplet list is `n`
identical copies of a spectrum that realizes one SM generation, it inherits the
local anomaly-cancellation conditions, via the existing `nCopies` scaling. -/
theorem nGenerations_localAnomalyFree
    (n : Nat) (S : NullEdgeInternalSpectrum) (h : S.RealizesOneGeneration)
    (T : NullEdgeInternalSpectrum)
    (hT : T.multiplets = nCopies n S.multiplets) :
    T.LocalAnomalyFree := by
  unfold LocalAnomalyFree
  rw [hT, h]
  exact nCopies_localAnomalyFree n _ standardModelOneGeneration_localAnomalyFree

end NullEdgeInternalSpectrum

/-! ## Furey as one realization (example, not an assumption)

The Furey `Cl(6)` construction reproduces exactly the `standardModelOneGeneration`
multiplet table (this is what the Furey anomaly bridge establishes). We package
that table as a `NullEdgeInternalSpectrum` to witness the API: the grading marks
the whole internal sector `chi_E`-odd, and `legalYukawa` records the three SM
Yukawa pairings `Q_L–u_R^c`, `Q_L–d_R^c`, `L_L–e_R^c` by label.

This is purely illustrative: nothing in the API or the inheritance theorems
depends on the Furey realization. -/

open NullEdgeInternalSpectrum

/-- The three legal Standard-Model Yukawa pairings, recorded by multiplet label
(`Q_L`/`u_R^c`, `Q_L`/`d_R^c`, `L_L`/`e_R^c`). Bookkeeping only. -/
def smLegalYukawa (a b : ChiralMultiplet) : Bool :=
  (a.label = "Q_L" && b.label = "u_R^c") ||
  (a.label = "Q_L" && b.label = "d_R^c") ||
  (a.label = "L_L" && b.label = "e_R^c")

/-- A Furey-style null-edge internal spectrum: the canonical one-generation
table, marked uniformly `chi_E`-odd, with the SM Yukawa pairings. -/
def fureyStyleRealization : NullEdgeInternalSpectrum where
  multiplets := standardModelOneGeneration
  grading := fun _ => InternalGrading.odd
  legalYukawa := smLegalYukawa

/-- The Furey-style spectrum realizes one SM generation by construction. -/
theorem fureyStyleRealization_realizesOneGeneration :
    fureyStyleRealization.RealizesOneGeneration := rfl

/-- Consequently the Furey-style realization inherits the full anomaly package,
with no recomputation of anomaly coefficients. -/
theorem fureyStyleRealization_anomalyFree :
    fureyStyleRealization.LocalAnomalyFree ∧
      fureyStyleRealization.WittenSU2AnomalyFree :=
  NullEdgeInternalSpectrum.anomalyFree_of_realizesOneGeneration
    fureyStyleRealization fureyStyleRealization_realizesOneGeneration

end PhysicsSM.NullEdge
