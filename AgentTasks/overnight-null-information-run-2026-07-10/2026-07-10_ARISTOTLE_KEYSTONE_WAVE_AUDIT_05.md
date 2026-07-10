# KEYSTONE_WAVE_AUDIT_05 — keystone mass and quantum-history wave

Independent source-level audit for job `codex-keystone-wave-audit-20260710-05`.
Scope: the three landed modules under `PhysicsSM/Draft/NullEdge/`
(`D4NullRaySpinorFactorization`, `UnitaryHistoryComposition`,
`CheckerboardOperatorHistoryBridge`), the three current proof targets under
`AgentTasks/aristotle-standalone/*/Core.lean`
(`PluckerQuartet`, `PositiveSector`, `SummableFourier`), the two latest
independent reports (`GRAND_STRATEGY_02`, `LATEST_KINEMATICS_SPIN_AUDIT_04`), and
both control matrices (`MANUSCRIPT_CLAIM_MATRIX`, `THEORY_COMPLETION_MATRIX`).

**Source files were not edited.** Findings first, ordered by severity.

Grades: `CLOSED` (the kernel statement proves exactly what the caption claims and
is a landed, non-`sorry` theorem), `PARTIAL` (statement is honest but narrower
than the surrounding prose, or rests on supplied data / an absent import), `OPEN`
(the claimed arrow is a `sorry` target or not in the kernel at all).

Verification legend:
- `[verified-here]` re-elaborated in this Lean/Mathlib (v4.28.0).
- `[source-only]` module imports upstream files **absent** from this tree; it
  cannot be recompiled here and its `#print axioms … #guard_msgs` guard is **not
  enforceable**; audited from source text plus stated guard.
- `[sorry-target]` a proof target whose body is `by sorry`; the statement is
  audited, the proof does not exist yet.

---

## F0 (SEVERITY: HIGH) — The wave is still not self-contained, and the three "targets" are unproven

Two structural facts dominate every grade below.

1. **The build target is a stub.** `lakefile.toml` builds only the library
   `Audit` = `Audit/Core.lean`, whose sole theorem is
   `KeystoneWaveAudit.package_marker : True`. `[verified-here]` — it builds and is
   axiom-clean, and it proves nothing about the corpus.

2. **All three "landed" modules are `[source-only]`.** Every imported upstream
   module is absent from the tree (confirmed by search: no file named
   `D4NullShellLattice`, `PluckerMass`, `CheckerboardPathSumTransferPower`,
   `HistoryOperatorMonoidalDagger`, `Clifford3Plus1WalkSymbol`,
   `CanonicalGramTurnDictionary`, `NullFactorizationSpinFiber` exists outside
   `.lake`).

   | Landed module | Missing import(s) |
   |---|---|
   | `D4NullRaySpinorFactorization` | `D4NullShellLattice`, `PluckerMass` (`Vec4`, `nullRoots`, `CSpinor`, `rankOneHermitian`, `spinorWedge`) |
   | `UnitaryHistoryComposition` | `HistoryOperatorMonoidalDagger` (`historyOperator`, `parallelHistory`, `sigmaX`, `sigmaZ`) |
   | `CheckerboardOperatorHistoryBridge` | `CheckerboardPathSumTransferPower`, `HistoryOperatorMonoidalDagger` (`directionPathSum`, `Direction`, `transfer`, `directionPathSum_eq_transfer_pow`) |

   Consequence: none of the three modules' `#print axioms` guards can be executed
   here, so their "build-enforced assumption footprint" is an unverified assertion
   about source text — the *identical* under-delivery `LATEST_KINEMATICS_SPIN_AUDIT_04`
   recorded as its F0. The problem has not been fixed; it has moved to new files.

3. **All three proof targets are `sorry`.** Every declaration in
   `PluckerQuartet/Core.lean`, `PositiveSector/Core.lean`, and
   `SummableFourier/Core.lean` has body `by sorry` (these are submission stubs, not
   results). Any matrix row that reads them as achieved is premature.

Recommendation: vendor the upstream modules into the submission set (or downgrade
the three landed modules to `[import]`/source-only in both matrices), and mark the
three targets `OPEN / sorry` until a non-`sorry` proof lands.

---

## Question-by-question findings

### Q1 — Does the D4→spinor factorization genuinely supply primitive null rays to the same `rankOneHermitian`/`spinorWedge` API used by mass?

`D4NullRaySpinorFactorization` — `[source-only]`.

**Verdict: YES, as a source-level arrow — CLOSED modulo F0, with two supplied
conventions.** `all_d4_null_rays_factor` states, for each of the six future axial
rays, `rankOneHermitian (spinor r) = pauliHalf (scaledRoot r)`, and
`noncollinear_spinor_control` uses `spinorWedge` — both the *same* `PluckerMass`
API that the Gram/Plücker mass layer consumes. `roots_are_selected_future_null`
and `scales_positive` tie the six spinors to genuine members of `nullRoots`. So
this is a real arrow from selected primitive null directions into the mass
decoration API, not a parallel re-definition. Good.

**PARTIAL caveats.**
1. **Coverage is six future rays, not twelve.** The matrix's "twelve luminal
   steps" (M6) are twelve *roots*; the factorization decorates the six
   *future* (`t = 1`) axial rays only. The other six are the antipodes; the
   caption "future D4 null rays" is honest, but a reader of M6 must not conflate
   twelve steps with twelve spinor decorations.
2. **The projective scale is a hidden normalization.** `rayScale` is `2` for the
   x/y rays and `1` for the z rays, and the equality is with
   `pauliHalf (scaledRoot r)`, i.e. the half-Pauli of a *positively rescaled*
   root. Rank-one Hermitians only fix a null direction up to positive scale, so
   this is legitimate, but the specific `2/2/2/2/1/1` choice is what makes the
   two sides equal on the nose — a supplied normalization, not a derived one.
3. **Decorations are chosen, not derived.** The Gaussian-integer spinors
   (`![1,I]`, etc.) are hand-assigned; no theorem reconstructs them from a bare
   graph. Correctly disclaimed in the docstring.

Net: it feeds the mass API for real (answers the question yes), but the spinor
map and its projective normalization are supplied, and it is unbuildable here.

### Q2 — Do unitary gate histories + the checkerboard bridge close quantum composition, and what still depends on transfer normalization?

`UnitaryHistoryComposition` and `CheckerboardOperatorHistoryBridge` — both
`[source-only]`.

**Verdict: the composition law is CLOSED generically; closure of the *physical*
quantum engine is PARTIAL, and the sole remaining dependency is the unitarity
(normalization) of the transfer gate itself.**

What is genuinely closed (source-level):
- `UnitaryHistoryComposition` proves, with a two-sided `IsUnitary`, that
  `historyOperator` of any list of unitary gates is unitary
  (`historyOperator_unitary`), that equal-length parallel (Kronecker) histories
  are unitary (`parallel_history_operator_unitary`), that a *replicated* history
  is unitary (`replicated_history_operator_unitary`), and a noncommuting
  `sigmaX / sigmaZ` witness rules out a commutative/identity collapse. This is a
  substantive general theorem, not a conjunction.
- `CheckerboardOperatorHistoryBridge.pathSum_as_operator_history` equates the
  scalar `directionPathSum … n` with the matching entry of
  `historyOperator (List.replicate n (transfer mu phase))`, with the nonzero `85`
  fixture on both sides. A real bridge from the primitive path-sum layer into the
  operator layer (for the **uniform** history only).

What still depends on transfer normalization — **exactly one arrow**:
- `replicated_history_operator_unitary` requires `IsUnitary (transfer mu phase)`
  as its hypothesis, and **no theorem proves the transfer gate is unitary**.
  `transfer mu phase` is built from supplied `mu` and `phase` (e.g. the witness
  `phase = 3,5` gives the non-unitary entry `85`). So the chain
  `path sum = uniform operator history` ∘ `unitary gate ⇒ unitary history`
  closes *conditionally on* `IsUnitary (transfer mu phase)`, which holds only for
  a normalized `(mu, phase)` regime that is not yet identified or proved.

Progress vs `LATEST_KINEMATICS_SPIN_AUDIT_04`: that audit's single "next theorem"
was `transfer_history_unitary` (unitary gate ⇒ unitary uniform history). The
*general* half of that is now landed as `replicated_history_operator_unitary`; the
**gate** half (`IsUnitary (transfer mu phase)`) is the only piece left. The
THEORY_COMPLETION_MATRIX "Quantum composition" row therefore now *understates* the
state: the unitarity composition law is landed (D at source level); only the gate
normalization is B.

### Q3 — Would the parameterized Plücker quartet target remove `hmu` on a family, or merely rename the assumption?

`PluckerQuartet/Core.lean` — `[sorry-target]` (all declarations `by sorry`).

**Verdict: it removes the explicit `hmu : mu2 = m^2` hypothesis on a family, but
only by relocating the identification into the *definition* of the decoder
`SAt`; it is stronger than a pure rename (it pins the correct functional form
`m ↦ m²` across a family, killing the single-point-coincidence worry) yet still
short of a derivation.**

Detail: `SAt m x := ![0, 0, m^2 * x 2, 0]` bakes `m²` into the shift operator, and
`parameterized_decoder_pairing_formula` claims `B x (SAt m x) = m² (x 2)²`.
Because `x = e2q + Q chi` has `x 2 = 1` for every `chi`, the target
`parameterized_class_cost_eq_plucker` claims class cost `= m² = normSq(wedge edge0 (edge1 m))`
for all `chi`. I re-elaborated both sides `[verified-here]`: the class cost is
`m²` independent of `chi`, and the Plücker `normSq(wedge)` is `m²`. So the number
matches by construction, and `two_scale_nondegenerate_control` (`2/5 ↦ 4/25`,
`3/5 ↦ 9/25`, distinct) upgrades the old single `4/25` point to a genuine
`m ↦ m²` map — a real improvement.

But nothing in the target *derives* `SAt` (the eigenvalue-carrying decoder) from
primitive data; the `m²` that was the hypothesis `hmu` is now the coefficient in
the ad-hoc definition of `SAt`. So: `hmu` is discharged on the constructed family
(good), yet the mass identification is still supplied — as a definitional choice
rather than a named hypothesis. Grade if landed: **PARTIAL** (family-level removal
of `hmu`, correct functional form, but decoder is inserted, not derived). Grade
now: **OPEN** (`sorry`).

### Q4 — Does the summable Fourier target have sufficient hypotheses for a true countable synthesis theorem?

`SummableFourier/Core.lean` — `[sorry-target]`.

**Verdict: YES for a true *countable* (infinite-mode) synthesis error/convergence
theorem — the summable envelope genuinely fixes the `card ι` blow-up that made
`FiniteFourierContinuumLift` a fixed-grid statement — but "continuum" still
overreaches: the index stays a countable discrete set, and summability of the
synthesized series is assumed, not derived.**

Detail: over `Countable ι` and a Banach `E`,
`infinite_fourier_error_bound` claims
`‖synthInfinite φ approx − synthInfinite φ exact‖ ≤ ε · ∑' k, g k`
under `Summable g`, `g ≥ 0`, `ε ≥ 0`, `‖φ k‖ ≤ 1`, summability of both
synthesized series, and pointwise `‖approx − exact‖ ≤ ε · g`. This is exactly the
right hypothesis set for a genuine countable synthesis bound: the **summable
envelope `∑' g`** replaces `FiniteFourierContinuumLift`'s divergent `card ι`
factor, so the bound survives the infinite index. `infinite_fourier_tendsto`
(vanishing `ε n`) and the geometric witness (`∑' = 1`) are consistent and
nondegenerate. The hypotheses are sufficient and honest.

Caveats: (i) `ha`/`he` (summability of `phase • approx`, `phase • exact`) are
*assumed*, so this is a relative synthesis-error theorem, not an existence theorem
— it presupposes the synthesis converges. (ii) "continuum" is a naming overreach:
`ι` is countable/discrete; this is an infinite-*mode* synthesis, not an integral
over a continuum of momenta, and it is not an `L²`/inverse-Fourier/PDE statement.
Grade if landed: **PARTIAL** (true countable synthesis, "continuum" caption
overstates). Grade now: **OPEN** (`sorry`).

### Q5 — Would positive-sector intertwiner invariance establish physical sector selection, or only presentation invariance?

`PositiveSector/Core.lean` — `[sorry-target]`.

**Verdict: only presentation invariance.** `Sector B := {x // 0 < B x x}` is the
entire positive cone of the form, and `sectorEquiv` / `positive_sector_nonempty_invariant`
say a pairing-preserving linear equivalence carries the positive cone to the
positive cone (and preserves nonemptiness). That is the statement that an isometry
of the form preserves its positive cone — invariance of the description under a
change of presentation. It contains **no selection principle**: nothing singles
out a physical sector among competitors, no Krein `J`-decomposition into
`±`-sectors, no invariant subspace/equivalence class. The Minkowski `boost`
witness (`!![5/4,3/4;3/4,5/4]`, `cosh²−sinh² = 1`) confirms a boost moves a
positive vector while preserving the form — again presentation invariance, not
selection. This matches the GRAND_STRATEGY A4 kill condition precisely: it lands
the presentation-equivalence half and leaves invariant *sector selection* (and
Born) open. Grade if landed: **PARTIAL** (presentation invariance only). Grade
now: **OPEN** (`sorry`).

### Q6 — Hidden dictionaries, degeneracies, convention mismatches, manuscript rows over/understating

- **Dictionaries (supplied, disclosed, must not be upgraded):** the spinor
  decorations and their `2/2/2/2/1/1` projective normalization (Q1); the transfer
  gate's `(mu, phase)` normalization = its unitarity (Q2); the mass eigenvalue
  `m²` now living inside the decoder `SAt` (Q3); the `(+ − − −)` signature with
  coordinate `0` named time, inherited from `D4NullShellLattice` (Q1, carried over
  from Audit-04 F1).
- **Degeneracies / normalizations:** `SAt`'s class cost is `m²` *independent of
  `chi`* because `x 2 = 1` for all `x = e2q + Q chi` — the `chi`-family is a fixed
  point of the pairing, so "for every `chi`" is weaker than it looks
  (`[verified-here]`). The `4/25`↔`9/25` control is nonetheless genuine.
- **Convention mismatches:** `UnitaryHistoryComposition.IsUnitary` is two-sided
  (correct); `PositiveSector`'s "Sector" is the whole positive cone, not a
  representation sector; `SummableFourier`'s "continuum" is a countable discrete
  index. Each is a caption that outruns its kernel.
- **Manuscript rows that now understate the kernel:** the
  THEORY_COMPLETION_MATRIX "Quantum composition" row says "unitarity job running"
  — but the *general* unitary-history composition law
  (`historyOperator_unitary`, `parallel_history_operator_unitary`,
  `replicated_history_operator_unitary`) has landed (source-level); only gate
  unitarity remains. MANUSCRIPT_CLAIM_MATRIX has no row for
  `UnitaryHistoryComposition` or `D4NullRaySpinorFactorization` at all.
- **Manuscript rows that now overstate the kernel:** any reading of the three
  `AgentTasks/aristotle-standalone` targets (`PluckerQuartet`, `PositiveSector`,
  `SummableFourier`) as results overstates them — they are `sorry` stubs (F0.3).
  M5's "finite-grid position-space convergence" must not silently absorb the
  countable `SummableFourier` claim until it is proved; and neither the mass-row
  `hmu` discharge nor sector selection may be counted until `PluckerQuartet` /
  `PositiveSector` land non-`sorry`.

---

## CLOSED / PARTIAL / OPEN summary

| Item | Module / target | Status | Grade | One line |
|---|---|---|---|---|
| F0 | build closure + guards | `[source-only]`/stub | **OPEN (HIGH)** | 3 landed modules import absent files; only `Audit/Core.lean` (`= True`) builds; 3 targets are `sorry` |
| Q1 | `all_d4_null_rays_factor` | `[source-only]` | **CLOSED\*** | genuine arrow into `rankOneHermitian`/`spinorWedge`; 6 future rays; projective scale + spinors supplied (\*modulo F0) |
| Q2a | unitary history composition law | `[source-only]` | **CLOSED\*** | history/parallel/replicated unitarity + noncommuting witness are landed generically (\*modulo F0) |
| Q2b | checkerboard bridge → *quantum* engine | `[source-only]` | **PARTIAL** | uniform-history bridge closed; sole gap = unitarity (normalization) of `transfer mu phase` |
| Q3 | `parameterized_class_cost_eq_plucker` | `[sorry-target]` | **OPEN** | if landed, PARTIAL: removes `hmu` on a family but bakes `m²` into `SAt` (not derived) |
| Q4 | `infinite_fourier_error_bound` | `[sorry-target]` | **OPEN** | if landed, PARTIAL: true countable synthesis (summable envelope fixes `card` blow-up); "continuum" overstates |
| Q5 | `positive_sector_nonempty_invariant` | `[sorry-target]` | **OPEN** | if landed, PARTIAL: presentation invariance only, not physical sector selection |

---

## Strongest honest end-to-end chain now available

Every arrow below is real; each is annotated with its true status. The chain is
*source-level* (F0: it cannot be rebuilt in this package) and it stops being
quantum at one named arrow.

```
selected D4 null shell (12 axial null roots, decidable)          [Audit-04, verified]
  → 6 future axial null rays decorated by Gaussian spinors,
    rankOneHermitian(spinor r) = pauliHalf(scaledRoot r)          [Q1  CLOSED*, supplied scale]
  → for every decorated pair, free two-edge mass operator
    = complexified turn channel at the nonneg Plücker scale        [GeneralGramTurnScale, Audit-04, source-only]
  ⟂ mass identification μ² = m²                                    [SUPPLIED — hmu, or baked into SAt (Q3 OPEN)]

  ‖ primitive length-n direction path sum
    = entry of historyOperator(replicate n (transfer mu phase))    [Q2  CLOSED*, uniform history]
  → any history of two-sided-unitary gates is unitary
    (sequential, parallel/Kronecker, replicated)                   [Q2a CLOSED*, landed generically]
  ⟂ unitarity of transfer mu phase                                 [SUPPLIED — transfer normalization (Q2b PARTIAL)]
```

Two supplied dictionaries (`μ² = m²`; transfer-gate unitarity) are the only
things separating this from a checked chain "null directions → mass API" and
"primitive path sum → unitary finite-history evolution." Everything else is a
landed (source-level) theorem. The 3+1 Clifford algebra, position-space/PDE
continuum, sector selection, and Born rule remain outside this chain (OPEN).

---

## One exact next theorem

Close the single arrow that upgrades the *whole* quantum-composition layer and is
now minimal because its general consumer has already landed
(`UnitaryHistoryComposition.replicated_history_operator_unitary`): prove the
checkerboard transfer gate is two-sided unitary under its normalization, then let
the landed replicated-history law finish the uniform history.

```lean
-- imports: CheckerboardPathSumTransferPower (transfer, Direction),
--          UnitaryHistoryComposition (IsUnitary, replicated_history_operator_unitary)
theorem transfer_gate_unitary
    (mu : ℂ) (phase : Direction → ℂ)
    (hnorm : ‖mu‖ ^ 2 + ‖phase Direction.left‖ ^ 2 = 1
             ∧ ‖phase Direction.right‖ ^ 2 + ‖mu‖ ^ 2 = 1)   -- the normalization to be pinned
    : UnitaryHistoryComposition.IsUnitary (transfer mu phase) := by
  sorry

-- immediate corollary via the ALREADY-LANDED replicated law:
theorem transfer_uniform_history_unitary
    (mu : ℂ) (phase : Direction → ℂ) (n : ℕ)
    (hgate : UnitaryHistoryComposition.IsUnitary (transfer mu phase)) :
    UnitaryHistoryComposition.IsUnitary
      (historyOperator (List.replicate n (transfer mu phase))) :=
  UnitaryHistoryComposition.replicated_history_operator_unitary _ n hgate
```

- **Witness (mandatory, nondegenerate):** exhibit one normalized rational/Gaussian
  `(mu, phase)` on the unit shell (e.g. built from a `(3/5, 4/5)` split) for which
  the product `(transfer mu phase)ᴴ * (transfer mu phase) = 1` exactly, and
  `transfer mu phase ≠ 1`, so the gate is a nontrivial unitary — *not* the `85`
  witness, which is deliberately non-normalized.
- **Kill / falsifier:** if no normalization of `(mu, phase)` makes
  `transfer mu phase` two-sided unitary (e.g. the corner/branch convention is not
  norm-preserving), then the checkerboard evolution is not unitary; the
  operator-history layer of M5 must be restated around a contraction / CP map, and
  the "unitary histories" claim is retracted to a non-unitary transfer statement.

This converts Q2 from PARTIAL to CLOSED, discharges the last non-imported
dependency of the quantum-composition row, and is strictly smaller than the
mass-keystone target (`PluckerQuartet`, Q3), which additionally requires deriving
`SAt` rather than defining it. Prerequisite (F0): vendor
`CheckerboardPathSumTransferPower` and `HistoryOperatorMonoidalDagger` into the
submission so the theorem — and the guards — actually build.
