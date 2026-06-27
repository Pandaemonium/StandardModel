# Null-edge Aristotle wave integration triage

Type: no-build integration audit. No Lean/Lake/pre-commit/build command was run.

Provenance of the task: `PROMPT.md` (integration triage for returned null-edge
jobs), the Pro feedback update in
`AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md`
("integrate before expanding"), `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
§21, and `docs/CONVENTIONS.md`.

## 0. Scope and a load-bearing caveat about this snapshot

Returned outputs collected from the submitted project (`AgentTasks/`):

Proof-job reports (each describes a kernel-clean Lean file):

- `null-edge-ew-stabilizer-report.md` -> `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean`
- `null-edge-finite-tetrad-postulate-report.md` -> `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`
- `null-edge-scalar-kinetic-reconstruction-report.md` -> `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean`
- `null-edge-sm-anomaly-audit-report.md` -> `PhysicsSM/Draft/StandardModelAnomalyAudit.lean`

Audit/strategy/source reports (no Lean theorem banked; some propose `sorry` targets):

- `null-edge-super-dirac-sign-double-counting-audit.md` (Gate A spec)
- `null-edge-krein-stability-audit.md`
- `null-edge-fms-wz-composite-audit.md`
- `null-edge-flat-branch-count-protocol.md` (Gate C kill-switch)
- `null-edge-qcd-obstruction-scope.md`
- `null-edge-moduli-rank-prediction-ledger.md`
- `null-edge-mass-prior-art-citation-audit.md`
- `null-edge-chiral-mechanism-strategy.md`
- `null-edge-continuum-square-limit-strategy.md`

Returned strategy outputs (R1/R2/R3, used as context, not theorem claims):
`null-edge-unified-mass-grand-strategy-report.md`,
`null-edge-unified-mass-proof-chain.md`,
`null-edge-unified-mass-aristotle-next-jobs.md`.

**Caveat (must be respected before any trusted promotion).** The `PhysicsSM/Draft/*.lean`
files referenced by the four proof reports are **not present in this submitted
project**; only the reports are. Therefore the "kernel-clean, sorry-free, axioms
= {propext, Classical.choice, Quot.sound}" status is **report-asserted, not
re-verified here**, and the PROMPT guardrail "do not treat a compiled proof as
semantically correct unless its statement matches the intended claim" cannot be
discharged from this snapshot. Every promotion recommendation below is therefore
conditional on a statement-matches-claim re-verification against the live repo
(a small dedicated verification job — see §5).

## 1. Convention spine (the integration invariant, extracted)

All returned outputs were checked against the four §21.8 / backlog invariant
axes. The good news: the returned corpus is **mutually consistent** on the spine,
and consistent with `docs/CONVENTIONS.md`. No sign/metric contradiction was
found between any two returned jobs. The shared spine is:

- Metric signature: mostly-minus `(+,-,-,-)`; null `p^2 = 0`, massive `p^2 = m^2`.
  (CONVENTIONS "Metric signature"; explicit in super-Dirac audit §0, branch-count
  §0, continuum-strategy §0.)
- Architecture: dual-soldered `D_N = sum_a c(alpha^a) nabla_{ell_a}`,
  `C_a = c(alpha^a)`, `alpha^a(ell_b) = delta^a_b`. Diagonal
  `c(ell_a^flat) nabla_{ell_a}` only as a documented negative comparison.
- Gradings kept strictly separate: `Gamma_s` (spacetime chirality), `chi_E`
  (internal), `epsilon_form` (form degree); form/internal grading may never
  repair a spacetime-chirality sign.
- Kinetic-sign / super-Dirac square (locked spec, confirmed by the sign audit):
  `D = i D_N + Gamma_s Phi_H`,
  `D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`, with
  `+Phi_H^2` **iff** `[Gamma_s, Phi_H] = 0`; mass-shell `-Box_null + Phi^2 = 0`
  gives `p^2 = m^2`.
- No double counting: `K_null = Phi_H^2` on-shell (one relation), never
  `m_Plucker^2 + m_Higgs^2`. Fermion mass in `Phi_H^2`; W/Z mass in
  `|nabla^A H|^2` / link stiffness.
- Electroweak: physics-Hermitian generators `T_i = sigma_i/2`, `Y(H)=1`,
  `Q = T_3 + Y/2`, `H_0 = (0, v/sqrt(2))` (EW-stabilizer, FMS, anomaly all agree).

**Gap, not conflict:** none of the four proof-job files currently carries a
single standardized convention-import banner declaring its metric / grading /
kinetic-sign / frame-normalization imports. The invariant is satisfied
*implicitly and per-report*, but not as a machine-checkable header. Add the
banner as part of the promotion policy (G1) before trusted promotion.

## 2. Compatibility matrix across returned jobs

Fields: T=target; A=assumptions; M=metric; G=grading; K=kinetic sign / mass-shell;
F=frame/soldering; L=claim label; X=conflicts; P=promotion verdict.

### 2.1 Proof jobs (Lean reports)

| Job | T (target) | A (assumptions) | M | G | K | F | L (label) | X (conflicts) | P (verdict) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| EW stabilizer | `ker B_EW = span_R{Q} = u(1)_em`, `dim ker = 1`, `rank = 3`; quadratic form `q(X)=||B_EW X||^2` same kernel | SM EW group; Higgs doublet rep; vacuum `H_0=(0,v/sqrt2)`, `v != 0`; **B_EW is R-linear `R^4 -> C^2`** (real coords essential); Hermitian generators | n/a (internal) | internal rep only; no `Gamma_s` | n/a (zeroth order) | n/a (gauge-internal) | structural theorem (given group+rep+vacuum) | none. Generator convention matches CONVENTIONS | **Trusted-promotable** as structural theorem, with banner + the real-coordinate caveat; verify file matches report first. Stage-2 `m_W,m_Z` coefficient theorem NOT done |
| Finite tetrad postulate | `[nabla_a,C_b]=0 => T_frame=0`; `D_N^2 = Kplus + T_frame`; `D_N^2 = Boxnull + Cdiamond + T_frame`; tetrad-postulate corollaries | arbitrary `Ring R`, `Fintype iota`; `Boxnull/Cdiamond` need `Invertible (4:R)`; tetrad postulate an explicit premise | n/a (abstract ring) | sign-neutral; no Phi/`Gamma_s` | this is `D_N^2` only, NOT graded `D^2` | abstract `C_a`,`nabla_a`; no concrete Gram | structural theorem (finite ring identity) | **Naming hazard:** report's `Kplus = Boxnull + Cdiamond` is NOT CONVENTIONS' `K_null` (which excludes `C_diamond`). See §3-A | **Trusted as standalone finite identity**, BUT **draft-only for the B4/P2 finite-square spine** (gated by Gate A and B1/B3 ordering). Add the non-vanishing witness it recommends |
| Scalar/Higgs kinetic | inverse-Gram reconstruction `g^{-1}(xi,eta)=sum G^{ab} xi(ell_a) eta(ell_b)`; `G` = matrix inverse of Gram; Higgs corollary; Euclidean-collapse guardrail | real `V`; dual covectors `alpha^a`; nondegeneracy via supplied `sharp` map; `alpha := ell.dualBasis` | mostly-minus (Lorentzian inverse-Gram) | n/a | reconstructs kinetic symbol; sign-consistent | **dual-soldered `alpha^a`** (not `ell^flat`); local frame/holonomy out of scope | reconstruction | none on conventions. Uses own `sharp`/`dualBasis` encoding, not a shared `NullSolderFrame` | **Draft-only**: backlog dependency "S8 must be re-audited against B1/B3 before promotion." Refactor onto B0 `NullSolderFrame` when it exists |
| SM anomaly (1 gen) | `grav`, `U(1)^3`, `SU(2)^2 U(1)`, `SU(3)^2 U(1)` anomaly sums all `= 0`; invariant with/without `nu_R^c` | left-handed Weyl multiplets; `Q=T_3+Y/2`, `Y(Q_L)=1/6`; exact rationals | n/a | left-handed convention only; no `Gamma_s` square | n/a | n/a | representation/structural bookkeeping (NOT a chirality claim) | none. Hypercharges match CONVENTIONS | **Trusted-promotable** as anomaly arithmetic only, with the explicit disclaimer that it does NOT show null-edge realizes the chiral SM. Verify file matches report first |

### 2.2 Audit / strategy / source jobs (no banked Lean theorem)

| Job | T (target) | Key result | L | X (conflicts) | P (verdict) |
| --- | --- | --- | --- | --- | --- |
| Super-Dirac sign + double-counting | Gate A specification | `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum C_a[nabla_a,Phi]`; `+Phi^2 iff [Gamma_s,Phi]=0`; M1-M9 failure modes; proposes `super_dirac_square_single` (+ odd companion) `sorry` targets | audit | none (confirms CONVENTIONS) | **Docs-only / Gate A input.** Gate A is **NOT yet resolved in Lean** (A1/A2 are still `sorry` targets). This blocks all finite-square promotion |
| Krein stability | Lorentzian adjointness hygiene | finite Krein-double `J`-self-adjoint theorem (holds for every `D_+`) + 3 counterexamples (nonreal spectrum, growing mode, doubling guarantees nothing) | audit (necessary, not stability) | none (confirms Krein non-overclaim rule) | **Docs-only.** No stability/real-spectrum/unitarity claim may be promoted. Launch C5+C7 (theorem + counterexample) as one paired Lean job |
| FMS W/Z composite | corrected gauge-invariant composite | schematic `O_e^a` is gauge-**covariant, not invariant** -> rejected as written; corrected framed triplet `W_e^a=(1/2)tr(sigma^a X_s^dag U_e X_t)` + singlet `H_s^dag U_e H_t` | reconstruction/structural | **Conflict with CONVENTIONS "FMS/gauge-invariant composites"** (lists schematic `O_e^a`). See §3-B | **Docs-only now; update CONVENTIONS.** Corrected composite may be promoted to "current working composite" (not prediction). E1 only after CONVENTIONS update and S11 |
| Flat branch-count | determinant-level no-doubling test | **KILL-SWITCH:** flat tetrahedral retarded operator FAILS Gate C as-is: 4 high-momentum corner null branches + positive-dimensional null variety + pervasive complex-energy branches; `+Gamma_s Phi` mass block does NOT remove them | audit/protocol | none (enforces branch-count rule) | **Docs-only; HARD STOP** on no-doubling / continuum / dynamical promotion. Highest-priority risk. Launch C2a/C2b + C1/C3 |
| QCD scope | boundary-only scoping | no finite `B_QCD`, no color gap theorem exists; recommend NO QCD-labelled theorem job now; frozen P1/P1.5 wording | audit | none (confirms QCD boundary rule) | **Docs-only.** Reject any `B_QCD` / proton-mass theorem job until a finite `S`, canonical map, and gap theorem are drafted |
| Moduli-rank ledger | prediction gate | reconstruction-not-prediction discipline; naive parameter count is first-screen only; prediction needs redundancy-robust `rank(dF)<dim M_EFT` or `R(theta)=0`; ranked candidates | audit / prediction-gate | none (confirms prediction gate) | **Docs-only.** No prediction claim promotable yet |
| Prior-art citation | source/provenance | core P1 cluster ok-as-recorded; several ids unverified (`2508.17338`, `2604.07471`, original FMS, Wilczek "mass without mass"); title caution | source audit | none, but flags overclaim phrases | **Docs-only; HARD STOP** on typesetting any unverified DOI/venue. Re-resolve all ids live before submission |
| Chiral mechanism | mechanism decision | pilot domain-wall/SSH (C9) first; internal chiral rep as co-pilot; reject non-Hermitian/Krein route; conditional on Gate C + Krein | strategy | none | **Docs-only strategy.** Feeds next-job choice; gated by Gate C |
| Continuum square-limit | staged D-spine | S1-S7 staged plan; `-Box_null+Phi^2=0 => p^2=m^2`; Gate D must wait for Gate C | strategy | none (spine consistent) | **Docs-only strategy.** All heavy D-work gated by the Gate C kill-switch |

## 3. Convention conflicts and notation aliases to normalize

A. **Kinetic-operator naming AND decomposition (`K_h` / `K_null` / `Box_null` /
   `Kplus`).** This is more than a rename. In the tetrad-postulate report
   `Kplus := sum_{a,b} C_a C_b nabla_a nabla_b` and `Kplus = Boxnull + Cdiamond`,
   so `D_N^2 = Kplus + T_frame`. In `docs/CONVENTIONS.md` and the super-Dirac
   audit, `K_null` is the **symmetric box only** and `D_N^2 = K_null + C_diamond
   + T_frame`, i.e. `K_null` **excludes** `C_diamond`. Thus the report's `Kplus`
   equals `K_null + C_diamond`, not `K_null`. Normalize via job A6
   (`NullEdgeKineticNormalization`): pick one symbol for the symmetric box
   (recommend `Box_null`), one for `C_diamond`, and reserve `K_null` for exactly
   one of them, with an alias lemma. Do not let `Kplus`/`K_h`/`K_null` drift into
   the same trusted statement.

B. **FMS composite `O_e^a` vs corrected `W_e^a`.** CONVENTIONS "FMS/gauge-invariant
   composites" still lists the schematic `O_e^a = H_s^dag tau^a U_e H_t` as the
   (unlocked) target. The FMS audit proves that object is gauge-covariant
   (adjoint at the source vertex), **not** gauge invariant. Update the CONVENTIONS
   entry: keep status "Unlocked but narrowed"; record `O_e^a` as
   covariant-not-invariant; record the corrected gauge-invariant framed triplet
   `W_e^a = (1/2) tr(sigma^a X_s^dag U_e X_t)` plus singlet `H_s^dag U_e H_t` as
   the current working composite (reconstruction, not prediction).

C. **B_EW real- vs complex-coordinate convention.** The `dim ker = 1`, `rank = 3`
   counts hold only because `B_EW` is treated as an **R-linear** map
   `R^4 -> C^2`. This must travel as an explicit import on every downstream use;
   a C-coordinate reading changes the count. Lock it in the EW convention block.
   Do not "fix" any future conflict by silently switching to C-coordinates
   (that would weaken/alter the theorem).

D. **Generator convention.** Hermitian `T_i = sigma_i/2`, `Y(H)=1`,
   `Q=T_3+Y/2` is used consistently by EW-stabilizer, FMS, and anomaly, matching
   the locked CONVENTIONS choice. The EW report's note that the anti-Hermitian
   `i`-factor is an overall scalar (kernel/rank unchanged) should be recorded so
   the two conventions are not re-litigated. No conflict; record the bridge.

E. **Convention-import banner.** No returned proof file carries a standardized
   metric/grading/kinetic-sign/frame header. Introduce one template (part of A7
   convention appendix / G1 policy) and require it before trusted promotion.

## 4. Prioritized integration plan

Ordered to honor "integrate before expanding" and the §21 / backlog gating.

1. **Verification + scaffolding (do first).**
   - Statement-matches-claim re-verification of the four referenced Lean files
     against the live repo (they are absent from this snapshot). Confirm
     sorry-free and axiom-clean. (Prereq for ANY trusted promotion.)
   - G0 dependency DAG; G1 promotion policy + convention-import banner template;
     G2 sign/normalization dashboard over the four files.
2. **CONVENTIONS update (A3).** Fold in: §3-A kinetic naming/decomposition
   decision; §3-B FMS corrected composite; §3-C real-coordinate B_EW lock; §3-D
   generator-convention bridge; record the Gate C branch-count status and the
   super-Dirac sign verdict as the locked Gate A spec.
3. **Promote the safe results (with banners, post-verification).** EW stabilizer
   (structural theorem) and SM anomaly arithmetic (with its non-chirality
   disclaimer). Keep both in `Draft/` only until G1 banners attached.
4. **Hold the frame/square cluster.** Tetrad `D_N^2` identities stay trusted as
   standalone ring algebra but **draft-only** for the B4/P2 spine. Re-audit the
   scalar/Higgs kinetic file against B1/B3 (S8 dependency) before promoting;
   refactor both onto a shared B0 `NullSolderFrame`.
5. **Resolve Gate A in Lean (unblocks finite square).** A1
   `super_dirac_square_single` + odd companion; A2 grading counterexamples.
   No finite-square theorem is promotable until these land.
6. **Resolve the Gate C kill-switch.** C2a (raw branch script) / C2b
   (interpretation against acceptance criteria); C1/C3 determinant branch
   theorems. No Gate D / no-doubling / dynamical promotion until this clears.
7. **Citations.** Re-resolve every DOI/venue live; add original FMS; resolve or
   downgrade Wilczek; before any manuscript typesetting.

## 5. Hard-stop list (must NOT be incorporated as-is)

- **Any finite square theorem** (graded `D^2`, B4/P2 square spine) — blocked
  until Gate A is resolved in Lean (A1/A2/A3). [PROMPT guardrail, explicit.]
- **Any no-doubling / "retardedness avoids doublers" / continuum / dynamical
  claim** — the branch-count audit shows the flat tetrahedral retarded operator
  currently FAILS Gate C (corner null branches + positive-dimensional null
  variety + pervasive complex-energy branches; mass block does not remove them).
  Only "avoids coefficient-zero doublers; determinant-level branches remain to
  be tested" is sayable.
- **Any Krein -> stability / real-spectrum / positivity / unitarity claim** —
  explicit counterexamples exist; Krein `J`-self-adjointness is hygiene only.
- **FMS schematic `O_e^a` as gauge-invariant** — it is only covariant; use the
  corrected `W_e^a` triplet (+ singlet).
- **Any `B_QCD` / Plucker-derives-proton-mass / confinement theorem** — no
  finite structure or gap theorem exists.
- **Any prediction claim from the moduli map `F`** — reconstruction is not
  prediction; needs redundancy-robust `rank(dF) < dim M_EFT` or `R(theta)=0`.
- **Typesetting unverified citations** (`2508.17338`, `2604.07471`, original FMS,
  Wilczek "mass without mass") and the overclaim title/phrases listed in the
  prior-art audit (`origin of all mass`, `gauge symmetry breaks` as observable,
  `spectral gap` for the P1 Plucker invariant, `predicts/derives` for inputs).
- **Resolving any of the above by weakening a statement** (e.g. switching B_EW to
  C-coordinates to dodge the rank count, or dropping a load-bearing tetrad-postulate
  hypothesis) — forbidden by the PROMPT guardrails.

## 6. Recommended next jobs

Integration-freeze wave (no broad Wave-4 proof wave yet):

- **Verification job:** confirm the four referenced `Draft/*.lean` files exist,
  are sorry-free, axiom-clean, and that each theorem statement matches its report
  claim. (Unblocks promotion; currently unverifiable in this snapshot.)
- **G0/G1/G2 + A3:** dependency DAG, promotion policy with convention-import
  banner, sign/normalization dashboard, and the CONVENTIONS update folding in
  §3-A..E.
- **A1 + A2 (Gate A):** super-Dirac square sign Lean theorem (positive + odd
  companion) and grading counterexamples — top priority unblocker for B4.
- **C2a/C2b + C1/C3 (Gate C):** branch-count script (raw + interpreted) and
  determinant branch theorems — resolve the kill-switch before any D-work.
- **B0 -> B1 -> B3 -> B2 -> B4 ordering:** define `NullSolderFrame`, then the
  simplex frame and inverse-Gram, then diagonal obstruction, then (only after
  Gate A) the finite square decomposition. Re-audit S8 scalar kinetic against
  B1/B3 in this pass.
- **C5 + C7 (paired):** finite Krein-double self-adjointness theorem together
  with the "J-self-adjoint does not imply real spectrum/stability" counterexample.
- **E1 (after CONVENTIONS update and S11):** gauge invariance of the corrected
  FMS composite `W_e^a`.
- **Chirality:** pilot the domain-wall / SSH zero-mode (C9) only after Gate C
  branch-count evidence exists; carry the internal-chiral-rep + anomaly sums as
  the co-pilot bookkeeping layer.
- **Source:** live DOI re-resolution job before any submission.

Jobs explicitly NOT to launch now: any `B_QCD`/QCD theorem; any prediction-claim
job from `F`; any heavy Gate D continuum job ahead of Gate C; any FMS Lean job on
the schematic `O_e^a`.
