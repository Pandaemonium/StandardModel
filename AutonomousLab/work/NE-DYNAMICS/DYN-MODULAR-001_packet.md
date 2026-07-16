# DYN-MODULAR-001 source packet (normalized archival record)

- Project: NE-DYNAMICS (P1 derived dynamics)
- Work item: DYN-MODULAR-001
- Owner/role: claude / research_scientist ; Skeptic: codex (cross-family)
- Artifacts: `PhysicsSM/Draft/NullEdge/PairModularSelection.lean` and
  `PhysicsSM/Draft/NullEdge/HermitianPartitionPositive.lean`
- Status: **kernel-clean partial result**; S0 is closed, while the full work
  item remains OPEN pending S2 maximum-entropy uniqueness or a Research
  Director re-scope (DQ-007).
- Aristotle budget used: one focused package (S0 partition nonvanishing).

## Audit trail

built (claude) -> cross-family red-team (codex: repair required, 6 findings)
-> repaired + strengthened (claude) -> re-audit (codex: findings 2-6 closed;
finding 1 narrowed) -> S0 partition theorem isolated by Claude, proved by
Aristotle, and integrated by Codex. Maximum-entropy uniqueness remains open.
Reports: `CODEX_RED_TEAM_DYN-MODULAR-001_2026-07-12.md` (+ its re-audit
addendum).

## One-sentence contribution (accurate)

The interacting pair generator `Kop z` of the Paper E lane -- explicitly
*supplied* there -- satisfies a kernel-checked **balanced central-shift
selection**: on the pair sector it is a central shift of a multiple of the rest
block `B z` iff the two occupation levels balance, and at balance the
modular-Hamiltonian flow equals the `B z` pair evolution. The Hermitian
partition is now proved nonzero and the displayed modular Hamiltonian is
certified to exponentiate to the normalized Gibbs state. The stronger
work-item target (a *unique max-entropy Gibbs* state) is not achieved.

## Theorems (verbatim, all kernel-clean `[propext, Classical.choice, Quot.sound]`, guard-pinned)

- `pairGGE_isHermitian (a b : ℝ) (z : ℂ) : (pairGGE a b z)ᴴ = pairGGE a b z`
- `pair_modular_selection (a b : ℝ) (z : ℂ) : (∃ ν d : ℂ, pairGGE a b z = ν•Bz z + d•1) ↔ a = b`
- `pair_flow_of_balance (a : ℝ) (z t : ℂ) (X) : exp(t•pairGGE a a z) X exp(-t•pairGGE a a z) = exp(t•Bz z) X exp(-t•Bz z)`
- `balanced_partition_ne_zero (a : ℝ) (z : ℂ) (β : ℝ) : partition (pairGGE a a z) β ≠ 0`
- `balanced_gibbs_state_certified (a : ℝ) (z : ℂ) (β : ℝ) : exp(-modHam (pairGGE a a z) β) = gibbsState (pairGGE a a z) β`
- `balanced_gibbs_modular_flow (a : ℝ) (z : ℂ) (β t : ℝ) (X) : modFlow (pairGGE a a z) β t X = exp(-(iβt)•Bz z) X exp((iβt)•Bz z)`
- `pair_selection_kill (z : ℂ) : ¬ ∃ ν d, pairGGE 1 0 z = ν•Bz z + d•1`
- `level_projector_not_conserved (z : ℂ) (hz : z ≠ 0) : Bz z * Nlow ≠ Nlow * Bz z`
- `pair_evolution_phase_sensitive : Uop 0 1 (3+4i) 5 (basisVec lowPair) highPair ≠ Uop 0 1 (5:ℂ) 5 (basisVec lowPair) highPair` (about the SUPPLIED `Uop` evolution)
- `equal_modulus` ; `kop_highPair` / `kop_lowPair` (the `Kop`<->`B z` bridge)

## Supplied-input ledger (accurate)

| Ingredient | Status |
| --- | --- |
| wedge coupling `z` (hence `B z`, `Kop z`) | SUPPLIED (Paper E; not derived) |
| `Nlow, Nhigh` | level projectors / constraints, NOT conserved charges (`level_projector_not_conserved`) |
| `a, b` | REAL level parameters (so `pairGGE` is Hermitian) |
| `β, t` | real modular time (in `balanced_gibbs_modular_flow`) |
| balance `a = b` | the SELECTION criterion; why a dynamics enforces it is not derived |
| the state | finite Gibbs state; conjugation (not half-sided) flow; NO max-entropy uniqueness; no continuum thermal-time |

## Achievement status vs the work item

Work item asked for: "unique finite Gibbs state whose modular flow equals the
Plücker pair evolution up to explicit β rescaling." Achieved: the flow-equality
with certified Gibbs-state reading, plus the selection/kill/controls. NOT
achieved: (S1) exponential intertwiner `Uop = exp(-iαKop)` to attach the phase
witness to the selected flow; (S2) max-entropy uniqueness (finite GGE
variational argument).

## Verification (claude, 2026-07-12)

The targeted Pair/Hermitian build passes, and the aggregate
`OvernightTheoryAxiomGuard` passes at 8,368 jobs. All registered headline
theorems report the standard three axioms only. The S0 proof came from focused
Aristotle task `7b561cc8` and was independently compiled before integration.

## Landing / disposition (Codex writer lane + Director)

1. The kernel-clean partial result is aggregate-registered as claim
   `DYN-PAIR-GIBBS` at grade M / SRL 4.
2. The full work item stays OPEN: prove S2, or the Research Director re-scopes
   DYN-MODULAR-001 to the achieved Gibbs-certified selection result with S1/S2
   as successors (DQ-007).
3. Do not attach the supplied `Uop` phase witness to the selected modular flow
   until S1 closes.
