# Standing goal - Codex solo carrier/null-edge work

You are the solo active executor for today's carrier/null-edge run unless the
current git state or ledger shows fresh peer activity.  The original master plan
is still `RUN_PLAN.md`, but this prompt supersedes the old two-executor
coordination rules for Codex: do not wait for Claude review before making
progress.  Treat the latest Claude commits, Fable answers, Aristotle outputs,
`THREAD_BOARD.md`, `LEDGER.md`, and the manuscript/status updates as live
steering context.

Mission: develop the new Claude/Fable ideas already present in the repository to
their highest practical potential, while preserving the run's core discipline:
kernel-checked Lean where possible, honest claim grading, guard blocks for
flagships, provenance, frequent Aristotle proof/strategy/audit jobs, and small
verified commits.

## First principles

- **Current state is authoritative.** Before relying on old chat context, inspect
  `git status`, recent commits, `LEDGER.md`, `THREAD_BOARD.md`,
  `AgentTasks/fable_parallel/*.md`, and any relevant task notes.
- **Kernel = truth.** A theorem is trusted only when the intended statement is
  represented correctly in Lean, accepted by the kernel, verified under the
  pinned toolchain, and guarded when it is a flagship.
- **No narrower substitute goals.** Make real progress toward the program, not
  merely the easiest passing subset.  If a statement is false or mis-scoped,
  record the honest correction and move to the next useful target.
- **Work with dirty state.** Do not revert user or peer changes.  If uncommitted
  files are unrelated, leave them alone.  If they affect the task, inspect and
  work around them carefully.
- **Solo does not mean unreviewed.** Replace the old Claude cross-review gate
  with explicit self-review, Aristotle audit jobs after risky integrations, and
  ledger notes that name claim boundaries and over-claim risks.
- **Skip new Fable/model calls.** Do not initiate Fable calls or external
  model-review calls as part of this solo prompt unless the user explicitly asks.
  Harvest and act on the Fable/Claude material already written into the repo.

## Working surface

You may work across the former Codex and Claude lanes when doing solo work:

- Carrier / Weitzenbock / Q_A / Q_T / index / Gupta-Bleuler lanes.
- Closure / Q_C / GateYM / Osterwalder-Seiler / KP / product-Haar lanes.
- New Fable-driven threads: horizon area/entropy, signature/dimension
  selection, real-structure/KO/unimodularity seam, chirality-solder audit,
  equivariant McKean-Singer, RG-Schur, and anomaly gates.

Preserve file-local conventions and ownership history.  If fresh peer activity
appears in `PhysicsSM/Draft/NullEdge/Carrier/**`,
`CarrierAxiomGuard.lean`, `PhysicsSM/Draft/NullEdge/GateYM/**`, or
`SlabAxiomGuard.lean`, coordinate via `LEDGER.md` and git rather than
overwriting it.

## 2026-07-07 lane refresh and next Aristotle names

This section is the current launch map for solo work.  It supersedes the older
"fresh" names below when opening a new Aristotle project.  Before submitting,
poll `aristotle list`, harvest any `IDLE` result, and check
`ARISTOTLE_LANE_DOCKET_2026-07-07.md` so no active or already-harvested target
is resubmitted.  New project directories should use exactly the descriptive
future-facing names in this table, or the same pattern with a date bump if the
work moves past 2026-07-07.  If a listed target has advanced, mint an even more
specific non-colliding `ne-next-*` name and record it in the docket.

Current poll context: Q10 Spin/Weyl scalar amplitude (`05fdd744`), Q08 Fock
graded radical / LGV lift (`b4206467`), and HSTAR model audit (`16d04733`) have
been harvested locally.  The HSTAR harvest opened one Aristotle slot; refill it
with a Ward/descent quotient-action follow-up after the local HSTAR commit.
That refill is now running as `b1980b93`, bringing Aristotle back to twelve
running StandardModel-relevant lanes.  The still-running lanes below should not
be duplicated:

| Project | Active Aristotle job | Lane |
|---|---|---|
| `b1980b93` | `ne-next-hstar-ward-descent-quotient-action-proof-20260707` | HSTAR finite Ward/descent quotient action |
| `fbdbe43f` | `ne-next-q10-spinweyl-d4-selfdual-positive-corner-proof-20260707` | Q10 finite `d = 4` positive corner |
| `f8aa05c8` | `ne-next-q08-graded-radical-exterior-quotient-followup-proof-20260707` | Q08 graded radical ideal/span follow-up |
| `ecbf61d8` | `ne-solo-lane-w2a-qa-minkowski-detp-bridge-proof-20260707` | W2a `Q_A` / Minkowski aperture |
| `5ff9424e` | `ne-next-q12-gammaprime-e4-healing-semantic-audit-20260707` | Q12 GammaPrime E4 semantic audit |
| `96058502` | `ne-solo-lane-q12-c8-psa-sector-ms-bridge-audit-20260707` | Q12 PSA / C8 / sector MS |
| `82cc3c8e` | `ne-solo-lane-rg-schur-nullnilpotency-instability-proof-20260707` | RG-Schur null-nilpotency instability |
| `4b462390` | `ne-solo-lane-q09-screenarea-bwcut-reeh-witness-audit-20260707` | Q09 screen / BW / Reeh gate |
| `373f0283` | `ne-solo-lane-q01-gauss-constraint-positive-quotient-proof-20260707` | Q01 Gauss positive quotient |
| `6e37da00` | `ne-solo-lane-q04-octonion-lambdac3-leftaction-bridge-strategy-20260707` | Q04 octonion left-action bridge |
| `ef87c91f` | `ne-solo-lane-q02-invariant-trace-teleparallel-eslot-audit-20260707` | Q02 invariant trace / E-slot |
| `aa4e48f6` | `ne-next-q11-jacobi-cauchybinet-rc0-integration-audit-20260707` | Q11 Jacobi / Cauchy-Binet RC0 |

Recently harvested and not to duplicate: Q13 global overclaim audit
(`07f40fff`), literature/provenance source-gap audit (`5713746e`), and Q10
Spin/Weyl scalar-amplitude classification (`05fdd744`), Q08 Fock graded
radical assembly (`b4206467`), and HSTAR Ward/descent model audit (`16d04733`).
The duplicate Q12 radical-healing proof project (`297ae18c`) was canceled after
the local proof of `E4_nontrivial_healing`.

| Lane | Pursuit | Highest-value next artifact | Next unique Aristotle job name |
|---|---|---|---|
| W1-E | Carrier / Weitzenbock `E` slot | Torsion vs symmetric soldering-difference split, with exact vanishing hypotheses | `ne-next-w1-eslot-torsion-soldering-split-proof-20260707` |
| W2a-QA | Aperture identification | Harvest `ecbf61d8`; then follow up on the literal `Q_A` to Minkowski aperture bridge if blocked | `ne-next-w2a-qa-minkowski-aperture-contract-followup-proof-20260707` |
| W2a-QT | Turn-slot identification | Diagonal/nilpotent-free hypotheses for `Phi = Gamma * phi` and square-zero traps | `ne-next-w2a-qt-diagonal-turnslot-normality-proof-20260707` |
| W2b | Graded irreducibility | Bigraded normal form for no-common-carrier | `ne-next-w2b-bigraded-no-common-carrier-normalform-strategy-20260707` |
| W2c | Relative exhaustiveness | PBW/rewriting normal form plus named dropped-hypothesis obstruction terms | `ne-next-w2c-relative-exhaustiveness-pbw-dropterm-audit-20260707` |
| CAPSTONE | Four-slot carrier identity | Guarded assembly only, with no spectral mass-form wording | `ne-next-capstone-four-slot-guarded-identity-redteam-audit-20260707` |
| OS1 | Strong-coupling gap scaffold | Genuine small-`beta` multi-plaquette KP/character-polymer rung | `ne-next-os1-smallbeta-two-to-nplaquette-kp-rung-proof-20260707` |
| QC-GRAM | Closure readout / `Q_C` | Exact two-torus readout and carrier-contract normalization boundary | `ne-next-qcgram-two-torus-exact-readout-carrier-contract-proof-20260707` |
| PH/RP | Product-Haar to Wilson RP | Gap audit from banked product-Haar positivity to interacting Wilson measure | `ne-next-rp-producthaar-to-wilson-rp-gap-strategy-20260707` |
| KP/Penrose | Fixed-forest injection | Support lemma or no-go certificate for the Penrose partition route | `ne-next-kp-fixedforest-fiber-injection-or-nogo-proof-20260707` |
| Q01 | Gupta-Bleuler physical positivity | Harvest `373f0283`; then wire finite positive-sector witness to actual carrier/Gauss/Ward hypotheses | `ne-next-q01-carrier-gauss-ward-positive-quotient-followup-audit-20260707` |
| Q02 | Gravity / invariant `E` slot | Harvest `ef87c91f`; then audit trace/P-probe/teleparallel wording against new `E`-slot facts | `ne-next-q02-eslot-trace-pprobe-teleparallel-followup-audit-20260707` |
| Q03 | Dispersion and doublers | Determinant/wedge dispersion identity plus doubler and mass-shell ledger | `ne-next-q03-wedge-dispersion-doubler-massshell-proof-20260707` |
| Q04-Fock | Strand-Fock SM fiber selection | Pentad, hypercharge/Z6 rigidity, supertrace/anomaly finite identities | `ne-next-q04-pentad-hypercharge-z6-supertrace-proof-20260707` |
| Q04-Oct | XOR-Fano to `Lambda(C^3)` | Harvest `6e37da00`; then operator-valued left-action bridge with no raw-octonion associativity | `ne-next-q04-xorfano-lambdac3-leftaction-operator-bridge-followup-strategy-20260707` |
| Q05 | Triality as monodromy | Equivariant index, cover multiplicativity, no-four-orbit route | `ne-next-q05-monodromy-triality-cover-index-strategy-20260707` |
| Q06 | Continuum / GW / refinement | Heterogeneous path-sum and edge-word lift beyond homogeneous transfer powers | `ne-next-q06-heterogeneous-pathsum-gw-edgeword-lift-strategy-20260707` |
| Q07 | Koide / T-solder | Kappa gate, tetrahedral probe, and Hessian/oracle kill tests | `ne-next-q07-tsolder-koide-kappa-hessian-killgate-audit-20260707` |
| Q08-RAD | Exterior Fock radical | Harvest `f8aa05c8`; then audit/integrate the ideal/span follow-up or open the next exact blocker | `ne-next-q08-graded-radical-ideal-integration-audit-20260707` |
| Q08-LGV | Checkerboard / LGV | Multi-layer brick-wall lift of the corrected scattering-vertex DAG | `ne-next-q08-multilayer-brickwall-sharedvertex-lgv-proof-20260707` |
| Q09-REEH | Horizon / screen well-posedness | Harvest `4b462390`; then isolate finite Reeh-screen hypotheses or no-go | `ne-next-q09-finite-reeh-screenarea-wellposedness-followup-audit-20260707` |
| Q09-BW | BW-cut locality | Concrete finite BW-cut locality witness or proof that no current witness exists | `ne-next-q09-bwcut-locality-witness-construction-proof-20260707` |
| Q10-SCALAR | Signature / scalar amplitude | Harvest `fbdbe43f`; then audit the finite `d = 4` positive corner or open the real Spin/Weyl replacement | `ne-next-q10-spinweyl-positive-corner-integration-audit-20260707` |
| Q10-BOUNDARY | Stable-order / dimension boundary | Keep signature theorem, reconstruction assumption, and physical interpretation separated | `ne-next-q10-stableorder-dimension-reconstruction-boundary-audit-20260707` |
| Q11-RC0 | `J_R` / RC0 determinant cocycle | Harvest `aa4e48f6`; then integration audit for Jacobi/Cauchy-Binet semantics | `ne-next-q11-rc0-det-cocycle-groupaction-followup-proof-20260707` |
| Q11-ORDER | Majorana / order condition | Upgrade C3 sector identities toward operator-level invariant uniqueness | `ne-next-q11-ordercondition-invariant-operator-uniqueness-strategy-20260707` |
| Q12-GAMMA | GammaPrime quotient | Harvest `5ff9424e`; then audit the nonzero-quotient/proper-radical descended-commutation theorem and generalize only if the audit is clean | `ne-next-q12-gammaprime-e4-nonzeroquotient-descended-commutation-audit-20260707` |
| Q12-C8 | C8 / `J_R` descent | Harvest `96058502`; then sector conjugation and C8 compatibility gates | `ne-next-q12-c8-jr-sector-descent-compatibility-proof-20260707` |
| Q12-PSA | PSA anomaly gates | PSA-2/3 determinant-line phase gates and promotion conditions | `ne-next-q12-psa23-determinantline-sectorphase-strategy-20260707` |
| Q12-MS | Equivariant McKean-Singer | Exact finite-to-analytic boundary for charge-resolved sector index claims | `ne-next-q12-equivariant-ms-sector-index-boundary-audit-20260707` |
| RG-SCHUR | Coarse-graining | Harvest `82cc3c8e`; then null-nilpotency-instability witness or blocker | `ne-next-rg-schur-nullnilpotency-instability-followup-proof-20260707` |
| C-1FORM | Finite center/twist backgrounds | Twist-sector API and RP/background-cohomology boundary | `ne-next-c1form-twistsector-background-rp-api-audit-20260707` |
| SPIN10-U5 | Pure-spinor internal selection | U(5) / pure-spinor-line stabilizer shadow or finite substitute | `ne-next-spin10-u5-purespinor-stabilizer-shadow-strategy-20260707` |
| M4-WIT | Concrete Pauli/Pontryagin witness | Krein-sharp carrier instantiation and positive-sector probe | `ne-next-m4-pauli-pontryagin-krein-positive-probe-proof-20260707` |
| HSTAR | Model-by-model constraint audits | Harvest `b1980b93`; then integrate/audit the quotient action or open the Gauss-covector rank interface | `ne-next-hstar-ward-descent-quotient-action-integration-audit-20260707` |
| PLUMBING | Cross-lane real structures | Compatibility table for `J_R`, edge reversal, monodromy inversion, `#`, linearity, and antilinearity | `ne-next-plumbing-jr-edge-reversal-sharp-compatibility-audit-20260707` |
| Q13 | Red-team / no-go | Re-audit Q12 E4, W2a bridge, RG-Schur, and latest manuscript wording for the four over-claim modes | `ne-next-q13-e4-w2a-rg-overclaim-regression-audit-20260707` |
| Manuscript | P1 v3 / scorecard / thread board | Synchronize claim grades after the next integration wave | `ne-next-manuscript-p1-round2-scorecard-threadboard-sync-audit-20260707` |
| LIT-PROV | Literature and provenance | Close source-key and convention-citation gaps from the harvested provenance audit | `ne-next-lit-nullstrand-source-provenance-closeout-audit-20260707` |

Balanced refill rule: when capacity opens, load a mixed pack rather than a proof
monoculture.  A good twelve-lane load is six proof/construction jobs, three or
four strategy jobs, and two or three adversarial audits.  Audits are especially
valuable after local landings such as `E4_nontrivial_healing`, because the Lean
kernel checks the statement, not whether the statement deserves the prose claim.

## Complete solo lane roster

Use this roster as the top-level map when choosing work or refilling
Aristotle.  It is deliberately broader than the immediate harvest queue: every
row is a live research lane unless `THREAD_BOARD.md` or a later ledger entry
parks it.  Treat the names here as baseline lane patterns, not necessarily as
unused launch names; use the refreshed `ne-next-*` names above for new
submissions unless you deliberately mint an even more specific non-colliding
name.

| Lane | Pursuit | Next local artifact | Baseline Aristotle job-name pattern |
|---|---|---|---|
| W1 | Carrier / Weitzenbock `E` slot | Discrete torsion versus symmetric soldering-difference split; guard footprint review | `ne-solo-lane-w1-weitz-eslot-split-proof-20260707` |
| W2a | Aperture and turn identification | Concrete `Q_A` aperture contract plus corrected `Phi = Gamma * phi` turn identity | `ne-solo-lane-w2a-aperture-turn-identification-proof-20260707` |
| W2b | Graded irreducibility | Bigraded slot-normal-form route to no-common-carrier | `ne-solo-lane-w2b-bigraded-irreducibility-strategy-20260707` |
| W2c | Relative exhaustiveness / PBW | Normal-form statement and named obstruction terms for dropped hypotheses | `ne-solo-lane-w2c-pbw-exhaustiveness-obstruction-audit-20260707` |
| CAPSTONE | Four-slot carrier identity | Assembly of already guarded finite summands only; no spectral mass wording | `ne-solo-lane-capstone-four-slot-identity-redteam-audit-20260707` |
| OS1 | Strong-coupling gap scaffold | Genuine small-`beta` multiplaquette character/polymer rung beyond zero-coupling fixtures | `ne-solo-lane-os1-smallbeta-multiplaquette-rung-proof-20260707` |
| QC / QC-GRAM | Closure readout and normalization | Exact finite readout, Gram/Laplacian normalization, and carrier-side contract boundaries | `ne-solo-lane-qc-exact-readout-normalization-proof-20260707` |
| PH / RP | Product-Haar to Wilson-measure RP | Gap audit from banked product-Haar positivity to interacting Wilson measure | `ne-solo-lane-rp-producthaar-wilson-measure-gap-audit-20260707` |
| KP / Penrose | Fixed-forest injection | Support lemmas or no-go certificate for the Penrose partition route | `ne-solo-lane-kp-fixedforest-fiber-injection-support-strategy-20260707` |
| Q01 | Gupta-Bleuler physical positivity | Wire the unbalanced finite witness to actual carrier/Gauss constraints, Ward invariance, and completeness | `ne-solo-lane-q01-gauss-constraint-positive-quotient-proof-20260707` |
| Q02 | Gravity / invariant `E`-slot | Invariant trace functional, P-probe boundary, and teleparallel wording guard | `ne-solo-lane-q02-invariant-trace-teleparallel-eslot-audit-20260707` |
| Q03 | Dispersion and doublers | Determinant/wedge dispersion identity plus explicit doubler and mass-shell ledger | `ne-solo-lane-q03-dispersion-doubler-determinant-ledger-proof-20260707` |
| Q04 strand-Fock | SM fiber selection | Pentad fiber, hypercharge/Z6 rigidity, supertrace/anomaly finite identities | `ne-solo-lane-q04-strand-pentad-hypercharge-z6-proof-20260707` |
| Q04 octonion bridge | XOR-Fano to `Lambda(C^3)` | Operator-valued left-action bridge after sign-gauge and ConventionBridge landings | `ne-solo-lane-q04-octonion-lambdac3-leftaction-bridge-strategy-20260707` |
| Q05 | Triality as monodromy | Equivariant index, cover multiplicativity, no-four-orbit lemma, and monodromy kill conditions | `ne-solo-lane-q05-triality-monodromy-equivariant-index-strategy-20260707` |
| Q06 | Continuum / GW / refinement | Edge-reversal, hidden Wilson term, quotient-then-limit, HSSC/UM, and heterogeneous path-sum gates | `ne-solo-lane-q06-refinement-gw-hssc-um-audit-20260707` |
| Q07 | Mass values / T-solder | Koide equipartition, kappa gate, tetrahedral probe, and Hessian/oracle tests | `ne-solo-lane-q07-tsolder-koide-kappa-killgate-audit-20260707` |
| Q08 | Fock / checkerboard / LGV | Graded radical assembly and multi-layer brick-wall LGV lift after the corrected scattering DAG | `ne-solo-lane-q08-fock-graded-radical-lgv-lift-proof-20260707` |
| Q09 | Horizon / screen area / modular | Finite Reeh well-posedness, concrete BW-cut locality witness, entropy boundary | `ne-solo-lane-q09-screenarea-bwcut-reeh-witness-audit-20260707` |
| Q10 | Signature and dimension | Stable-order boundary plus Spin/Weyl same-chirality scalar-amplitude classification | `ne-solo-lane-q10-spinweyl-scalar-amplitude-classification-strategy-20260707` |
| Q11 | `J_R` / KO / RC0 | Jacobi/Cauchy-Binet cleanup, determinant cocycle, order-condition uniqueness | `ne-solo-lane-q11-jr-rc0-ordercondition-integration-proof-20260707` |
| Q12 | Chirality-solder / C8 / anomaly | Non-permutation Furey bridge, PSA-2/3 determinant-line phases, sector McKean-Singer gates | `ne-solo-lane-q12-c8-psa-sector-ms-bridge-audit-20260707` |
| RG-SCHUR | Coarse-graining | Concrete Schur-step witness that null microstructure can generate non-null mass terms | `ne-solo-lane-rg-schur-nullnilpotency-instability-proof-20260707` |
| C-1FORM | Finite center/twist backgrounds | Twist-sector API and honest RP/background-cohomology boundary | `ne-solo-lane-c1form-twistsector-rp-background-audit-20260707` |
| SPIN10-U5 | Pure-spinor internal selection | `Lambda(C^5)` / U(5) pure-spinor-line stabilizer shadow | `ne-solo-lane-spin10-u5-purespinor-stabilizer-strategy-20260707` |
| M4-WIT | Concrete Pauli/Pontryagin witness | Carrier-owned Krein-sharp instantiation and positivity probe | `ne-solo-lane-m4-pauli-pontryagin-carrier-instantiation-proof-20260707` |
| HSTAR | Model-by-model constraint audits | Nullity/rank of Gauss covectors, Ward identity, p > q nonvacuity, real-split kill scan | `ne-solo-lane-hstar-gauss-ward-realsplit-model-audit-20260707` |
| PLUMBING | Cross-lane real structures | `J_R`, edge reversal, monodromy inversion, `#`, and linear/antilinear compatibility table | `ne-solo-lane-plumbing-jr-edge-reversal-sharp-audit-20260707` |
| Q13 | Red-team / no-go | Four over-claim modes across the next batch of integrations | `ne-solo-lane-q13-global-overclaim-regression-audit-20260707` |
| Manuscript | P1 v3 / scorecard / thread board | Claim grades, ledger, thread board, and manuscript consistency after new landings | `ne-solo-lane-manuscript-scorecard-threadboard-sync-audit-20260707` |
| LIT-PROV | Literature and provenance | Source-key gaps, convention citations, and paper-dependent claim boundaries | `ne-solo-lane-lit-provenance-source-gap-audit-20260707` |

If Aristotle capacity is available after harvests, load a balanced pack from
this roster: five to seven proof/construction jobs with isolated statements,
three to four strategy jobs for design forks, and two or three adversarial
audits for recent or claim-risky integrations.  Prefer a parked, well-named
audit over a duplicate proof packet.

## Lane catalog

Keep all of these lanes alive, with priority set by current blockers,
Aristotle returns, and kernel-ready finite targets.  A lane may produce Lean,
an Aristotle proof/audit/strategy job, a no-go certificate, or a parked MEMO
with explicit kill conditions.

1. **Carrier / Weitzenbock square.** Maintain the carrier square stack:
   null-Clifford nilpotency, soldered square = `Q_A`, Weitzenbock master,
   `Q_T` turn/potential slot, `Q_C` closure slot, E-slot/torsion remainder,
   Krein square, concrete torus witnesses, and `CarrierAxiomGuard`.
2. **Gupta-Bleuler / Krein positivity.** Build on the finite GB and
   Kugo-Ojima results: `V'/N`, radical = charge image, nondegenerate quotient,
   descent under unitary/constraint-preserving maps, and the open positivity
   gate.  Do not claim a positive Hilbert quotient without the missing finite
   positivity hypothesis.
3. **GateYM / Q_C / OS1 / KP / RP.** Continue the closure/Q_C normalization,
   scalar and operator Gram checks, strong-coupling OS1 scaffold,
   reflection-positivity/product-Haar infrastructure, and Penrose/KP
   fixed-forest injection route.
4. **Checkerboard-GW / retarded transfer.** Use the exact GW relation,
   edge-reversal grading, palindromic transfer convention, hidden Wilson-term
   dispersion identity, and carrier-level GW generalization/counterexample
   search as one coherent Q06 rail.
5. **Equipartition / Koide / T-solder.** Continue the equipartition sum rule,
   Brannen/phase form, T-solder degree/kappa analysis, tetrahedral corner
   probe P1, and GATE M-KOIDE pre-registered kills.
6. **Fock / second quantization.** Develop the Q08 exterior algebra route:
   `dGamma` square identity, exterior quotient `Fock(V')/rad = Fock(V'/N)`,
   two-particle checkerboard determinant, and finite Pauli-vs-Sym positivity
   selection conjecture.
7. **Horizon / screen area.** Extend only from the proved finite screen-area
   polarization and null-screen wedge positivity.  Audit entropy, BW-cut,
   Jacobson, ANEC, and continuum horizon claims before promoting anything.
8. **Signature / dimension selection.** Kernelize the Q10 ladder:
   definite-no-null, split `Z^(2,2)` frustration, Lorentzian transitivity,
   null-orthogonality rigidity, split tachyonic mass witness, and
   same-chirality scalar-amplitude census.  Boundary: signature from stable
   order; dimension from chirality plus scalar-amplitude reconstruction.
9. **Real-structure / KO / unimodularity seam.** Pursue the Q11 rail:
   top-form-duality `J_R` on `Lambda(C^5)`, sign tables, internal positive
   form, KO placement, RC0/unimodularity equivalence, B-L counterexample,
   C3 Majorana identity, order-condition relocation, and the chirality-solder
   flag.  Do not say unimodularity follows from Krein closure.
10. **Chirality-solder / G2 parity / anomaly gates.** Pursue the Q12 audit:
   G2-parity mechanism, `tau Gamma' = Gamma'`, equivariant McKean-Singer by
   charge sector, PSA anomaly gates, C8 seam/J_R compatibility, and
   convention/lift checks before any safety claim.
11. **Strand-fock / Standard Model selection.** Keep the Q04/Q05 rails active:
    supertrace identity, pentad fiber, turn census, hypercharge/Z_6 rigidity,
    triality-as-monodromy, no-four orbit lemma, Distler-Garibaldi translation,
    and the octonion/Fock convention bridge.
12. **RG-Schur / coarse-graining.** Develop Schur-complement determinant
    identities, RG stability of Krein-self-adjoint Gamma-odd structure,
    instability of per-edge null nilpotency under blocking, and uniform
    majorant gate UM.
13. **Cross-lane real-structure plumbing.** Treat `J_R`, edge-reversal
    conjugation, base/fiber real structures, and `#` compatibility as plumbing
    that connects Q03, Q04 C8, Q06 edge reversal, Q11, and Q12.  Every use
    must say whether it is linear, antilinear, bilinear, or sesquilinear.
14. **Finite one-form center symmetry / twist backgrounds.** Continue the
    finite line-holonomy, electric-sector, twist-sector, and RP-background
    API.  Keep the hard boundary: finite sector bookkeeping is not a continuum
    center-symmetry Ward identity, confinement theorem, anomaly theorem, or
    cohomology classification.
15. **Spin(10) / U(5) / pure-spinor internal selection.** Pursue the strand-Fock
    bridge to the `Lambda(C^5)`/SU(5) presentation, pure-spinor-line stabilizer
    shadows, hypercharge/Z_6 rigidity, and the honest finite substitute for the
    Spin(10) selection story.  Do not revive any already-falsified Spin(10)
    transitivity claim.
16. **Concrete witnesses and positivity probes.** Keep the M4 Pauli/Pontryagin
    witness, Krein-positive-sector probes, tetrahedral T-solder probes, and
    small finite Hessian/oracle checks as reality tests for speculative lanes.
    A witness may promote, kill, or re-scope a theorem; record which happened.
17. **Round-2 red-team / no-go audit.** Treat Q13 and the four over-claim modes
    as an active lane, not a cleanup chore.  Hunt for vacuity, hollow
    telescoping, docstring-outruns-kernel, false shape, and convention drift
    across the round-1 and round-2 synthesis.
18. **Manuscript / scorecard / provenance.** Keep P1 v3, the honest scorecard,
    thread board, ledger, lit log, and claim grades aligned with what is
    actually kernel-checked or explicitly MEMO/OPEN.

### Solo pursuit matrix

Use this matrix to keep the run broad without becoming diffuse.  Each row is a
real lane.  A cycle should either advance one row locally, harvest an Aristotle
return for it, submit the named next job when capacity exists, or explicitly
record why the row is parked.

| Lane key | Pursuit | Current next local artifact | Aristotle use |
|---|---|---|---|
| W1 | Carrier / Weitzenbock assembly | `E`-slot torsion/soldering split and guard review | proof/strategy for the exact `E`-slot hypotheses |
| W2a | `Q_A` / `Q_T` identification | turn-slot `Phi = Gamma * phi` correction and aperture contract | proof job for corrected turn identity |
| W2b | Graded irreducibility | bigraded slot normal form and no-common-carrier statement | strategy/audit before proof hardening |
| W2c | Relative exhaustiveness | PBW/rewriting normal form with named obstruction terms | audit/strategy; do not fake exhaustiveness |
| CAPSTONE | Four-slot identity | semantic assembly of guarded summands only | adversarial audit for false mass-form wording |
| OS1 | Strong-coupling gap | next finite character/polymer small-beta rung | proof job for a real multiplaquette step |
| QC / QC-GRAM | Closure / `Q_C` | raw closure vs Gram/Laplacian normalization split | proof/audit for exact finite readout contracts |
| PH / RP | Product-Haar reflection positivity | gap from product-Haar bank to Wilson measure | audit/strategy |
| KP / Penrose | Fixed-forest injection | support lemmas or no-go for Penrose partition route | proof/strategy follow-up |
| Q01 / GB-QUOTIENT | Gupta-Bleuler positivity | integrate finite witness/no-go into carrier/Gauss constraint hypotheses | proof/audit after the model-level statement is isolated |
| Q02 / G-TP | Gravity / E-telescope | corrected telescoping, P-probe, finite gravity boundary wording | audit with kill conditions |
| Q03 / DISPERSION | Dispersion and doublers | determinant/wedge identity plus doubler ledger | proof job |
| Q04 / STRAND-FOCK | Pentad fiber / anomaly | supertrace and finite-difference anomaly statements | proof job |
| Q04 / octonion bridge | XOR-Fano / Furey bridge | `Lambda(C^3)` left-action/operator bridge after sign-gauge and Baez-line products landed | follow-up strategy/audit |
| Q05 | Triality / monodromy | cover multiplicativity, equivariant index, no-four orbit | strategy job |
| Q06 | Checkerboard-GW / transfer | heterogeneous edge-word/path-sum lift beyond the landed homogeneous transfer-power bridge | follow-up lift strategy; do not resubmit the landed bridge |
| Q07 | Koide / T-solder | tetrahedral corner probe, kappa and Hessian gates | audit/strategy |
| Q08 / FOCK-GB | Exterior Fock / checkerboard | graded radical assembly plus multi-layer/generic LGV lift after the corrected scattering-DAG landing | proof/strategy follow-ups |
| Q09 | Horizon / screen area | finite Reeh gate and BW-cut witness after the A9.1 degeneracy/invariance landing | strategy/audit, then proof only after hypotheses are exact |
| Q10 | Signature / dimension | scalar-amplitude reconstruction and stable-order boundary audit after the intrinsic inertia-index landing | classification strategy/audit |
| Q11 | `J_R` / KO / RC0 | Jacobi/Cauchy-Binet cleanup, order-condition uniqueness | active proof, then integration audit |
| Q12 | Chirality-solder / C8 / anomaly | non-permutation Furey bridge, triality wording, PSA-2/3 | active proof/audit, then sector gates |
| RG-SCHUR | Coarse-graining | nilpotency failure witness, Berezin layer, and complex-star sharp after Schur determinant/Krein-Gamma stability landing | audit/proof follow-ups |
| C-1FORM | Twist backgrounds | finite line-holonomy/twist-sector API boundary | audit |
| SPIN10-U5 | Pure-spinor internal selection | U(5) / pure-spinor-line stabilizer shadow | strategy |
| M4-WIT | Concrete witnesses | Pauli/Pontryagin and positivity probes | proof/audit as a reality test |
| Q13 | Red-team / no-go | four over-claim modes across new landings | recurring audit job |
| Manuscript | P1 v3 / scorecard / provenance | claim grades, thread board, ledger, lit log consistency | recurring audit job |

## Aristotle lane loading board

Keep Aristotle busy with independent, high-quality jobs, not duplicate packets.
Before every submission wave, check `aristotle list`, `aristotle tasks`, and
`ARISTOTLE_LANE_DOCKET_2026-07-07.md`; count still-running jobs first, harvest
completed jobs before refilling, and do not resubmit an active target under a
new name.  Project directories and Aristotle project names should match the job
name exactly.  If the calendar date changes, update the suffix from `20260707`
to the current date.

Live queue snapshot from the latest local poll on 2026-07-07 (verify again with
`aristotle list` before acting):

- **Still running / poll first:** the current running set has eleven
  StandardModel-relevant lanes: the older Q11 Jacobi/Cauchy-Binet lane
  `aa4e48f6`, the W2a `Q_A`/Minkowski bridge `ecbf61d8`, and the nine
  still-running solo-lane refill projects listed below.
- **Harvest-first before more refill:** Q13 global overclaim (`07f40fff`) and
  literature/provenance (`5713746e`) have already been harvested.  The Q12 E4
  radical-healing proof job (`297ae18c`) was canceled after Codex locally
  proved `E4_nontrivial_healing`.  If any listed running job turns `IDLE`,
  harvest and integrate/audit it before submitting a duplicate target under a
  new name.
- **Recently harvested; do not resubmit under new names:** Q08 fixed-degree
  Fock quotient bridge, Q08 same-parity nonvacuous checkerboard / naive LGV
  kill, Q08 corrected scattering-vertex LGV DAG, Q12 genuine non-diagonal
  triality witness, Q12 C8 non-permutation Hadamard bridge, manuscript postfix
  claim-grade audit, Q01 finite positive-sector witness/no-go, Q06 edge-reversal
  transfer-power bridge, Q09 screen-area degeneracy/invariance completion,
  Q10 intrinsic inertia-index bridge, Q04 sign-gauge reconciliation, Q04
  Baez-to-XOR ConventionBridge line products, RG-Schur determinant/Krein-Gamma
  stability,
  Q11/Q04 C3 Majorana turn census, Q06 Wilson-symbol determinant /
  Wilson-scalar identity, Q09 nullscreen entropy kill audit, Q04 octonion/Fock
  convention audit, Q12 C8 compatibility audit, Q11 RC0 determinant-cocycle
  strategy, P1 manuscript claim audit, Q08 `dGamma` globalization and
  integration audit, Q08 L4 checkerboard determinant, Q09 BW-cut locality
  scaffold, Q10 Sylvester-inertia bridge, Q10 multi-time embedding, Q11 B-L
  dictionary, Q12 GammaPrime quotient, Q12 Furey bridge audit, Q12 charge
  resolution, Q12 triality bridge, Q12 PSA-1, Q12 G2 parity, Q13 red-team
  audit, Q10 Lorentzian transitivity, Q10 split witness, Q10 scalar-amplitude
  census, Q09 modular no-go, Q08 decomposable `dGamma` square, and Q06
  carrier-GW positive/negative cases.
- **Canceled/redundant:** `ne-q06-palindrome-gw-no-native-proof-20260707`
  is superseded by the local compiler-trust-free landing; the Q12 E4
  radical-healing proof job `297ae18c` is superseded by the local
  `E4_nontrivial_healing` landing.

Active solo refill wave.  These names are already submitted and should be
treated as running/harvest-first until the docket records their result:

| Project | Status | Aristotle job name | Lane | Type |
|---|---|---|---|---|
| `aa4e48f6` | running | `ne-q11-jacobi-minor-cauchybinet-rc0-cleanup-proof-20260707` | Q11 RC0 | proof/strategy |
| `ecbf61d8` | running | `ne-solo-lane-w2a-qa-minkowski-detp-bridge-proof-20260707` | W2a aperture | proof/strategy |
| `96058502` | running | `ne-solo-lane-q12-c8-psa-sector-ms-bridge-audit-20260707` | Q12 PSA / C8 bridge | audit/strategy |
| `82cc3c8e` | running | `ne-solo-lane-rg-schur-nullnilpotency-instability-proof-20260707` | RG-Schur | proof/strategy |
| `b4206467` | running | `ne-solo-lane-q08-fock-graded-radical-lgv-lift-proof-20260707` | Q08 Fock / LGV | proof/strategy |
| `4b462390` | running | `ne-solo-lane-q09-screenarea-bwcut-reeh-witness-audit-20260707` | Q09 screen / BW | audit/strategy |
| `373f0283` | running | `ne-solo-lane-q01-gauss-constraint-positive-quotient-proof-20260707` | Q01 Gauss positivity | proof/audit |
| `05fdd744` | running | `ne-solo-lane-q10-spinweyl-scalar-amplitude-classification-strategy-20260707` | Q10 scalar amplitude | strategy/proof |
| `6e37da00` | running | `ne-solo-lane-q04-octonion-lambdac3-leftaction-bridge-strategy-20260707` | Q04 octonion bridge | strategy/audit |
| `ef87c91f` | running | `ne-solo-lane-q02-invariant-trace-teleparallel-eslot-audit-20260707` | Q02 E-slot / trace | audit |
| `16d04733` | running | `ne-solo-lane-hstar-gauss-ward-realsplit-model-audit-20260707` | HSTAR model audit | audit/strategy |

Last refill pack, now partly harvested.  Treat these names as already submitted,
not as open capacity, unless the docket explicitly records a renewed follow-up:

| Priority | Aristotle job name | Lane | Type | Intended deliverable |
|---|---|---|---|---|
| 1 | `ne-q08-dgamma-exterior-globalization-integration-audit-20260707` | Q08 `dGamma` | audit | Semantic audit of the globalization landing: decomposable identity vs full exterior-algebra operator, no overclaim. |
| 2 | `ne-q08-radical-exterior-ideal-pairing-proof-20260707` | Q08 Fock quotient | proof | Exact perfect-pairing/ideal statement needed for `Fock(V')/rad = Fock(V'/N)`, after the running pairing-dual job returns. |
| 3 | `ne-q08-l4-two-particle-checkerboard-rational-determinant-proof-20260707` | Q08 checkerboard Fock | proof | L=4 two-particle checkerboard determinant identity over rational polynomials. |
| 4 | `ne-q11-exterior-det-cocycle-rc0-group-proof-20260707` | Q11 group RC0 | proof/strategy | Upgrade Cartan RC0 to the exterior-functor determinant cocycle or return the exact missing hypothesis. |
| 5 | `ne-q11-c3-majorana-turn-census-proof-20260707` | Q11/Q04 Majorana | proof | Finite C3 Majorana identity and bare-turn invariant census with order-condition flags explicit. |
| 6 | `ne-q12-furey-ladder-bridge-matrix-entry-audit-20260707` | Q12 convention bridge | audit | Entrywise audit of the specific repo ladder/Furey bridge matrix against XOR-Fano signs and ordering. |
| 7 | `ne-q12-gammaprime-quotient-equivariance-audit-20260707` | Q12 quotient chirality | audit/strategy | Decide exact finite hypotheses for `tau Gamma' = Gamma'` downstairs before any per-sector index claim. |
| 8 | `ne-q06-retarded-wilson-symbol-determinant-proof-20260707` | Q06 transfer/GW | proof | Determinant-level "retardedness is the Wilson term" dispersion identity, respecting the palindromic/nonabelian boundary. |
| 9 | `ne-q09-bwcut-torus-modular-locality-audit-20260707` | Q09 horizon/modular | audit | Finite torus BW-cut matrix-locality test and kill conditions after the positive-generator no-go. |
| 10 | `ne-q10-sylvester-inertia-frustrated-triple-bridge-proof-20260707` | Q10 signature | proof/strategy | Bridge the diagonal-signature frustrated triple to a general Sylvester-inertia statement, or isolate the obstruction. |
| 11 | `ne-q01-krein-positive-sector-witness-or-no-go-audit-20260707` | Q01 positivity | audit | Nonvacuous positive-sector witness, or a sharp no-go separating quotient nondegeneracy from positivity. |
| 12 | `ne-q13-round1-verdict-redteam-audit-20260707` | Q13 red team | audit | Adversarial audit of the round-1 verdicts and recent landings for the four over-claim modes. |

Older detailed refill backlog.  These names are useful target descriptions, but
some are now active, harvested, or too close to active names.  For any new
submission, prefer the `ne-next-*` launch names in the 2026-07-07 lane refresh
above, or mint an even more specific non-colliding name after checking the
docket:

| Lane | Earlier Aristotle job-name pattern | Type | Intended deliverable |
|---|---|---|---|
| W1 carrier E-slot | `ne-w1-eslot-torsion-soldering-splitting-followup-proof-20260707` | proof/strategy | Carrier `E` slot split into antisymmetric torsion and symmetric soldering-difference pieces, with exact vanishing hypotheses. |
| W2a turn slot | `ne-w2a-phi-gamma-turnslot-corrected-identity-proof-20260707` | proof | Corrected turn-slot identity, keeping the gamma-even cancellation mistake dead. |
| W2b irreducibility | `ne-w2b-bigraded-normalform-no-common-carrier-strategy-20260707` | strategy/audit | Bigraded slot-normal-form route for the upgraded no-common-carrier theorem. |
| W2c exhaustiveness | `ne-w2c-relative-exhaustiveness-pbw-obstruction-audit-20260707` | audit/strategy | PBW/rewriting route for relative exhaustiveness and the exact extra terms when hypotheses are dropped. |
| Capstone | `ne-capstone-graded-four-slot-identity-overclaim-audit-20260707` | audit | Adversarial check that the capstone is only an identity of graded summands unless extra spectral hypotheses are proved. |
| OS1 gauge gap | `ne-os1-smallbeta-character-polymer-next-rung-proof-20260707` | proof | Genuine finite small-beta multiplaquette KP/character-polymer rung beyond saturated beta-zero fixtures. |
| QC exact finite cycle | `ne-qc-torus-transfer-readout-normalization-proof-20260707` | proof | Exact finite Z2 two-torus readout/correction theorem or a precise obstruction to the next normalization. |
| QC carrier bridge | `ne-qc-carrier-closure-gram-contract-audit-20260707` | audit | Whether any concrete carrier-side closure-to-scalar statement is available without smuggling in a measure theorem. |
| Product-Haar/RP | `ne-rp-producthaar-to-wilson-measure-gap-audit-20260707` | audit/strategy | Gap analysis from banked product-Haar positivity to interacting Wilson-measure reflection positivity. |
| KP/Penrose | `ne-kp-penrose-fixedforest-support-lemma-followup-proof-20260707` | proof/strategy | Follow-up support lemmas for the fixed-forest fiber-injection route, or a no-go certificate. |
| Q01 Gupta-Bleuler | `ne-q01-carrier-gauss-positive-subquotient-wiring-proof-20260707` | proof/audit | Wire the finite unbalanced witness to actual carrier/Gauss constraints, or isolate the missing Ward/completeness hypotheses. |
| Q01 positivity audit | `ne-q01-kugo-ojima-witness-physical-interpretation-audit-20260707` | audit | Lock the boundary between the finite witness/no-go and any carrier-level physical-sector claim. |
| Q02 gravity/E-slot | `ne-q02-eslot-teleparallel-pprobe-gravity-boundary-audit-20260707` | audit | Corrected E-telescope plus P-probe review for gravity-interface wording and finite kill conditions. |
| Q03 dispersion | `ne-q03-wedge-dispersion-doubler-ledger-proof-20260707` | proof | Determinant/wedge dispersion identity and explicit doubler ledger targets. |
| Q04 strand-fock | `ne-q04-pentad-supertrace-anomaly-difference-proof-20260707` | proof | Exterior supertrace/anomaly identity and finite-difference corollary on the pentad fiber. |
| Q04 color bridge | `ne-q04-octonion-leftaction-lambdac3-operator-bridge-strategy-20260707` | strategy | Operator-valued `Lambda(C^3)` bridge using left-multiplication operators and the landed sign/convention bridges, without raw-octonion associativity assumptions. |
| Q04 sign regression | `ne-q04-baez-furey-xorfano-sign-table-regression-audit-20260707` | audit | Post-proof regression audit for the sign-gauge and ConventionBridge corrections. |
| Q05 triality | `ne-q05-triality-monodromy-cover-index-strategy-20260707` | strategy | Equivariant index, cover multiplicativity, triangle holonomy toy model, and no-four-orbit route. |
| Q06 carrier derivation | `ne-q06-heterogeneous-pathsum-edgeword-gw-lift-strategy-20260707` | strategy/audit | Lift the landed homogeneous transfer-power bridge toward heterogeneous decoration-level generator conjugation and path-sum layers. |
| Q07 Koide/T-solder | `ne-q07-koide-tsolder-kappa-hessian-witness-audit-20260707` | audit/strategy | Decide whether the tetrahedral corner probe supports, refines, or kills the kappa mechanism. |
| Q08 exterior quotient | `ne-q08-exterior-quotient-graded-radical-assembly-proof-20260707` | proof/strategy | Assemble the literal graded radical/ideal quotient statement beyond fixed-degree exterior powers. |
| Q08 checkerboard Fock | `ne-q08-multilayer-brickwall-firstsharedvertex-lgv-lift-strategy-20260707` | proof/strategy | Lift the landed one-vertex scattering DAG to a multi-layer brick wall with a generic first-shared-vertex swap. |
| Q09 horizon/screen | `ne-q09-finite-reehschlieder-wellposedness-gate-strategy-20260707` | strategy/audit | After the A9.1 landing, isolate exact finite Reeh-screen hypotheses or return a no-go/well-posedness obstruction. |
| Q09 BW witness | `ne-q09-bwcut-locality-witness-construction-audit-20260707` | audit/strategy | Feed the BW-cut locality rubric a concrete witness or record why none is available. |
| Q10 scalar amplitude | `ne-q10-spin-weyl-scalar-amplitude-real-classification-strategy-20260707` | strategy | Route from finite census substitutes to real Spin/Weyl scalar-amplitude classification. |
| Q10 stable-order boundary | `ne-q10-stable-order-dimension-reconstruction-boundary-audit-20260707` | audit | Keep signature theorem, dimension reconstruction, and physical interpretation separated. |
| Q11 RC0 integration | `ne-q11-exterior-cocycle-groupaction-integration-audit-20260707` | audit | Review any Jacobi/Cauchy-Binet landing for semantic alignment and hidden assumptions. |
| Q11 Majorana/order | `ne-q11-ordercondition-invariant-operator-uniqueness-strategy-20260707` | strategy | Upgrade C3 sector-level identities toward operator-level invariant uniqueness and order-condition verdicts. |
| Q12 PSA gates | `ne-q12-psa23-determinantline-phase-gates-strategy-20260707` | strategy/audit | PSA-2/3 determinant-line phases and anomaly-gate promotion conditions. |
| Q12 `J_R` descent | `ne-q12-jr-descent-sector-conjugation-proof-20260707` | proof/strategy | Involution descent and sector conjugation gates for the C8 seam. |
| Q12 equivariant MS | `ne-q12-equivariant-ms-sector-index-promotion-audit-20260707` | audit | Exact finite-to-analytic boundary for charge-resolved equivariant McKean-Singer. |
| RG-Schur | `ne-rg-schur-blocking-nullnilpotency-failure-audit-20260707` | audit/strategy | What RG blocking preserves, and where per-edge null nilpotency provably fails. |
| C-1FORM/charge | `ne-c1form-finite-twist-sector-rp-background-api-audit-20260707` | audit | Whether the finite twist-sector API can honestly support an RP/background-cohomology bridge. |
| SPIN10-U5 | `ne-spin10-u5-purespinor-line-stabilizer-shadow-strategy-20260707` | strategy | Mathlib/PhysLean route to the pure-spinor-line stabilizer rung or an honest finite shadow. |
| M4 witness | `ne-m4-pauli-pontryagin-positive-sector-probe-proof-20260707` | proof/audit | Concrete positivity probe that can promote, kill, or re-scope the KPON/Q01 story. |
| Q13 red team | `ne-q13-postrefill-overclaim-regression-audit-20260707` | audit | Red-team the new refill harvests for vacuity, hollow telescoping, docstring outruns kernel, and false shape. |
| Manuscript/claims | `ne-manuscript-round2-scorecard-threadboard-consistency-audit-20260707` | audit | Reconcile P1 v3, scorecard-style docs, thread board, and ledger after the next integration wave. |
| Provenance/lit | `ne-lit-nullstrand-source-provenance-gap-audit-20260707` | audit | Find paper/source-provenance gaps in the newest manuscript and Lean/doc claims. |

Use this table as a queue, not a quota.  Maintain roughly twelve active
StandardModel-relevant Aristotle lanes during autonomous periods by mixing:
proof jobs that have isolated statements, strategy jobs for design forks, and
adversarial audits for recently landed or high-risk claims.

## Research goals aligned to the new repo material

1. **Q09 horizon/screen area.** Turn the area-as-relational-aperture memo into
   finite algebra: screen polarization of the `2 x 2` determinant, null-screen
   wedge-count formulas, positivity, and honest boundaries.  A9.1 now has the
   degeneracy iff and simultaneous determinant-one invariance landing; the next
   gates are a finite Reeh-screen theorem or no-go, a concrete BW-cut locality
   witness, and the entropy/Jacobson/ANEC boundary.  The universal entropy
   coefficient remains false-shape across complexes.  Park entropy, Jacobson,
   BW-cut, and ANEC claims as MEMO/strategy until their finite hypotheses are
   stated and checked.
2. **Q10 signature/dimension selection.** Treat signature as the order-side
   theorem rail and dimension as a reconstruction rail.  Kernelize the finite
   ladder first: definite-no-null, the `Z^(2,2)` frustrated-triple obstruction,
   Lorentzian positive-pairing transitivity, null-orthogonality rigidity,
   split-signature tachyonic witnesses, and the same-chirality scalar-amplitude
   census.  The Sylvester-equivalent bridge and intrinsic numerical-index
   witness form (`p >= 2`, `q >= 2` via positive/negative definite subspaces)
   are now landed; next targets are stable-order semantic audits and the
   scalar-amplitude reconstruction/classification ladder.  Never claim "3+1
   from consistency alone"; use the Q10 boundary: signature is a theorem about
   stable order, dimension is conditional on the named chirality and
   scalar-amplitude axioms.
3. **Q11 real-structure / KO / unimodularity seam.** Develop the explicit
   `J_R` construction on `Lambda(C^5)`, the sign tables, positive internal
   form, KO placement, RC0/unimodularity equivalence, B-L counterexample,
   C3 Majorana identity, and order-condition relocation.  Treat the
   "Krein closure gives unimodularity" slogan as corrected/false.
4. **Q12 chirality-solder audit.** Develop the G2-parity thread, the new
   constraint-equivariance hypothesis `tau Gamma' = Gamma'`, the
   charge-resolved equivariant McKean-Singer prerequisite, and the PSA anomaly
   gates.  Treat "factor separation" as superseded by the stronger G2-parity
   mechanism; do not claim safety without the bridge/convention check.
5. **Q06-Q08 synthesis.** Use the new exact-GW/edge-reversal, equipartition
   Koide, Fock-Gupta-Bleuler, checkerboard determinant, and RG-Schur material as
   active research rails.  Q08 L4 is landed in a minimal disjoint-support form;
   the next targets are the exterior quotient theorem, a multi-layer
   brick-wall lift of the landed scattering-vertex DAG, and a generic
   first-shared-vertex swap/full signed-LGV lemma.  Convert near-free finite
   identities into Lean, and keep speculative physics claims explicitly MEMO or
   OPEN.
6. **QC-GRAM and Q_C.** Continue the closure/Q_C line: distinguish raw linear
   closure defects from Gram/Laplacian normalization, pursue concrete Carrier
   factorization only with the correct normalization, and keep beyond-leading
   positivity claims open unless proved.
7. **OS1/KP/RP infrastructure.** Continue the Osterwalder-Seiler,
   product-Haar/RP, character/polymer, and Penrose/KP routes when they are the
   highest-EV finite targets.  Prefer exact support lemmas and honest no-go
   statements over broad gap claims.
8. **Manuscript/status alignment.** Keep the P1 v3 manuscript, thread board,
   scorecard, and ledger aligned with what is actually kernel-checked.  New
   MEMO-grade material should improve the roadmap without being promoted to
   PROVED.

## Immediate solo workflow

1. **Harvest fresh in-repo context.** Read and act on new files such as
   `AgentTasks/fable_parallel/Q09_answer.md`,
   `AgentTasks/fable_parallel/Q10_answer.md`,
   `AgentTasks/fable_parallel/Q11_answer.md`,
   `AgentTasks/fable_parallel/Q12_answer.md`, the round-2 packet intro, recent
   `LEDGER.md` entries, and
   `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`.
2. **Land kernel-ready finite algebra first.** Prefer small exact statements:
   screen-area/aperture polarization (Q09 L1), finite no-go trace arguments,
   G2 parity checks, equivariant index bookkeeping, quotient descent lemmas,
   QC-GRAM/Q_C normalization, and RG-Schur determinant identities.
3. **Use Aristotle early.** For nontrivial proofs, unclear decompositions,
   statement audits, or strategy choices, prepare focused Aristotle jobs.  Use
   both proof jobs and strategy jobs.  Do not churn on hard Lean when a clean
   Aristotle packet can be made.
4. **Keep Q_C / OS1 / KP alive.** The former Codex lane remains important:
   QC-GRAM and concrete Q_C factorization, Osterwalder-Seiler strong-coupling
   scaffold, product-Haar/RP infrastructure, and the Penrose/KP crux.
5. **Promote or park new ideas honestly.** Each Fable proposal should become
   one of: a kernel theorem, an Aristotle task, a documented handoff, a
   ledger/thread-board update, or a rejected/parked claim with a reason.

## Solo cadence

- Every work cycle: inspect state -> choose highest-EV target -> prove or
  document -> verify -> commit -> ledger heartbeat.
- Literature rounds remain valuable, especially before paper-dependent claims.
  Use the Neo4j/vector scripts or MCP tooling as described in
  `Scripts/MCP_SERVERS.md` and log meaningful deltas in `LIT_LOG.md`.
- Run `aristotle list`/`aristotle tasks` regularly enough to harvest completed
  jobs, but do not busy-wait.  Cancel or park stale jobs by the 2-hour rule.
- Keep Aristotle near saturation when there are enough independent lanes.  Aim
  for roughly twelve active StandardModel-relevant jobs during autonomous
  periods, mixing proof, strategy, and adversarial-audit jobs.
- Every Aristotle submission must have a unique descriptive project directory
  and job name, such as `ne-q10-l3-lorentzian-transitivity-20260707`, not a
  generic pack name.  Record project IDs and deliverables in
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md` or its successor.
- For proof-only jobs, prefer focused Mathlib Lake packages.  Lightweight
  context packs are fine for strategy/audit jobs; if a proof job stalls on
  environment setup, cancel or park it and resubmit as a focused package.
- After every 2-4 meaningful integrations, submit or record an adversarial audit
  pass.  Use Aristotle audit jobs when the integration is mathematically risky.
- If new Fable/Claude text appears in the repo, harvest it promptly: summarize
  decisions in `LEDGER.md`, update `THREAD_BOARD.md` when it changes priorities,
  and create exact Lean/Aristotle targets where possible.  Do not initiate a new
  Fable call yourself.

## Claim discipline

- Use explicit grades: PROVED, MODELED, OPEN, MEMO, strategy, handoff, or
  counterexample/no-go.
- Watch the four over-claim modes on every landing: vacuity, hollow telescoping,
  docstring outruns kernel, and false shape.
- Do not weaken theorem statements silently.  If the intended theorem is too
  hard, leave a precise draft/handoff marker or send it to Aristotle.
- Do not import physical meaning from prose into Lean claims.  Say exactly what
  the kernel proves and what remains interpretation or future work.

## Verification

For each Lean increment:

```text
lake env lean PhysicsSM/Path/To/File.lean
lake build PhysicsSM.Path.To.Module
```

For guarded flagships, also check the relevant guard file:

```text
lake env lean PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean
lake env lean PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean
```

Run `pre-commit run --all-files` before commits.  Do not claim `lake build`
passed unless it was actually run.  For broad or trusted claims, run the
broader build required by `docs/BUILD.md`.

## Commit and log discipline

- Use small commits with prefix `twoday-carrier-202607:`.
- Stage specific files only.  Never `git add -A` blindly.
- Each meaningful commit should have a ledger heartbeat or task note describing:
  what changed, claim grade, verification commands, provenance, and remaining
  issues.
- Leave unrelated untracked context packs, model notes, or peer artifacts alone
  unless they are explicitly part of the harvest being committed.

## Today's north star

The best solo work today turns the newest synthesis into durable artifacts:
kernel-checked finite theorems, guarded statements, exact no-go results,
Aristotle-ready proof packets, and clear claim boundaries.  Be ambitious, but
make the ambition legible to the Lean kernel and to future reviewers.
