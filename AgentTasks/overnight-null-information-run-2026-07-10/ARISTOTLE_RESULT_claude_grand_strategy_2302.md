# Overnight strategy advisory — finite null-information run (2026-07-10)

Scope: advisory only. No Lean proof target is opened here; the theorem corpus
referenced below lives in `Null_Edge_Future_Directions.md` (HARVEST RESULTS +
Rounds 3-9), `THEORY_COMPLETION_MATRIX.md`, `MANUSCRIPT_CLAIM_MATRIX.md`, and
`SIMULATION_BENCHMARKS.md`. Every anchor named below is a *landed* module cited
in those records; every `NEW` statement is a proposed job. Grades follow the
run's convention (`M` kernel-checked, `T|H` conditional, `C` pre-registered
conjecture, `[import]`, `[interp]`).

All five answers end with an explicit **fleet routing tag**:
`{manuscript}`, `{proof-fleet}`, `{sim-lab}`.

---

## Q1 — Shortest coherent route to ONE executable primitive-to-observable chain

Target: the `THEORY_COMPLETION_MATRIX.md` **Composition test** chain
```
primitive null data -> gauge-equivalence class -> positive physical state
  -> finite action/evolution -> spectral/closure observable
  -> calibrated units -> known-physics benchmark -> falsifiable extrapolation
```

### The landed anchors already cover every arrow individually

| Arrow | Landed anchor(s) | Grade |
|---|---|---|
| primitive null data | `GateI1.Core`, `i1_5_cauchy_binet_mass_identity`, `SuiteDResourceCore.free_states_characterized` (`det P = 0 ↔ rank ≤ 1`) | M |
| → gauge-equivalence class | `GenericFiniteHodge` (unique harmonic rep in `ker Q ∩ ker Q*`), `DecoderChainHomotopy` (cohomology action invariant under `D ↦ D+QR+RQ`) | M |
| → positive physical state | `PositiveHodgeDecoder` (`e2` non-exact positive harmonic, `D#D e2 = μ² e2`), `PositiveSectorClassification` (`A≻0 ⇒ A+BᴴB≻0`, gap ≥ 1) | M |
| → finite action/evolution | `CayleyHamiltonianGenerator` (J-unitary Cayley flow), `CarrierDynamicsCapstone`, `Goal4FieldEquation.field_equation` | M |
| → spectral/closure observable | `CarrierKreinSquare`, `ExactQuantumWalkDispersion`, `det P` = Plücker area (`GateI1`) | M |
| → calibrated units | `SuiteAOp2Geom` (`dCausal m 0 1 = 1/m`), `ComptonBoundSq` (`widthSq ≥ 1/(4m²)`) | M (ratio) / [import] |
| → known-physics benchmark | `ExactCheckerboardPathSum`, `QuantitativeDiracWalkContinuum` (`E²=p²+m²`) | M finite / [import] continuum |
| → falsifiable extrapolation | `SubluminalBound` (`v_g<1` for `m≠0`, `=1` iff massless) | M |

**The gap is not a missing arrow — it is a missing *joint witness*.** Every arrow
is proved, but on *different* carriers/witnesses. A chain assembled from theorems
about different objects has an unnamed seam (see Q5, Risk 2). The shortest
coherent route therefore needs exactly **two** new *composition* theorems that
re-prove nothing but tie the existing anchors to **one** explicit rational Krein
carrier `𝒞 = (V, J, Q, D)` (take the `PositiveHodgeDecoder` witness augmented
with the `CheckerboardCarrierBridge` kinetic term), splitting the 8-node chain at
the shared "spectral observable" node.

### The exact two new statements

```lean
-- C1: closes arrows 1-4 (primitive → quotient → positive → spectral) on ONE carrier.
theorem NullChainCarrierSpectrum
    (𝒞 : KreinCarrier) (P : MomentumGram) (e2 : 𝒞.V) (μ : ℝ)
    (hprim : P.det = μ^2 ∧ 0 < μ^2)                         -- GateI1 primitive
    (hquot : 𝒞.IsHarmonicRep e2 ∧ ∀ R, 𝒞.cohomAction (𝒞.D + 𝒞.Q*R + R*𝒞.Q) e2
                                        = 𝒞.cohomAction 𝒞.D e2)  -- GenericFiniteHodge + DecoderChainHomotopy
    (hpos  : e2 ∈ 𝒞.positiveSector ∧ 0 < 𝒞.kreinForm e2 e2)      -- PositiveHodgeDecoder + PositiveSectorClassification
    : 𝒞.D # 𝒞.D *ᵥ e2 = (μ^2 : ℝ) • e2 ∧ P.det = μ^2 := ...
-- reading: primitive Plücker area = gauge-quotient-invariant = positive-sector spectral mass, ALL equal on 𝒞.
```

```lean
-- C2: closes arrows 4-8 (spectral → units → benchmark → falsifier) on the SAME 𝒞.
theorem NullChainDiracBenchmark
    (𝒞 : KreinCarrier) (μ : ℝ) (hμ : 0 < μ)
    (hspec : 𝒞.D # 𝒞.D *ᵥ 𝒞.e2 = μ^2 • 𝒞.e2)               -- output of C1
    : 𝒞.IsJUnitary (Cayley 𝒞.D)                              -- CayleyHamiltonianGenerator
      ∧ Cayley 𝒞.D = 𝒞.checkerboardOneTurn                   -- ExactCheckerboardPathSum
      ∧ (∀ k, dispersion 𝒞 k = Real.arccos (Real.cos k * Real.cos (θ μ)))  -- ExactQuantumWalkDispersion
      ∧ continuumShell 𝒞 = (fun p => p^2 + μ^2)              -- QuantitativeDiracWalkContinuum (E²=p²+m²)
      ∧ comptonLength 𝒞 = 1/μ                                -- SuiteAOp2Geom / ComptonBoundSq
      ∧ (∀ k ≠ 0, groupSpeedSq 𝒞 k < 1) ∧ groupSpeedSq 𝒞 0 = 1 := ...  -- SubluminalBound (falsifier)
```

The seam is guaranteed: C1's conclusion `D#D e2 = μ² e2` is literally C2's
hypothesis `hspec`, on the same term `𝒞.e2`, so the two theorems compose into a
single Lean term `NullChainDiracBenchmark 𝒞 μ hμ (NullChainCarrierSpectrum ...).1`.

**Kill conditions.**
- C1 dies if the positive-sector `D#D` eigenvalue on `e2` differs from `det P`
  (quotient/positivity mismatch), or if no nonzero `D`-invariant `J`-positive
  sector contains `e2`.
- C2 dies if `Cayley 𝒞.D` is not `J`-unitary, if the continuum shell ≠ `p²+μ²`,
  or if any massive mode reaches/exceeds the null front (`groupSpeedSq ≥ 1`).

**Routing.** C1, C2 `{proof-fleet}`; the resulting one-term chain and its arrow
table `{manuscript}` (the "derivation spine" figure of RUN_PLAN A4); numerical
regression of C1's `det P = μ²` and C2's dispersion/subluminal on the shared
witness = benchmarks **S03→S05→S07 chained** `{sim-lab}` (one config file, one
seed, exact rational arithmetic → V1).

---

## Q2 — Five highest-value KILLABLE rungs for tonight

Constraints per rung: finite statement, exact witness, negative control,
pre-registered kill condition. **None duplicates the RUN_PLAN §1c running jobs**
(Kraus no-signaling `17674ce6`, two-region microcausality `13b40077`, SSB
degeneracy `af7eb850`, dimensional transmutation `3ea09edf`, four-hole walk tail
`3906ed40`, spin fiber `ccff7fc8`, Krein-chain-equivalence `2687b7bb`,
positive-Hodge Rayleigh `be5c5929`, vacuum-shift `63170980`, spectral-monodromy
`8066248d`, rapidity-distance `f001c5e8`, geometry-register-Λ `e4aad67f`, chain
spectral-distance `7895c97a`).

Ranked by leverage (program order of RUN_PLAN §"research-program order":
rigidity → positive-sector → binding → dictionaries).

### R1 (top) — `SolderedDecompUnique`: carrier rigidity under nondegenerate soldering
Wires the abstract `GradedDecompUniqueness` (`blocks_eq_eigenspaces`,
`decomposition_unique`, `split_not_forced`) onto the concrete carrier
`2(D#D) = Q_A + Q_C + 2E_# + 2Q_T` (`CarrierRigidity`,
`FourChannelRigidityCapstone`). This is the explicitly-flagged open step
("wiring it to the real carrier is separate work (open)") and program step 1.
```lean
theorem SolderedDecompUnique (𝒞 : KreinCarrier)
    (hsold : 𝒞.NondegenerateSoldering)         -- E-slot grade operator has pairwise-distinct eigenvalues
    : ∃! split : ChannelSplit 𝒞, split.reassembles (𝒞.D # 𝒞.D) := ...
```
- Witness: the `FourChannelRigidityCapstone` rational `QA,QC,QT,Es` (already
  linearly independent, unique entry selectors).
- Negative control: `split_not_forced` — WITHOUT soldering the type-count alone
  admits ≥ 2 inequivalent splits.
- **Kill:** two inequivalent four-block splits of the same carrier *under
  nondegenerate soldering*, or a fifth independent block ⇒ Conjecture A false,
  carrier is not a finite universality class.

### R2 — `SingletMassGapCompose`: confinement as the only positive-mass sector
Composes `ConfinementPositivity` (colored ≺ 0, singlet ≻ 0),
`PositiveSectorClassification` (`A≻0 ⇒ A+BᴴB≻0`, gap ≥ 1), and
`Goal1Confinement`/`Goal1Hadron` (spectrum `{-1,8,9}`, gap 9) into one claim on
the real 12-dim `Cl(4)⊗C³` carrier.
```lean
theorem SingletMassGapCompose (H : Hadron12)
    : (∀ B, 0 ≺ H.singletBlock → 0 ≺ H.singletBlock + Bᴴ*B)        -- singlet gap stable under closure
      ∧ (∀ v, H.isColored v → H.kreinForm v v ≤ 0)                 -- no isolated colored positive mass
      ∧ H.leastEig H.singlet = -1 ∧ 1 ≤ H.leastEig H.colored := ...
```
- Witness: singlet `(1,1,1)`, colored `(1,-1,0)`, gap 9, `d=(0,1,7),κ=4` (3-4-5).
- Negative control: a colored "bound state" candidate — provably indefinite.
- **Kill:** a colored sector with stable isolated positive mass and correct
  constraint descent ⇒ Conjecture B / `M8` falsifier fires.

### R3 — `CarrierBindingDeficitTight`: binding = entanglement deficit on the carrier's own K
Composes `CarrierClosurePlane.carrier_closure_binds` (carrier binds
*unconditionally*), `BindingInformationInvariant`, `BindingEntanglementDeficit`.
```lean
theorem CarrierBindingDeficitTight (𝒞 : KreinCarrier) (lam kap : ℚ) (hk : 0 < kap)
    : 𝒞.bindingDefect = -kap
      ∧ kap = concurrence 𝒞 * lam
      ∧ 𝒞.missingMass = entanglementDeficit 𝒞.joint 𝒞.separated := ...
```
- Witness: `(lam,kap) = (2,1)`.
- Negative control: wrong-plane / product state (`kap=0`, defect `0`).
- **Kill:** binding disappears (`defect ≥ 0`) under enlargement/refinement, or
  `missingMass ≠ entanglementDeficit` ⇒ `M8` falsifier.

### R4 — `CPMinimalThreeCompose`: three is minimal-nonzero-phase, not a forced count
Composes `KMPhaseCounting` (`0 < physCP N ↔ 3 ≤ N`), `FiniteKMCP` (N=2 no-go +
N=3 witness `J = 6912/78125`), `KMFlagship` (`physicalPhases N = incidence
corank`), guarded by `FamilyRankNoGo.forcing_iff_rankfixing`.
```lean
theorem CPMinimalThreeCompose
    : (∀ N, 0 < FiniteKM.physicalPhases N ↔ 3 ≤ N)
      ∧ FiniteKM.jarlskog three witness = 6912/78125
      ∧ (∀ ax, ForcesThree ax ↔ (ax ↔ (strandRank = 2))) := ...  -- any "forcer" ⟺ the datum itself
```
- Witness: N=3 3-4-5 unitary, `J = 6912/78125 ≠ 0`.
- Negative control: N=2 rephasing removes all phases (`J = 0`).
- **Kill:** a nonzero-Jarlskog N=2 witness, or a rank-forcing axiom provably
  *independent* of the datum `n=2` ⇒ `M10` falsifier.

### R5 — `HiggsDofGaugeMassCompose`: Goldstone → longitudinal DOF, mass = Gram cost
Composes `GaugeMassGram` (`M² = ⟨g_a T_a φ, g_b T_b φ⟩` PSD; zero diagonal iff
stabilizes reference), `HiggsDofConservation`, `HiggsLongitudinalMode`.
```lean
theorem HiggsDofGaugeMassCompose (φ : Ref) (T : Gen)
    : (M2 φ T).PosSemidef
      ∧ (broken φ T → dofTransferred φ T = 1)
      ∧ (unbroken φ T ↔ (M2 φ T).diag = 0)
      ∧ totalDOF before = totalDOF after := ...
```
- Witness: `diag(0,1)` generator (one unbroken, one broken).
- Negative control: unbroken generator (`M²=0`, no DOF transfer).
- **Kill:** DOF count not conserved, or a broken generator with zero Gram mass ⇒
  `M9` falsifier. (Honest boundary: the *radial* Higgs self-mass stays [import].)

**Bench alternate** (`SuiteD`, if a slot frees): `MassResourceConversion` from
`SuiteDResourceCore` + `EntropyMonotoneReal` — mass non-increasing under free
(rotation) ops, non-decreasing under decoherence, signed-closure exception;
witness `det = 4/25`, control collinear `det = 0`; kill = a free op that creates
mass or decoherence that lowers it absent signed closure.

**Routing.** R1-R5 `{proof-fleet}`; their manuscript rows are `M4/M8/M10/M9`
respectively and R1 upgrades the §"carrier rigidity" frontier `{manuscript}`;
regression fixtures = **S04 (R1), S08 (R3), S10 (R4), S09 (R5)** and a new
singlet-gap fixture for R2 `{sim-lab}`.

---

## Q3 — Measurement / classical-records row (grade O): smallest honest instrument API

**Design rule (event horizon).** The finite QI layer *uses* quantum probability;
it does **not** derive the Born rule (RUN_PLAN §C3; "What stays untouchable").
So the trace/probability rule is an explicit `[import]`, and only *structural*
theorems (normalization, no-disturbance, repeatable-record stability,
decoherence) are proved. An honesty guard `no_free_probability` proves the
probability rule is **not** fixed by the CP/TP algebra alone — forbidding any
"we derived Born" reading.

### Minimal API (states, instruments, outcomes, no-disturbance)
```lean
structure FinState (d : ℕ) where
  ρ : Matrix (Fin d) (Fin d) ℂ
  herm : ρ.IsHermitian
  psd  : ρ.PosSemidef
  norm : ρ.trace = 1                       -- positivity+normalization are IMPORTED, not derived

structure Instrument (d : ℕ) (X : Type) [Fintype X] where
  E : X → (Matrix (Fin d) (Fin d) ℂ → Matrix (Fin d) (Fin d) ℂ)
  cp : ∀ x, IsCPMap (E x)                  -- each branch completely positive (Kraus form)
  tp : IsTracePreserving (fun ρ => ∑ x, E x ρ)   -- the family is trace-preserving

def outcomeProb (I : Instrument d X) (s : FinState d) (x : X) : ℝ :=
  (I.E x s.ρ).trace.re                     -- ⟵ THIS trace rule IS the Born input [import]
def postState  (I) (s) (x) (h : 0 < outcomeProb I s x) : FinState d := ⟨I.E x s.ρ / outcomeProb I s x, …⟩
def nonSelective (I) (s) : FinState d := ⟨∑ x, I.E x s.ρ, …⟩
```

### Theorems (all structural; none derives Born)
```lean
theorem instrument_prob_normalized (I) (s) : ∑ x, outcomeProb I s x = 1          -- from tp + s.norm
theorem instrument_prob_nonneg     (I) (s) (x) : 0 ≤ outcomeProb I s x           -- from cp
theorem no_disturbance_marginal    (I_B : Instrument on factor B) (s : FinState (dA*dB))
    : partialTraceB (nonSelective I_B s) = partialTraceB s                        -- cite Kraus no-signaling 17674ce6 (do NOT re-prove)
theorem record_stability (I : projective) (s) (x) (h)                             -- repeatability
    : outcomeProb I (postState I s x h) x = 1 ∧ postState I (postState I s x h) x = postState I s x
theorem decoherence_pinches (I : pointer-basis projective) (s)
    : (nonSelective I s).ρ = Matrix.diagonal (fun i => s.ρ i i)                    -- coherences destroyed; link EntropyMonotoneReal
```

### The honesty gate (the Born boundary made a theorem)
```lean
-- probability is NOT determined by the instrument algebra: two effect assignments,
-- same CP/TP structure, different numbers on a witness ⇒ the rule must be imported.
theorem no_free_probability :
    ∃ (I : Instrument 2 (Fin 2)) (s : FinState 2) (prob' : … → ℝ),
      SatisfiesCPTPConsistency prob' I ∧ prob' I s 0 ≠ outcomeProb I s 0 := ...
```

- Witness: `d=2`, pointer `{|0⟩,|1⟩}`, `ρ = ½[[1,z],[z̄,1]]`, projectors
  `P₀=|0⟩⟨0|, P₁=|1⟩⟨1|`; `outcomeProb = ½,½`; `postState = |0⟩⟨0|` or `|1⟩⟨1|`;
  `nonSelective ρ = diag(½,½)` (coherence `z` destroyed).
- Negative control: (i) a **non-TP** family ⇒ `∑ outcomeProb ≠ 1` (normalization
  kill); (ii) a **nonprojective** Kraus fixture where `record_stability` FAILS
  (`outcomeProb after ≠ 1`) — separates genuine records from soft measurements.
- **Kill (row-level):** if `no_disturbance_marginal` cannot be stated without
  identifying tensor factors with spacelike regions (that is the separate,
  still-open causal-factorization theorem — keep it CITED, not assumed); or if
  the honesty gate `no_free_probability` is *false* (probability forced by the
  algebra) — which would mean Born actually is derivable and the whole event-
  horizon disclosure must be rewritten.

**Routing.** `instrument_prob_*`, `record_stability`, `decoherence_pinches`,
`no_free_probability` `{proof-fleet}`; `no_disturbance_marginal` cites the running
`17674ce6` `{proof-fleet, cite-only}`; the "Born is imported, not derived"
paragraph + the `no_free_probability` disclosure `{manuscript}` (fixes the
grade-O row to a stated finite interface with an explicit Born boundary, matching
completion-matrix "Measurement and classical records"); the pointer-basis
decoherence + repeatability numerics = **new benchmark S15** (nonprojective Kraus
control) `{sim-lab}`.

---

## Q4 — Dynamics / action row: one displayed action principle + the theorem that makes it a law

### The unifying displayed principle
The three landed results are three faces of the **same** Krein–Dirac square `D`:
- `FourChannelPathActionCapstone` / `HistoryLocalFourChannelAction`: the action
  *decomposes* — `4 D#D = Q_A + Q_C + 4Q_T + 4E_#`;
- `CarrierDynamicsCapstone`: the carrier *evolution equations* from `D`;
- `CayleyHamiltonianGenerator`: the *J-unitary flow* generated by `D`.

Display them as one principle:

> **Krein–Dirac least action.** Physical null histories extremize
> `S[ψ] = Σ_history ⟨ψ, D#D ψ⟩_J` on the chosen `D`-invariant positive sector;
> its Euler–Lagrange equation is the finite field equation `D#D ψ = μ² ψ`
> (= `Goal4FieldEquation.field_equation`), its natural coordinates are the four
> channels `(Q_A,Q_C,Q_T,E_#)`, its history-integral form is the checkerboard
> path sum, and its time evolution is the J-unitary Cayley flow of the same `D`.

### The one theorem that makes it the evolution law (not a model choice)
```lean
theorem ActionGeneratesUnitaryDynamics (𝒞 : KreinCarrier) (hD : 𝒞.D # = 𝒞.D)
    (ψ : ℝ → 𝒞.positiveSector) :
    -- (a) stationarity of S at every t
    (∀ t, IsStationary (fun φ => 𝒞.action φ) (ψ t))
    ↔
    -- (b) ψ is the J-unitary Cayley flow generated by D
    (∀ t, ψ t = Cayley (t • 𝒞.D) (ψ 0))
    -- and either side implies (c) Noether conservation
    ∧ (IsStationary … → (∀ t, 𝒞.kreinForm (ψ t) (ψ t) = 𝒞.kreinForm (ψ 0) (ψ 0)
                          ∧ 𝒞.channelBudget (ψ t) = 𝒞.channelBudget (ψ 0))) := ...
```

Why this upgrades the row from `H/B` to a law: today each capstone could be an
*independent* modeling choice (a scoring functional, a set of ODEs, a unitary
map). The equivalence `(a) ⟺ (b)`, plus the conservation corollary `(c)`, forces
them to be one object: the `D` that decomposes into four channels is the `D`
whose action-stationarity is the field equation is the `D` that generates the
conserved unitary flow. Once proved, "evolve by `U`" is no longer a postulate —
it is *forced by* "extremize `S`," and vice versa.

- Witness: `PositiveHodgeDecoder` `e2`, `D#D e2 = μ² e2`, `U(t)e2` J-unitary,
  `⟨e2,Je2⟩` conserved.
- Negative control: a non-Krein-self-adjoint `D'` (`D'# ≠ D'`) where Cayley is
  **not** J-unitary and the budget drifts — pins the load-bearing hypothesis
  `D# = D`.
- **Kill:** a Krein-compatible variation making `S` stationary whose solution is
  NOT the Cayley flow (`(a) ⇏ (b)`) ⇒ the action underdetermines dynamics, the
  row stays H/B; or Cayley flow that fails to conserve the four-channel budget
  ⇒ the "one operator" story breaks.

**Routing.** `ActionGeneratesUnitaryDynamics` `{proof-fleet}` (Dynamics/action
row flagship, THEORY_COMPLETION_MATRIX); the displayed principle + "three faces
of one operator" paragraph `{manuscript}` (§A1 thesis clause 5, §7 dynamics);
norm-and-budget-conservation regression along the Cayley flow = benchmark
**S05 extension** (add a conservation column) `{sim-lab}`.

---

## Q5 — Two biggest OVER-CLAIM risks + audit checks

### Risk 1 — Docstring-outruns-kernel / false-shape at the CHANNEL-NAMES seam
The "one operator, both forces" spine rests on the [C] dictionary
aperture/closure/turn/**gravity**. The kernel proves the *algebra* (`CarrierRigidity`:
`2 D#D = Q_A+Q_C+2E_#+2Q_T`, no fifth block; `Goal3ChannelRG4`: four independent
RG coordinates). It does **not** prove `Q_C` *is* gauge curvature or `E` *is*
gravity — those are labels. Prior near-miss already caught: `BargmannCP`
docstring said "phase = celestial solid angle" while only the tangent identity is
kernel-proved (tightened); the `tr(D²)=Einstein–Hilbert` step is flagged as
"definitional bookkeeping, not the Chamseddine–Connes heat-kernel theorem." The
risk is systemic across P-E/P-G/P-L and the gravity/E-slot rows.

Audit checks:
1. **Name-vs-type audit.** For every physics identification (gauge, gravity,
   Higgs, generation, Λ), grep the Lean statement; confirm the physics object
   appears *in the type*, not only the docstring. If only in prose → downgrade to
   [C], annotate "label, not derived." (RUN_PLAN §12a definition audit + §12b
   text-vs-prose.)
2. **Block-distinctness audit.** Confirm the claimed distinctions are theorems,
   not conventions — e.g. `E_# ≠ E` (soldering-gradient vs Krein cross term):
   require an explicit lemma `E_sharp ≠ E_slot` with a rational witness.
3. **Import-tagging audit.** Every heat-kernel / known-Hamiltonian / continuum
   step carries an explicit `[import]` tag; **no consequence of an imported law
   counts as a prediction** (completion-matrix rule; RUN_PLAN B4). Grep the
   manuscript for prediction language adjacent to an `[import]` anchor.

### Risk 2 — Vacuity / hollow-telescoping at capstones + the "one-witness" illusion
Capstones (`FourChannelPathActionCapstone`, `KMFlagship`, `CarrierDynamicsCapstone`,
`MassResourceConsistency`) are conjunction "navigation interfaces" — risk of a
grand-theorem reading of an AND of definitions (mode 2). More dangerous: the
composition-test chain risks being assembled from theorems on *different*
witnesses, so no single object satisfies all arrows — the chain looks end-to-end
but the joint hypothesis is never witnessed (mode 1 vacuity). Compounding: several
"landed" modules were HELD then "RESOLVED after restart"
(`PathSumSemantics`, `ComptonBoundSq`, `EntropyMonotoneReal`, `Goal3BoostCovRational`);
their green status must be re-confirmed under Lean 4.28.0, and `Goal3BoostCov`
(transcendental) is explicitly NOT landed.

Audit checks:
1. **Payload-citation rule.** Manuscript prose cites the payload lemma, not the
   capstone conjunction (RUN_PLAN §A2). For each capstone, enumerate conjuncts
   and confirm each is independently non-trivial (not `True`, not a `rfl`
   unfolding). Flag definitional conjuncts.
2. **Joint-witness audit (the key new check).** Require the composition chain to
   be one Lean term on ONE carrier, feeding each arrow's output as the next
   arrow's input hypothesis on the *same term* (exactly what Q1's C1→C2 seam
   enforces). If it cannot be written as a single term with shared variables, it
   has an unnamed seam ⇒ not end-to-end; do not display it as such.
3. **Build + footprint reconfirmation.** Targeted `lake build` per cited anchor
   under Lean 4.28.0, and `#print axioms` = `[propext, Classical.choice,
   Quot.sound]` (no `sorry`, no `native_decide` in trusted promotion, no new
   axioms; RUN_PLAN §7c/§12a). Re-run for the four HELD/RESOLVED modules and drop
   any that regress.
4. **Load-bearing hypothesis check.** For each capstone/composition theorem, drop
   each explicit hypothesis and confirm elaboration fails; a droppable hypothesis
   signals the theorem is weaker (or more vacuous) than the prose claims.

**Routing.** All audit checks `{proof-fleet + manuscript}` (they are the RUN_PLAN
§12 dawn-audit tasks); the joint-witness audit specifically gates the Q1 chain
before it enters the manuscript spine.

---

## Consolidated prioritized work plan

| # | Item | Statement(s) | Kill condition (one-line) | Fleet |
|---|---|---|---|---|
| 1 | Chain seam A | `NullChainCarrierSpectrum` (Q1 C1) | positive-sector eigenvalue ≠ `det P` on shared carrier | proof-fleet |
| 2 | Chain seam B | `NullChainDiracBenchmark` (Q1 C2) | Cayley not J-unitary / shell ≠ p²+m² / massive mode ≥ c | proof-fleet |
| 3 | Rigidity | `SolderedDecompUnique` (R1) | 2 splits under soldering, or 5th block | proof-fleet |
| 4 | Confinement | `SingletMassGapCompose` (R2) | colored isolated positive mass | proof-fleet |
| 5 | Dynamics law | `ActionGeneratesUnitaryDynamics` (Q4) | stationary solution ≠ Cayley flow | proof-fleet |
| 6 | Binding | `CarrierBindingDeficitTight` (R3) | defect ≥ 0 under refinement | proof-fleet |
| 7 | CP minimality | `CPMinimalThreeCompose` (R4) | N=2 nonzero Jarlskog / forcer ≠ datum | proof-fleet |
| 8 | Higgs DOF | `HiggsDofGaugeMassCompose` (R5) | DOF not conserved | proof-fleet |
| 9 | Measurement | Q3 instrument API + `no_free_probability` | Born forced by algebra (gate false) | proof-fleet |
| 10 | Chain spine + arrow table | assembled C1∘C2, graded | joint-witness audit fails | manuscript |
| 11 | Displayed action principle | Krein–Dirac least action + Q4 thm | (as #5) | manuscript |
| 12 | Born-boundary paragraph | disclosure keyed to `no_free_probability` | — | manuscript |
| 13 | Over-claim audits | Q5 checks 1-4 (both risks) | anchors that regress are dropped | manuscript + proof-fleet |
| 14 | Chain regression | S03→S05→S07 chained on one witness | numeric ≠ exact rational fixture | sim-lab |
| 15 | Rung fixtures | S04(R1),S08(R3),S10(R4),S09(R5),singlet-gap(R2) | control fires / tolerance breach | sim-lab |
| 16 | New S15 | pointer-basis decoherence + nonprojective repeatability control | record not stable where claimed | sim-lab |
| 17 | Conservation regression | S05 + norm/four-channel-budget column | budget drifts along Cayley flow | sim-lab |

**Sequencing tonight:** land #1-#2 first (they make the completion-matrix
Composition-test row executable, the single highest-leverage deliverable), then
#3 and #5 (rigidity + dynamics law — the two structural spines), then #4/#6/#7/#8
in parallel (independent dictionary rungs, easy→hard), then #9 (measurement row,
grade O → stated interface). Manuscript items #10-#13 follow each proof as it
lands; sim-lab items #14-#17 shadow the corresponding proofs for V1 regression.
Hold all broad new jobs from 06:30; switch to #13 audits at the 07:00 cutoff.
