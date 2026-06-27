import Mathlib
import PhysicsSM.Draft.NullEdgeFureyPhiH
import PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation
import PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage

/-!
# FUR-G2 — true-gauge quotient descent for the legal `Φ_H` interface

`PhysicsSM.Draft.NullEdgeFureyPhiH` proves gauge covariance of the internal
Yukawa map `Φ_H` over an **arbitrary** `Monoid G` via the bundled interface
`GaugeCovariantPhiH H_L H_R G`.  That parametricity is correct but it has never
been instantiated over the *true* Standard Model gauge surface.  The gauge
island provides exactly such a surface:

* `SMCoveringQuotient` — the genuine `S(U(2)×U(3))`-block gauge group obtained as
  the `ℤ₆`-quotient of the product cover `U(1)×SU(2)×SU(3)`
  (`PhysicsSM.Gauge.StandardModelSubgroup`), with a `Group` instance and a proven
  multiplicative equivalence onto the `SM`-block units;
* `quotientActQubitPlusQutritHom : SMCoveringQuotient →* Function.End QubitPlusQutrit`
  — a genuine, kernel-trivial quotient *representation* on the qubit⊕qutrit
  carrier `ℂ² ⊕ ℂ³`.

This file wires the legal `Φ_H` interface to that true quotient group.

## What is established here

1. **The true gauge group surface to use.** `TrueGaugeGroup := SMCoveringQuotient`
   is the `Monoid`/`Group` we instantiate `GaugeCovariantPhiH` over, and
   `trueQuotientQubitQutritAction` re-exports the existing genuine quotient
   representation on `ℂ²⊕ℂ³`.

2. **Kernel-triviality / descent for the internal fiber action.** A cover-level
   datum `GaugeCovariantPhiH H_L H_R SMCoveringTriple` whose chiral
   representations are constant on image-equivalence classes
   (`CoverFactoringPhiH`) **descends** to a genuine quotient datum
   `GaugeCovariantPhiH H_L H_R SMCoveringQuotient` (`CoverFactoringPhiH.descend`),
   and the entire `ℤ₆` covering kernel acts as the identity class
   (`descend_kernel_trivial`).

3. **Any quotient intertwiner is a proper null-edge Furey `Φ_H`.** For every
   `GaugeCovariantPhiH H_L H_R SMCoveringQuotient`, the resulting `Φ_H` is
   `χ_E`-odd, `Γ_s`-even (the `+Φ_H²` mass sign), gauge-covariant for **every
   element of the true Standard Model quotient group**, and squares to the
   checkerboard mass block (`phiH_proper_trueQuotient`).  The descended datum
   inherits this (`descend_isProperPhiH`).

## Adversarial honesty: the missing representation bridge

The descent above is **carrier-generic**: it works for *any* chiral carriers
`H_L, H_R` once a gauge-intertwining Yukawa block `M` and chiral representations
`ρ_L, ρ_R : SMCoveringTriple → End` factoring through the quotient are supplied.

What the repository does **not** yet contain — and what this file deliberately
does not fabricate — is the concrete bridge identifying these chiral carriers
`H_L, H_R` and representations `ρ_L, ρ_R` with the **Furey minimal-left-ideal /
occupation carrier**.  The only genuine quotient representation already proven
(`quotientActQubitPlusQutritHom`) acts on the *gauge* carrier `QubitPlusQutrit`
(`ℂ²⊕ℂ³`), i.e. on the fundamental qubit⊕qutrit, **not** on the Furey ideal `J`
/ its conjugate `J*` (the `L ⊕ R` carrier on which `Φ_H` acts), and not on the
null-edge occupation lattice `Occ = Finset (Fin 3)`.  See
`trueGauge_phiH_missing_bridge` below for the exact missing theorem statement.

So the strongest *currently provable* result is: **the legal `Φ_H` gauge-
covariance interface descends to, and is correct over, the true `S(U(2)×U(3))`
quotient group, conditional on a chiral representation of that quotient on the
Yukawa carrier — and that chiral representation is the one remaining handoff.**

## Guardrails honoured

* No new axioms.  No statement is weakened to `True` or made vacuous.
* We do **not** claim the Furey ideal carries the quotient representation; that
  is flagged as the open bridge.
-/

namespace PhysicsSM
namespace Draft
namespace FureyTrueGaugePhiH

open PhysicsSM.Draft.FureyPhiH
open PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Gauge.QunitQubitQutritDictionary

/-! ## 1. The true gauge group surface -/

/-- The **true Standard Model gauge group** to instantiate the legal `Φ_H`
interface over: the `ℤ₆`-quotient `SMCoveringQuotient` of the product cover
`U(1)×SU(2)×SU(3)`, proven multiplicatively equivalent to the `S(U(2)×U(3))`
block units.  It carries a `Group` instance, hence in particular a `Monoid`. -/
abbrev TrueGaugeGroup : Type := SMCoveringQuotient

/-- Re-export of the genuine quotient representation already proven in the gauge
island: the block action of the true quotient on the qubit⊕qutrit gauge carrier
`ℂ²⊕ℂ³`.  This is the *gauge* representation surface; it is **not** the Furey
Yukawa carrier (see the handoff at the end of the file). -/
noncomputable abbrev trueQuotientQubitQutritAction :
    SMCoveringQuotient →* Function.End QubitPlusQutrit :=
  quotientActQubitPlusQutritHom

section Carriers

variable {H_L H_R : Type*}
  [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
  [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]

/-! ## 2. Any quotient intertwiner gives a proper null-edge Furey `Φ_H` -/

/-- **The true-gauge correctness theorem.**  For any gauge-covariant Yukawa
datum over the *true* Standard Model quotient group `SMCoveringQuotient`, the
resulting internal Yukawa operator `Φ_H`:

1. is `χ_E`-odd (`{χ_E, Φ_H} = 0`);
2. is `Γ_s`-even (commutes with the internal `1`), giving the physical `+Φ_H²`;
3. is **gauge-covariant for every element of the true SM quotient group** — not
   merely for the product cover;
4. squares to the block-diagonal checkerboard mass block `(M Mᴴ) ⊕ (Mᴴ M)`.

This is the legal `Φ_H` interface's `isProperPhiH`, now read over the genuine
`S(U(2)×U(3))` quotient. -/
theorem phiH_proper_trueQuotient (P : GaugeCovariantPhiH H_L H_R SMCoveringQuotient) :
    (chiE * P.op = -(P.op * chiE))
      ∧ ((1 : Module.End ℂ (H_L × H_R)) * P.op = P.op * 1)
      ∧ (∀ q : SMCoveringQuotient, P.act q * P.op = P.op * P.act q)
      ∧ (P.op * P.op =
          LinearMap.prodMap (P.M ∘ₗ LinearMap.adjoint P.M)
            (LinearMap.adjoint P.M ∘ₗ P.M)) :=
  P.isProperPhiH

/-- The gauge-covariance clause of `phiH_proper_trueQuotient`, isolated: `Φ_H`
commutes with the action of every element of the true SM quotient group. -/
theorem phiH_gauge_covariant_trueQuotient
    (P : GaugeCovariantPhiH H_L H_R SMCoveringQuotient) (q : SMCoveringQuotient) :
    P.act q * P.op = P.op * P.act q :=
  (P.isProperPhiH.2.2.1) q

/-! ## 3. Descent from the product cover to the true quotient -/

/-- A cover-level gauge-covariant Yukawa datum over the product-cover group
`SMCoveringTriple` whose chiral representations **factor through the true
quotient**, i.e. are constant on `SMCoveringTriple.ImageEquiv` classes.  This is
exactly the legality condition that lets the action descend to the
`S(U(2)×U(3))` quotient: the `ℤ₆` covering kernel must act with no effect. -/
structure CoverFactoringPhiH
    (H_L H_R : Type*)
    [NormedAddCommGroup H_L] [InnerProductSpace ℂ H_L] [FiniteDimensional ℂ H_L]
    [NormedAddCommGroup H_R] [InnerProductSpace ℂ H_R] [FiniteDimensional ℂ H_R]
    where
  /-- The cover-level gauge-covariant Yukawa datum. -/
  base : GaugeCovariantPhiH H_L H_R SMCoveringTriple
  /-- The left chiral representation is constant on image-equivalence classes. -/
  rhoL_factors : ∀ x y : SMCoveringTriple,
    SMCoveringTriple.ImageEquiv x y → base.rhoL x = base.rhoL y
  /-- The right chiral representation is constant on image-equivalence classes. -/
  rhoR_factors : ∀ x y : SMCoveringTriple,
    SMCoveringTriple.ImageEquiv x y → base.rhoR x = base.rhoR y

namespace CoverFactoringPhiH

variable (C : CoverFactoringPhiH H_L H_R)

/-- **Descent.**  A cover datum whose chiral representations factor through the
quotient yields a genuine gauge-covariant Yukawa datum over the *true* Standard
Model quotient group `SMCoveringQuotient`. -/
noncomputable def descend : GaugeCovariantPhiH H_L H_R SMCoveringQuotient where
  M := C.base.M
  rhoL := Quotient.lift C.base.rhoL C.rhoL_factors
  rhoR := Quotient.lift C.base.rhoR C.rhoR_factors
  intertwine := by
    intro q; induction q using Quotient.ind; exact C.base.intertwine _
  intertwine_adj := by
    intro q; induction q using Quotient.ind; exact C.base.intertwine_adj _

@[simp] theorem descend_M : C.descend.M = C.base.M := rfl

@[simp] theorem descend_rhoL_mk (x : SMCoveringTriple) :
    C.descend.rhoL ⟦x⟧ = C.base.rhoL x := rfl

@[simp] theorem descend_rhoR_mk (x : SMCoveringTriple) :
    C.descend.rhoR ⟦x⟧ = C.base.rhoR x := rfl

/-- The descended Yukawa operator `Φ_H` is literally the cover-level one (it
depends only on the shared block `M`). -/
theorem descend_op : C.descend.op = C.base.op := rfl

/-- On a class representative, the descended gauge action agrees with the
cover-level action. -/
theorem descend_act_mk (x : SMCoveringTriple) :
    C.descend.act ⟦x⟧ = C.base.act x := rfl

/-- **Kernel-triviality of the descended action.**  Any cover element whose
covering image is the identity (in particular every one of the six `ℤ₆` kernel
elements) acts through the descended representation exactly as the identity
class.  This is the precise sense in which the `ℤ₆` covering kernel acts trivially
on the internal fiber. -/
theorem descend_kernel_trivial (x : SMCoveringTriple) (hx : x.smImage = 1) :
    C.descend.act ⟦x⟧ = C.descend.act (1 : SMCoveringQuotient) := by
  have h : (⟦x⟧ : SMCoveringQuotient) = (1 : SMCoveringQuotient) :=
    smCoveringTriple_smImage_one_quotient_eq x hx
  rw [h]

/-- **The descended datum is a proper null-edge Furey `Φ_H` over the true
quotient.**  Bundles `phiH_proper_trueQuotient` for the descended datum: the
descended `Φ_H` is `χ_E`-odd, `Γ_s`-even, covariant for every element of the true
SM quotient group, and squares to the checkerboard mass block. -/
theorem descend_isProperPhiH :
    (chiE * C.descend.op = -(C.descend.op * chiE))
      ∧ ((1 : Module.End ℂ (H_L × H_R)) * C.descend.op = C.descend.op * 1)
      ∧ (∀ q : SMCoveringQuotient, C.descend.act q * C.descend.op
          = C.descend.op * C.descend.act q)
      ∧ (C.descend.op * C.descend.op =
          LinearMap.prodMap (C.descend.M ∘ₗ LinearMap.adjoint C.descend.M)
            (LinearMap.adjoint C.descend.M ∘ₗ C.descend.M)) :=
  phiH_proper_trueQuotient C.descend

end CoverFactoringPhiH

end Carriers

/-! ## 4. Handoff: the exact missing representation bridge

The descent above is generic in the chiral carriers `H_L, H_R`.  To turn it into
a *physical* statement about the null-edge Furey sector one must supply a concrete
`CoverFactoringPhiH` whose carriers and representations are the Furey
minimal-left-ideal carrier.

**The exact missing theorem (handoff).**  There is currently *no* declaration in
the repository providing:

* finite-dimensional Hermitian chiral carriers `H_L`, `H_R` identified with the
  Furey minimal left ideal `J` (particles) and its conjugate `J*`
  (antiparticles) — equivalently with the left/right halves of the null-edge
  occupation carrier `Occ = Finset (Fin 3)` — together with
* chiral representations `ρ_L, ρ_R : SMCoveringTriple → Module.End ℂ H_L`,
  `Module.End ℂ H_R` that **factor through `SMCoveringQuotient`** (so that a
  `CoverFactoringPhiH H_L H_R` exists), and
* a Yukawa block `M : H_R →ₗ[ℂ] H_L` that is a gauge intertwiner for `ρ_L, ρ_R`.

Deliberately *not fabricated here.*  The only genuine quotient representation
proven in the repo, `quotientActQubitPlusQutritHom`
(`= trueQuotientQubitQutritAction`), acts on the **gauge** carrier
`QubitPlusQutrit = ℂ²⊕ℂ³` (fundamental qubit⊕qutrit) and is *not* split into a
chiral `L ⊕ R` Yukawa carrier, nor is it tied to the Furey ideal `J`/`J*` or to
the occupation lattice `Occ`.  No file under `PhysicsSM/Draft/NullEdge*` imports
any `PhysicsSM/Algebra/Furey/*` module, so the chiral-carrier identification
literally does not exist as a Lean dependency yet.

Note one must resist a degenerate "bridge": a `GaugeCovariantPhiH` over
`SMCoveringQuotient` always exists trivially (e.g. `M = 0` with constant
representations), so the genuine content of the handoff is **not** mere
nonemptiness — it is the *physical identification* of `H_L, H_R, ρ_L, ρ_R, M`
with the Furey/occupation data carrying the correct charges.  That identification
is the precise remaining work; the descent and correctness machinery on this side
is complete and waits only for it. -/

end FureyTrueGaugePhiH
end Draft
end PhysicsSM
