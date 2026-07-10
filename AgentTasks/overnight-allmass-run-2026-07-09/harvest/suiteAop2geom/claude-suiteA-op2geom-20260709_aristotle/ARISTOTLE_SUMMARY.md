# Summary of changes for run 60dfbc4f-f22a-4eaa-a350-f6d34e85c662
Delivered `RequestProject/Main.lean` (namespace `SuiteA_Op2Geom`) plus `ARISTOTLE_SUMMARY.md`, building against Mathlib only with no `sorry`/`admit`/`native_decide` and no new axioms. Every headline theorem is guarded in-file with `#guard_msgs (whitespace := lax) in #print axioms …` and has footprint exactly `[propext, Classical.choice, Quot.sound]`; the whole project builds cleanly.

All four targets landed on the C²/2-point Krein carrier:

- The Krein carrier: `H = ℂ²`, fundamental symmetry `J = σₓ = ![![0,1],![1,0]]` (Hermitian, `J²=1`, trace 0, indefinite, `‖J‖=1`), and Krein-self-adjoint Dirac `D m = ![![0,m],![-m,0]]` (`sharp (D m) = J (D m)ᴴ J = D m`). Key computation `[D m, diag f] = m·(f 1 − f 0)·σₓ`, hence `J·[D m, diag f] = m·(f 1 − f 0)·I` (the Krein causal-energy operator).

- Target 1 (causal spectral distance, defined + attained): `dCausal m x y = sSup { f y − f x : IsCausal m f ∧ ‖[D m, diag f]‖ ≤ 1 }`, following the Franco–Eckstein recipe (clean-room port): causal cone `IsCausal m f := (J·[D m, diag f]).PosSemidef`, characterized by `0 ≤ m·(f 1 − f 0)` (`isCausal_iff`), plus Connes steepness `‖[D m, diag f]‖ ≤ 1`. Well-definedness/attainment is `dCausal_isGreatest_01`, with optimizer `fwit m = ![0, 1/m]`.

- Target 2 (scale recovery): `dCausal_01 : dCausal m 0 1 = 1/m` for `m>0`. Mandatory non-degeneracy fixtures: `dCausal_witness_3 : dCausal 3 0 1 = 1/3` and `dCausal_witness_35 : dCausal (3/5) 0 1 = 5/3` (explicit nonzero rationals).

- Target 3 (order recovery): `CausalLE` is a partial order (`causalLE_isPartialOrder`), orients the two edges (`causalLE_01`, `not_causalLE_10`), and its metric shadow reproduces the strict order (`dCausal_pos_iff : 0 < dCausal m x y ↔ x ≠ y ∧ CausalLE m x y`).

- Target 4 (E-slot as mismatch): `causalLE_mass_independent` (order/conformal class is the same for all masses) together with `Eslot_mismatch` (scale differs; the entire disagreement is the ratio `Eslot m m' = m'/m`) and `Eslot_ne_one` (defect ≠ 1 exactly when m ≠ m') — the finite Malament split "causal order fixes the conformal class for free; decorations owe the scale."

Kills stated as theorems and shown avoided: `kill_degenerate_avoided` (distance strictly positive, `= 1/m`, not 0/∞), `kill_mass_dependence` (`dCausal 3 0 1 ≠ dCausal 1 0 1`), and `causalLE_isPartialOrder` (relation is a genuine partial order).

Honest notes (in ARISTOTLE_SUMMARY.md): the Lorentzian Dirac is the antisymmetric partner of the seed's symmetric Euclidean `Dm` — with `J = σₓ` this is the clean choice making the causal-energy operator a real multiple of the identity (the symmetric seed Dirac gives a spacelike, trivial cone). The Franco–Eckstein recipe is ported specialized to the finite carrier, not as a general library. The E-slot is fully proved on the 2-point witness; escalation to the C⁴ FiniteCPT witness is not attempted.

# Suite A — operator-to-geometry: a finite causal spectral distance on the T2 carrier

All deliverables are in `RequestProject/Main.lean` (namespace `SuiteA_Op2Geom`).
The file builds against Mathlib only, contains no `sorry`/`admit`/`native_decide`
and adds no axioms. The axiom footprint of every headline theorem is
`[propext, Classical.choice, Quot.sound]`, verified in-file by
`#guard_msgs (whitespace := lax) in #print axioms <thm>`.

## Which targets landed

- **Target 1 — causal spectral distance, defined + well-defined.** ✅
  `dCausal` is defined on the two–point Krein carrier and its optimum is
  *attained* on the finite carrier: `dCausal_isGreatest_01` proves the defining
  set has a greatest element `1/m` realized by an explicit test function
  `fwit m = ![0, 1/m]` (so the `sSup` is a genuine max, not a vacuous bound).
- **Target 2 — scale recovery.** ✅ `dCausal_01 : dCausal m 0 1 = 1/m` for
  `m > 0`, mirroring the Euclidean seed `fwit_sep`. Mandatory non-degeneracy
  fixtures: `dCausal_witness_3 : dCausal 3 0 1 = 1/3` and
  `dCausal_witness_35 : dCausal (3/5) 0 1 = 5/3` — explicit rational, nonzero
  values.
- **Target 3 — order recovery.** ✅ The operator-derived relation `CausalLE` is a
  partial order (`causalLE_isPartialOrder`: reflexive, transitive, antisymmetric),
  orients the two points (`causalLE_01`, `not_causalLE_10`), and its metric shadow
  reproduces the strict order: `dCausal_pos_iff : 0 < dCausal m x y ↔ x ≠ y ∧ CausalLE m x y`.
- **Target 4 (stretch) — E-slot as mismatch.** ✅ Proved on the witness.
  `causalLE_mass_independent` shows the causal (conformal) class is the *same* for
  any two masses `m, m'`, while `Eslot_mismatch` shows the decoration-derived scale
  differs and the entire disagreement is the ratio `Eslot m m' = m'/m`;
  `Eslot_ne_one` shows this defect is `≠ 1` exactly when `m ≠ m'`. This is the
  finite, kernel-level Malament split: causal order fixes the conformal class for
  free, decorations owe the scale.

## Kills (stated and *avoided*, as theorems)

- Scale-degeneracy kill avoided: `kill_degenerate_avoided`
  (`0 < dCausal m 0 1 ∧ dCausal m 0 1 = 1/m`) — the distance is neither identically
  `0` nor `+∞`.
- Mass-independence kill avoided: `kill_mass_dependence : dCausal 3 0 1 ≠ dCausal 1 0 1`.
- Not-a-partial-order kill avoided: `causalLE_isPartialOrder`.

## The Krein carrier and the definition of `dCausal`

Carrier `H = ℂ²` (`Fin 2`) with:

- Fundamental symmetry `J = σₓ = ![![0,1],![1,0]]` — Hermitian (`Jc_herm`),
  `J² = 1` (`Jc_sq`), trace `0` (`Jc_trace_zero`), hence genuinely indefinite;
  and unitary with `‖J‖ = 1` (`Jc_norm`).
- Krein-self-adjoint Dirac operator `D m = ![![0, m],![-m, 0]]` (real
  antisymmetric), with `sharp X = J Xᴴ J` and `sharp (D m) = D m` (`sharp_Dc`).
  Note this Lorentzian Dirac is the *antisymmetric* partner of the seed's
  symmetric Euclidean `Dm`; with `J = σₓ` it is the unique clean choice making the
  Krein causal-energy operator a real multiple of the identity.
- Key computation: `[D m, diag f] = (m·(f 1 − f 0))·σₓ` (`diracCommutator_eq`),
  so `J·[D m, diag f] = (m·(f 1 − f 0))·I` (`kreinComm_eq`) — the Krein
  "causal-energy" operator.

**Franco–Eckstein recipe port (clean-room, not assumed in Mathlib):**

- Causal cone: `IsCausal m f := (J·[D m, diag f]).PosSemidef`, i.e. the Krein
  causal-energy operator is positive semidefinite. On the carrier this is exactly
  `0 ≤ m·(f 1 − f 0)` (`isCausal_iff`).
- Steepness normalization (Connes): `Steep m f := ‖[D m, diag f]‖ ≤ 1`, using the
  genuine L² matrix operator norm.
- Causal spectral distance:

  `dCausal m x y = sSup { f y − f x : IsCausal m f ∧ ‖[D m, diag f]‖ ≤ 1 }`.

  For the two edges this gives `dCausal m 0 1 = 1/m` (future direction) and
  `dCausal m 1 0 = 0` (against the arrow of time), so the *asymmetry* of `dCausal`
  encodes the causal order.

## Non-degeneracy witness value

`m = 3 ⇒ dCausal 3 0 1 = 1/3` (and `m = 3/5 ⇒ dCausal (3/5) 0 1 = 5/3`), both
explicit nonzero rationals, so "recovers scale" is not vacuous.

## Honest notes

- **Franco–Eckstein port.** The recipe is ported specialized to the finite
  carrier, not as a general Lorentzian-spectral-triple library. Two standard
  ingredients are combined: (i) the causal cone via Krein-positivity of the
  causal-energy operator `J·[D,f]`, and (ii) the Connes steepness normalization
  `‖[D,f]‖ ≤ 1`. The direction of the distance (`sup` of `f y − f x` over
  admissible `f`) matches the Lorentzian "steep causal function" formula. On a
  genuinely off-diagonal 2-point space one must use the *antisymmetric* Dirac with
  `J = σₓ` for the causal cone to be nontrivial; the symmetric Euclidean seed
  Dirac paired with `σₓ`/`σ_z` yields a spacelike (`indefinite`) causal-energy
  operator and hence a trivial cone — this is why the Lorentzian and Euclidean
  Dirac operators differ.
- **E-slot.** Fully proved on the 2-point witness as the exact scale mismatch
  `m'/m` at fixed causal order. It is stated for this finite carrier; a general
  statement over an arbitrary finite carrier (e.g. the `C⁴` FiniteCPT witness) is
  not attempted here.
- **Scope.** All four targets are landed on the `C²`/2-point Krein carrier. The
  optional escalation to the `C⁴` FiniteCPT witness (`ConjectureR`) is not carried
  out; the E-slot statement is the 2-point finite version.
