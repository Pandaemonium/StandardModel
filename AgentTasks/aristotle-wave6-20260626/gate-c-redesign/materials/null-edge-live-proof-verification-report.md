# Null-edge live draft-proof verification and semantic-review report

Type: live verification + semantic review job. Generated 2026-06-26.

Provenance of the task: `PROMPT.md` (verify the four live draft proof files the
wave integration triage flagged as report-asserted but not re-verified),
`AgentTasks/aristotle-wave-integration-triage.md` (§0 caveat and §5/§6
verification job), `AgentTasks/null-edge-trusted-theorem-promotion-policy.md`
(G1 checklist and the Section 4 semantic-review protocol), `docs/CONVENTIONS.md`,
and `docs/NULLSTRAND.md`.

## 0. Method and scope (what was actually run)

Unlike the integration triage (a no-build audit produced when the `Draft/*.lean`
files were absent from the snapshot), this job ran live Lean checks. The four
target files are **present** in this snapshot.

Toolchain actually used: the repo pin `leanprover/lean4:v4.28.0` with the
`lakefile.toml` `mathlib` requirement at `rev = v4.28.0` (Mathlib oleans already
cached in `.lake`). Checks were per-file and targeted; no full-repo `lake build`
and no broad proof wave were run, per the PROMPT guardrail "prefer smallest
checks."

Per file, three checks were run:

1. Smallest relevant elaboration check:
   `lake env lean PhysicsSM/Draft/<File>.lean` (policy C13a; no ProofWidgets
   dependency). All four elaborate with exit 0 and no errors / no `sorry`
   warnings.
2. Placeholder-token scan (policy C13b): `grep` for `sorry` / `admit` /
   `opaque` / `unsafe` / `@[implemented_by]` / `axiom ` / `native_decide`.
   Zero hits in all four files.
3. Axiom closure (policy C13c): `#print axioms` on every main declaration.

Axiom-closure results (all within the allowed kernel set
`{propext, Classical.choice, Quot.sound}`):

| File | declarations checked | axioms |
| --- | --- | --- |
| `NullEdgeElectroweakStabilizer.lean` | `B_EW_eq_matrix`, `ew_stabilizer_kernel`, `ew_stabilizer_kernel_finrank`, `ew_stabilizer_rank`, `ew_quadratic_form_kernel` | `{propext, Classical.choice, Quot.sound}` |
| `NullEdgeFiniteTetradPostulate.lean` | `frame_term_vanishes` | `{propext, Quot.sound}` |
| `NullEdgeFiniteTetradPostulate.lean` | `dirac_square_decomp`, `dirac_square_of_tetrad`, `boxnull_add_cdiamond`, `dirac_square_full_decomp`, `dirac_square_full_of_tetrad` | `{propext, Classical.choice, Quot.sound}` |
| `NullEdgeScalarKineticReconstruction.lean` | `repr_eq_apply_predual`, `covector_bilin_reconstruction`, `inverse_gram`, `inverse_gram_reconstruction`, `higgs_kinetic_reconstruction`, `euclidean_collapse_guardrail` | `{propext, Classical.choice, Quot.sound}` |
| `StandardModelAnomalyAudit.lean` | `sm_anomaly_cancellation`, `sm_anomaly_cancellation_with_nu` (and the four component lemmas) | `{propext, Classical.choice, Quot.sound}` |

So the triage's "kernel-clean, sorry-free, axioms = {propext, Classical.choice,
Quot.sound}" status is now **re-verified, not merely report-asserted**, for all
four files. The remaining work in this report is the PROMPT/G1 step the kernel
does not do: statement-matches-claim and convention fidelity.

**Standing caveat (PROMPT + governing principle of G1).** A compiled, axiom-clean
proof is *not* automatically the intended physics claim. Each verdict below is a
semantic review, not a promotion. This report promotes nothing.

**Cross-cutting gap (applies to all four files).** None of the four files carries
the standardized convention-import banner (metric / grading / kinetic-sign /
frame-normalization header) required by G1 criteria C5-C8 and triage §3-E. The
relevant conventions are stated in each file's module docstring and are
individually consistent with `docs/CONVENTIONS.md`, but they are not yet a
machine-checkable header. Attaching the banner is a prerequisite for any trusted
promotion.

---

## 1. `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean`

Status: present. Elaborates clean; no placeholder tokens; axioms clean.

### 1.1 Main theorem statements in English

* `B_EW_eq_matrix` (faithfulness): the closed-form `R`-linear map `B_EW v` agrees
  with the matrix action `x -> rho(x) . H0`, where `rho(x)` is the real
  combination `x0 T1 + x1 T2 + x2 T3 + x3 (Y/2)` of the Hermitian generators and
  `H0 = (0, v/sqrt 2)`.
* `ew_stabilizer_kernel`: for `v != 0`, the kernel of the orbit-obstruction map
  `B_EW v : R^4 -> C^2` equals the real line `span_R {Qgen}`, where
  `Qgen = (0,0,1,1)` is the coordinate vector of the charge `Q = T3 + Y/2`.
* `ew_stabilizer_kernel_finrank`: for `v != 0`, `dim_R (ker B_EW) = 1`.
* `ew_stabilizer_rank`: for `v != 0`, `dim_R (range B_EW) = 3`.
* `ew_quadratic_form_kernel`: for `v != 0`, the zero set of the quadratic
  obstruction `q(x) = ||B_EW v x||^2` equals `span_R {Qgen}`.

Supporting facts checked: `Qmat_mulVec_H0` (`Q H0 = 0`, the charge stabilises the
vacuum) and `rho_Qgen` (`rho(Qgen) = Q = diag(1,0)`), which together justify
naming the kernel line `u(1)_em`.

### 1.2 Independent re-derivation (semantic check)

With `T1,T2,T3 = sigma_i/2` and `Y/2 = (1/2) I`, one computes
`rho(x) H0 = ( kappa (x0 - i x1), kappa (x3 - x2) )` with
`kappa = v/(2 sqrt 2)`. This matches the closed form in `B_EW`, and
`B_EW_eq_matrix` certifies it inside Lean. For `v != 0` (so `kappa != 0`),
`B_EW x = 0` iff `x0 - i x1 = 0` and `x3 = x2`; over the reals this forces
`x0 = x1 = 0`, `x2 = x3`, i.e. the kernel is `{(0,0,t,t)} = span{(0,0,1,1)}`,
giving `dim ker = 1` and `rank = 4 - 1 = 3`. The charge matrix `Q = diag(1,0)`
indeed annihilates `H0 = (0, v/sqrt 2)`. All statements are correct and the
`hv : v != 0` hypothesis is load-bearing (with `v = 0` the map is zero and the
kernel statement fails), so nothing is vacuous.

### 1.3 Convention fidelity (C5-C8, C11)

* Electroweak block matches `docs/CONVENTIONS.md` "Electroweak / Structural
  theorem" exactly: `Y(H) = 1`, `Q = T3 + Y/2`, `H0 = (0, v/sqrt 2)`,
  `B_EW(X) = X H0`, target `ker B_EW = u(1)_em`, `rank q = 3`.
* Hermitian generators `T_i = sigma_i/2` match the locked physics-Hermitian
  normalization. The docstring records the bridge to the anti-Hermitian
  convention (the overall `i` is a scalar leaving kernel/rank unchanged) - this
  matches triage §3-D and is correct.
* Real-coordinate lock (triage §3-C, C8-adjacent): the counts `dim ker = 1`,
  `rank = 3` hold precisely because `B_EW` is treated as an **R-linear** map
  `R^4 -> C^2` (the real Lie algebra `su(2) (+) u(1)` has real dimension 4). The
  docstring states this explicitly. This caveat must travel as an explicit import
  on any downstream use; a C-coordinate reading changes the count and is
  forbidden as a "fix" (triage §5).
* Metric/grading/kinetic-sign: n/a (this is a zeroth-order internal
  representation-theory statement; no `Gamma_s`, no square, no metric). Correctly
  absent rather than mis-stated.

### 1.4 Minor notes

* CONVENTIONS phrases the target as "rank q = 3" for the quadratic form
  `q(X) = |B_EW X|^2`. The file proves `rank` as `finrank (range B_EW) = 3` (the
  linear map) and, separately, that the zero set of `q` equals `span{Q}`. For a
  Gram form `q(x) = <B_EW x, B_EW x>` the radical is exactly `ker B_EW`, so the
  form-rank equals the map-rank `= 3`; the two formulations agree. This is a
  faithful rendering, but a promoted statement could add the literal
  quadratic-form-rank corollary for an exact textual match.
* Claim label (C4): "structural theorem" - justified; the forcing algebraic
  inputs (group via generators, doublet representation, vacuum section, `v != 0`)
  are all explicit hypotheses/definitions. Not a prediction.

### 1.5 Verdict

**Trusted-promotable as a structural theorem**, conditional on (a) attaching the
G1 convention banner and (b) carrying the real-coordinate caveat as an explicit
import. Statement matches the intended manuscript claim; no semantic defect; no
vacuity. This confirms the triage's conditional verdict now that the file is
verified. Out of scope and **not** done here: the stage-2 `m_W`, `m_Z`
coefficient theorem (`docs/CONVENTIONS.md` "Coefficient formulas" remains an
unproved target).

---

## 2. `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`

Status: present. Elaborates clean; no placeholder tokens; axioms clean.

### 2.1 Main theorem statements in English

Setting: arbitrary (possibly non-commutative) `Ring R`, finite index type `iota`;
`C, nab : iota -> R` model the Clifford symbols `C_a = c(alpha^a)` and transports
`nabla_a`. `frameComm a b = nab a * C b - C b * nab a = [nabla_a, C_b]`;
`DN = sum_a C_a nabla_a`; `Tframe = sum_{a,b} C_a [nabla_a, C_b] nabla_b`;
`Kplus = sum_{a,b} C_a C_b (nabla_a nabla_b)`.

* `frame_term_vanishes`: if `[nabla_a, C_b] = 0` for all `a,b` (the finite tetrad
  postulate), then `Tframe = 0`.
* `dirac_square_decomp`: `DN^2 = Kplus + Tframe` (arbitrary `C`, `nab`).
* `dirac_square_of_tetrad`: under the tetrad postulate, `DN^2 = Kplus`.
* `boxnull_add_cdiamond` (needs `Invertible (4 : R)`): `Boxnull + Cdiamond =
  Kplus`, where `Boxnull = (1/4) sum {C_a,C_b}{nabla_a,nabla_b}` and
  `Cdiamond = (1/4) sum [C_a,C_b][nabla_a,nabla_b]`.
* `dirac_square_full_decomp`: `DN^2 = Boxnull + Cdiamond + Tframe`.
* `dirac_square_full_of_tetrad`: under the tetrad postulate,
  `DN^2 = Boxnull + Cdiamond`.

### 2.2 Independent re-derivation (semantic check)

`DN^2 = sum_{a,b} C_a nabla_a C_b nabla_b`. Adding/subtracting `C_a C_b nabla_a
nabla_b` gives `DN^2 = Kplus + sum_{a,b} C_a [nabla_a,C_b] nabla_b = Kplus +
Tframe`, confirming `dirac_square_decomp`. Expanding the anticommutator and
commutator products, `{C_a,C_b}{nabla_a,nabla_b} + [C_a,C_b][nabla_a,nabla_b] =
2 C_a C_b nabla_a nabla_b + 2 C_b C_a nabla_b nabla_a`; summing over `a,b`
(relabelling the second term) and dividing by 4 yields `Kplus`, confirming
`boxnull_add_cdiamond`. All identities check out. The tetrad-postulate hypothesis
is load-bearing (the conclusion is false for generic non-commuting data), so
`frame_term_vanishes` / `dirac_square_of_tetrad` are not vacuous.

### 2.3 Convention fidelity and the naming hazard

* `Boxnull`, `Cdiamond`, `Tframe`, and the decomposition `DN^2 = Boxnull +
  Cdiamond + Tframe` match `docs/NULLSTRAND.md` ("Frame term and tetrad
  compatibility") and `docs/CONVENTIONS.md` ("Frame/tetrad defect") **exactly**,
  including the `1/4` normalizations and the commutator/anticommutator structure.
* **Naming hazard (triage §3-A), confirmed but not a drift.** The file's `Kplus`
  is the combined block `Boxnull + Cdiamond` (`= sum C_a C_b nabla_a nabla_b`),
  which is *not* CONVENTIONS' `K_null` (the symmetric box only, excluding
  `C_diamond`). Crucially, the file does **not** name anything `K_null`; it uses
  the neutral name `Kplus` for the combined block, and its `Boxnull` matches the
  locked `Box_null`. So there is no convention drift in the statements as
  written. The hazard is only that a future trusted statement must not let
  `Kplus`/`K_h`/`K_null` collide into one symbol; the A6 kinetic-normalization
  job should reserve `K_null` for exactly one block with an alias lemma.
* Metric/grading/kinetic-sign: deliberately n/a. This is the **ungraded** null
  Dirac square `D_N^2`, abstract finite ring algebra. It is *not* the graded
  super-Dirac square `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum C_a[nabla_a,Phi]`; the
  file makes no claim about `Gamma_s`, `Phi`, signs, or mass-shell. Correctly
  scoped.

### 2.4 Verdict

**Trusted as a standalone finite ring identity** (label: finite identity),
conditional on the G1 banner. Statements match the intended `D_N^2`
decomposition; algebra verified; the tetrad postulate is an explicit, load-bearing
hypothesis. **Draft-only for the B4/P2 finite-square spine**: any *graded*
super-Dirac square result built on this is gated by Gate A (C12, triage §5), and
Gate A (super-Dirac sign + wrong-grading counterexamples) is not yet resolved in
Lean. Also recommended before promotion: add the non-vanishing witness the report
suggests (a concrete `[nabla_a, C_b] != 0` instance with `Tframe != 0`) so the
hypothesis is demonstrably non-vacuous in-repo.

---

## 3. `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean`

Status: present. Elaborates clean; no placeholder tokens; axioms clean.

### 3.1 Main theorem statements in English

Setting: real vector space `V`, covectors in `Dual R V`. A dual-soldered null
frame is a basis `alpha` of `Dual R V` with predual null edges `ell` satisfying
`alpha^a(ell_b) = delta^a_b`. Nondegeneracy of a symmetric form `g` is encoded by
a "sharp" map `sharp : Dual R V -> V` with `g(sharp xi, v) = xi v` (the inverse
musical isomorphism); the induced inverse metric is
`g^{-1}(xi,eta) = g(sharp xi, sharp eta) = compl12 g sharp sharp`.

* `repr_eq_apply_predual`: in such a dual basis, the `a`-th coordinate of a
  covector `xi` equals its edge evaluation `xi(ell_a)`.
* `covector_bilin_reconstruction`: for any bilinear form `B` on covectors,
  `B xi eta = sum_{a,b} B(alpha^a, alpha^b) xi(ell_a) eta(ell_b)`.
* `inverse_gram`: with `alpha = ell.dualBasis` and `G^{bc} = g^{-1}(alpha^b,
  alpha^c)`, one has `sum_b g(ell_a,ell_b) G^{bc} = delta_a^c`, i.e. `G` is the
  matrix inverse of the Gram matrix `g_{ab} = g(ell_a, ell_b)`.
* `inverse_gram_reconstruction`: `g^{-1}(xi,eta) = sum_{a,b} G^{ab} xi(ell_a)
  eta(ell_b)`.
* `higgs_kinetic_reconstruction`: the `xi = eta = dH` corollary, reconstructing
  the kinetic symbol `<DH,DH>_{g^{-1}}` from null-edge derivatives `dH(ell_a)`.
* `euclidean_collapse_guardrail`: if `G^{ab} = delta^{ab}`, the reconstruction
  collapses to the naive positive edge sum `sum_a (xi(ell_a))^2`.

### 3.2 Independent re-derivation (semantic check)

`repr_eq_apply_predual` is the standard dual-basis evaluation. Bilinear expansion
of `xi = sum xi(ell_a) alpha^a`, `eta = sum eta(ell_b) alpha^b` gives
`covector_bilin_reconstruction`. For `inverse_gram`: with `G^{bc} =
g(sharp alpha^b, sharp alpha^c) = alpha^b(sharp alpha^c)` and `sharp alpha^c =
sum_b alpha^b(sharp alpha^c) ell_b`, one gets `sum_b g(ell_a,ell_b) G^{bc} =
g(ell_a, sharp alpha^c) = alpha^c(ell_a) = delta_a^c` using symmetry of `g` and
the `sharp` raising property. Correct - `G` is a genuine two-sided Gram inverse.
The remaining results are direct specializations. No vacuity: the `sharp`
hypothesis is satisfiable exactly when `g` is nondegenerate (e.g. Lorentzian),
and `ell` is a genuine basis.

### 3.3 Convention fidelity (C5-C8, C11)

* Frame/soldering (C8): uses the **dual-soldered** covectors `alpha^a =
  ell.dualBasis`, never the diagonal flats `ell_a^flat`. Matches the locked
  dual-soldered architecture and the rejection of the diagonal architecture in
  `docs/CONVENTIONS.md` / `docs/NULLSTRAND.md`.
* Metric signature (C5): the theorems are stated for an **arbitrary**
  nondegenerate symmetric `g` (signature-agnostic); the "mostly-minus Lorentzian
  inverse-Gram" framing lives only in the prose docstring. This is a strength
  (more general), but note that the Lorentzian content is interpretive, not
  pinned in the Lean statements - the banner should record that the result is
  signature-general and the Lorentzian reading is the intended specialization.
* The file uses its own local `sharp` / `ell.dualBasis` encoding rather than a
  shared `NullSolderFrame` (B0) structure (which does not yet exist in the repo).

### 3.4 Minor notes

* `euclidean_collapse_guardrail` formalizes only the **one** direction (diagonal
  `G = I` implies the naive square sum). The docstring's "if (and only if, on the
  diagonal data)" is appropriately hedged, but the converse is not a Lean
  theorem; a promoted statement should not be read as a full iff.
* Claim label (C4): "reconstruction" - justified (a known mechanism, the inverse
  metric, is reconstructed from null-edge primitives; inputs remain free). Not a
  prediction.

### 3.5 Verdict

**Draft-only.** The linear algebra is correct, faithful to the §19.4
inverse-Gram reconstruction, and convention-consistent. It is held in `Draft/`
per the backlog dependency (triage §4, C12): S8 scalar/gauge null-kinetic
reconstruction must be re-audited against B1/B3, and refactored onto the shared
B0 `NullSolderFrame` once that exists, before promotion. No semantic defect;
keep-as-draft is a dependency/scaffolding decision, not a correctness problem.

---

## 4. `PhysicsSM/Draft/StandardModelAnomalyAudit.lean`

Status: present. Elaborates clean; no placeholder tokens; axioms clean.

### 4.1 Main theorem statements in English

One-generation Standard Model spectrum as left-handed Weyl multiplets
(right-handed fields as left-handed conjugates), each with colour multiplicity,
weak multiplicity, and hypercharge `Y` (convention `Q = T3 + Y/2`):
`QL(3,2,1/6)`, `LL(1,2,-1/2)`, `uRc(3,1,-2/3)`, `dRc(3,1,1/3)`, `eRc(1,1,1)`;
`mult = colour * weak`.

* `grav_anomaly_zero`: `sum mult * Y = 0` (U(1)-gravitational anomaly).
* `cube_anomaly_zero`: `sum mult * Y^3 = 0` (U(1)^3 anomaly).
* `su2_anomaly_zero`: over weak doublets, `sum colour * Y = 0` (SU(2)^2 U(1)).
* `su3_anomaly_zero`: over colour triplets, `sum weak * Y = 0` (SU(3)^2 U(1)).
* `sm_anomaly_cancellation`: the conjunction of the four.
* `sm_anomaly_cancellation_with_nu`: the same four sums still vanish after adding
  a right-handed neutrino conjugate `nuRc(1,1,0)`.

### 4.2 Independent re-derivation (semantic check)

* grav: `6*(1/6) + 2*(-1/2) + 3*(-2/3) + 3*(1/3) + 1*1 = 1 - 1 - 2 + 1 + 1 = 0`.
* cube: `6*(1/6)^3 + 2*(-1/2)^3 + 3*(-2/3)^3 + 3*(1/3)^3 + 1 = 1/36 - 1/4 - 8/9 +
  1/9 + 1 = 0`.
* SU(2)^2 U(1) (doublets QL, LL): `3*(1/6) + 1*(-1/2) = 0`.
* SU(3)^2 U(1) (triplets QL, uRc, dRc): `2*(1/6) + 1*(-2/3) + 1*(1/3) = 0`.
* `nuRc` has `Y = 0`, colour 1, weak 1, contributing 0 to every sum.

All four cancellations are correct exact-rational facts; the proofs discharge
them by `simp`/`norm_num` on explicit rationals (genuine computation, not
vacuous).

### 4.3 Convention fidelity and scope

* Hypercharges match `docs/CONVENTIONS.md` (`Q = T3 + Y/2`, `Y(Q_L) = 1/6`).
* **Scope disclaimer (load-bearing, present in the file).** This is
  representation/structural **bookkeeping**, not a chirality claim. It proves the
  standard one-generation anomaly arithmetic and nothing more: it does **not**
  show the null-edge construction realises the chiral Standard Model, and says
  nothing about doubling / Nielsen-Ninomiya. The file's docstring states this
  explicitly; it must travel with the theorem on promotion (triage §2.1 verdict).
* Completeness note (not a defect): the file covers the four hypercharge-dependent
  anomalies. The `SU(3)^3` anomaly cancels because QCD is vector-like, `SU(2)^3`
  vanishes by pseudoreality, and the Witten `SU(2)` global anomaly (even number of
  doublets) is a parity condition - none of these are part of this arithmetic
  audit and their absence is consistent with the stated scope.

### 4.4 Verdict

**Trusted-promotable as anomaly arithmetic only** (label: audit / finite
identity), conditional on the G1 banner and on carrying the explicit
non-chirality disclaimer. Statements match the intended claim; arithmetic
verified; no vacuity. Confirms the triage's conditional verdict.

---

## 5. Summary table

| File | Exists | Elaborates | Placeholder tokens | Axioms clean | Statement matches claim | Convention banner | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `NullEdgeElectroweakStabilizer.lean` | yes | yes | none | yes | yes | missing | Trusted-promotable (structural theorem) after banner + real-coordinate caveat; stage-2 m_W/m_Z not done |
| `NullEdgeFiniteTetradPostulate.lean` | yes | yes | none | yes | yes | missing | Trusted as standalone finite identity after banner; draft-only for the graded square spine (Gate A) |
| `NullEdgeScalarKineticReconstruction.lean` | yes | yes | none | yes | yes | missing | Draft-only (S8 re-audit vs B1/B3; refactor onto B0 NullSolderFrame) |
| `StandardModelAnomalyAudit.lean` | yes | yes | none | yes | yes | missing | Trusted-promotable (anomaly arithmetic only) after banner + non-chirality disclaimer |

## 6. Decisions and recommendations

* All four files are **present**, elaborate cleanly under the pinned toolchain,
  contain no placeholder proof tokens, and have axiom closures inside the allowed
  kernel set. The triage's report-asserted status is now re-verified.
* All four theorem statements are **semantically faithful** to their intended
  claims and consistent with the Locked entries of `docs/CONVENTIONS.md`; no
  vacuity, no silent weakening, and the load-bearing hypotheses (`v != 0`, the
  tetrad postulate, nondegeneracy via `sharp`, explicit hypercharges) are
  genuine.
* **No file is promoted here** (PROMPT guardrail; this is review only). Before any
  promotion under the G1 policy:
  1. Attach the standardized convention-import banner (C5-C8) to each file - the
     one cross-cutting gap (triage §3-E).
  2. EW stabilizer: lock the real-coordinate `R^4 -> C^2` caveat as an explicit
     import; optionally add the literal quadratic-form-rank corollary.
  3. Finite tetrad: keep `Kplus` distinct from `K_null` (A6 normalization);
     add an in-repo non-vanishing `T_frame` witness; do not let any graded square
     depend on it until Gate A is resolved in Lean.
  4. Scalar kinetic: re-audit S8 against B1/B3 and refactor onto B0
     `NullSolderFrame` before leaving `Draft/`.
  5. Anomaly audit: carry the non-chirality / non-doubling disclaimer with the
     theorem.
* Hard-stop reminders (triage §5) remain in force: no finite graded-square
  promotion before Gate A; no no-doubling / continuum / Krein-stability claim;
  none of these four files makes such a claim, which is the correct behaviour.
