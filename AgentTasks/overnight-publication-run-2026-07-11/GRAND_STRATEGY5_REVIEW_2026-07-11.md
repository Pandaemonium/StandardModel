# Grand-strategy review 5 — post-selector-descent publication endgame

Project: `codex-pub-grand-strategy5-20260711`
Run: `overnight-publication-run-2026-07-11`
Mode: **review-only, no source edits.** Every claim below is matched to an exact
declaration in the supplied tree and to its trust footprint. Freeze 06:30 PDT,
hard audit 07:00 PDT.

Reject list enforced throughout: (a) coordinate readers that pre-encode the
desired channels; (b) generic quotient repackaging sold as physics; (c)
sampled-momentum substitutes for all-zone results; (d) eigenmode existence sold
as localization or topological stability.

---

## 0. Verified source ground truth (what actually exists)

| Paper | Decisive landed declaration (file) | Exact content | What is NOT in source |
| --- | --- | --- | --- |
| C | `twoWall_protected_modes` (`ModeInvariantHalfWinding.lean:417`) | `∃ V≠0, (toC Wwall).mulVec V = -V` **and** `∃ V≠0, = V` for ONE concrete 8×8 walk `Wwall = walkQ cW sWall`, forced by `Afix_selfadj`/`Afix_involution` on the fixed legs; controls `Afix0`, `Afix4` have `det(A∓1)=36/25≠0` | no wall-count quantifier / no `2 mod 4` iff; no support/decay (V is a global 8-vector); no perturbation-stability theorem. `Afix4` **equals** `Afix0` numerically, so there are really 2 distinct compressions, not 3 |
| D | `fourier_localStep_iterate` (`LiveDFTComposition.lean:290`) + `localStep_eq_inverseFourier_symbol:277` | for all finite `n`, all `k`: `fourier (localStep^[n] ψ) k = (finiteLocalSymbol m eps k)^n .mulVec (fourier ψ k)`; all-zone modewise. Parseval `:120`, round trips `:60/:92` | no physical scaling / Shannon interpolation; no position-space `R^3` rate; no operator/state-distance corollary |
| E | `gamma_create_covariance_restrict` (`CARAnnihilationLocality.lean:103`), `fockInner_annihilate_left:79`; `witnessPairKick_two_particle_nontrivial` (`PlueckerQuarticInteraction.lean:431`), `pairKick_singleton:418` | creation covariance + relation-filtered support; CAR adjointness; a unit Plücker phase `(3+4i)/5` kick invisible on 1-particle basis, nonzero on 2-particle | annihilation covariance NOT present (only its adjoint law); no causal-locality-of-observables theorem; the "4/5 survival" discriminator lives in a module not in this tree |
| F | `existsUnique_descended_iff` (`ChannelSelectorDescent.lean:92`); `selector_rigid_iff_injective` (`Rigidity:32`); `no_finite_selector_rigidifies:80`; `no_unique_type_invariant_refinement` (`NoGo:56`); torsor classification (`RefinementTorsor`) | descent = quotient universal property (intrinsicality checker); additive rigidity iff injectivity; finite-selector no-go; maximal-symmetry no-go; complete type-only affine fibre | NO live carrier selector; no relation-preservation on a real presentation; no physical quotient; no physical-vs-information comparison |

Trust-footprint note (audit-critical): Paper C's chain (`Bfix_iso`,
`Wwall_Bfix`, `Afix_*`, `Wwall_orthogonal`, `twoWall_protected_modes`) is
discharged by `native_decide`, i.e. it carries `Lean.ofReduceBool` (compiler
trust). This is inside the allowed axiom set, but unlike the D/E/F files it has
**no `#print axioms` guard** on the headline theorem. Add a guard before the
letter cites it (see checklist).

---

## 1. Probability-weighted ranking of the next six theorem/composition jobs

Ranked by (expected manuscript value) x (P[lands before freeze]). Each names
shape, hypotheses, witness/control, blocker, consequence, fallback.

**Job 1 — Paper A / A-prime release artifact closure (P≈0.9, value high).**
Shape: non-theorem engineering gate (immutable source identity, clean Linux
full build, root license, archive id). Hypotheses: reproducibility re-audit
already green (`REPRODUCIBILITY_REAUDIT_2026-07-10.md`). Witness: reproducible
build hash. Control: fresh clean checkout builds with zero `sorry`. Blocker:
license/archive id are human actions, not proofs. Consequence: flips A and the
obstruction letter from NEAR-READY to READY. Fallback: ship letter first (fewer
moving parts, shared author line).

**Job 2 — Paper D operational corollary: iterate is an exact ℓ² isometry
(P≈0.8, value high).** Shape: `‖localStep^[n] ψ‖ = ‖ψ‖` (position-norm),
proved from `fourier_localStep_iterate` + `fourier_parseval` + modewise
unitarity `finiteLocalSymbol_unitary`. Hypotheses: `NeZero L`, `m eps : ℝ`.
Witness: any nonzero `modeState`. Control: a non-unitary symbol breaks it (keep
`zero_mode_control`). Blocker: assembling Parseval across the iterate cleanly.
Consequence: first *operational* (norm-conserving dynamics) statement, the
honest bridge toward a distance corollary. Fallback: state single-step isometry
only.

**Job 3 — Paper F live word-carrier selector (the §2 theorem below) (P≈0.55,
value very high).** Shape: descended homogeneous-degree selector on a source
word module via `existsUnique_descended_iff`. This is the scientific core; it is
the only job that can move F from "section" to "standalone". Blocker:
noncircular definition + relation-preservation is genuinely hard. Fallback: land
the **kill** direction (`no_descent_of_relation_witness` witness) as an honest
presentation-dependence certificate.

**Job 4 — Paper C guard + honest restatement (P≈0.85, value medium).** Shape:
add `#print axioms twoWall_protected_modes` guard (audit only, no math) and lock
manuscript prose to the demoted statement in §4. Blocker: none technical.
Consequence: prevents the letter/paper from over-claiming under hard audit.
Fallback: if guard cannot be added under freeze, embargo all "protected /
localized / 2 mod 4" language and cite only the eigenmode existence.

**Job 5 — Paper E annihilation covariance + filtered support (P≈0.6, value
medium).** Shape: mirror of `gamma_create_covariance_restrict` for
`annihilate`, then the relation-filtered corollary. Hypotheses: same `hlocal`.
Witness/control already exist for the creation side. Blocker: sign bookkeeping
(`opSign`) on the annihilation branch. Consequence: completes the CAR
covariance pair — necessary infrastructure for Job 6, still not novelty alone.
Fallback: ship creation side only, mark annihilation "in flight".

**Job 6 — Paper E Plücker-phase interaction discriminator composition (P≈0.4,
value high if it lands).** Shape: the covariance-compatible two-particle
observable of §6, invisible to one-particle dynamics. Blocker: needs Job 5 and a
genuine intertwining of `Gamma U` with `witnessPairKickLinearEquiv`.
Consequence: first E result exceeding standard second quantization. Fallback:
present as a preregistered composition target, not a theorem.

Ordering rationale: Jobs 1/2/4 are cheap and de-risk two papers; Job 3 is the
single highest-value but lowest-probability scientific bet and must run in
parallel, not on the critical path.

---

## 2. Smallest live, noncircular Paper F selector theorem worth formalizing now

The descent theorem (`existsUnique_descended_iff`) is exactly the quotient
universal property — an intrinsicality *checker*, confirmed by the semantic
audit. It constructs no carrier selector. The smallest *live* theorem is the
first instance where an honestly source-defined selector is shown to descend (or
is killed), with the four channels never named in the definition.

**Setup (noncircular by construction).**
- Alphabet `L : Type*` of generators (solder letters / edge moves), NOT the four
  channel names.
- Source module `F := L →₀ R` (free `R`-module on words/letters; or the free
  associative construction if edge-exchange needs multiplication).
- Carrier evaluation `eval : F →ₗ[R] V` sending each generator to the operator
  it represents; require `Function.Surjective eval` (the carrier is generated).
- Selector `P : Module.End R F` = the *degree/parity grading operator*:
  `P` scales each basis word `w` by its solder/word-degree parity
  `(-1)^{deg w}` (or multiplies by `deg w` for the additive grading). This is
  defined purely from letter counts, so it references no channel and no target
  basis — it cannot be a coordinate reader.

**Theorem shape (positive).**
`existsUnique_descended_iff eval P heval` gives:
`(∃! Q, Q ∘ eval = eval ∘ P) ↔ PreservesEvaluationKernel eval P`.
So the *live obligation* collapses to a single check.

**Relation-preservation obligation (the real work).**
`PreservesEvaluationKernel eval P`, i.e. `ker eval ≤ ker (eval ∘ P)`. Concretely:
every defining relation `r ∈ ker eval` (each `eval r = 0`) must be **homogeneous
of fixed degree-parity**, so that `P r ∈ ker eval` as well. Discharge by:
enumerate the finite generating set of relations `{r_1,…,r_k}`; show each `r_i`
is degree-parity homogeneous; conclude `eval (P r_i) = (parity_i)·eval r_i = 0`;
extend to `ker eval` by linearity. This is the noncircular content — it says the
grading is intrinsic to the *presentation*, not to a chosen basis.

**Nonzero witness (nontriviality — reject the trivial `P = id`).**
Exhibit two words `w₁, w₂` of opposite parity with `eval w₁ ≠ 0`, `eval w₂ ≠ 0`,
and `descendedSelector … (eval w₁) = eval w₁`, `= -(eval w₂)` (odd word flips).
This proves the descended `Q` is not a scalar and genuinely separates sectors —
the honest analogue of `witnessPairKick_two_particle_nontrivial`.

**Negative control (mandatory).**
A source selector that is NOT relation-homogeneous — e.g. `P'` that scales a
single generator that appears inside a relation of mixed degree. Then produce
`x ∈ F` with `eval x = 0` and `eval (P' x) ≠ 0` and invoke
`no_descent_of_relation_witness eval P' x hx hPx` to conclude
`¬ DescendsThrough eval P'`. This is the exact presentation-dependence
certificate and the required guard against fabricated channels.

**Kill theorem (if descent fails for the intended grading).**
If the honest solder-degree grading turns out non-homogeneous on the true
relation set, the paper does not lose — it *gains* a no-go:
`Paper F kill: the solder-degree selector is presentation-dependent`, proved by
`no_descent_of_relation_witness` on the explicit offending relation. State it as
"no intrinsic degree selector on this carrier", which is a publishable negative
result and forecloses a whole class of would-be channel selectors.

**Follow-on gate (do not skip).** Once descended, prove it commutes with
chirality and has the separated joint spectrum feeding
`ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique` — that is what
turns "a selector descends" into "the decomposition is forced".

Likely blocker: writing the relation set for the *live* carrier explicitly and
proving homogeneity without silently importing the target basis. Fallback order:
(1) positive descent; (2) if hard, the kill theorem; (3) if neither, publish the
descent criterion as the intrinsicality gate only (current state), no live
selector claim.

---

## 3. Does Paper F earn a standalone paper, a theorem section, or a program note?

**Verdict: a strong theorem section now — NOT a standalone paper yet.**

Justification against the Dawn test "does the one-sentence claim survive
deleting all references to Lean?": today F's landed results are (i) a torsor
classification of the type-only fibre, (ii) rigidity iff injectivity, (iii) two
finite/maximal-symmetry no-gos, and (iv) a descent criterion that is provably
the quotient universal property. Every one is an *enabling / obstruction* result
about the moduli of decompositions; none constructs the physically or
information-theoretically preferred orbit. A standalone paper whose thesis is
"we classify the channel selectors" cannot be honestly written, because no live
selector is defined. Sold standalone, it would be generic quotient repackaging —
exactly reject-list item (b).

**Exact shortest gate to the next grade (section → standalone):** land §2's
positive live selector theorem *with* its relation-preservation proof, nonzero
witness, and negative control, then chain it through
`two_sign_gradings_decomposition_unique` and add ONE comparison of the physical
vs information-theoretic preferred orbit on two inequivalent nonzero carriers. If
only the kill theorem lands, F upgrades to "standalone no-go note", not a
classification paper.

Fallback if §2 stalls before freeze: keep F as a theorem section inside the
channel-moduli paper and demote the abstract to "we give the intrinsicality
gate and rule out finite / fully-natural selectors", removing any wording that
implies a preferred channel is selected.

---

## 4. Strongest honest Paper C statement, with exact demotions

**Strongest statement the source supports (verbatim-faithful):**
"An explicitly derived two-wall finite coined walk `Wwall` on 8 sites carries an
exact nonzero `+1` eigenmode and an exact nonzero `-1` eigenmode. Their
existence is *forced*, not fitted: the reflection-fixed-leg compression `Afix`
is self-adjoint and an involution with trace 0, so `±1` modes must appear. Two
matched in-class controls on the same legs — the zero-wall field `[+,+,+,+]`
(`Afix0`) and the reflection-symmetric four-wall field `[+,-,+,-]` (`Afix4`) —
have non-self-adjoint compressions with `det(A∓1)=36/25≠0`, hence no `±1` mode.
The determinant routes stay closed (`det = +1` throughout)."

Anchors: `twoWall_protected_modes`, `Afix_selfadj`, `Afix_involution`,
`Afix_trace`, `Afix0_no_{neg,pos}_mode`, `Afix4_no_{neg,pos}_mode`.

**Mandatory demotions (each absent in source → embargoed):**
- **No `iff wall count = 2 mod 4`.** There is no theorem quantified over wall
  count. Only two distinct compressions are exhibited (`Afix4` is numerically
  equal to `Afix0`). Demote any "2 mod 4 / even-vs-odd wall" prose to: "for the
  displayed two-wall field vs the two displayed controls." Do not imply a family.
- **No "localized".** The eigenvectors are global 8-component vectors; there is
  no support-restriction, decay, or edge-concentration theorem. Replace
  "localized mode" with "exact `±1` eigenmode". Selling eigenmode existence as
  localization is reject-list item (d).
- **No "topologically protected" / stability.** There is no
  perturbation-stability theorem. Replace "topologically protected" with "forced
  by the self-adjoint fixed-leg compression". The word "protected" in
  `twoWall_protected_modes` is an internal name, not a proven robustness claim —
  do not let it leak into the manuscript.

**Honest fallback if a reviewer presses:** the result is a *mechanism* theorem
(self-adjoint compression ⇒ forced `±1` split) plus a discriminating control
pair, not a topological-phase theorem. That mechanism claim is fully proved and
is the safe headline.

---

## 5. Single best Paper D theorem after finite spectral conjugacy, and shortest
path to an operational consequence

**Best theorem: `fourier_localStep_iterate`** (all finite time steps are exactly
powers of the pointwise finite character block at every momentum), backed by
`localStep_eq_inverseFourier_symbol`. It is the exact, all-zone spectral
diagonalization of the dynamics — not a sampled-momentum substitute (it is
universally quantified over `k : Position L`), so it clears reject-list item (c).

**Shortest path to an operational consequence (three steps, all in-scope):**
1. `finiteLocalSymbol_unitary` (present) ⇒ each block preserves the internal
   inner product at every `k`.
2. Combine with `fourier_parseval` (present) ⇒ **exact ℓ² norm conservation of
   the full iterate**: `positionNormSq (localStep^[n] ψ) = positionNormSq ψ`.
   This is Job 2 and is the first genuinely operational statement.
3. From norm conservation + linearity, derive a **two-symbol state-distance /
   Trotter-type bound**: `‖localStep_{m,eps}^[n] ψ − localStep_{m',eps'}^[n] ψ‖`
   controlled by the momentum-wise block difference `‖A_k^n − B_k^n‖`. That is
   the operational distance confronting arXiv:1212.2839 the gate matrix wants.

**Blocker:** step 3's continuum/position-space rate still needs the *missing*
physical scaling + Shannon interpolation; do NOT present the ℓ² isometry or the
coefficient-tail rate as continuum `R^3` convergence (reject-list (c)). **Honest
fallback:** ship steps 1–2 (exact finite unitary dynamics + norm conservation)
as the operational core and keep the continuum rate preregistered.

---

## 6. Paper E composition that first exceeds standard second-quantization
infrastructure via the Plücker phase

CAR adjointness, `Gamma(UV)=Gamma(U)Gamma(V)`, covariance, and Fock-inner
preservation are standard infrastructure — necessary but not novel. The first
composition that *exceeds* it is a **Plücker-phase interaction discriminator
that is one-particle-invisible but Γ-covariance-compatible**:

**Shape.** Let `A := witnessPairKickLinearEquiv` (the exact `(3+4i)/5`
Plücker-phase pair kick, unitary and involutive). Prove:
1. `A` is invisible on every one-particle sector: `pairKick_singleton` (present)
   gives `A (basisVec {i}) = basisVec {i}`.
2. `A` is nonzero on a two-particle sector: `witnessPairKick_two_particle_nontrivial`
   (present) with amplitude exactly the normalized Plücker phase
   (`witnessPairKick_forward_amplitude`).
3. **New content:** `A` commutes with the free covariant flow generated by
   `Gamma U` for the relevant local `U` (or the exact obstruction to commuting),
   so the observable distinguishing the two two-particle orientations is a
   *bona fide invariant of the local dynamics*, not an isolated rank-two kick.

**Why it exceeds infrastructure:** the discriminating datum is the Plücker phase
`(3+4i)/5` itself — a spinor-area invariant — appearing in a two-particle
amplitude that is provably absent from all one-particle dynamics. That is the
"invisible to one-particle dynamics" thesis of Paper E made exact.

**Load-bearing prerequisite:** Job 5 (annihilation covariance + filtered
support) must land so that the covariant flow is the full CAR automorphism, not
half of it. **Witness:** `highPair → lowPair` amplitude `= (3+4i)/5 ≠ 0`.
**Control:** `pairKick_singleton` (one-particle invisibility) and a collinear /
`z=const` field reproducing the trivial phase. **Blocker:** step 3's
intertwining of `A` with `Gamma U` may fail (the kick may not be Γ-covariant);
if so, the **honest fallback** is to publish the one-particle-invisible /
two-particle-nonzero interference witness as a *finite interference discriminator*
(explicitly "not a scattering theory", matching the gate matrix's own boundary
control), which is still beyond standard infrastructure but weaker than a
covariant interaction.

Reject guard: do not sell the isolated involutive kick as an interaction; the
novelty is only earned once it is tied to the covariant flow (step 3) or
honestly labeled a discriminator.

---

## 7. Freeze-aware schedule (through 06:30) and hard-audit checklist (through 09:00)

**Build/parallelism note:** run the theorem jobs in parallel, each on its own
file; verify each with an explicit module build (never a bare default-target
build) and a `sorry` grep before counting it landed.

Schedule to 06:30 (freeze = construction stops; only these land):
- **now–02:00** Job 1 (release artifact: source identity, clean Linux full
  build, license, archive id) — highest P, unblocks two papers. In parallel
  start Job 4 (Paper C guard + prose lock) and Job 2 (D ℓ² isometry).
- **02:00–03:30** Land Job 2; begin Job 5 (E annihilation covariance).
- **03:30–05:00** Job 3 (F live selector: attempt positive descent; if stalling
  by 04:15, pivot to the kill theorem) in parallel with finishing Job 5.
- **05:00–06:00** Job 6 attempt *only if* Job 5 landed; else mark preregistered.
- **06:00–06:30** Freeze prep: re-run every headline `#print axioms` guard;
  regenerate build; lock prose to the honest statements in §§4–6.

Hard-audit checklist to 09:00 (07:00 audit start):
1. **Zero `sorry` / zero `admit`** across all nine `.lean` files (grep, not
   trust). Confirm each headline theorem's `#print axioms` ∈
   {propext, Classical.choice, Quot.sound, Lean.ofReduceBool, Quot.sound}.
2. **Paper C footprint:** add/confirm a `#print axioms twoWall_protected_modes`
   guard; document `native_decide`/`Lean.ofReduceBool` trust and that
   reproduction requires native compilation on the audit machine. Confirm the
   det controls `36/25 ≠ 0` recompute.
3. **Paper C prose:** grep the manuscript for "localized", "protected",
   "topological", "2 mod 4", "any/every wall" — each must be removed or scoped
   to the two displayed controls (§4).
4. **Paper D prose:** grep for "continuum", "R^3", "Shannon", "operational
   distance" — must be marked open/preregistered unless step 1–2 of §5 landed;
   confirm the negative lattice-angle convention (`*_eq_analytic_neg`,
   `quarter_zone_sign_control`) is stated with the correct sign and not reversed.
5. **Paper E prose:** confirm annihilation covariance is labeled "in flight" if
   Job 5 did not land; confirm the kick is called a discriminator, not a
   scattering interaction, unless Job 6 step 3 landed. Confirm the "4/5 survival"
   claim's module is actually present in the release tree (it is NOT in this
   snapshot — do not cite it from here).
6. **Paper F prose:** confirm descent is described as the intrinsicality gate /
   quotient universal property, not a channel classification, unless §2 landed;
   confirm no coordinate reader hides the four channels in any selector
   definition.
7. **Fresh clean checkout** builds all default targets with no network, no
   cached `.olean` from the working tree; artifact hash recorded.
8. **Claim matrix / gate matrix parity:** every `T`/`M` grade points to a real
   declaration name that exists (spot-check 5); demote any row whose declaration
   is absent from the release tree.

---

## 8. Exact manuscript claim actions — upgrade / preserve / demote / embargo

**UPGRADE**
- D ℓ² norm conservation of the finite iterate (once Job 2 lands): promote from
  "modewise unitarity" to "exact operational norm-conserving dynamics".
- A / A-prime: on Job 1 completion, upgrade NEAR-READY → READY (release gate
  cleared), letter first.
- E creation-covariance-with-support (`gamma_create_covariance_restrict`):
  upgrade to a stated theorem in the manuscript (currently infrastructure).

**PRESERVE (already honest — do not touch)**
- D: `fourier_localStep_iterate`, `localStep_eq_inverseFourier_symbol`,
  `fourier_parseval`, round trips, `finiteLocalSymbol_unitary`,
  `quarter_zone_sign_control` (all-zone, exact).
- F: descent criterion as *intrinsicality gate*; rigidity-iff-injectivity;
  finite-selector and maximal-symmetry no-gos; torsor classification.
- E: CAR adjointness; `pairKick_singleton`; `witnessPairKick_two_particle_nontrivial`.
- C: eigenmode-existence-forced-by-self-adjoint-compression + the two det
  controls (the §4 statement).

**DEMOTE**
- C: any "iff wall count = 2 mod 4" → "for the displayed two-wall field vs two
  controls" (only two distinct compressions exist; four-wall = zero-wall
  numerically).
- C: "localized mode" → "exact `±1` eigenmode" (no support theorem).
- F: any "we classify / select the preferred channel" → "we give the
  intrinsicality gate and rule out finite/fully-natural selectors".
- D: any coefficient-tail or integer-mode-exhaustion rate presented as continuum
  `R^3` convergence → "finite / coefficient-space rate; continuum open".
- E: "interaction" for the isolated kick → "finite interference discriminator"
  unless Job 6 step 3 lands.

**EMBARGO (do not print under any framing until the named proof lands)**
- C: "topologically protected", "topological stability", "protected mode"
  (no perturbation-stability theorem exists; internal name only).
- C: any perturbation-robustness statement.
- D: "operational distance to arXiv:1212.2839", "Shannon interpolation",
  "3+1 position-space Dirac convergence" (all open).
- F: "physical quotient", "preferred orbit", "physical vs information-theoretic
  selector chooses the aperture/closure/turn/solder orbit" (no live selector
  and no physical quotient defined).
- E: the "double-kick survival 4/5 vs 1" discriminator — its module is not in
  this release tree; embargo until the source is present and guarded.

---

### One-line disposition per paper
- **A / A-prime:** theorem spine done; only the release artifact gate stands —
  clear it (Job 1) and ship the letter first.
- **C:** publish the forced-`±1`-eigenmode mechanism + control pair; embargo
  localization/topology/2-mod-4; add the missing axiom guard.
- **D:** publish the exact all-zone spectral conjugacy + (Job 2) norm
  conservation; keep continuum/operational-distance preregistered.
- **E:** finish the CAR covariance pair (Job 5); the Plücker-phase discriminator
  is the first beyond-infrastructure result — earn "interaction" only via Job 6
  step 3.
- **F:** strong theorem section, not a standalone paper; the shortest gate to
  standalone is the §2 live word-degree selector (positive descent, or an honest
  kill theorem).
