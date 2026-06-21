# Aristotle task: the bioctonion <-> Fock bridge (Baez-Huerta final stage)

Date: 2026-06-10

## Goal

Fill the ten documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldOctonionBridgeAristotle.lean
```

proving the explicit intertwiner between the bioctonionic spinor model
(`PhysicsSM.Algebra.Octonion.SpinorFierz`) and the Fock model
(`PhysicsSM.Spinor.SpinorTenfoldFock`). Targets, in priority order:

1. `fockToOct_cliffordAction_even` / `fockToOct_cliffordAction_odd`
   (the intertwining — the heart of the bridge), and `Q10_iotaV`.
2. The inverse identities `octToFockEven_fockToOct`,
   `octToFockOdd_fockToOct`, `fockToOct_octToFockEven`,
   `fockToOct_octToFockOdd`.
3. `hermActionC_smul_vec`, `spinorSquareC_fockToOct` (the quadric bridge,
   constant exactly `2` through one trace reversal), `iotaV_eq_zero_iff`.

The two payoff theorems (`purity_iff_spinorSquareC`,
`fierz_clifford_via_octonions`) are already derived in the draft modulo
the targets: completing the targets completes the Baez-Huerta program —
the trusted `D = 10` Fierz identity re-derived from the alternativity of
the octonions, on the very Fock model used by the `Spin(10)` program.

## Definitions and oracle

All definitions live in the trusted module
`PhysicsSM/Spinor/SpinorTenfoldOctonionBridge.lean` (machine-generated
`octImage` table and inverse rows; null-vector bridge `iotaV`; algebraic
instances). **Every target statement is verified in exact
Gaussian-rational arithmetic** by

```bash
python Scripts/oracle/validate_bioctonion_fock_bridge.py
```

(all checks `OK`: form match, vacuum kernel dimension 1, vacuum purity,
intertwining on all 10 x 32 basis cases, invertibility of both chirality
restrictions, quadric constant `c = 2`). The statements are correct as
written. If one resists proof, suspect the proof route, not the statement;
if you become convinced a statement is false, STOP and report — that means
a transcription bug that must be reported, not patched around.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
  Plain kernel `decide` only on `Finset (Fin 5)`/`Fin 8` bookkeeping; the
  `ℂ`-valued identities are not decidable.
- Do not change any definition, the `octImage` table, the inverse rows, or
  any sign convention. Helper lemmas are welcome (e.g. bilinearity of
  `hermActionC`, evaluation lemmas `octImage_insert`-style, `coordC`
  linearity).

## Proof guidance

- Everything is `ℂ`-(bi)linear, so all targets reduce to finite basis
  grids: expand `ψ = Σ_S ψ S • basisSpinor S` (`spinor_eq_sum_basis` in
  `PhysicsSM.Spinor.SpinorTenfoldGammaSymm`), use `fockToOct_basisSpinor`,
  `fockToOct_add`, `fockToOct_smul` (proved in the definitions module) and
  `cliffordAction_sum_vec`/`cliffordAction_sum_spinor`.
- The basis cases are identities between explicit bioctonions whose entries
  are `0, ±1` (`octImage`) and `0, ±1/2` (`nullVecE/F`): after unfolding,
  each closes by `norm_num`/`Complex.ext_iff`-style evaluation plus the
  octonion component simp lemmas of `PhysicsSM.Algebra.Octonion.Basic`.
  Useful organization: per-vector lemmas
  `hermActionC (nullVecE j) (octImage S) = (sign) • octImage (insert j S)`
  (for `j ∉ S`, matching `wedge_basisSpinor_of_not_mem`), and similarly
  for `nullVecF`/`contract`.
- For the quadric bridge, polarizing over the 16 even basis spinors is an
  acceptable route (the diagonal terms plus the symmetric cross terms);
  `gammaBilinear_basis_repr`-style expansion lemmas are in
  `SpinorTenfoldPurity`/`SpinorTenfoldGammaSymm`.

## Verification

```bash
lake build PhysicsSM.Spinor.SpinorTenfoldOctonionBridge
lake build PhysicsSM.Draft.SpinorTenfoldOctonionBridgeAristotle
```

Axiom check on `fierz_clifford_via_octonions` and
`purity_iff_spinorSquareC`: only `[propext, Classical.choice, Quot.sound]`.

## Submission

Status: COMPLETE, integrated 2026-06-12 from the fifth attempt.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave6-20260611-project
```

Job ID (active):

```text
7054d23b-bbd1-4900-8414-ca8354f29f1d
```

Output archive:

```text
AgentTasks/aristotle-output/spin10-octonion-fock-bridge-20260612
```

Selected extraction:

```text
AgentTasks/aristotle-output/spin10-octonion-fock-bridge-20260612-extracted2
```

Integrated into:

```text
PhysicsSM/Draft/SpinorTenfoldOctonionBridgeAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.SpinorTenfoldOctonionBridgeAristotle
```

Previous jobs (failed/cancelled):

```text
00325fbd-0479-4b91-a1eb-08717ba7e593
ac97f984-08a5-4d12-b43c-fcfcbb095de0
4c2cd9ac-18bc-4e6a-8e49-4a8966da1890
46e12a3c-815b-4560-93bf-badb8dafea60
```
