# Null-edge unified mass plan: next Aristotle job wave

**No-build strategy/audit deliverable. Generated 2026-06-26.**

This report answers PROMPT Section G: the next wave of Aristotle jobs for the
null-edge unified mass program. No Lean or build command was run. Job targets
reference the theorem chain in
`AgentTasks/null-edge-unified-mass-proof-chain.md` (entries T1-T18) and the
strategy analysis in
`AgentTasks/null-edge-unified-mass-grand-strategy-report.md`.

Job types: **Proof/formalization** (Lean kernel target), **No-build
strategy/audit** (written analysis), **Source/literature** (citation and
prior-art audit). Risk levels: Low / Medium / High refer to the chance the job
returns without a usable result, not to physical risk.

Composition of this wave: 4 proof/formalization jobs (J1-J4), 4 no-build
strategy/audit jobs (J5-J8), 1 source/literature job (J9), 1 prediction/
moduli-rank job (J10). Total 10 jobs (exceeds the requested minimum of 8 with
>= 3 proof, >= 3 no-build, >= 1 source, >= 1 prediction).

Sequencing note: J1-J3 are independent finite-algebra proof jobs and should be
launched in parallel as the first wave. J5 (sign/double-counting audit) should
precede J4 (super-Dirac square). J9 and J10 can run concurrently with the proof
jobs.

---

## J1. Proof: Yukawa checkerboard square + rectangular singular-value theorem

- Title: Finite chiral checkerboard square with a constant Yukawa mass block.
- Goal: prove T5 and T6 -- that null L/R propagation plus a constant
  chirality-flip `M` yields `K_L psi_L = M M^dagger psi_L`,
  `K_R psi_R = M^dagger M psi_R`, and that
  `posSpectrum(M M^dagger) = posSpectrum(M^dagger M)` for rectangular `M`.
- Files/context: a fresh `PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean`
  importing `Mathlib`; convention notes from the Working Plan Sections 6.1,
  15.5, 16.6; sign convention `D^2 = -K + Phi^2` => `K = Phi^2`.
- Exact target: the two checkerboard identities as a single theorem plus the
  positive-spectrum equality as a second theorem; rectangular `M` allowed; zero
  modes characterized.
- Expected output: kernel-clean Lean theorems, no `s o r r y`.
- Why it matters: cleanest proof that a massive elementary fermion is null
  propagation plus an internal chirality-flip gap; the most decisive P1.5 toy
  theorem; directly answers "how can a fermion have mass if motion is null."
- Success criteria: both theorems compile under the pinned toolchain; sign
  convention documented; `M^dagger` defined via the Hilbert inner product.
- Risk: Low. Pure finite algebra; the SVD spectrum equality is near-standard in
  Mathlib.

## J2. Proof: electroweak stabilizer kernel and rank (stage 1)

- Title: Electroweak orbit obstruction -- `ker B_EW = u(1)_em`, `rank = 3`.
- Goal: prove T9 -- for `G = SU(2)_L x U(1)_Y` on `H in C^2`, `Q = T_3 + Y/2`,
  `H_0 = (0, v/sqrt 2)`, the orbit map `B_EW(X) = rho(X) H_0` has kernel
  `span(Q)` and the quadratic form `q(X) = |B_EW(X)|^2` has rank 3.
- Files/context: `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean` importing
  `Mathlib`; Working Plan 6.3, 15.7, 16.8; SM hypercharge convention `Y(H) = 1`,
  `Q = T_3 + Y/2`.
- Exact target: `ew_stabilizer_kernel` and `ew_stabilizer_rank` (stage 1 only;
  coefficient formulas deferred to a later job, T10).
- Expected output: kernel-clean Lean theorems.
- Why it matters: photon masslessness and the three massive directions as a
  structural theorem given the SM group and Higgs rep; the most tractable
  nontrivial electroweak statement; the finite-algebra gateway from Abelian
  Higgs to real electroweak structure.
- Success criteria: kernel equals the span of the charge generator; rank exactly
  3; explicit basis and generator normalization documented; labeled as
  structural theorem (not prediction).
- Risk: Low-Medium. Concrete `C^2` representation computation; the risk is
  basis/normalization bookkeeping.

## J3. Proof: Abelian Higgs gauge-invariant link-stiffness identity

- Title: Finite Abelian Higgs link stiffness on null edges.
- Goal: prove T8 -- `S_H = v^2 sum_e |w_e - 1|^2` with gauge-invariant mismatch
  `w_e = sigma_s^{-1} U_e sigma_t`, plus the gauge-invariance lemma and the
  separate small-holonomy expansion `v^2 |w_e - 1|^2 = v^2 epsilon^2 A_e^2 +
  O(epsilon^4)`.
- Files/context: `PhysicsSM/Draft/NullEdgeAbelianHiggsLink.lean` importing
  `Mathlib`; Working Plan 6.2, 15.6, 16.7; gauge-invariant wording guardrail
  (16.9).
- Exact target: the exact stiffness identity (primary), gauge invariance under
  `phi_v -> g_v phi_v`, `U_e -> g_s U_e g_t^{-1}` (primary), and the expansion
  lemma (secondary, labeled as interpretation).
- Expected output: kernel-clean Lean theorems.
- Why it matters: shows gauge-boson mass can arise on a null-edge graph; bridges
  to the electroweak stabilizer; demonstrates the covariant-reference-section
  framing without "symmetry breaking" language.
- Success criteria: the exact identity and gauge invariance compile; the
  expansion is a clearly-separated lemma so the exact theorem is not conflated
  with the physical interpretation.
- Risk: Low-Medium. Finite algebra + one Taylor bound. Note in the handoff that
  alone this is close to lattice gauge-Higgs theory.

## J4. Proof: graded super-Dirac square with separated gradings

- Title: Graded super-Dirac square `D^2 = -D_N^2 + Phi^2 - i Gamma_s [.,Phi]`.
- Goal: prove T14 -- under
  `Gamma_s^2 = 1`, `{Gamma_s, C_a} = 0`, `[Gamma_s, nabla_a] = 0`,
  `[Gamma_s, Phi] = 0`, `[C_a, Phi] = 0`, derive the square with correct
  `+Phi^2` sign; add the kinetic decomposition
  `D_N^2 = Box_null + C_diamond + T_frame`.
- Files/context: `PhysicsSM/Draft/NullEdgeSuperDiracSquare.lean` importing
  `Mathlib`; NULLSTRAND super-Dirac guardrails; Open Questions 6.9; keep
  `Gamma_s`, `chi_E`, `epsilon_form` distinct.
- Exact target: the graded square theorem and the kinetic decomposition lemma.
- Expected output: kernel-clean Lean theorems with the five hypotheses explicit.
- Why it matters: the operator-unification keystone separating the null kinetic
  shell from the `Phi_H^2` mass block; prevents the fermion-mass /
  gauge-boson-mass conflation.
- Success criteria: the sign is `+Phi^2` under the stated hypotheses; gradings
  separated; mass-shell sign documented so `-Box_null + Phi^2 = 0` gives
  `p^2 = m^2`.
- Risk: Medium-High. Operator algebra with a known sign trap; run J5 (audit)
  first.

## J5. No-build audit: super-Dirac grading/sign and Phi_H^2 double-counting

- Title: Sign-and-double-counting audit for the super-Dirac square.
- Goal: produce a written audit verifying (a) the `+Phi^2` vs `-Phi^2` sign
  under each grading choice, including the negative case where `Phi` is odd under
  the same `Gamma_s`; (b) that the Pluecker kinetic invariant and `Phi_H^2` are
  the two sides of one on-shell condition `K_h(xi) = spec(Phi_H^2)`, never two
  additive mass sources; (c) that fermion mass stays in `Phi_H^2` and W/Z mass in
  `|nabla^A H|^2`.
- Files/context: NULLSTRAND; Open Questions 6.9; Working Plan Sections 2, 10,
  15.10, 16.16; context-pack hits 1 and 3.
- Exact target: an audit note enumerating the sign cases, the on-shell matching
  statement, and a checklist that any operator-level theorem must satisfy to
  avoid double-counting.
- Expected output: a Markdown audit under `AgentTasks/`.
- Why it matters: the double-counting trap is the most dangerous internal
  inconsistency; the sign trap is the most likely silent error in J4.
- Success criteria: every sign case resolved with explicit commutation
  assumptions; a reusable no-double-counting checklist.
- Risk: Low. Pure analysis; high leverage as a gate on J4.

## J6. No-build audit: gauge-invariant phrasing and FMS pitfalls

- Title: Gauge-language and FMS-composite audit for finite graph Higgs.
- Goal: audit all program text for gauge-symmetry-breaking wording errors;
  replace with covariant-reference-section language; assess the proposed FMS
  composite `O_e^a = H_s^dagger tau^a U_e H_t` (T11) for whether its leading
  vacuum expansion actually reproduces the W/Z field.
- Files/context: Working Plan 4.3, 15.8, 16.9; Publication Plan P2-F; FMS
  literature leads.
- Exact target: a phrase-replacement table (avoid/use), an assessment of the
  candidate composite, and a recommended corrected composite if the schematic is
  wrong.
- Expected output: a Markdown audit under `AgentTasks/`.
- Why it matters: gauge-breaking wording is a guaranteed referee strike and is
  physically wrong; the FMS composite is the path to gauge-invariant physical
  W/Z excitations.
- Success criteria: a concrete corrected composite (or confirmation of the
  proposed one) and a complete phrase table.
- Risk: Medium. The exact composite expansion is genuinely open; the job may
  return "needs a proof job" for the composite while still delivering the
  phrasing audit.

## J7. No-build audit: determinant-level branch-count / no-doubling protocol

- Title: No-doubling determinant protocol for the tetrahedral retarded operator.
- Goal: set up the determinant-level no-doubling analysis (T16) -- write
  `D_+(q) = sum_a C_a (exp(i q_a)-1)/h`, the symbol `p(q)`, and the precise
  determinant test `det D_+(q) = 0`; identify candidate real, complex, and
  high-momentum branches; specify the smallest concrete patch on which a Lean
  computation is feasible.
- Files/context: NULLSTRAND no-doubling section; Open Questions 6.11, 6.13.7;
  AGENTS no-doubling note.
- Exact target: a protocol document plus a concrete low-dimensional patch
  statement ready to hand to a Lean proof job.
- Expected output: a Markdown audit under `AgentTasks/`.
- Why it matters: retardedness alone is not a no-doubling proof; the
  determinant-level test is the physical one and is required before any chiral-SM
  claim.
- Success criteria: an explicit, computable determinant target and an
  enumeration plan for branches/chirality.
- Risk: Medium. The general case is hard; the deliverable is the protocol and a
  tractable special case, not the full theorem.

## J8. No-build strategy: continuum symbol / commuting-square plan

- Title: Finite-to-continuum symbol and commuting-square strategy.
- Goal: lay out the master-blocker plan (grand-strategy C.1) -- the scaling-test
  order (flat symbol -> flat determinant -> curved tetrad -> commuting square ->
  Lichnerowicz), the exact flat symbol theorem to prove first, the frame-term
  contamination risks (`O(h^{-1})` blow-up), and the success/failure criteria
  for each stage.
- Files/context: NULLSTRAND scaling tests; Open Questions Q5/Q6, 6.13.9;
  Publication Plan P2-F.
- Exact target: a staged plan with a concrete first Lean target (the flat
  fixed-graph symbol convergence) and explicit failure signatures.
- Expected output: a Markdown strategy note under `AgentTasks/`.
- Why it matters: the continuum limit is the master blocker; without it "null
  edges do real work" is unsupported. A staged plan converts an intractable goal
  into a sequence of checkable ones.
- Success criteria: a first Lean target that is genuinely finite/flat and a
  clear gate for each subsequent stage.
- Risk: Low for the plan; the underlying proofs are High and are deferred.

## J9. Source/literature audit: prior-art and citation verification

- Title: Prior-art differentiation and citation-metadata audit.
- Goal: verify and finalize citations for P1/P1.5/P2 and sharpen the novelty
  boundary -- massive spinor-helicity (`1709.04891`), two-twistor mass models
  (`2102.07063`), Chin-Lee mass/concurrence (`1407.2492`, arXiv-only, no DOI),
  Peres-Scudo-Terno (`quant-ph/0203033`) and Gingrich-Adami (`quant-ph/0205179`)
  as frame-dependence guardrails, positive Grassmannian (`1212.5605`),
  spinor-network closure (`1201.2120`), Connes-Chamseddine spectral action
  (`hep-th/0610241`), Marcolli-van Suijlekom gauge networks, and the Wilczek
  "mass without mass" anchor (the one non-arXiv source still to verify).
- Files/context: Manuscript Draft Section 10 and the open-tasks list;
  Publication Plan P1-F/P2-F literature anchors; context-pack scoped paper hits;
  AGENTS provenance and citation-hygiene rules.
- Exact target: a verified citation table (arXiv id, journal ref, DOI where it
  exists) with explicit "no DOI" flags, plus a one-paragraph novelty statement
  per paper distinguishing it from each cited precedent.
- Expected output: a Markdown source-audit under `AgentTasks/`.
- Why it matters: "origin of mass" invites overreach; precise prior-art
  differentiation is the difference between "narrow, reviewable novelty" and
  "crank." Citation hygiene is an explicit repo guardrail.
- Success criteria: every citation resolved or flagged; no DOI invented for the
  arXiv-only Chin-Lee item; the Wilczek anchor resolved or marked unverified.
- Risk: Low. Bounded literature verification; only-extremely-well-known sources
  should be asserted, the rest flagged.

## J10. Prediction/moduli-rank job: the prediction gate ledger

- Title: Moduli-rank prediction ledger and codimension gate.
- Goal: build the `F : M_finite -> M_EFT` ledger (T17) -- enumerate the
  `M_finite` coordinates (graph family, null-frame/tetrad data, dual-soldering
  normalization, edge weights, gauge group, reps, Higgs potential, Yukawas,
  Majorana/sterile blocks, spectral function, cutoff, counterterms) and the
  `M_EFT` coordinates (`g_1,g_2,g_3,v,lambda,Y_u,Y_d,Y_e,Y_nu,M_R,CKM,PMNS,
  Lambda_QCD`, Wilson coefficients); compute a naive parameter count; state the
  codimension criterion (`rank(dF) < dim M_EFT` or `R(theta_EFT) = 0`); and list
  the realistic structural prediction candidates (forbidden Pauli counterterms,
  restricted Yukawa rank/texture, anomaly-forced representation class, forced
  Higgs rep/stabilizer, spectral-action coupling relation, generation-number
  reason, Lorentz-dispersion correction).
- Files/context: Working Plan Section 2 (Level 3), 15.12, 16.15; NULLSTRAND
  prediction gate; Strengthened Program "forcing-vs-restating" rule.
- Exact target: the ledger, the count, the codimension criterion, and a ranked
  list of the most plausible structural predictions to pursue, each with a
  smallest-useful-theorem target.
- Expected output: a Markdown ledger under `AgentTasks/`.
- Why it matters: this is the gate that separates reconstruction from prediction
  -- the decisive question for whether the program is "unified reconstruction" or
  "a derivation of the mass spectrum." It also protects against the fast-failure
  mode "parameter full rank."
- Success criteria: a complete coordinate enumeration, an honest count, a clear
  statement that codimension (not counting) is the real criterion, and at least
  three ranked structural-prediction targets with smallest-useful-theorem
  statements.
- Risk: Medium. The codimension analysis is conceptually hard; the deliverable
  is the disciplined ledger and candidate list, not a proved constraint.

---

## Wave summary and launch order

```text
Job  Type              Target (chain ref)                         Risk
---  ----------------  -----------------------------------------  ------
J1   Proof             Yukawa checkerboard + SVD (T5,T6)          Low
J2   Proof             EW stabilizer ker/rank (T9)                Low-Med
J3   Proof             Abelian Higgs link stiffness (T8)          Low-Med
J4   Proof             Graded super-Dirac square (T14)            Med-High
J5   Audit (no-build)  Sign + double-counting (gate for J4)       Low
J6   Audit (no-build)  Gauge wording + FMS composite (T11)        Med
J7   Audit (no-build)  No-doubling determinant protocol (T16)     Med
J8   Strategy (nobuild)Continuum symbol / commuting square (C.1)  Low(plan)
J9   Source/lit        Prior-art + citation verification          Low
J10  Prediction        Moduli-rank ledger + gate (T17)            Med
```

Recommended launch:

1. Parallel first wave: J1, J2, J3 (independent finite-algebra proofs); J5, J9,
   J10 (no-build, run concurrently).
2. After J5: J4 (super-Dirac square), then J6.
3. Then J7 and J8 (continuum/no-doubling), which feed the harder P2 proof jobs
   (T13, T15, T16) in a later wave.

All proof jobs target `PhysicsSM/Draft/` modules importing `Mathlib`, kept as
clearly-labeled drafts until semantic review (statement alignment, convention
drift, hidden assumptions) precedes any promotion to the trusted surface, per
the repo's trusted-vs-draft policy.
