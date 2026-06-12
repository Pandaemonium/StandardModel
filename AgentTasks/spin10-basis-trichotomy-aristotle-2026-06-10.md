# Aristotle task: basis-pair annihilator trichotomy (Prop 3 normal forms)

Date: 2026-06-10

## Goal

Fill the seven documented `sorry`s in

```text
PhysicsSM/Draft/SpinorTenfoldBasisTrichotomyAristotle.lean
```

establishing the annihilator-intersection dimension formula for pairs of
Fock basis spinors and the `d ∈ {1, 3, 5}` trichotomy:

```lean
mem_annihilator_basisSpinor_iff   -- N_T in coordinates
mem_pairAnnihilator_iff           -- N_S ∩ N_T in coordinates
pairAnnihilator_vacuum_weak       -- consistency with colorAxisSubmodule
finrank_pairAnnihilator           -- dim = |S∩T| + (5 - |S∪T|)
card_inter_add_card_compl_union   -- = 5 - |S ∆ T|
finrank_pairAnnihilator_trichotomy -- even/even: d ∈ {1,3,5}
trichotomy_witnesses              -- all three strata realized
```

## Mathematical intent

The normal-form backbone of Proposition 3 (the orbit trichotomy) of
`Sources/Spin10_stabilizer.txt`: `d = 5` is the trivial stratum, `d = 3`
the Krasnov/Standard-Model stratum (the witness pair's intersection is the
color axis), `d = 1` the generic stratum. Group-level transitivity (a later
job) extends this to all pure-spinor pairs.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
  Plain kernel `decide` is fine for the `Finset (Fin 5)` cardinality
  identity (1024 pairs) if a structural proof is not quicker.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Proof guidance

- `mem_annihilator_basisSpinor_iff`: model proofs are
  `mem_annihilator_vacuumSpinor_iff` (`SpinorTenfoldPurity`) and
  `mem_annihilator_weakSpinor_iff` (`SpinorTenfoldColorAxis`). Expand
  `cliffordAction_eq_sum`; the nonzero images `wedge i (basisSpinor T)`
  (`i ∉ T`) and `contract i (basisSpinor T)` (`i ∈ T`) are signed basis
  spinors at *distinct* subsets `insert i T` / `T.erase i`, so evaluating
  the sum at each such subset extracts each coefficient.
- `finrank_pairAnnihilator`: build a `LinearEquiv` with
  `({i // i ∈ S ∩ T} → ℂ) × ({i // i ∉ S ∪ T} → ℂ)` following the explicit
  to/from/left-inv/right-inv pattern of `colorAxisLinearEquivC3`
  (`SpinorTenfoldColorAxis`), then `Module.finrank_prod`,
  `Module.finrank_pi`, `Fintype.card_subtype`/`Fintype.card_coe`.
- Trichotomy parity: `|S ∆ T| ≡ |S| + |T| (mod 2)` and `≤ 5`.

## Verification

```bash
lake build PhysicsSM.Draft.SpinorTenfoldBasisTrichotomyAristotle
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

Status: COMPLETE. Integrated 2026-06-10.

Submission project:

```text
AgentTasks/aristotle-submit/spin10-wave5-20260610
```

Job ID:

```text
5662f6a5-9f6e-4f29-9e8b-d59cd0b6c3bc
```

## Result

All seven `sorry`s proved. Key additions beyond the original targets:
- `pairAnnihilatorEquivCoord` — the explicit linear equivalence to `pairCoord S T`
- `pairCoord_card` — the cardinality bookkeeping lemma
- `finrank_pairAnnihilator_symmDiff` — the symmetric-difference form of the dimension formula

`card_inter_add_card_compl_union` proved by kernel `decide` over 1024 pairs (no `native_decide`).
`pairAnnihilator_vacuum_weak` proved by `rfl`.
Axioms: `[propext, Classical.choice, Quot.sound]` only.
