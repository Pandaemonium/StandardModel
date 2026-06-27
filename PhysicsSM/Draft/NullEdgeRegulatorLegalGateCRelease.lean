import Mathlib

/-!
# C84: Gate C **v4** release *contract* around a regulated/projected construction

This module states the post-Pro-verdict **Gate C v4** release target as a clean
logical *contract* over a regulated / projected construction
`(D0, R, G, Pin, Pout)`.  It does **not** discharge Gate C and it does **not**
assert that any concrete null-edge operator satisfies the contract.  It only
fixes the *shape* of a legal release.

## The verdict being encoded

A scalar Wilson factor `W(q) = Σ_a (1 - cos q_a)` lifts non-origin torus zeros,
but a regulator `R(q) = O(q²)` has the **same origin linearization** as the bare
operator `D0`.  Since C21 shows the unprojected origin/null branch is
`Γ_s`-balanced, such a regulator cannot turn the surviving origin sector into a
`Γ_s`-pure Weyl sector.  Hence the correct release object is **not**

```text
"Wilson lifts all non-origin zeros, therefore Gate C is solved."
```

but the conjunction

```text
Gate C releases for (D0, R, G, Pin, Pout) only if BOTH
  * LiftNonOrigin   (the regulated construction has no zeros away from origin), and
  * OriginWeylPure  (the projected origin tangent branch is G-pure),
plus the ghost / Krein / gauge / counterterm clauses.
```

## Relationship to C80 (`NullEdgeRegulatorLegalityAPI`)

The companion module `PhysicsSM.Draft.NullEdgeRegulatorLegalityAPI` (task C80)
is intended to own the predicates `IsGrading`, `OriginWeylPure`,
`OriginBalanced`, `SameOriginLinearization`, `LiftNonOrigin`, `RegulatorLegal`,
and `IrrelevantAtOrigin`.  At the time of writing C80 is **not yet available in
this snapshot**, so to keep this module self-contained those minimal predicates
are **duplicated here** (in this namespace).  When C80 lands, the duplicated
predicates below should be deleted and replaced by `open`/`import` of the C80
definitions; the theorem statements are written so that this is a definitional
substitution.

## Honesty discipline

Nothing physical is assumed as fact.  The genuine content is the *logical*
decomposition of "Gate C v4 release" into independent clauses, plus the two
projection theorems, the negative guardrail (`LiftNonOrigin` alone is
insufficient), and the bridge theorem assembling the named predicate
`GateC_v4_released`.  Discharging any of the clauses on the actual null-edge
operator data is **out of scope** and is left entirely open.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeRegulatorLegalGateCRelease

/-! ## Duplicated minimal C80 predicates (merge with C80 later)

These are the abstract regulator-legality predicates.  They are modelled on a
finite linearization module `Lin` (over `ℝ`) carrying a chosen grading `G`, with
the *origin linearization* supplied as data rather than computed from a Fréchet
derivative (exactly as C80 plans).  Momenta / candidate zeros live in an abstract
index type `Z`. -/

variable {Lin Z : Type*} [AddCommGroup Lin] [Module ℝ Lin]

/-- **(C80, duplicated).**  A grading is an `ℝ`-linear involution on the
linearization module (e.g. `G_f = Γ_s T`). -/
def IsGrading (G : Lin → Lin) : Prop :=
  Function.Involutive G ∧ IsLinearMap ℝ G

/-- **(C80, duplicated).**  An origin linearization `x` is *Weyl-pure* for the
grading `G` when it lies in the `+1` eigenspace of `G` (the retained Weyl
sector). -/
def OriginWeylPure (G : Lin → Lin) (x : Lin) : Prop := G x = x

/-- **(C80, duplicated).**  An origin linearization `x` is *balanced* for `G`
when it lies in the `-1` eigenspace and is nonzero — the C21 situation in which
the surviving branch carries equal `+`/`-` chirality weight and is therefore
**not** `G`-pure. -/
def OriginBalanced (G : Lin → Lin) (x : Lin) : Prop := G x = -x ∧ x ≠ 0

/-- A balanced (nonzero, `-1`-graded) origin linearization is never Weyl-pure.
Over a real module the two eigenspaces meet only at `0`. -/
theorem balanced_not_pure {G : Lin → Lin} {x : Lin}
    (h : OriginBalanced G x) : ¬ OriginWeylPure G x := by
  rintro hpure
  obtain ⟨hbal, hne⟩ := h
  -- `x = G x = -x`, hence `2 • x = 0`, hence `x = 0`.
  have hxx : x = -x := by rw [← hbal, hpure]
  have h2 : (2 : ℝ) • x = 0 := by
    have hsum : x + x = 0 := by nth_rewrite 1 [hxx]; exact neg_add_cancel x
    simpa [two_smul] using hsum
  have : x = 0 := by
    have := smul_eq_zero.mp h2
    rcases this with h | h
    · norm_num at h
    · exact h
  exact hne this

/-! ## The Gate C v4 dataset and its derived linearizations

A `RegulatorLegalGateCData` packages the regulated/projected construction
`(D0, R, G, Pin, Pout)` at the level of origin-linearization data, together with
the surviving-zero predicate of the regulated construction and four abstract
physics certificate clauses (ghost / Krein / gauge / counterterm).  The
certificate clauses are kept as opaque `Prop` fields so that this module is a
*contract*: it neither proves nor presupposes them. -/

/-- A complete **Gate C v4** dataset around a regulated/projected construction
`(D0, R, G, Pin, Pout)`.

* `D0lin` — the origin linearization of the bare construction `D0`.
* `Rlin` — the **first-order** origin contribution of the regulator `R`
  (`0` exactly when `R` is irrelevant at the origin, `R(q) = O(q²)`).
* `G` — the chosen grading (`G_f = Γ_s T`).
* `Pin`, `Pout` — the input/output projectors of the projected construction.
* `regulatedZero` — the predicate "`q` is a surviving zero of the regulated
  construction `D0 + R`".
* `origin` — the distinguished origin momentum.
* `ghostZeroSafe`, `kreinPositive`, `gaugeCovariant`, `countertermLegal` —
  opaque certificate clauses (Golterman–Shamir ghost-zero safety, Krein
  positivity, gauge covariance, and counterterm legality respectively). -/
structure RegulatorLegalGateCData (Lin Z : Type*) [AddCommGroup Lin] [Module ℝ Lin] where
  /-- origin linearization of the bare construction `D0`. -/
  D0lin : Lin
  /-- first-order origin contribution of the regulator `R`. -/
  Rlin : Lin
  /-- the chosen grading `G` (`G_f = Γ_s T`). -/
  G : Lin → Lin
  /-- input projector of the projected construction. -/
  Pin : Lin → Lin
  /-- output projector of the projected construction. -/
  Pout : Lin → Lin
  /-- "`q` is a surviving zero of the regulated construction `D0 + R`". -/
  regulatedZero : Z → Prop
  /-- the distinguished origin momentum. -/
  origin : Z
  /-- opaque Golterman–Shamir ghost-zero safety certificate clause. -/
  ghostZeroSafe : Prop
  /-- opaque Krein positivity certificate clause. -/
  kreinPositive : Prop
  /-- opaque gauge-covariance certificate clause. -/
  gaugeCovariant : Prop
  /-- opaque counterterm-legality certificate clause. -/
  countertermLegal : Prop

namespace RegulatorLegalGateCData

variable (d : RegulatorLegalGateCData Lin Z)

/-- The **unprojected** regulated origin linearization, `D0 + R` at the
origin. -/
def regulatedOriginLin : Lin := d.D0lin + d.Rlin

/-- The **projected** regulated origin linearization,
`Pout ∘ Pin` applied to `D0 + R` at the origin — the actual surviving origin
tangent branch of the projected construction. -/
def projectedOriginLin : Lin := d.Pout (d.Pin (d.D0lin + d.Rlin))

end RegulatorLegalGateCData

/-! ## Duplicated regulator-legality predicates at the dataset level -/

variable (d : RegulatorLegalGateCData Lin Z)

/-- **(C80, duplicated).**  The regulator is *irrelevant at the origin*: its
first-order origin contribution vanishes (`R(q) = O(q²)`). -/
def IrrelevantAtOrigin : Prop := d.Rlin = 0

/-- **(C80, duplicated).**  The regulated construction has the *same origin
linearization* as the bare construction. -/
def SameOriginLinearization : Prop := d.regulatedOriginLin = d.D0lin

/-- **(C80, duplicated).**  `LiftNonOrigin`: the regulated construction has **no
surviving zeros away from the origin** (Wilson's role — lift all non-origin
zeros). -/
def LiftNonOrigin : Prop := ∀ q, d.regulatedZero q → q = d.origin

/-- The Gate C v4 *origin purity* clause: the **projected** surviving origin
tangent branch is `G`-pure (a single Weyl sector). -/
def DataOriginWeylPure : Prop := OriginWeylPure d.G d.projectedOriginLin

/-- **(C80, duplicated).**  `RegulatorLegal`: the conjunction that the Pro
verdict identifies as the real release content — `LiftNonOrigin` **and**
projected-origin `G`-purity.  Crucially, lifting alone is *not* legality. -/
def RegulatorLegal : Prop := LiftNonOrigin d ∧ DataOriginWeylPure d

/-! ## C80-style negative lemmas: irrelevant regulators cannot repair the origin

These are the duplicated core C80 failure statements, kept here so the contract
is self-contained. -/

/-- **An irrelevant regulator preserves a non-pure origin.**  If `R` is
irrelevant at the origin (`Rlin = 0`) and the *bare* origin linearization is not
`G`-pure, then the *regulated unprojected* origin linearization is still not
`G`-pure — it is literally unchanged. -/
theorem same_linearization_preserves_origin_not_pure
    (hR : IrrelevantAtOrigin d)
    (hbare : ¬ OriginWeylPure d.G d.D0lin) :
    ¬ OriginWeylPure d.G d.regulatedOriginLin := by
  have : d.regulatedOriginLin = d.D0lin := by
    simp [RegulatorLegalGateCData.regulatedOriginLin, IrrelevantAtOrigin.eq_1] at *
    simp [hR]
  rwa [this]

/-- **No irrelevant regulator repairs a balanced origin.**  If `R` is irrelevant
at the origin and the bare origin linearization is `G`-balanced (the C21
situation), the regulated unprojected origin linearization is not `G`-pure. -/
theorem no_irrelevant_regulator_repairs_balanced_origin
    (hR : IrrelevantAtOrigin d)
    (hbal : OriginBalanced d.G d.D0lin) :
    ¬ OriginWeylPure d.G d.regulatedOriginLin :=
  same_linearization_preserves_origin_not_pure d hR (balanced_not_pure hbal)

/-! ## The Gate C v4 release contract -/

/-- **Gate C v4 release contract.**  Gate C *releases* for the regulated /
projected construction `(D0, R, G, Pin, Pout)` exactly when **all** of the
following independent clauses hold:

* `lift` — `LiftNonOrigin`: no surviving zeros away from the origin;
* `originPure` — the projected origin tangent branch is `G`-pure
  (`OriginWeylPure`);
* `ghost` — the ghost-zero-safety certificate;
* `krein` — the Krein-positivity certificate;
* `gauge` — the gauge-covariance certificate;
* `cterm` — the counterterm-legality certificate.

This is a *contract*: it is **not** asserted to hold for any concrete
operator. -/
structure RegulatorLegalGateCRelease (d : RegulatorLegalGateCData Lin Z) : Prop where
  /-- the regulated construction lifts every non-origin zero. -/
  lift : LiftNonOrigin d
  /-- the projected origin tangent branch is `G`-pure. -/
  originPure : DataOriginWeylPure d
  /-- Golterman–Shamir ghost-zero safety certificate. -/
  ghost : d.ghostZeroSafe
  /-- Krein positivity certificate. -/
  krein : d.kreinPositive
  /-- gauge-covariance certificate. -/
  gauge : d.gaugeCovariant
  /-- counterterm-legality certificate. -/
  cterm : d.countertermLegal

/-- The named Gate C **v4** release predicate produced by the bridge theorem. -/
def GateC_v4_released (d : RegulatorLegalGateCData Lin Z) : Prop :=
  RegulatorLegalGateCRelease d

/-! ## Projection theorems: a release entails each required clause -/

/-- **Projection: release ⇒ `LiftNonOrigin`.** -/
theorem release_liftNonOrigin (h : RegulatorLegalGateCRelease d) :
    LiftNonOrigin d := h.lift

/-- **Projection: release ⇒ `OriginWeylPure`** (of the projected origin
branch). -/
theorem release_originWeylPure (h : RegulatorLegalGateCRelease d) :
    DataOriginWeylPure d := h.originPure

/-- **Projection: release ⇒ `RegulatorLegal`** (both required regulator-legality
clauses at once). -/
theorem release_regulatorLegal (h : RegulatorLegalGateCRelease d) :
    RegulatorLegal d := ⟨h.lift, h.originPure⟩

/-! ## Bridge theorem: `RegulatorLegal` + physics clauses ⇒ named release -/

/-- **Bridge.**  `RegulatorLegal` (i.e. `LiftNonOrigin` together with projected
origin `G`-purity) together with the four physics certificate clauses
(ghost-zero safety, Krein positivity, gauge covariance, counterterm legality)
assemble into the named `GateC_v4_released` predicate. -/
theorem gateC_v4_release_bridge
    (hLegal : RegulatorLegal d)
    (hghost : d.ghostZeroSafe)
    (hkrein : d.kreinPositive)
    (hgauge : d.gaugeCovariant)
    (hcterm : d.countertermLegal) :
    GateC_v4_released d :=
  ⟨hLegal.1, hLegal.2, hghost, hkrein, hgauge, hcterm⟩

/-! ## Negative guardrail: `LiftNonOrigin` alone is insufficient

There is a dataset whose regulated construction lifts every non-origin zero, yet
which fails the Gate C v4 release because the projected origin branch is *not*
`G`-pure.  The witness uses the concrete chirality linearization model
`Lin = Fin 2 → ℝ` with grading `G = diag(+1, -1)` and a balanced origin
`D0lin = (1, 1)` (one `+` and one `-` chirality unit, the C21 balance), no
regulator, and trivial projectors. -/

/-- Concrete chirality grading on `Fin 2 → ℝ`: `+1` on the right-handed weight
(index `0`), `-1` on the left-handed weight (index `1`). -/
def chiralGrade : (Fin 2 → ℝ) → (Fin 2 → ℝ) := fun x => ![x 0, - x 1]

/-- The `LiftNonOrigin`-but-not-release witness dataset: a balanced origin
linearization that no projection here repairs, with no surviving non-origin
zeros and all physics clauses set to `True`. -/
def liftOnlyWitness : RegulatorLegalGateCData (Fin 2 → ℝ) (Fin 1) where
  D0lin := ![1, 1]
  Rlin := 0
  G := chiralGrade
  Pin := id
  Pout := id
  regulatedZero := fun _ => False
  origin := 0
  ghostZeroSafe := True
  kreinPositive := True
  gaugeCovariant := True
  countertermLegal := True

/-- The witness lifts every (non-existent) non-origin zero. -/
theorem liftOnlyWitness_lift : LiftNonOrigin liftOnlyWitness := by
  intro q hq
  exact absurd hq (by simp [liftOnlyWitness])

/-- The witness' projected origin branch is **not** `G`-pure. -/
theorem liftOnlyWitness_not_pure : ¬ DataOriginWeylPure liftOnlyWitness := by
  intro h
  have h1 := congrFun h 1
  norm_num [DataOriginWeylPure, OriginWeylPure, liftOnlyWitness,
    RegulatorLegalGateCData.projectedOriginLin, chiralGrade] at h1

/-- **Guardrail.**  `LiftNonOrigin` alone does **not** suffice for a Gate C v4
release: there is a dataset satisfying `LiftNonOrigin` that is not released. -/
theorem liftNonOrigin_insufficient :
    ∃ d : RegulatorLegalGateCData (Fin 2 → ℝ) (Fin 1),
      LiftNonOrigin d ∧ ¬ GateC_v4_released d :=
  ⟨liftOnlyWitness, liftOnlyWitness_lift, fun h =>
    liftOnlyWitness_not_pure (release_originWeylPure liftOnlyWitness h)⟩

/-! ## Summary -/

/-- **C84 summary.**  The Gate C **v4** release contract:

1. `RegulatorLegalGateCData` packages the regulated/projected construction
   `(D0, R, G, Pin, Pout)` with its surviving-zero predicate and four opaque
   physics certificate clauses;
2. `RegulatorLegalGateCRelease` defines release as the conjunction of
   `LiftNonOrigin`, projected-origin `OriginWeylPure`, and the ghost / Krein /
   gauge / counterterm clauses;
3. a release projects onto both `LiftNonOrigin` (`release_liftNonOrigin`) and
   `OriginWeylPure` (`release_originWeylPure`);
4. `LiftNonOrigin` alone is insufficient (`liftNonOrigin_insufficient`);
5. `RegulatorLegal` plus the physics clauses bridges to the named
   `GateC_v4_released` predicate (`gateC_v4_release_bridge`).

No concrete operator is asserted to satisfy the contract. -/
theorem c84_gateC_v4_contract_summary :
    (∀ d : RegulatorLegalGateCData Lin Z,
        RegulatorLegalGateCRelease d → LiftNonOrigin d) ∧
    (∀ d : RegulatorLegalGateCData Lin Z,
        RegulatorLegalGateCRelease d → DataOriginWeylPure d) ∧
    (∀ d : RegulatorLegalGateCData Lin Z,
        RegulatorLegal d → d.ghostZeroSafe → d.kreinPositive →
        d.gaugeCovariant → d.countertermLegal → GateC_v4_released d) ∧
    (∃ d : RegulatorLegalGateCData (Fin 2 → ℝ) (Fin 1),
        LiftNonOrigin d ∧ ¬ GateC_v4_released d) :=
  ⟨fun d => release_liftNonOrigin d, fun d => release_originWeylPure d,
    fun d => gateC_v4_release_bridge d, liftNonOrigin_insufficient⟩

end PhysicsSM.Draft.NullEdgeRegulatorLegalGateCRelease
