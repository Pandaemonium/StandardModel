# Live-repository reconciliation

> **Controlling post-harvest update (06:16 PDT).** The report body correctly
> validates the three explicit axis bases and the proposed compact-rate
> constant, but some status sentences still describe the submitted staging
> snapshot. In the live tree `CliffordDiagonalPositionBridge` is already
> placeholder-free and guarded. After this report identified the last literal
> parameter seam, `PluckerDiracCarrierBridge` also landed: one supplied pair's
> `massSq` is now the Gibbs gap, the mass argument in the exact `3+1` Clifford
> square, and the mass argument in the split-step tangent, with `4/25` massive
> and collinear-zero controls. The consolidated guard passes **8,092 jobs**.
> The compact-box product-rate proof remains the active Aristotle job. These
> live facts override every stale "in flight" or 8,090-job sentence below.
> S24 now regresses the new bridge, so the live laboratory count is **19
> families: 16 V0/V1 and three V2**; the report's 18-family audit remains the
> correct audit of its earlier snapshot.

Audit 13 is an adversarial re-audit after the joint witness landed and the two
spatial/rate bridges went into flight. Live facts (controlling over the static
snapshot) used throughout:

- `PluckerJointTheoryWitness` has **landed placeholder-free**; its
  `one_pair_joint_chain` composition and the two nondegeneracy controls are no
  longer `s o r r y` stubs. In *this* focused package the staging copy
  `Targets/PluckerJointTheoryWitness.lean` still shows three `s o r r y` stubs and
  imports absent `PhysicsSM.*` modules; per standing instruction that is
  **[packaging]/[staging]**, not a live regression. Payload declarations, not the
  target-stub file, are the source of truth.
- The **consolidated overnight axiom guard passes at 8090 jobs** (up from 8030 at
  the four-P0 landing and 8032 at the harvest batch). No new axioms; the trusted
  set remains `{propext, Classical.choice, Quot.sound}`.
- **S23** is a **new exact shared-pair V1 regression** confronting the joint
  witness (rational `4/25`, `step(4/25)(0,1)=(1,46/25)`, `Var(0)=4/625`).
- The lab is now **18 families**: **15 V0/V1** and **three V2** — **S18, S21,
  S22**. S20 is **V0/V1** (algebraic self-consistency; its normalized gap
  cancels), exactly as Audit 12 required.
- The two in-flight targets remain staged with `s o r r y`:
  `CliffordDiagonalPositionBridge/Core.lean` (9 obligations) and
  `Compact3Plus1DiracRate/Core.lean` (15 obligations). Their **statements** are
  audited here for mathematical truth; their proofs are not yet landed.

Snapshot-vs-live count note: the prompt body says "17 families" and "confirm
S20 is V0/V1 and S18/S21/S22 are the only V2." That is the pre-S23 count. With
S23 landed the correct live count is **18 families**; the V2 set is unchanged
(S18/S21/S22), and S20 remains V0/V1. Both statements are consistent — S23 added
one V0/V1 row and no V2 row.

Verdict tags: **[true]** recomputed correct · **[narrow]** correct but weaker
than the caption · **[hollow]** true but does not carry the implied physics ·
**[generic]** holds for a whole class, so the specific witness adds no
discriminating content · **[tautology]** compares a closed form to itself ·
**[open]** claimed-next, not landed · **[packaging]/[staging]** import/stub gap
only · **[error]** a genuine status/arithmetic mistake in a supplied report.

Independent numeric checks were run in exact rational and `binary64` arithmetic
and are harness checks, not Lean proofs.

---

## 1. Source-and-axiom audit of every landing since Audit 12

All five landings named in the brief are reconciled against their payload
declarations. Footprint on every row: `s o r r y`-free source, axioms pinned to
`{propext, Classical.choice, Quot.sound}`, consolidated guard now 8090 jobs;
`PhysicsSM.*` absence in focused packages is [packaging].

| Landing | Payload anchor | Content | Verdict |
|---|---|---|---|
| Full-window flow stability | `DiscretePluckerFlowStability` (`deaaa176`) | conserved positive-definite first integral with coefficient `min(mu,4-mu)/2 > 0` for every `0<mu<4`; all-iterate bound on the **full** elliptic window (replaces the conservative `mu≤2`) | **[true]** — genuine strengthening; the coefficient is strictly positive across the open window and vanishes at the endpoints, which is the correct boundary |
| Corrected flow rotation | `DiscretePluckerFlowRotation` (`e4dfa6d2`) | conjugacy of `step mu` to a unit-circle rotation with `2-mu=2c`, `c²+s²=1`, `s≠0`; Aristotle **rejected** the original false statement (trace match without circle normalization) and the load-bearing normalization hypothesis is now displayed | **[true]** — recomputed `2-4/25=46/25=2·23/25` ⇒ `c=23/25`, `s²=96/625`, `s=4√6/25≠0`; the injectivity/`/s` step is the only nontrivial obligation; caption must stay "elliptic window `0<mu<4`" |
| Gibbs rigidity | `FiniteGibbsVariance` rigidity block (`07f73e42`) | `0<p_i` (strict positivity), `Var=0 ↔ constant spectrum`, `0<Var ↔ nonconstant spectrum` | **[true]** — the `→` direction is genuinely load-bearing on `probability_positive`; upgrades the earlier inequality `Var≥0` to a rigidity dichotomy |
| Finite position Route B | `SuccessiveAxisPositionWalk` / finite position register (`624c8719`) | channel-dependent one-site translations compose with pointwise unitaries into a norm-preserving finite position walk | **[true] as isometry, [hollow] as Dirac** — this is the same defect Audit 12 flagged; norm preservation holds for **any** velocity table and **any** unitary coins. The Dirac content is precisely what `CliffordDiagonalPositionBridge` (in flight, §2) must supply |
| Finite instrument API | `FiniteInstrumentAPI` (Claude, `b5e0773e`) | Kraus-complete finite instrument: normalization, positivity, projective repeatability, compatible no-disturbance; qubit witness + noncommuting disturbance control | **[true]**; caption obligation stands — the Born outcome rule is **imported** (postulate P4, grade I), record/decoherence model still B; do not read instrument-consistency as a derivation of Born weights |

No source-level over-claim on the five landings. The only standing semantic
defect is the **[hollow]** Route-B position walk, which the two in-flight bridges
target.

---

## 2. Line-by-line audit of the three axis bases and `U D Uᴴ = alpha_j`

Object: `CliffordDiagonalPositionBridge/Core.lean`. The decisive claim is
`axisBasis_conjugates_velocity`: `axisBasis j · velocityDiag j · (axisBasis j)ᴴ =
generator j` for the project's `alpha1, alpha2, alpha3`. I recomputed all three
axes **exactly** (rational + `i` bookkeeping) and confirmed independently in
`binary64` (`s = √2/2`); every axis passes unitarity **and** the conjugation
identity.

**Sign table → diagonal (`velocitySign j a = -1` if `tetraVelocity`, else `+1`):**

- axis 0: `TTFF` ⇒ `velocityDiag 0 = diag(-1,-1,+1,+1)`
- axis 1: `TFTF` ⇒ `velocityDiag 1 = diag(-1,+1,-1,+1)`
- axis 2: `TFFT` ⇒ `velocityDiag 2 = diag(-1,+1,+1,-1)`

Each row has exactly two `-1`/two `+1`, i.e. the trace-zero, signature-`(2,2)`
signature of a Clifford involution — a **necessary** condition for the
diagonalization to exist. The **columns of `axisBasis j` are the eigenvectors,
in the order matching those diagonal signs.**

**Axis 0 (`alpha1`, anti-diagonal, couples `0↔3`, `1↔2`, both `+`).** Columns of
`axisBasis 0` are, up to `1/√2`:
`c0=e0−e3` (λ=−1), `c1=e1−e2` (λ=−1), `c2=e0+e3` (λ=+1), `c3=e1+e2` (λ=+1).
These are exactly the `±1` eigenvectors of `alpha1`; the `(−,−,+,+)` order
matches `velocityDiag 0`. **[true].**

**Axis 1 (`alpha2`, imaginary, couples `0↔3` with `∓i`, `1↔2` with `±i`).**
Columns on block `{0,3}`: `c0∝(1,−i)` (λ=−1), `c1∝(1,i)` (λ=+1); on block
`{1,2}`: `c2∝(1,i)` (λ=−1), `c3∝(1,−i)` (λ=+1). Each is proportional (phase `±i`)
to the true `alpha2` eigenvector for the assigned sign; `U D Uᴴ` is
phase-invariant, so the identity holds. Order `(−,+,−,+)` matches
`velocityDiag 1`. **[true].**

**Axis 2 (`alpha3`, real, couples `0↔2` with `+`, `1↔3` with `−`).** Columns on
`{0,2}`: `c0∝(1,−1)` (λ=−1), `c1∝(1,1)` (λ=+1); on `{1,3}`: `c2∝(1,−1)` (λ=+1),
`c3∝(1,1)` (λ=−1). Matches the `alpha3` eigenvectors with order `(−,+,+,−)` =
`velocityDiag 2`. **[true].**

Independent `binary64` recomputation for all three axes:
`(axisBasis j)ᴴ·axisBasis j = axisBasis j·(axisBasis j)ᴴ = I` and
`axisBasis j · velocityDiag j · (axisBasis j)ᴴ = generator j` to `< 1e-12`. **All
three pass.**

**Load-bearing basis change is genuine.** `identity_basis_fails_axis_zero`
(`velocityDiag 0 ≠ alpha1`) is [true] and non-vacuous: `velocityDiag 0` is
diagonal while `alpha1` is anti-diagonal, so no Bool sign table can equal a
generator in the identity basis. This is exactly the arrow the hollow
`SuccessiveAxisPositionWalk` lacked. `axisSymbol_entry_hasDerivAt`
(`d/dε axisSymbol|_0 = (−i)·generator j`) is the correct per-axis tangent: with
`phaseDiag j ε = diag(cos ε − i·sgn·sin ε)`, `d/dε|_0 = diag(−i·sgn) =
−i·velocityDiag j`, and conjugation by `axisBasis j` gives `−i·generator j`. The
supplied `s_sq` (`s·s = 1/2`) is the only scalar fact the unitarity proofs need.

**Verdict.** The explicit bases and their sign ordering are **exactly correct**;
`axisBasis_conjugates_velocity` is provable as stated and is the genuine
sign-table↔Clifford dictionary Audit 12 called the single highest-value proof. The
one caption obligation: `cliffordAxisShift`/`spatialStep` still prove **isometry**
(`spatialStep_preserves_norm`), and the **tangent-`−iH`** reading comes from
`axisSymbol_entry_hasDerivAt`, which is per-axis symbol content, not yet a
position-space `exp(−iHt)` limit. Caption "finite spatial Dirac step with exact
per-axis `−iα_j` tangent; position-space/continuum limit open."

---

## 3. Truth audit of the proposed `D4 = 16 B² exp B` local Trotter constant

Object: `Compact3Plus1DiracRate/Core.lean`,
`one_step_to_exact_flow_bound`:
`‖splitStep(k,m,ε) − exactFlow(k,m,ε)‖ ≤ D4·ε²` for `|ε|≤1`, with
`B = |kx|+|ky|+|kz|+|m|`, `D4 = 16 B² e^B`.

**Structure recomputed.** Each `factor(q,g) = cos q · I − i sin q · g`. For `g`
Hermitian with `g²=1`, this is **exactly** `exp(−i q g)`. Hence
`splitStep = e^{−iεkxα₁} e^{−iεkyα₂} e^{−iεkzα₃} e^{−iεmβ}` and
`exactFlow(ε) = e^{−iεH}`, `H = kxα₁+kyα₂+kzα₃+mβ`. Setting `A_j = −iε·c_j g_j`
(`c_j ∈ {kx,ky,kz,m}`, `‖g_j‖=1`), we have `‖A_j‖ = |ε||c_j|` and
`a := Σ‖A_j‖ = |ε|B ≤ B`.

**Plausible: yes.** The standard first-order product estimate
`‖∏ e^{A_j} − e^{ΣA_j}‖ ≤ (Σ_{i<j}‖A_i‖‖A_j‖)·e^{Σ‖A_k‖}` gives, with
`Σ_{i<j}‖A_i‖‖A_j‖ ≤ ½(Σ‖A_j‖)² = ½ε²B²` and `e^{|ε|B} ≤ e^B`,
`‖splitStep − exactFlow‖ ≤ ½ B² e^B · ε²`.
So `D4 = 16 B² e^B` is a **valid over-estimate** — the deliberately generous
constant is provable, and the docstring's "deliberately generous" is honest.

**Sharpenable by exactly 32×.** The sharp simple constant is `½ B² e^B`;
`D4 / (½B²e^B) = 32`. Recommend either landing `D4` as-is (headroom absorbs any
proof slack) or tightening to `½ B² e^B`. Empirical leading coefficient at the
`(1,2,2,3)` witness (`B=8`): `‖·‖/ε² → 11.36` as `ε→0`; both `D4·ε²` and
`½B²e^B·ε²` bound the true error with large margin (at `ε=0.01`: true error
`1.14e−3`, `½B²e^B·ε² = 9.54`, `D4·ε² = 305`).

**No counterexample; rate is genuinely `O(1/n)`, not `O(1/n²)`.** The generators
**anticommute** (`{α_i,α_j}=0`, `{α_i,β}=0`), so `[α₁,α₂]=2α₁α₂≠0`
(recomputed `(α₁α₂)_{00}=I≠−I=(α₂α₁)_{00}`). The leading Trotter error is
therefore genuinely nonzero: `n·error → const > 0`. Any promotion of the
**unsymmetrized** `x,y,z,mass` product to second order is false; the guard
`spatial_generators_noncommute` (`α₁α₂ ≠ α₂α₁`) is the exact control forbidding
it. A Strang/palindromic symmetrization would be a **separate** `O(1/n²)` rung
and must not be claimed for this product.

**No silent switches — all four preserved.**
1. **Factor order.** `splitStep = α₁·α₂·α₃·β` (x,y,z,mass), identical to S21's
   ordered `(Ux Uy Uz Um)`. No reordering.
2. **Norm.** L2 operator norm (`Matrix.Norms.L2Operator`), matching S18/S21's
   Frobenius up to the fixed `dim=4` constant. No norm swap.
3. **Compact quantifier.** `one_step_to_exact_flow_bound` is pointwise in
   `(k,m)`; `fixed_time_many_step_bound` is pointwise; the **uniform** upgrade
   `fixed_time_many_step_bound_on_box` quantifies over `|k_·|≤K`, `|m|≤M` via
   `Dbox K M = 16(3K+M)² e^{3K+M}`, and `D4_le_Dbox` is correct because
   `B = |kx|+|ky|+|kz|+|m| ≤ 3K+M` (checked: at `(1,2,2,3)`, `B=8 ≤ 3·2+3=9`,
   `D4=3.05e6 ≤ Dbox(2,3)=1.05e7`). No quantifier inflation.
4. **Rate.** `O(1/n)` at fixed `T` via `unitary_pow_telescope`
   (`‖Uⁿ−Vⁿ‖ ≤ n‖U−V‖`, both unitary) and `exactFlow_div_pow`
   (`exactFlow(t/n)ⁿ = exactFlow(t)`), giving `n·D4·(t/n)² = D4·t²/n`. Correct;
   no rate switch. `box_error_envelope_tendsto_zero` closes the limit.

**Nondegeneracy.** `benchmark_1223_nondegenerate` (`H(1,2,2,3)² = 18·I`, `H≠0`,
`Dbox(2,3)>0`) is a genuine nonzero witness (`ω²=1+4+4+9=18`). The phase-reversal
control (`+i m ε` mass factor → wrong Hamiltonian `H'` with `−mβ`) is the S21/S18
falsifier and should travel with the bound.

**Verdict:** `D4 = 16 B² e^B` is **plausible and provable** (a factor-32 loose
first-order product constant); the box majorant `Dbox = 16(3K+M)² e^{3K+M}`,
the `O(1/n)` telescope, and the noncommutation control are all correct. Land as
stated (or sharpen to `½B²e^B`); it is the correct `3+1` lift of S18.

---

## 4. Hollow-composition audit of `one_pair_joint_chain`

Payload: for `(psi phi : CSpinor)`, `(chi q : Quartet)`, `(x : State)`,
`(beta : ℝ)`, the conjunction of five clauses, all in one Lean term with the
shared pair `(psi,phi)`:

1. `quartetB (qe2+quartetQ chi) (spinorSelectedDecoder psi phi …) = massSq psi phi`
   — decoder/Hodge class cost equals the Plücker mass;
2. `action(q+qe2)+action(q−qe2)−2·action(q) = massSq psi phi` — action Hessian
   (second difference) equals the same mass;
3. `firstIntegral (massSq psi phi) (step (massSq psi phi) x) =
   firstIntegral (massSq psi phi) x` — the variational flow with stiffness
   `mu = massSq psi phi` conserves its first integral;
4. `HasDerivAt (log ∘ partition (pluckerTwoLevel psi phi)) (−meanEnergy …) beta`;
5. `HasDerivAt (meanEnergy (pluckerTwoLevel psi phi)) (−variance …) beta`.

**What it genuinely connects (real shared-term seam).** The single scalar
`massSq psi phi` is the **literal** argument of clauses 1, 2, 3 and — crucially —
is the **only energy scale** of the ensemble in 4, 5, because
`pluckerTwoLevel psi phi = ![0, massSq psi phi]` (verified in
`FiniteGibbsResponse.lean:73`). So the ensemble gap **is** `massSq psi phi`. This
is exactly the joint-witness single-carrier condition: five interfaces (decoder,
action curvature, flow stiffness, partition, mean energy) are pinned to one
scalar built from one supplied pair, with **no interface free to introduce an
unrelated mass**. This passes the joint-witness audit (one term, shared
variables) and is **more than a bare conjunction** for the mass scalar. **[true].**

**What carries value vs. what is generic.**
- Clauses **1 and 2 are value-carrying identities**: "decoder cost `= massSq`"
  and "action second difference `= massSq`" are nontrivial equalities that would
  fail for a mismatched decoder/action. These are the substantive seams.
- Clause **3 is [generic]**: `firstIntegral(mu)` is an **exact algebraic
  invariant of `step mu` for every real `mu`** (recomputed: with `t=2−mu`,
  `x₂²+(tx₂−x₁)²−t x₂(tx₂−x₁) = x₁²+x₂²−t x₁x₂`). Conservation holds for all
  stiffness; using `mu = massSq psi phi` shares the term but tests no property of
  its value. (It is not even confined to the elliptic window — conservation is
  window-independent; only *boundedness of iterates* needs `0<mu<4`.)
- Clauses **4 and 5 are [generic]**: `d log Z/dβ = −⟨E⟩` and `d⟨E⟩/dβ = −Var`
  hold for **every** finite spectrum. They share the pair through
  `pluckerTwoLevel psi phi`, but the identities do not depend on the gap equalling
  `massSq`; they attach the universal fluctuation-response law to the pair's
  ensemble.

So the honest reading: `one_pair_joint_chain` **genuinely forces one mass scalar
across five interfaces** (the anti-fragmentation content is real), of which
clauses 1–2 are discriminating equalities and clauses 3–5 are generic laws
evaluated on the shared scalar. It is a legitimate composition witness, **not** a
conjunction of unrelated facts — but three of five conjuncts add breadth
(same scalar everywhere), not depth (value-specific consequences).

**What it does NOT connect.** Nothing in the theorem references `alpha_i`, `beta`
(the Dirac mass matrix), `H`, the Clifford symbol, `splitStep`, `exactFlow`, the
position walk, or `exp(−iHt)`. The witness spans the **mass / action / flow /
ensemble ("static + thermodynamic") cluster only**; it says nothing about
**kinematics or Dirac propagation**. The `massSq psi phi` scalar is never shown
to be the `m` entering `H`/`exactFlow`. The name "JointTheoryWitness" therefore
overstates: caption it "**joint mass/action/flow/ensemble witness on one pair**;
kinematic/propagation cluster not connected." It also derives none of the
decorations, decoder, action, or ensemble form — all supplied (the docstring is
honest on this).

**Controls.** `rational_joint_chain_control` gives the positive witness
(`massSq edge0 (edge1 2/5)=4/25`, decoder `=4/25`, action curvature `=4/25`,
`step(4/25)(0,1)=(1,46/25)`, `Var(0)=4/625`); `collinear_joint_zero_control`
gives the genuine collapse (`massSq=0`, action curvature `0`, `Var=0`). ND gate
**passes** — the zero control is a real degeneration, not vacuous.

---

## 5. V0–V4 evidence audit of all 18 simulator families

Live lab = 18 landed families (S01–S23 minus the 5 still-queued S04/S09/S10/S11/
S14). Tier ladder: V0 exact fixture, V1 numerical regression against a landed
Lean theorem, V2 reproduction of imported accepted physics with disclosed
dictionary, V3 calibrated fit, V4 pre-registered prediction. No V2/V3 is a
prediction.

**The three V2 rows (only these):**
- **S18** — fixed-momentum free `1+1` Dirac propagator, `(split·coin)ⁿ` vs.
  imported analytic propagator, `k=3/5,m=4/5,t=1`, final error `<0.003`, explicit
  `D t²/n` bound. **[true] V2**, disclosed imported target; not a prediction, no
  PDE/infinite-volume claim.
- **S21** — fixed-momentum free `3+1` four-component split-step, ordered
  `(Ux Uy Uz Um)ⁿ` vs. imported analytic Clifford exponential, `k=(1,2,2),m=3,
  t=1/4`, final `<0.002`, empirical `n·error` stabilizes. **[true] V2**, empirical
  rate only (the uniform theorem is the in-flight `Compact3Plus1DiracRate`, §3).
- **S22** — independent three-level fluctuation-response, spectrum `(0,4/25,
  9/25)`, central finite-difference of `⟨E⟩` vs. `−Var`, Richardson error
  `<1e−10`, `O(h²)` scaling. **[true] V2** — this is the non-tautological
  response test Audit 12 §9 demanded; it **exercises** `meanEnergy_hasDerivAt`
  rather than plugging a closed form into itself.

**S20 is V0/V1 (not V2), confirmed.** `C_sim = β²Var` with `β=x/gap`,
`Var=gap²p(1−p)` ⇒ the gap cancels identically and `C_sim(x) ≡ x²e^x/(1+e^x)² ≡
C_ana(x)` for every gap (grid error `~2.78e−16`, rounding only). Correctly
re-tiered to algebraic self-consistency + the `Var(0)=4/625` fixture; the peak is
a property of the universal function, not a physics recovery. **[tautology] as a
V2, [true] as V0/V1** — the re-tier is the honest resolution.

**S23 (new) is V1, confirmed.** Exact shared-pair regression of the joint
witness: rational fixtures `massSq=4/25`, `step(4/25)(0,1)=(1,46/25)`,
`Var(0)=4/625`, all regressed against the landed `one_pair_joint_chain`
controls. This is a **numerical regression against a landed Lean theorem** = V1,
**not** an external physics reproduction — correctly *not* counted among the V2
rows. **[true] V1.**

**Remaining 14 V0/V1 rows** (with S20 and S23, 15 V0/V1 total): S01, S02, S03,
S05, S06, S07, S08, S12, S13, S15, S16, S17, S19, plus S20, S23. Spot audit of
the tiering-sensitive ones:
- **S05/S06** carry V2-labelled sub-targets but the *landed* content is V0/V1
  (exact path sums, unitarity, no-gos, isometric position walk); the Dirac
  continuum/`−iH` identification is the open arrow (§2), so they must not be
  captioned as V2 reproductions.
- **S16 vs S19**: keep distinct — S16 is the supplied oscillator group, S19 the
  action-derived variational flow/rotation; do not merge.
- **S17** anchors the ensemble response/rigidity; its `4/25→4/625` numbers are a
  real Plücker invariant, not a free constant.

**Tier-count verdict:** 18 families = **15 V0/V1 + 3 V2 (S18, S21, S22)**; **no
V3/V4**; the empirical-prediction row remains **O**. Consistent with the live
facts.

---

## 6. Four over-claim checks + nondegeneracy gate on every new flagship

C1 fidelity (Lean = caption) · C2 non-vacuity · C3 hypothesis exposure · C4
footprint (`s o r r y`-free; axioms ⊆ `{propext, Classical.choice, Quot.sound}`;
guards) · ND (positive witness **and** a genuinely failing control).

| Flagship | C1 | C2 | C3 | C4 | ND |
|---|---|---|---|---|---|
| `one_pair_joint_chain` (landed) | **needs caption** — five interfaces share one mass scalar (true), but 3/5 conjuncts are generic and it does **not** touch kinematics; caption "mass/action/flow/ensemble witness," not "theory witness" | pass — `rational_joint_chain_control` (all `=4/25`, `Var=4/625`) | pass — decorations/decoder/action/ensemble supplied, disclosed in docstring | pass (live) — guard at 8090 jobs, pinned axioms; staging stub is [packaging] | **pass** — collinear zero control genuinely collapses mass/action/variance |
| `axisBasis_conjugates_velocity` (in flight) | pass — `U D Uᴴ = α_j` recomputed exactly for all three axes; sign order correct | pass — `identity_basis_fails_axis_zero` shows the basis change is load-bearing | pass — bases/signs explicit; isometry vs `−iH` distinguished | **`s o r r y` stub** — statement true, proof not landed | pending — needs the landing; controls present |
| `axisSymbol_entry_hasDerivAt` (in flight) | pass — tangent `(−i)·generator j` matches per-axis `d/dε` | pass — nonzero off-diagonal generators | pass — per-axis symbol, not position-space limit | **`s o r r y` stub** | pending |
| `one_step_to_exact_flow_bound` / `…_on_box` (in flight) | pass — bound provable; factor order/norm/quantifier/rate all preserved (§3) | pass — `benchmark_1223_nondegenerate` (`H²=18I`, `H≠0`) | pass — `|ε|≤1`, `B≤3K+M` displayed; "unsymmetrized ⇒ only `O(1/n)`" disclosed | **`s o r r y` stub** | pass — noncommute control + phase-reversal falsifier |
| S22 (V2, harness) | pass — confronts `meanEnergy_hasDerivAt` by independent finite difference | pass — 3-level `(0,4/25,9/25)`, gap does not cancel | pass — imported nothing but the derivative theorem; disclosed | numeric harness; anchor legit and **exercised** | **pass** — degenerate ⇒ both 0; reversed-sign fails |
| S23 (V1, harness) | pass — exact regression of landed joint-witness controls | pass — rational `4/25`,`46/25`,`4/625` | pass — V1 (regression vs theorem), not V2 | numeric harness; anchor landed | **pass** — collinear/degenerate zero control |

**Substantive items:** (i) `one_pair_joint_chain` passes the footprint/ND gates
but needs a **caption fix** (breadth ≠ end-to-end theory; no kinematic arrow).
(ii) The two in-flight bridges are **true statements with sound witnesses** but
are still `s o r r y` stubs — they fail C4 only because unlanded, not because of
any semantic defect. Landing them is the priority (§8).

---

## 7. Exact corrections to the run matrices and manuscript

### SIMULATION_BENCHMARKS.md
1. **Add the S23 row** as V1: "exact shared-pair joint-witness regression
   (`massSq=4/25`, `step(4/25)(0,1)=(1,46/25)`, `Var(0)=4/625`) against
   `one_pair_joint_chain`; anchor `PluckerJointTheoryWitness`; negative control =
   collinear pair collapses all three." Update the header count to **18 families,
   15 V0/V1 + 3 V2**.
2. **S20 row** — keep the Audit-12 correction: pass metric is an algebraic
   identity (`x²p(1−p) ≡ x²e^x/(1+e^x)²`, gap cancels); tier **V0/V1**, not V2.
3. **S22 row** — confirm as the genuine V2 fluctuation-response confrontation;
   note it is the row that *exercises* `meanEnergy_hasDerivAt` (S20 does not).

### MANUSCRIPT_CLAIM_MATRIX.md
4. **M14 (laboratory).** Change "seventeen benchmark families … fourteen V0/V1" →
   "**eighteen** families … **fifteen** V0/V1 plus three disclosed V2 (S18, S21,
   S22)"; add S23 as the exact shared-pair V1 regression.
5. **New/updated joint-witness row.** Record `one_pair_joint_chain` as **landed**
   with grade **M (finite composition)**, load-bearing assumption "one supplied
   pair drives every scalar; decorations/decoder/action/ensemble supplied,"
   witness `rational_joint_chain_control`, control `collinear_joint_zero_control`,
   simulation S23. **Falsifier:** any interface admits an independent mass, or the
   collinear control fails to zero. **Caption boundary (mandatory):** this witness
   spans mass/action/flow/ensemble only; it does **not** connect to kinematics or
   Dirac propagation, and 3 of its 5 conjuncts are spectrum/stiffness-generic.
6. **M6 (kinematics).** Route B's spatial Dirac reading is **still open at the
   source level**: the landed position walk is isometry-only; the
   sign-table↔Clifford dictionary is `axisBasis_conjugates_velocity`
   (**in flight**, statement verified true here), and the `3+1` uniform rate is
   `Compact3Plus1DiracRate` (**in flight**, `D4`/`Dbox` verified true here). Do
   not caption the spatial Dirac walk as landed until both bridges land.
7. **M17 (thermodynamics).** Keep S20 as V0/V1 self-consistency and S22 as the V2
   response confrontation; the shared-pair ensemble is now also pinned by
   `one_pair_joint_chain` (its gap = `massSq psi phi`).

### THEORY_COMPLETION_MATRIX.md
8. **Empirical-prediction / laboratory line** ("seventeen families PASS: fourteen
   V0/V1"): update to **eighteen families, fifteen V0/V1 + three V2**. No V4
   candidate; row stays **O**.
9. **Kinematics row.** The sign-table↔Clifford bridge and the `3+1` uniform rate
   are the two **in-flight** deliverables whose statements are now verified
   correct; grade stays `D/H/B/K` with those two as the named next arrows.
10. **Dynamics + Mass + Thermodynamics rows.** The joint witness makes the
    **mass↔action↔flow↔ensemble** seam a single Lean term; note this composes
    those four rows on one carrier, while the **kinematics** row remains
    disconnected from that carrier (the cross-cluster arrow is §8).

### Stale/carried items
11. Carried [error]s remain controlling: Audit-10 "Dirac needs `H²=−k²I`" is false
    (`H²=+(‖k‖²+m²)I`, `α²=β²=+I`); the genuine V2 IDs are S18/S21/S22 (not the
    GS-04 Schottky/dispersion mislabels).

---

## 8. Single highest-value theorem to launch next

Audit 12's top pick (sign-table↔Clifford tangent bridge) is now **in flight** as
`axisBasis_conjugates_velocity` (statement verified true, §2). The next
highest-value theorem is the **cross-cluster mass seam**: the joint witness pins
one mass scalar across mass/action/flow/ensemble but never feeds it into the
Dirac propagator. Closing that arrow makes a **single pair** drive both the
static/thermo cluster **and** `3+1` Dirac propagation — the last seam separating
"two disjoint witnesses" from "one end-to-end witness."

**Statement sketch (type-correct against the two files):**

```lean
open Compact3Plus1DiracRate
open PhysicsSM.Spinor.PluckerMass          -- massSq, CSpinor, edge0, edge1
open PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse  -- pluckerTwoLevel

/-- The one supplied pair's Plücker mass `massSq psi phi` is simultaneously the
    energy gap of its Gibbs two-level ensemble AND the mass entering the 3+1
    Dirac step, whose n-step split-step converges to exact Dirac evolution at
    rate O(1/n).  One scalar, static+thermo cluster AND kinematic cluster. -/
theorem plucker_mass_drives_dirac_propagation
    (psi phi : CSpinor) (kx ky kz t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1) :
    let m := massSq psi phi
    -- (a) same scalar is the ensemble gap
    (pluckerTwoLevel psi phi 1 = m) ∧
    -- (b) same scalar drives 3+1 Dirac propagation at O(1/n)
    ‖ (splitStep kx ky kz m (t / (n : ℝ))) ^ n
        - exactFlow kx ky kz m t ‖
      ≤ D4 kx ky kz m * t ^ 2 / n := by
  s o r r y
```

- **Why highest value.** It is the *only* statement that shares one Lean term
  across the two clusters the corpus currently keeps disjoint (§4, §8 of Audit
  12). Its two conjuncts are both already-audited-true pieces
  (`pluckerTwoLevel _ 1 = massSq` by `rfl`; the bound by §3), so the composition
  is cheap yet upgrades the manuscript spine from "two witnesses" to "one."
- **Witness (nondegenerate).** `psi=edge0`, `phi=edge1 (2/5)` ⇒ `m=4/25`;
  `(kx,ky,kz)=(1,2,2)`, `t=1`: reuses `benchmark_1223_nondegenerate`
  (`H(1,2,2,3)²=18I`) with a genuine nonzero mass.
- **Negative control.** (i) collinear pair ⇒ `m=0`: the mass factor is `I`, the
  step is purely spatial, and the ensemble gap collapses (`collinear_joint_zero_control`);
  (ii) phase-reversed mass factor (`+i m ε`) converges to `exp(−iH')`,
  `H'=…−mβ≠H`, so the bound is violated for large `n`.
- **Kill condition.** If `massSq psi phi` cannot be substituted into
  `splitStep/exactFlow` while preserving the `D4·t²/n` bound (i.e. the mass slot
  needs a *different* scalar than the ensemble gap), the two clusters do not share
  a carrier and the "one-pair full witness" claim is false — downgrade the
  manuscript to two independent witnesses.

Runner-up: land the two in-flight bridges themselves
(`axisBasis_conjugates_velocity` + `stepSymbol`-style `−iH`; `D4`/`Dbox`), since
`plucker_mass_drives_dirac_propagation` reuses `Compact3Plus1DiracRate` directly.

---

## 9. Dawn verdict: one candidate full theory, or a family of compatible finite models?

**Current status: a family of compatible finite models with three genuine
end-to-end finite chains and one clean killed route — not yet one candidate full
theory.**

What genuinely composes on shared carriers:
- **Dynamics chain:** selected directions → `massSq`/`PluckerActionHessian` →
  `DiscretePluckerVariationalFlow` → `DiscretePluckerFlowStability` (full window
  `0<mu<4`) → `DiscretePluckerFlowRotation` (unit-circle conjugacy).
- **Ensemble chain:** `FiniteGibbsResponse` (`d log Z/dβ=−⟨E⟩`) →
  `FiniteGibbsVariance` (`d⟨E⟩/dβ=−Var`, rigidity `Var=0 ⇔ constant spectrum`),
  now confronted by the non-tautological V2 **S22**.
- **Mass/action/flow/ensemble joint witness:** `one_pair_joint_chain` — one pair,
  one mass scalar across five interfaces (§4), regressed by **S23**.
- **Killed route:** the simultaneous six-channel coin admits no complex-scalar-
  square Dirac block.

**What is still required for the manuscript to claim ONE candidate full theory:**

1. **The cross-cluster seam (the decisive one).** The joint witness and the
   Dirac propagation live on **disjoint carriers**: `massSq psi phi` is never
   shown to be the `m` in `H`/`exactFlow`. Until
   `plucker_mass_drives_dirac_propagation` (§8) lands, the "mass" of the static
   cluster and the "mass" of the kinematic cluster are two numbers that merely
   look alike. **This is the single arrow whose absence keeps the corpus a family
   of compatible models rather than one theory.**
2. **The spatial Dirac bridge must land.** `axisBasis_conjugates_velocity` +
   `axisSymbol_entry_hasDerivAt` are **true** (§2) but **unlanded**; the landed
   position walk is isometry-only. Without them there is no arrow from the
   internal `−iH` algebra to a spacetime walk.
3. **The `3+1` uniform rate must land.** `D4`/`Dbox` (§3) are **true** but
   **unlanded**; S21 is empirical-rate-only. This is the exact→`exp(−iHt)`
   dictionary in `3+1`.
4. **Primitive selection dictionaries remain B/O.** The action, coin
   coefficients, time axis, and spinor decorations are supplied, not derived from
   primitive null data; every chain starts one node downstream of the ontology.
5. **No genuine prediction.** The lab is 15 V0/V1 + 3 V2; there is **no V3/V4**.
   A candidate full theory may import laws, but it needs at least one honestly
   ranked route to a pre-registered observable — currently absent (row **O**).

**Bottom line for the manuscript.** State it plainly: *"We exhibit one candidate
finite null-information architecture with three checked end-to-end finite chains
(dynamics; ensemble response; a one-pair mass/action/flow/ensemble witness) and
one killed route, connected to accepted physics by three disclosed V2
reproductions. It is not yet a single theory: the static-mass scalar is not yet
identified with the Dirac-propagation mass (one Lean term away, §8), the spatial
Dirac walk and the `3+1` continuum rate are proved as statements but not yet
landed, and no observable is predicted rather than imported."* The **fastest path
from "family of compatible models" to "one candidate theory"** is: land the two
in-flight bridges, then land `plucker_mass_drives_dirac_propagation`. That single
cross-cluster theorem is what would license the manuscript to say "one candidate
full theory."

---

## Consolidated defect ledger for Audit 13

1. **[caption] `one_pair_joint_chain`** — genuinely pins one mass scalar across
   five interfaces (true, non-fragmenting), but clauses 3–5 are
   spectrum/stiffness-**generic** and nothing touches kinematics. Caption "joint
   mass/action/flow/ensemble witness," never "theory witness."
2. **[true, land] `axisBasis_conjugates_velocity`** — `U D Uᴴ = α_j` recomputed
   exactly for all three axes; sign ordering correct; identity-basis control
   load-bearing. Statement true; still a `s o r r y` stub — landing is priority.
3. **[true, generous, land] `D4 = 16 B² e^B`** — valid first-order product
   constant, 32× the sharp `½B²e^B`; factor order/norm/box quantifier/`O(1/n)`
   rate all preserved; anticommutation forbids `O(1/n²)` (control present). Still
   a stub.
4. **[V0/V1] S20** — Schottky curve-match is a tautology (gap cancels); correctly
   re-tiered. **[V2] S22** — the genuine response confrontation. **[V1] S23** —
   exact shared-pair regression, correctly not counted as V2.
5. **[count] matrices** — update laboratory rows to **18 families, 15 V0/V1 + 3
   V2 (S18, S21, S22)**; add the S23 row.
6. **[gap] cross-cluster mass seam** — the static mass `massSq psi phi` is not yet
   the Dirac `m`; `plucker_mass_drives_dirac_propagation` (§8) is the exact next
   theorem and the dawn-blocking arrow.
7. **[carried]** `H²=+(‖k‖²+m²)I` (`α²=β²=+I`); genuine V2 IDs are S18/S21/S22.
8. **[packaging]** focused-package `PhysicsSM.*` import gaps and the residual
   `Targets/*` stub copies are staging facts, not live regressions; consolidated
   guard is green at 8090 jobs with pinned axioms.
