# COMPOSITION_WAVE_AUDIT_03.md

Independent audit (Codex, 2026-07-10) for job
`codex-composition-wave-audit-20260710-03`.

## Scope and reproduction note

The prompt names `Audit/Inputs`; in this repository the four audited sources
actually live under `PhysicsSM/Draft/NullEdge/`:

| Audited source | Contains |
|---|---|
| `PhysicsSM/Draft/NullEdge/CheckerboardPathSumTransferPower.lean` | `directionPathSum_eq_transfer_pow`, `two_step_nontrivial_witness` |
| `PhysicsSM/Draft/NullEdge/HistoryOperatorMonoidalDagger.lean` | `historyOperator_append/_dagger/_parallel`, `operator_composition_witness` |
| `PhysicsSM/Draft/NullEdge/Carrier/PositiveHodgePhysicalMass.lean` | `class_mass_wellDefined`, `nondegenerate_quartet_witness`, quartet lemmas |
| `PhysicsSM/Draft/NullEdge/Carrier/HodgePluckerMassBridge.lean` | `quartet_class_cost_eq_canonical_plucker`, `class_cost_eq_canonical_plucker`, `matched_four_twentyfive_witness` |

**Verification status is not uniform, and this is the single most important
audit fact.**

- The two **standalone** files (`CheckerboardPathSumTransferPower`,
  `HistoryOperatorMonoidalDagger`) import only `Mathlib`. I re-elaborated their
  full contents here: they compile with **no errors**, and every listed theorem
  reports a x i o m s **exactly** `[propext, Classical.choice, Quot.sound]`. These
  results are independently confirmed, not merely trusted from the in-file
  `#print a x i o m s` / `#guard_msgs` guards.
- The two **Carrier** files **cannot be elaborated in this repository**. They
  import modules that are absent from the tree (verified by `find`/`grep`):
  - `PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo`
    (supplies `RadicalProperty`, `class_cost_constant`,
    `PositiveHodgeRayleigh`, `nilpotent_positive_class_witness`,
    `witnessB/witnessQ/witnessS`),
  - `PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary`
    (supplies `edge0`, `edge1`, `canonical_plucker_mass`),
  - `PhysicsSM.Spinor.PluckerMass` (supplies `complexAbsSq`, `spinorWedge`).

  None of these exist here. Consequently `class_mass_wellDefined` and
  `quartet_class_cost_eq_canonical_plucker` **could not be built or
  a x i o m-audited locally**; their footprint guards could not be re-run. Per the
  job instruction ("do not infer soundness merely from comments or guard
  messages"), the two Carrier theorems are audited at **source/logical level
  only** and are labelled accordingly. No `s o r r y`, `a d m i t`, `a x i o m`, or
  `@[implemented_by]` appears in any of the four files.

---

## 1. Findings (highest severity first)

### F1 (HIGH) — Mass-bridge and physical-mass theorems are unverifiable in this deliverable.
Declarations: `HodgePluckerMassBridge.quartet_class_cost_eq_canonical_plucker`,
`HodgePluckerMassBridge.class_cost_eq_canonical_plucker`,
`PositiveHodgePhysicalMass.class_mass_wellDefined` and all of
`PositiveHodgePhysicalMass.*quartet*`.

These depend on three imported modules that are **not present** in the audited
repository (see Scope). The build cannot be produced, so the assertion that
their assumption footprint is `[propext, Classical.choice, Quot.sound]` is
**not established here** — it rests entirely on the in-file guards, which the job
forbids trusting. This is a packaging/deliverable defect: the "repaired mass
bridge" is shipped without its transitive dependencies, so it is not auditable
as a compiled artifact in this run. Everything below about the Carrier files is
therefore a reading of proof *shape*, not a verified result.

### F2 (MEDIUM) — The physics-carrying identification `mu2 = m^2` remains an inserted hypothesis; the "mass" is a chosen numerical coincidence, not a derivation.
Declaration: `HodgePluckerMassBridge.class_cost_eq_canonical_plucker`
(hypothesis `hmu : mu2 = m ^ 2`).

Reading the proof term, the theorem is a two-line rewrite
(`class_cost_constant … ; rw [hmu, canonical_plucker_mass]`): given `hmu`, the
class-invariant Hodge cost of any exact representative equals
`complexAbsSq (spinorWedge edge0 (edge1 m))`. The entire "Hodge eigenvalue =
physical mass²" content is the supplied equality `hmu`; nothing derives it. The
docstring discloses this ("remains a displayed bridge hypothesis; it is not
derived here"), so it is honest, but the bridge is a **conditional identity
keyed on the central unproved physical assumption**.

### F3 (LOW) — `quartet_class_cost_eq_canonical_plucker` is a shared-value wiring, and `4/25` is engineered on both sides.
Declaration:
`HodgePluckerMassBridge.quartet_class_cost_eq_canonical_plucker`.

The nondegenerate quartet's decoder entry is chosen as `4/25`
(`PositiveHodgePhysicalMass.quartetS`) and the spinor scale is chosen as `2/5`,
so both sides equal `4/25 = (2/5)^2` by construction. The theorem is a genuine
equality of two independently-defined quantities, but the agreement is a
selected numerical coincidence at one point, not a derived arrow. This is the
intended kind of "fixture wiring" (see closure below), so it is LOW; it is only
a defect if read as more than a shared constant.

### F4 (LOW) — `HistoryOperatorMonoidalDagger.parallelHistory` has no lemma characterizing its unequal-length behaviour.
Declaration: `HistoryOperatorMonoidalDagger.parallelHistory` and
`historyOperator_parallel`.

On unequal-length inputs `parallelHistory` silently **truncates to the shorter
list** (the `| _, _ => []` clause discards the longer tail once either side is
empty). `historyOperator_parallel` is correctly guarded by
`hlen : h1.length = h2.length`, and the nil/cons mismatch cases are discharged
by contradiction (`simp at hlen`), so no false claim is made. But there is no
theorem at all describing the unequal-length output; a caller could
mis-read the definition as a genuine independent-clock parallel product. Purely
a documentation/coverage gap, not a soundness bug: on the equal-length domain
the Kronecker orientation is exactly right.

### F5 (LOW) — `class_mass_wellDefined` still carries mild redundancy, but `hcl'` is already gone.
Declaration: `PositiveHodgePhysicalMass.class_mass_wellDefined`.

Contrary to what a "remove the redundant premise" task might suggest, the
current source **already omits** `hcl' : Q h' = 0`. The remaining hypotheses are
load-bearing at the level of the proof text (`hcl` feeds `class_cost_constant`;
`heig'`, `hn'` feed the `h'`-side cost). See §4 for the full analysis.

---

## 2. Focus questions — CLOSED / PARTIAL / OPEN

### (a) Does `CheckerboardPathSumTransferPower` sum every finite direction history with the stated outgoing-phase convention and equal the transfer element? — **CLOSED** (locally re-verified).
Declaration: `CheckerboardPathSumTransferPower.directionPathSum_eq_transfer_pow`.

- `histories n` enumerates **all** `2^n` length-`n` direction lists
  (`nil ↦ [[]]`, `cons` prepends `left`/`right`); `directionPathSum` sums over
  every one of them, keeping those whose `terminalDirection start h` equals
  `finish` and zeroing the rest — so every history of the fixed length is
  present.
- The phase convention is genuinely **outgoing**: `phasedPathWeight` weights a
  step `d → e` by `turnWeight mu d e * phase e` (phase of the destination), and
  `transfer mu phase finish start = turnWeight mu start finish * phase finish`
  matches index-for-index. Rows are outgoing/final, columns incoming, as the
  docstring states.
- `directionPathSum_eq_transfer_pow` proves the sum equals
  `(transfer mu phase ^ n) finish start`. I re-elaborated the file: proof
  compiles, a x i o m s `[propext, Classical.choice, Quot.sound]`.
- `two_step_nontrivial_witness` (`decide`) gives `directionPathSum 2 · · =
  85 = (transfer^2) …` with both off-diagonal transfers `≠ 0`, excluding
  straight-only and diagonal-transfer collapse. Verified.

Honest caveat (matches docstring): "every finite history" is **per fixed length
`n`** (a transfer *power*), not a sum over all lengths — which is the correct
statement. No unitarity, Fourier transform, or continuum PDE is claimed.

### (b) Does `HistoryOperatorMonoidalDagger` have correct chronological, reversal/adjoint, and Kronecker orientations, including the `parallelHistory` unequal-length boundary? — **CLOSED** (locally re-verified).
Declarations: `historyOperator_append`, `historyOperator_dagger`,
`historyOperator_parallel`, `operator_composition_witness`.

- **Chronological:** `historyOperator = List.prod`, so `[A,B] ↦ A*B` in list
  order; `historyOperator_append` gives `prod (h1 ++ h2) = prod h1 * prod h2`.
- **Reversal/adjoint:** `daggerHistory = (·.map conjTranspose).reverse`;
  `historyOperator_dagger` yields `(historyOperator h)ᴴ` via
  `Matrix.conjTranspose_list_prod` — reversal *and* gatewise adjoint together
  are the operator adjoint, correct orientation.
- **Kronecker:** `historyOperator_parallel` (guarded by `hlen`) gives
  `kronecker (prod h1) (prod h2)` using `mul_kronecker_mul`
  (`(A⊗B)(C⊗D)=(AC)⊗(BD)`), correct orientation.
- **Unequal-length boundary:** the theorem is restricted to `hlen`; the
  mismatch cases are closed by contradiction. The definition truncates to the
  shorter list off-domain (see F4), and no false identity is asserted there.
- `operator_composition_witness` certifies local noncommutativity
  (`[σx,σz] order matters`), the dagger identity, one-step parallel `= σx⊗σz`,
  and nonzero tensor. Re-elaborated: compiles, a x i o m s
  `[propext, Classical.choice, Quot.sound]`.

Honest caveat (matches docstring): gates are **supplied**; no inner product,
unitarity, or Born rule is derived.

### (c) Does `quartet_class_cost_eq_canonical_plucker` close the prior high-severity fixture-wiring defect? — **PARTIAL**.
Declaration:
`HodgePluckerMassBridge.quartet_class_cost_eq_canonical_plucker`.

- *At source level, yes, in the exact form the prior audit demanded.* Prior
  finding F1 was that the mass bridge shared its `4/25` only with the
  **degenerate** `diag(0,1,1)` witness (`matched_four_twentyfive_witness`, still
  present, still using `witnessB/witnessQ/witnessS`), never with the repaired
  nondegenerate quartet. The new theorem uses `quartetB/quartetQ/quartetS` and
  proves `((quartetB (qe2 + quartetQ chi) (quartetS (qe2 + quartetQ chi))):ℝ):ℂ
  = complexAbsSq (spinorWedge edge0 (edge1 (2/5)))` for **every** exact
  representative `chi`, rewriting through `nondegenerate_quartet_witness`'s last
  conjunct (`= 4/25`) and `canonical_plucker_mass`. This is precisely the
  "single next exact theorem" proposed in `PHYSICAL_MASS_CONTINUUM_AUDIT_02.md`,
  so the nondegenerate fixture now reaches the bridge.
- *But it is not CLOSED as a verified artifact.* It cannot be built here (F1:
  `CanonicalGramTurnDictionary`, `Spinor.PluckerMass`,
  `PositiveHodgeClassCostNoGo` all missing), so the guard cannot be re-run and
  the job forbids trusting it. And even if it compiles, it wires a **shared
  constant `4/25`**, engineered on both sides (F3), not a derived identity.

Net: the specific fixture-wiring **defect is addressed at the logical level**
(nondegenerate quartet ↔ canonical spinor pair), but verification and the
deeper derivation both remain outstanding → PARTIAL.

### (d) Does removing the redundant `hcl'` premise from `class_mass_wellDefined` preserve the intended theorem? — **CLOSED at source level** (build unverifiable here).
Declaration: `PositiveHodgePhysicalMass.class_mass_wellDefined`.

- The current signature has **no `hcl'`**; the only closedness hypothesis is
  `hcl : Q h = 0`. Removal is sound: with `hcohom : ∃ chi, h' = h + Q chi`,
  `hQQ : Q ∘ₗ Q = 0`, and `hcl`, the representative `h' = h + Q chi` satisfies
  `Q h' = Q h + Q (Q chi) = 0 + 0 = 0` automatically, so closedness of `h'` is a
  **consequence, not a premise**. The intended statement — "two normalized
  closed eigen-representatives in the same class have equal eigenvalue" — is
  unchanged, and the theorem is strictly **more general** (one fewer
  hypothesis).
- The proof text (`rcases hcohom; class_cost_constant …; linarith`) does not
  mention `hcl'`; `hcl`, `heig`, `hn`, `heig'`, `hn'` are all used. Non-vacuous:
  the quartet realizes the hypotheses (`quartet_e2_closed`, `quartet_e2_eigen`
  `= 4/25`, `quartet_e2_positive` `= 1`).
- Caveat: this reasoning is independent of the missing dependencies, but the
  file itself still cannot be elaborated here (needs `class_cost_constant`,
  `RadicalProperty`), so I confirm the logic, not the compiled build.

### (e) What exact arrow remains between supplied history gates / spinor decorations and the theory's primitive null data? — **OPEN** (central gap).

Three disconnected layers exist, with **no theorem linking any two of them**:

1. **Primitive direction histories** — `CheckerboardPathSumTransferPower`:
   `Direction` lists with `turnWeight`/`phase`, summed to a genuine transfer
   power. This is the only layer built from primitive combinatorial null-edge
   data, and it is fully verified.
2. **Supplied operator gates** — `HistoryOperatorMonoidalDagger`: histories of
   arbitrary complex matrices (Pauli fixture). The gate matrices are
   **external inputs**; nothing derives them from layer 1.
3. **Hodge/Pluecker mass** — the Carrier files: class cost `= complexAbsSq
   (spinorWedge …)`, connected to a scale only through the **supplied**
   hypothesis `mu2 = m^2` (F2) and the supplied spinor dictionary.

The remaining arrow is therefore threefold and entirely open: (i) derive the
operator gate assignment (layer 2) from primitive direction/null-edge histories
(layer 1); (ii) connect either transport layer to the Hodge/Pluecker mass
(layer 3); (iii) derive `mu2 = m^2` instead of assuming it. None is present.

---

## 3. Over-claim modes and the nondegeneracy gate

| Mode | Standalone files (verified) | Carrier files (source-level) |
|---|---|---|
| **Vacuity** | None. Witnesses instantiate all hypotheses (`two_step_nontrivial_witness`, `operator_composition_witness`). | None apparent: quartet satisfies `class_mass_wellDefined`'s hypotheses; `class_cost_eq_canonical_plucker` non-trivial given `hmu`. Not build-checked. |
| **Hidden assumption** | None beyond stated typeclasses. | `hmu : mu2 = m^2` (F2) and the supplied spinor/turn dictionary carry the physics; disclosed in docstrings. |
| **False shape** | None: conclusions match prose (transfer power; adjoint; Kronecker). | Bridge prose "closes the fixture-wiring defect" is accurate about *wiring* but the value equality is engineered `4/25` (F3). |
| **Degeneracy / trivial collapse** | Excluded and verified: off-diagonal transfer `≠ 0`, both straight+two-turn contribute (85); order-matters and parallel `≠ 0`. | Quartet is nondegenerate (`quartetB_left_nondegenerate`) and indefinite (`quartet_e2_positive = 1`, `quartet_e3_negative = -1`), `quartetQ ≠ 0`, `quartet_radical` non-vacuous — but only at source level. |

**Nondegeneracy gate:** passed and independently re-verified for the two
standalone files; asserted-but-not-built for the Carrier files (F1).

---

## 4. Strongest honest manuscript paragraph now supported

> Over the two-direction checkerboard alphabet, the finite sum over **all**
> length-`n` direction histories — each step weighted by one turn factor and one
> outgoing-step phase — equals exactly the corresponding matrix element of the
> `n`-th power of the one-step transfer operator
> (`directionPathSum_eq_transfer_pow`), an identity we re-elaborated and found to
> depend only on `[propext, Classical.choice, Quot.sound]`; the two-step integer
> fixture (common value `85`, off-diagonal transfer nonzero) rules out
> straight-only and diagonal-transfer collapse. Independently, finite histories
> of complex gate matrices form a monoidal dagger layer in which sequential
> gluing is operator multiplication (`historyOperator_append`), orientation
> reversal composed with the gatewise conjugate transpose is the operator
> adjoint (`historyOperator_dagger`), and length-matched disjoint histories
> compose by the Kronecker product of their totals (`historyOperator_parallel`),
> with a Pauli fixture certifying local noncommutativity, the dagger law, and a
> nonzero tensor step (`operator_composition_witness`); these too were
> re-elaborated with the same three-a x i o m footprint. Both are exact,
> a x i o m-clean, finite composition identities.

Explicitly **not** supported (must remain conditional/absent): the Hodge
physical-mass and Pluecker-bridge theorems could **not be compiled in this
repository** (missing `PositiveHodgeClassCostNoGo`, `CanonicalGramTurnDictionary`,
`Spinor.PluckerMass`), so no mass statement is verified here; the eigenvalue /
mass identification `mu2 = m^2` is assumed, not derived; the shared `4/25` is a
constant engineered on both sides; and no theorem connects the verified transport
layers to each other or to the mass.

## 5. Single next exact theorem

Bridge the two **already-verified** layers by realizing the checkerboard
transfer power as an operator-valued history, so primitive direction histories
and the monoidal operator layer stop being disjoint. Over `ℂ` (both layers'
prerequisites hold), the following is reachable — I checked that the proof term
type-checks against the landed `directionPathSum_eq_transfer_pow`:

```lean
-- in a module importing both standalone files, entries over ℂ
theorem pathSum_as_operator_history
    (mu : ℂ) (phase : Direction → ℂ) (n : Nat) (start finish : Direction) :
    directionPathSum mu phase n start finish
      = historyOperator (List.replicate n (transfer mu phase)) finish start := by
  rw [directionPathSum_eq_transfer_pow, historyOperator, List.prod_replicate]
```

This identifies the exact path sum with the `HistoryOperatorMonoidalDagger`
operator of the constant-gate history `[transfer, …, transfer]`, giving the
first genuine arrow from primitive direction histories (layer 1) into the
supplied-gate operator layer (layer 2) — the immediate prerequisite before any
attempt to derive, rather than supply, the gate assignment or `mu2 = m^2`.
