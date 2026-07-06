# Aristotle design+proof job: the unification verdict (charge_grading_mass_compatible)

You are a Lean 4 prover AND statement designer for the `PhysicsSM` project
(Mathlib, toolchain v4.28.0). BROWSE the repository you are given; do not trust
this prompt over the actual Lean. Deliver a NEW draft Lean file with a
kernel-checked theorem (no `s o r r y`, no `n a t i v e _ d e c i d e`,
standard axioms). ASCII only, LF; spaced escape-hatch tokens in prose.

## The question to settle (the "decisive test")

The project's octonion/null-edge "unification" asks whether the octonion
(color/charge) structure and the null-edge (mass) structure genuinely COUPLE, or
merely CO-LOCATE (are independent) on one spinor. A prior red-team concluded
"co-location, not coupling" for the current bridges. The single theorem that
would settle it is a statement about a mass form on the shared module
`J (x) CSpinor` and whether it factors through the spacetime projection.

## Substrate that already exists (READ these - verify in the repo)

- `PhysicsSM/Draft/NullEdge/GateI1/ColorBlindMass.lean`:
  `cNormSq`, `coloredMass z m := cNormSq z * m`, and `coloredMass_color_blind`:
  the three color-triplet states `v4, v5, v6` (from Furey `MinimalLeftIdeal`)
  receive the SAME norm-weighted mass for any `m`.
- `PhysicsSM/Draft/NullEdge/GateI1/ColorBlindMassOrbit.lean`:
  `hermSq x := star x dotProduct x` on `Fin 3 -> C`, proven `SU(3)`-invariant
  (`hermSq_su3_invariant`), so `coloredMassC_su3_blind`: a norm-weighted mass is
  constant on EVERY `SU(3)` orbit; `coloredMassC_octonionSU3_blind` states it for
  the octonion `su3Submonoid` (= `specialUnitaryGroup (Fin 3) C` by step 1a).
- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean` and
  `Furey/AnomalyBridge.lean`: `Q_op` (the octonion charge operator,
  `ComplexOctonion ->l[C] ComplexOctonion`) with kernel-checked eigenvalues
  (`Q_op_vbar4 = (-2/3) . vbar4`, etc.).
- `PhysicsSM/Draft/NullEdge/GateI1/SharedSpinorModule.lean`:
  `SharedSpinorModule := ComplexOctonion (x)[C] CSpinor`, `internalAction`,
  `spacetimeAction`, `internal_spacetime_commute` (currently VACUOUS - tensor
  bifunctoriality).

## What to design and prove (the guardrails are load-bearing)

Formalize `charge_grading_mass_compatible`: define a genuine mass form on
`J (x) CSpinor` (or on `ComplexOctonion (x) CSpinor` restricted to the color
sector) that is allowed to depend on BOTH the octonion factor (via `Q_op` /
`cNormSq`) AND the spacetime spinor, then prove which branch holds:

- COUPLING branch: there is a mass form whose value on a `Q_op`-charge
  eigenstate depends on the eigenvalue in a way that does NOT factor as
  (octonion scalar) x (spacetime mass) - i.e. the mass genuinely distinguishes
  charges. Prove it, referencing the SPECIFIC `Q_op` eigenvalues.
- CO-LOCATION branch (expected): any mass form built from the `SU(3)`-invariant
  octonion norm FACTORS as `(SU(3)-invariant octonion scale) x (spacetime mass)`,
  hence is BOTH color-blind and `Q_op`-charge-blind - the octonion factor
  supplies only an overall invariant scale, never a per-charge mass distinction.
  Prove the factoring/constancy statement, and it MUST reference the actual
  `Q_op` eigenvalues (e.g. the three color states share `Q_op = -2/3` AND share
  the mass), NOT a vacuous statement true of any bilinear form.

CRITICAL (semantic guardrail): a statement that is true of ANY tensor-product
form by bifunctoriality is VACUOUS and unacceptable (that was the flaw in
`internal_spacetime_commute`). The theorem must make the `Q_op` charge grading
and the mass value interact in its hypotheses/conclusion, so that it says
something FALSE if the mass did couple to charge. State the precise reading in a
docstring: "the null-edge mass on `J (x) CSpinor` is constant on `Q_op`
charge blocks / SU(3) orbits, so the octonion charge does not enter the mass -
co-location, not coupling," or the coupling opposite if you find it.

## Deliverable

A new file `PhysicsSM/Draft/NullEdge/GateI1/ChargeGradingMassCompatible.lean`
with the kernel-checked theorem(s), a careful docstring stating the branch and
why it is non-vacuous (which `Q_op` eigenvalues it references), imports limited
to Mathlib + the existing project modules above. Finish with a short report:
which branch, the exact statement, the `Q_op` eigenvalues used, and the axiom
footprint. Do not weaken to a vacuous form; if the honest theorem is the
co-location branch, that is the correct and valuable result.
