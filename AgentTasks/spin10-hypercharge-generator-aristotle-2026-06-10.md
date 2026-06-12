# Aristotle task: the physical hypercharge generator (Prop S3 infinitesimal)

Date: 2026-06-10

## Goal

Fill the four documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldHyperchargeOpAristotle.lean
```

establishing that the explicit Cartan element

```text
Y = sum_i (indexHypercharge6 i / 6) * rho(e_i ^ f_i)
```

of the infinitesimal `so(10)` action realizes the *physical* GUT-normalized
hypercharge on the Fock model:

```lean
rho_eVec_fVec_basisSpinor   -- rho(e_i ^ f_i) = n_i - 1/2 on basis states
hyperchargeOp_basisSpinor   -- Y basis_S = (fockHypercharge6 S / 6) basis_S
hyperchargeOp_vacuumSpinor  -- Y kills the vacuum (nu^c has Y = 0)
hyperchargeOp_weakSpinor    -- Y weak = weak (e^c has Y = +1)
```

## Mathematical intent

This is the infinitesimal heart of Proposition S3 of
`Sources/Spin10_stabilizer.txt` ("the stabilizer carries the physical
hypercharges") and of the marked-vs-projective stabilizer proposition: `Y`
fixes the marked vacuum, preserves only the *line* of the weak spinor, and
its eigenvalues are exactly the trusted hypercharge table of
`PhysicsSM.StandardModel.SpinorFockHypercharge` (which matches
`OneGenerationTable`).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- The file imports the draft module
  `PhysicsSM.Draft.SpinorTenfoldSO10ActionAristotle` for the *definition*
  `rho` only. Its four sorried theorems (`rho_intertwine`, `rho_bracket`,
  `chevalleyPairing_rho_skew`, `gammaBilinear_rho_equivariant`) are owned
  by a different job and MUST NOT be used; run `#print axioms` on the
  finished theorems and confirm no `sorryAx`.
- Do not change `rho`, `eVec`, `fVec`, `hyperchargeOp`, or any trusted
  definition or sign convention. Helper lemmas are welcome.

## Proof guidance

- `rho_eVec_fVec_basisSpinor`: expand with the proved `cliffordAction_eVec`
  and `cliffordAction_fVec`; evaluate `wedge i (contract i ·)` and
  `contract i (wedge i ·)` on `basisSpinor T` via
  `wedge_basisSpinor_of_not_mem`, `contract_basisSpinor_of_mem` (and the
  `_of_mem`/`_of_not_mem` complements) from
  `PhysicsSM.Spinor.SpinorTenfoldFock`; the `opSign` factors square to one
  since `belowCount i` is unchanged by inserting/erasing `i` itself
  (sign bookkeeping helpers in `PhysicsSM.Spinor.SpinorTenfoldCAR`).
- `hyperchargeOp_basisSpinor`: the eigenvalue is
  `Σ_{i∈S} y_i/2 - Σ_{i∉S} y_i/2 = Σ_{i∈S} y_i - (1/2)Σ_i y_i`, and the
  proved `indexHypercharge6_sum_zero` kills the shift. Split
  `Finset.univ = S ∪ Sᶜ` and push casts (`fockHypercharge6` is an integer
  sum; the statement is its complex cast over `6`).
- The last two targets are evaluations of the main theorem at `∅` and
  `{3,4}` (`fockHypercharge6 ∅ = 0`, `fockHypercharge6 {3,4} = 6`,
  both by `decide` or `norm_num` on the integer sum).

## Verification

```bash
lake build PhysicsSM.Draft.SpinorTenfoldHyperchargeOpAristotle
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

Status: re-submitted 2026-06-11, fifth attempt (incorporates the completed trusted Spin(10) action proofs context, with unrelated drafts pruned).

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave6-20260611-project
```

Job ID (active):

```text
4c71113d-6c0b-4739-b1fb-95743612c502
```

Previous jobs (failed/out-of-budget):

```text
ac7aab1a-9e84-40b4-86e8-d0f2c534f07e
122350ea-6583-4c32-a433-e4559c648bbf
ee0d7409-c8be-4707-860c-ebfc7969c984
cc5dd4d9-eb16-4aa1-84bd-c04965a7e292
```
