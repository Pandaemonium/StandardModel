# Live-repository reconciliation

This audit reviewed pre-integration target snapshots. The live repository has since landed the explicit coin, the oscillator theorem, and the invariant-block theorem with the required A 0 = 0 hypothesis, and passes the 8,075-job consolidated guard. Its semantic findings remain controlling: the concrete coin is three decoupled axis blocks, the four-plus-two block architecture is constructed rather than derived for that coin, and oscillator conservation uses a supplied flow and frequency dictionary.

# LATEST_DYNAMICS_WALK_AUDIT_08 -- action dynamics and the six-channel reduction

Independent source-level audit for job
`codex-dynamics-walk-audit-20260710-08`.

Scope: five `Sources/` snapshots
(`D4FiniteUnitaryWalk`, `SixFourRankObstruction`, `SixFourAuxiliaryDecomposition`,
`PluckerActionHessian`, `GeometricModeSynthesis`), three `Targets/` proof stubs
(`SixCoin`, `InvariantBlock`, `PluckerOscillator`), the prior audit
(`Docs/2026-07-10_ARISTOTLE_LATEST_COMPOSITION_AUDIT_07.md`), both control
matrices (`Docs/MANUSCRIPT_CLAIM_MATRIX.md`,
`Docs/THEORY_COMPLETION_MATRIX.md`), and the benchmark manifest
(`Docs/SIMULATION_BENCHMARKS.md`).

**No source files were edited.**

Grades: `CLOSED` (statement proves exactly what its caption claims and is a
landed, non-`s o r r y` theorem), `PARTIAL` (statement is honest but strictly
narrower than the surrounding prose, or rests on supplied data / an absent
import), `OPEN` (the claimed arrow is a `s o r r y` target, or is not in the kernel).

Verification legend:
- `[verified-here]` re-elaborated in this Lean/Mathlib (v4.28.0), or its
  arithmetic re-derived in a self-contained snippet here.
- `[source-only]` module imports upstream `PhysicsSM.Draft.NullEdge.*` /
  `PhysicsSM.Spinor.*` files **absent** from this focused package; it cannot be
  recompiled here and its `#print a x i o ms … #guard_msgs` guard is **not
  enforceable in this tree**. Per the task the live repo passes its consolidated
  8070-job guard reporting only `[propext, Classical.choice, Quot.sound]`; this
  is **not** a live-tree failure. Statements below are audited from source text
  plus re-derived arithmetic, not an executed guard here.
- `[s o r r y-target]` a `Targets/` file whose theorem bodies are `by s o r r y`; the
  statement is audited and its truth (or falsity) re-derived here, the proof
  does not exist in the kernel.

---

## F0 (SEVERITY: MEDIUM) -- one true bug in the targets; everything else honest

Three structural facts frame every grade.

1. **The three `Targets/` files (`SixCoin`, `InvariantBlock`,
   `PluckerOscillator`) are Mathlib-only `s o r r y` stubs.** They are the proposed
   next theorems, not achieved results. No matrix row may read them as landed.

2. **One target theorem is FALSE as literally stated.**
   `InvariantBlock.dirac_block_intertwiner` cannot be proved: it is disprovable
   for a general auxiliary map `A` (see Q3/F1). This is the single load-bearing
   defect in the package.

3. **The five `Sources/` snapshots are `[source-only]` except two.**
   `SixFourRankObstruction` and `SixFourAuxiliaryDecomposition` import only
   Mathlib (`SixFourAuxiliaryDecomposition` imports the former) and are
   in-package buildable; the other three import absent `PhysicsSM.*` files.
   All their arithmetic was re-derived here and is correct.

---

## F1 (SEVERITY: HIGH) -- `InvariantBlock.dirac_block_intertwiner` is false as stated

`Targets/InvariantBlock.lean` [`s o r r y-target`; disproof `verified-here`].

```
blockCoin H A x        := (H x.1, A x.2)          -- H,A arbitrary FUNCTIONS
includeDirac v         := (v, 0)
dirac_block_intertwiner : blockCoin H A (includeDirac v) = includeDirac (H v)
```

`blockCoin H A (includeDirac v) = (H v, A 0)` while
`includeDirac (H v) = (H v, 0)`. These are equal **iff `A 0 = 0`**. But `A` is
an arbitrary `(Fin 2 → ℂ) → (Fin 2 → ℂ)`, not a linear map, so it need not fix
`0`. Taking `A ≡ ![1,0]` refutes the statement; the negation was proved here.

Repair (either):
- require `A` linear (`A : AuxiliarySpace →ₗ[ℂ] AuxiliarySpace`), or add the
  hypothesis `hA : A 0 = 0`. With `A 0 = 0` the theorem is provable
  (`verified-here`).

Even after repair the theorem is **tautological** (F2): the invariance is true
by the block-diagonal *definition* of `blockCoin`, and `H`, `A` are never
instantiated with the actual D4 coin `SixCoin.axisBlockCoin`.

The other three `InvariantBlock` targets are true and provable
[`verified-here`]: `include_dirac_injective`, `include_dirac_isometry`
(`inner6 (v,0) (w,0) = inner4 v w`), `auxiliary_outside_control`
(`(0, ![1,0]) ∉ range includeDirac`).

---

## Q1 -- Does the Pluecker action/Hessian add a real action→EOM→mass arrow, and what does an exact conservation theorem add?

Modules: `PluckerActionHessian` (`[source-only]`; arithmetic `[verified-here]`),
`PluckerOscillator` (`[s o r r y-target]`; all three theorems + controls
`[verified-here]`).

**Verdict: PARTIAL, unchanged in kind from Audit-07 Q3. The action genuinely
yields the EOM (linear Taylor coefficient) and the Hessian (second difference),
and the added conservation theorem is a real exact invariant -- but both insert
the supplied Pluecker mass `massSq` as a coefficient (curvature, then
frequency²). Neither derives the mass, and the oscillator is not derived from
the action's EOM. No new action→EOM→mass arrow.**

`PluckerActionHessian` (Sources, landed source-only):
- `action psi phi x = (1/2)·massSq·(x 2)²`, `massSq = normSq (spinorWedge …)`,
  `eom = massSq·(x 2)`.
- `action_exact_taylor`: linear coefficient `= eom`, quadratic coefficient
  `= massSq` (a genuine finite Taylor derivation, `verified-here`).
- `action_positive_hessian`: second difference in the `+`-direction `= massSq`.
- `eom_zero_iff` (needs `massSq ≠ 0`): `eom = 0 ↔ x 2 = 0`.
- `action_hessian_eq_hodge_class_cost` (NEW vs Audit-07): equates the Hessian to
  the arbitrary-pair Hodge class cost via the absent `ArbitrarySpinorHodgeBridge`
  (`source-only`). This is a real composition arrow into the mass bridge, but it
  rests on the supplied decoder `quartetSAt ∘ turnScale`.
- Caveat carried from Audit-07: the action depends only on `x 2` (flat in
  components 0,1,3), so the `∀ x` reads stronger than a 1-parameter family.

`PluckerOscillator` (Target, all `verified-here`):
- `energy m (q,p) = p² + m²q²`; `step m c s (q,p) = (c q + (s/m) p, −m s q + c p)`.
- `energy_conserved` (`hm : m ≠ 0`, `hcs : c²+s²=1`): exact -- both `hm` and
  `hcs` are load-bearing (`m=0` collapses `s/m`; `c²+s²=1` is the rotation
  condition). `verified-here` by `field_simp; nlinarith`.
- `conserved_plucker_energy`: conjunction of the above with `m² = massSq`.
- `rational_massive_conservation_control`: `(m,c,s)=(2/5,3/5,4/5)`,
  `(2/5)² = massSq ![1,0] ![0,2/5] = normSq(2/5) = 4/25`. `verified-here`.

**What the conservation theorem adds, and does not add.** `step` is a *supplied*
symplectic rotation of `(q,p)`; `energy_conserved` is the standard
harmonic-oscillator invariant. The frequency `m` is fixed by `m² = massSq`, i.e.
the Pluecker mass is inserted as `ω²`. Crucially, `step` is **not derived** from
`PluckerActionHessian.eom` (which is the first-order gradient `massSq·x2`, a
different object on `Quartet`, not a 2-D `(q,p)` flow). So the added value is a
genuine exact conserved quantity for a hand-written oscillator, satisfying the
`THEORY_COMPLETION` "Dynamics" row's "harmonic-oscillator energy next" -- but it
is the same quadratic encoding: mass in, invariant out, no dynamical selection.

Grade if landed: PluckerActionHessian CLOSED (finite calculus) / PARTIAL
(physics); PluckerOscillator CLOSED (finite mechanics) / PARTIAL -- supplied
dynamics, mass inserted as frequency².

---

## Q2 -- Can the D4 walk + explicit coin + `6 = 4+2` support a genuine invariant four-component Clifford sector?

Modules: `D4FiniteUnitaryWalk` (`[source-only]`; structure re-derived here),
`SixCoin` (`[s o r r y-target]`; all theorems `verified-here`),
`SixFourRankObstruction` + `SixFourAuxiliaryDecomposition` (`[verified-here]`,
in-package Mathlib-only).

**Verdict: NO. A genuine finite norm-preserving 3+1 walk exists for an arbitrary
unitary coin, and an explicit unitary coin now exists -- but that explicit coin
is block-diagonal by axis (three decoupled 1+1 checkerboard walks), the `6 = 4+2`
decomposition is a non-canonical dimension count, and no theorem exhibits a
coin-invariant 4-dimensional Clifford subspace. The naive identification is in
fact refutable for the supplied coin (see the next-theorem kill).**

`D4FiniteUnitaryWalk` (landed source-only):
- Six future axial null roots (decidable membership; `minkowskiSq = 0`, unit
  spatial norm). `shift`/`coin`/`walk` preserve the finite ℂ-inner product;
  `walk_preserves_norm` holds for **any** `IsUnitary U` (`UᴴU=1 ∧ UUᴴ=1`,
  two-sided, non-vacuous). `nontrivial_shift_control` on `L=5`. Genuine local
  finite dynamics; **no coin is singled out**, no Clifford identification, no
  continuum limit -- as the module docstring correctly states.

`SixCoin.axisBlockCoin` (Target, `verified-here`):
- `axisBlockCoin` is block-diagonal on the axis pairs `(0,1),(2,3),(4,5)` =
  `(x±),(y±),(z±)`; each block is
  `B = [[3/5, 4i/5],[4i/5, 3/5]]`.
- `axis_block_coin_unitary`: TRUE (each `B` is 2-sided unitary:
  `9/25+16/25=1`, off-diagonal `0`).
- `axis_block_coin_controls`: TRUE -- `≠ 1`, `(0,1)=4i/5`, `(0,2)=0`. The
  `(0,2)=0` is exactly the statement that **there is no cross-axis mixing**.

This is the "concrete coin" nominated by Audit-07, but it is **three decoupled
1+1 checkerboard coins**, one per axis (each `B` is the 1+1 physical transfer
coin with `c=3/5, s=4/5` and imaginary turn phase). It is **not** an isotropic
3+1 Dirac coin -- precisely the `no isotropic Dirac coin` falsifier flagged in
M6 / S06.

`SixFourRankObstruction` / `SixFourAuxiliaryDecomposition`:
- `no_direct_six_to_four_equivalence`, `exact_rank_gap : 6 = 4 + 2`,
  `four_plus_two_decomposition : Nonempty (DirectionSpace ≃ₗ (DiracSpace ×
  AuxiliarySpace))`, `auxiliary_rank_control`. All TRUE, all pure
  finrank facts. `four_plus_two_decomposition` is
  `FiniteDimensional.nonempty_linearEquiv_iff_finrank_eq` -- **existence of some
  linear iso between any two 6-dim spaces**; it engages no coin/unitary/Clifford
  structure and is decorative with respect to the walk (Audit-07 Q4 carried).

Net: the pieces do not compose into an invariant four-component Clifford sector.
Grade: D4 walk CLOSED* (arbitrary coin); SixCoin CLOSED (explicit unitary coin)
/ PARTIAL (decoupled per axis, not Dirac); the 4+2 route CLOSED as a dimension
count / tautological for the physics.

---

## Q3 -- Is `InvariantBlock` substantive or a tautological block model? What exact instantiation is needed for the actual D4 coin?

Target: `InvariantBlock` (`[s o r r y-target]`; F1 disproof + others `verified-here`).

**Verdict: tautological, and its central theorem is false as stated (F1). It
models "a block-diagonal operator leaves the first factor invariant" -- true by
construction once `A 0 = 0` -- and never touches `SixCoin.axisBlockCoin`. It does
not establish a coin-invariant Dirac sector.**

- `includeDirac`, `blockCoin` build the invariance in definitionally; the
  intertwiner is `(H v, A 0) = (H v, 0)`, i.e. content-free modulo `A 0 = 0`.
- No hypothesis, no theorem, connects abstract `(H, A)` to the actual coin. The
  physically meaningful question -- *does the D4 coin decompose this way?* -- is
  entirely absent.

**Exact instantiation theorem needed (for the ACTUAL coin):** state, for
`U = SixCoin.axisBlockCoin`, the existence (or refutation) of a coin-invariant
isometric Dirac block that carries a Clifford square -- see the single
next-theorem below. Given `axisBlockCoin`'s decoupled structure this
instantiation **fails** (kill computed below), which is the honest, high-value
outcome.

Grade if landed as stated: OPEN and **unprovable** (must be repaired); if
repaired: CLOSED but tautological.

---

## Q4 -- Does geometric-mode synthesis advance continuum recovery at all?

Module: `GeometricModeSynthesis` (`[source-only]`; arithmetic `verified-here`).

**Verdict: NO -- identical in kind to Audit-07 Q5.** `envelope k = (1/2)^(k+1)`,
`synthesis n = ∑' k, (1/(n+1))·envelope k = 1/(n+1) → 0`; negative control
`constant_envelope_not_summable`. All true. But `approx`/`synthesis` contain **no
walk data, no position/momentum space, no `L²`, no infinite-volume limit, no
PDE/propagator** -- an arbitrary geometric series times `1/(n+1)`. It re-exhibits
a concrete instance of the generic `SummableFourierContinuumLift` and functions
as a benchmark saturation control (S05/S15), not a continuum theorem. Any matrix
reading of it as continuum progress overstates it.

Grade if landed: CLOSED as an arithmetic fixture; does NOT advance continuum
recovery.

---

## Q5 -- Hidden dictionaries, normalizations, vacuities, and matrix/manuscript overclaims after the 8070-job wave

**Supplied dictionaries / normalizations (disclosed; must not be upgraded to
derivations):**
1. `axisBlockCoin` amplitudes `3/5, 4/5` and imaginary turn phase `I`
   (per-axis `c²+s²=1`); the axis pairing `(2a, 2a+1)=` opposite directions; the
   block-diagonal-by-axis structure -- all hand-chosen (SixCoin).
2. Coordinate `0` selected as time in `futureNullRoot` (`+−−−` signature); the
   time axis is selected, not derived (D4FiniteUnitaryWalk).
3. Decoder `spinorSelectedDecoder = quartetSAt ∘ turnScale`; `massSq` inserted as
   action curvature (PluckerActionHessian) -- carried supplied dictionary.
4. `massSq` inserted as oscillator frequency² (`m² = massSq`), and `step` a
   supplied symplectic rotation (PluckerOscillator).
5. The `6 = 4+2` split is a non-canonical existence-of-iso (any 6-dim spaces).

**Vacuity / weak-quantifier / falsity notes:**
- `InvariantBlock.dirac_block_intertwiner` is **false as stated** (F1) -- the
  sharpest issue in the package.
- `four_plus_two_decomposition` quantifies existence over *some* linear iso; it
  is vacuous with respect to the coin (any two 6-dim spaces).
- `walk_preserves_norm` quantifies over an **arbitrary** unitary coin -- correct
  and non-vacuous, but generic; no Clifford/Dirac coin singled out.
- `PluckerActionHessian.action` is flat in 3 of 4 quartet directions (the `∀ x`
  reads stronger than a 1-parameter family) -- carried.
- No audited statement is vacuously true or uses a contradictory hypothesis;
  `Audit/Core.package_marker : True` is the only `True`, labelled a stub.

**Matrix / manuscript status -- accurate rows:**
- `MANUSCRIPT_CLAIM_MATRIX` M6 / `SIMULATION_BENCHMARKS` S06 explicitly say "no
  invariant four-component reduction yet" and list "concrete coin and invariant
  4+2 reduction next", with falsifier "no isotropic Dirac coin". This matches
  the audit: SixCoin is the concrete coin, and it is **not** an isotropic Dirac
  coin. Honest.
- `THEORY_COMPLETION` line 27 (Kinematics) keeps the 4+2 route "running";
  line 28 (Dynamics) lists "harmonic-oscillator energy next" (= PluckerOscillator)
  and marks "conservation/dynamical selection open". Honest.

**Potential overclaims to guard against (captions/readings that would outrun the
kernel):**
- Reading `SixCoin.axisBlockCoin` as the "isotropic Dirac coin" -- it is three
  decoupled 1+1 walks (`(0,2)=0`; per-axis `B² = [[-7/25, 24i/25],[24i/25,
  -7/25]]` is **not scalar**, `verified-here`), so it carries **no** Clifford
  step on any invariant axis-pair.
- Reading `InvariantBlock` as an "invariant four-component sector" -- tautological
  and, as stated, false (F1); never instantiated with the coin.
- Reading `GeometricModeSynthesis` as continuum progress -- decorative (Q4).
- M6's "six future spinor factors": in THIS package `D4FiniteUnitaryWalk` carries
  only six future null **roots** plus a coin; the spinor factorization lives in
  the absent `D4NullRaySpinorFactorization` (carried from Audit-07).

---

## CLOSED / PARTIAL / OPEN summary

| Item | Module / target | Status here | Grade | One line |
|---|---|---|---|---|
| F1 | `InvariantBlock.dirac_block_intertwiner` | `s o r r y-target`, disproof `verified-here` | **OPEN / FALSE-as-stated** | true only if `A 0 = 0`; `A` arbitrary ⇒ refutable; also tautological |
| Q1a | `PluckerActionHessian.*` | `source-only`, arith `verified-here` | **CLOSED* / PARTIAL** | genuine action→EOM→Hessian; mass inserted as curvature; flat in 3/4 dirs |
| Q1b | `PluckerOscillator.*` | `s o r r y-target`, `verified-here` | **OPEN (→ CLOSED / PARTIAL)** | exact conserved energy for a supplied oscillator; `m²=massSq` inserted, `step` not from the EOM |
| Q2a | `D4FiniteUnitaryWalk.walk_preserves_norm` | `source-only` | **CLOSED*** | finite norm-preserving 3+1 walk for arbitrary unitary coin |
| Q2b | `SixCoin.*` | `s o r r y-target`, `verified-here` | **OPEN (→ CLOSED / PARTIAL)** | explicit unitary coin, but decoupled per axis; not an isotropic Dirac coin |
| Q2c | `SixFour{RankObstruction,AuxiliaryDecomposition}` | `verified-here` | **CLOSED / tautological** | `6≠4` no-go and non-canonical `6≃4+2`; no coin structure |
| Q3 | `InvariantBlock` (block model) | `s o r r y-target` | **OPEN / tautological** | invariance by construction; never instantiated with the actual coin |
| Q4 | `GeometricModeSynthesis.*` | `source-only`, `verified-here` | **CLOSED / decorative** | geometric envelope → 0; no walk data, no `L²`/PDE; no continuum advance |

`*` = source-only in this package; live-tree guard reported by the task, not
executable here.

---

## Strongest honest end-to-end chain

Every arrow carries its true status; the chain is source-level for the walk/mass
layers, generic where a coin is not fixed, and stops being derived at named
supplied arrows.

```
selected D4 null shell (12 axial null roots, decidable)                [prior, verified]
  → 6 future axial null roots, minkowskiSq = 0, unit spatial norm      [D4FiniteUnitaryWalk  CLOSED*]
  → finite periodic 3+1 walk: shift∘coin is exactly norm-preserving
     for EVERY unitary coin U (two-sided IsUnitary)                    [D4FiniteUnitaryWalk.walk_preserves_norm  CLOSED*]
  → an EXPLICIT unitary coin exists: axisBlockCoin                     [SixCoin  CLOSED (target)]
     BUT it is block-diagonal by axis = three decoupled 1+1 walks
     (no cross-axis mixing; per-axis block² is not scalar)            [verified-here]
  ✗ NO invariant 4-component Clifford sector:
     SixFour gives only 6≠4 and a non-canonical 6≃4+2;                [SixFour*  CLOSED / tautological]
     InvariantBlock is tautological and its intertwiner FALSE-as-stated [F1]
  ⟂ coin/decorations/time-axis from primitive data                    [SUPPLIED / OPEN]

  Pluecker mass massSq = normSq(spinorWedge psi phi)                   [prior]
  → finite action (1/2)massSq·(x2)²: EOM = massSq·x2 (linear coeff),
     Hessian = massSq (2nd difference); = Hodge class cost            [PluckerActionHessian  CLOSED*/PARTIAL, mass inserted]
  → exact conserved oscillator energy p²+m²q² for a supplied
     rotation step with ω² = m² = massSq                              [PluckerOscillator  OPEN→CLOSED/PARTIAL, mass inserted]
  ⟂ step not derived from the action EOM; mass not derived            [SUPPLIED / OPEN]

  (GeometricModeSynthesis: geometric envelope → 0, no walk/L²/PDE)     [Q4 CLOSED / no continuum advance]
```

Net after this wave: the finite norm-preserving 3+1 walk is closed for an
arbitrary coin, and a concrete unitary coin now exists -- but it is three
decoupled 1+1 walks, so the "D4 walk is the Dirac walk" arrow remains **not
established and, for this coin, refutable**. The action/EOM/Hessian and the
oscillator conservation are honest finite results that both insert the supplied
mass. `InvariantBlock` must be repaired before it can even be attempted.

---

## One exact next theorem (highest value)

Turn `InvariantBlock`'s tautology and `SixFour`'s dimension count into a
statement about the **actual** coin: does `SixCoin.axisBlockCoin` carry a
coin-invariant, isometric 4-dimensional Clifford/Dirac block with 2 auxiliary
directions? The honest expected outcome is a **kill**.

```lean
-- Targets/D4CoinDiracBlock.lean  (imports: Mathlib only)
-- U := SixCoin.axisBlockCoin : Matrix (Fin 6) (Fin 6) ℂ
-- DiracSpace := Fin 4 → ℂ, DirectionSpace := Fin 6 → ℂ.

theorem axisBlockCoin_carries_dirac_block :
    ∃ (ι : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 6 → ℂ))
      (H : (Fin 4 → ℂ) →ₗ[ℂ] (Fin 4 → ℂ)) (r : ℝ),
      Function.Injective ι ∧                                   -- 4-dim image, 2 ancilla (exact_rank_gap)
      (∀ v w, inner6 (ι v) (ι w) = inner4 v w) ∧               -- isometry into the coin inner product
      (∀ v, (SixCoin.axisBlockCoin).mulVec (ι v) = ι (H v)) ∧  -- image is U-invariant, U|_im ≃ H
      (∀ v, H (H v) = (r : ℂ) • v) ∧ 0 < r := by              -- H is a genuine Clifford step (H² = r·I)
  s o r r y
```

- **Witness (if it were to hold):** an explicit `6×4` isometry `ι` picking a
  4-dim invariant subspace, `H` its restriction, and a rational `r`, plus a
  nonzero direction outside `im ι` (the 2-dim auxiliary).
- **Kill / falsifier (the expected result):** `axisBlockCoin` acts as three
  *decoupled* `2×2` blocks, so every coin-invariant subspace is a sum of axis
  planes (dimension in `{0,2,4,6}`). On any such block the coin restricts to
  `B = [[3/5, 4i/5],[4i/5, 3/5]]`, and `B² = [[-7/25, 24i/25],[24i/25, -7/25]]`
  is **not** a scalar multiple of `I` (`verified-here`). Hence no invariant
  4-dim block satisfies `H² = r·I`: the theorem is **false**, and `axisBlockCoin`
  is **not** a Clifford/Dirac coin. In that case M6 / `THEORY_COMPLETION`
  "Kinematics" must be restated as "6-direction walk = three decoupled 1+1
  checkerboard walks + a **separate** `4×4` Clifford symbol, not identified",
  `SixFour` stands only as the trivial dimension no-go, and `InvariantBlock`
  stays a repaired-but-tautological block model. This kill is strictly more
  informative than proving the tautology and directly discharges the S06 "no
  isotropic Dirac coin" gate.

Fix `InvariantBlock.dirac_block_intertwiner` first (add `A 0 = 0` or make `A`
linear); it is currently unprovable.
