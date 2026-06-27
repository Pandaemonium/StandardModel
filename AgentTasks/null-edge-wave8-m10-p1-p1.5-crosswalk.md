# Wave 8 M10 — P1 → P1.5 manuscript/proof crosswalk

Date: 2026-06-26.
Type: manuscript/proof crosswalk + no-build claim audit (this document carries
no new Lean proofs; it audits what is already in the repository).

Inputs read: `PROMPT.md`, `COMMON_CONTEXT.md`,
`Sources__Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`,
`Sources__Null_Edge_Causal_Graph_Publication_Plan.md`,
`AgentTasks__null-edge-wave8-master-strategy.md`, and every `*.lean` file in the
repository root.

Verification performed for this audit (Lean 4 `v4.28.0`, Mathlib `v4.28.0`):
- Full project build: **success, 8035 jobs, no errors, no `sorry`** (grep over
  all `*.lean` confirms zero `sorry`/`admit`/`axiom`/`opaque` tokens outside
  comments).
- `#print axioms` on every headline theorem (see §1 / §3): each depends only on
  `propext, Classical.choice, Quot.sound` — i.e. all are **kernel-backed** with
  the standard Mathlib axiom set; no custom axioms or `native_decide`/`ofReduceBool`.

---

## 0. Headline finding (publication-blocking, read first)

The P1 manuscript (`Sources__Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`)
lists five Lean anchors as "trusted unless noted". **Only one of them is present
in this repository.** The other four modules — including one the manuscript's
theorem-to-Lean table marks `trusted` — are **absent from the shipped artifact
bundle**:

| Manuscript anchor (as cited)                         | Manuscript label | In this repo? |
|------------------------------------------------------|------------------|---------------|
| `PhysicsSM.Spinor.PluckerMass`                       | trusted          | **YES** (`PhysicsSM__Spinor__PluckerMass.lean`) |
| `PhysicsSM.Spinor.TwistorPluckerMass`                | trusted          | **NO** |
| `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`      | draft kernel-clean | **NO** |
| `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`     | draft kernel-clean | **NO** |
| `NullEdgeSpinorNetworkClosure` (standalone artifact) | artifact kernel-clean | **NO** |

Consequence for the crosswalk: relative to *this deliverable*, every P1 claim
that points at a missing module is **source-backed only** (a provenance note in
prose), regardless of how the manuscript labels it. Three manuscript table rows
currently marked `trusted` (the two twistor rows) cannot be reproduced from the
files in this repository. This is the single most important thing to fix before
P1 submission: either re-vendor those modules into the trusted `PhysicsSM`
surface, or downgrade their labels in the manuscript (see §4 and §6).

By contrast, the **entire P1.5 finite-obstruction spine is present and
kernel-backed in this repository** (§3). So the Wave-7 recommendation "ship P1
then P1.5, hold branch/Krein as hedge" is sound, but with one inversion of
local readiness: *in this bundle the P1.5 Lean surface is more complete than the
P1 Lean surface.* P1's prose is mature; P1's auxiliary Lean anchors are not all
shipped here.

---

## 1. Claim label legend

We use the five explicit labels requested by the prompt:

- **theorem** — a kernel-checked Lean statement (no `sorry`), present and
  building in this repository, with standard axioms only.
- **reconstruction** — a finite/linear-algebra result that re-derives a
  known structure (lattice gauge-Higgs, singular values, EW stabilizer) inside
  the null-edge language; true and checked, but not novel physics on its own.
- **architecture** — a structural design statement (operator unification,
  soldering, super-Dirac square) used to organize the program; not itself a
  single checked theorem.
- **prediction** — a falsifiable physical claim requiring `rank(dF) < dim
  M_EFT` or a nontrivial relation `R(theta_EFT)=0`. *No P1/P1.5 claim qualifies;
  none should be labeled prediction.*
- **speculation** — interpretation/manifesto language not backed by a checked
  statement (e.g. "all mass is trapped light").

---

## 2. P1 claim → Lean crosswalk

P1 = `The Origin of Mass` (`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`).
"Repo status" is the status *in this artifact bundle*; "Manuscript label" is what
the draft currently asserts.

| # | P1 claim (prose) | Intended Lean declaration | Module present here? | Repo status | Correct label |
|---|------------------|---------------------------|----------------------|-------------|---------------|
| P1-a | A single null edge is massless: `det(psi psiᴴ)=0` | `det_rankOneHermitian_eq_zero` | yes (`PluckerMass`) | **kernel-backed** | theorem |
| P1-b | Two-edge mass = squared spinor wedge | `two_edge_plucker_mass_identity` | yes | **kernel-backed** | theorem |
| P1-c | Two-edge massless ⇔ wedge zero | `two_edge_mass_zero_iff_wedge_zero` | yes | **kernel-backed** | theorem |
| P1-d | Wedge zero ⇔ projective collinearity | `spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero` | yes | **kernel-backed** | theorem |
| P1-e | Finite bundle mass = total pairwise Plücker spread | `fin_bundle_plucker_mass_identity` | yes | **kernel-backed** | theorem (keystone) |
| P1-f | Determinant mass is real, nonnegative | `fin_bundle_det_im_eq_zero`, `fin_bundle_det_re_nonneg`, `fin_bundle_det_eq_ofReal_nonneg` | yes | **kernel-backed** | theorem |
| P1-g | Bundle massless ⇔ one common null direction | `fin_bundle_mass_zero_iff_common_direction` | yes | **kernel-backed** | theorem (headline iff) |
| P1-h | Celestial moment form `m² = (E²−|C|²)/4` | `pluckerMass_eq_energy_sq_sub_closureDefect_sq` | **no** (standalone artifact, not vendored) | **source-backed only** | theorem-elsewhere; treat as appendix/citation |
| P1-i | Closed fan is rest frame (`m² = E²/4`, not zero) | `closed_spinorFan_is_restFrame` | **no** | **source-backed only** | theorem-elsewhere; guardrail |
| P1-j | `SL(2,ℂ)` invariance of determinant mass | `finBundleMomentum_det_sl2_invariant` | **no** | **source-backed only** | theorem-elsewhere (draft) |
| P1-k | Two-twistor mass = wedge | `two_twistor_mass_invariant_eq_plucker` | **no** | **source-backed only** (manuscript wrongly marks `trusted`) | theorem-elsewhere |
| P1-l | Multi-twistor mass = pairwise | `multi_twistor_momentum_det_eq_pairwiseMass` | **no** | **source-backed only** (manuscript wrongly marks `trusted`) | theorem-elsewhere |
| P1-m | Static chiral Dirac slash squares to mass | `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` | **no** | **source-backed only** | theorem-elsewhere (P2 forward pointer) |
| P1-n | "Mass is trapped, disagreeing light" / QCD "mass without mass" / Higgs flip story | (Part I narrative) | n/a | interpretation | **speculation** (clearly fenced as Part I) |
| P1-o | Continuum Dirac limit, SM spectrum, neutrino mechanism, QCD confinement | (explicitly deferred) | n/a | out of scope | not claimed — keep in "separate work" |

Reading of the table:
- **Kernel-backed in this repo:** P1-a … P1-g. These are exactly the contents of
  `PhysicsSM__Spinor__PluckerMass.lean` and they fully support the P1 headline
  ("invariant mass = pairwise Plücker spread; massless ⇔ collinear"). The paper's
  core theorem can stand on this module alone.
- **Source-backed only here (kernel-clean elsewhere, but not in this bundle):**
  P1-h … P1-m. The manuscript's own labels for P1-h/-i (artifact), P1-j/-m
  (draft) are honest; but **P1-k and P1-l are labeled `trusted` while their
  module is absent** — that is the overclaim to fix (§4).
- **Speculation:** P1-n, correctly confined to Part I and the abstract's
  "conceptual statement" sentence.
- **Correctly deferred:** P1-o.

---

## 3. P1.5 theorem spine (finite quadratic obstructions) — all present & kernel-backed

P1.5 = the finite quadratic-obstruction companion. Every spine module below is
in this repository, builds, has no `sorry`, and uses standard axioms only
(verified by `#print axioms`).

| Spine entry | File / namespace | Key declarations | Status | Label |
|-------------|------------------|------------------|--------|-------|
| **Two-null split (observer axis)** | `PhysicsSM__Draft__NullEdgeP1TwoNullMasslessIff` | `splitMassSq`, `splitMassSq_eq_zero_iff_left_or_right_zero`, `splitMassSq_pos_iff_left_and_right_pos` | **kernel-backed** | theorem (`m²=4ab` collinearity in the 1+1 split; P1↔P1.5 hinge) |
| **Yukawa checkerboard (T5/T6)** | `PhysicsSM__Draft__NullEdgeYukawaCheckerboard` | `yukawa_checkerboard_square`, `nonzero_eigenvalue_swap`, `yukawa_nonzero_eigenvalue_correspondence`, `yukawa_ker_self`, `yukawa_ker_adjoint` | **kernel-backed** | reconstruction (singular-value/`MMᴴ`↔`MᴴM` correspondence in null-edge dress) |
| **Abelian Higgs link stiffness (T8)** | `PhysicsSM__Draft__NullEdgeAbelianHiggsLink` | `linkStiffness_gauge_invariant`, `linkStiffness_frozen_modulus`, `circle_normSq_sub_one_eq`, `small_holonomy_quadratic_bound` | **kernel-backed** | reconstruction (gauge invariance + frozen-modulus identity are theorems; `v²θ²` mass term is labeled interpretation in-file) |
| **Electroweak stabilizer (T9)** | `PhysicsSM__Draft__NullEdgeElectroweakStabilizer` | `B_EW_eq_matrix`, `ew_stabilizer_kernel`, `ew_stabilizer_kernel_finrank`, `ew_stabilizer_rank`, `ew_quadratic_form_kernel` | **kernel-backed** | reconstruction (`ker = span{Q} = u(1)_em`, rank 3; structural, not a photon-mass prediction) |
| **Scalar/gauge kinetic reconstruction** | — | — | **not present** | architecture only — see "safe?" note below |

Recommended P1.5 spine ordering for the paper (simplest→structural):
`splitMassSq` (hinge from P1) → `yukawa_checkerboard_square` + correspondence
→ `linkStiffness_*` → `ew_stabilizer_*` / `ew_quadratic_form_kernel`.

**Is scalar/gauge kinetic reconstruction safe to include?** Not yet, in this
bundle. There is no kinetic-reconstruction Lean module present, and
`COMMON_CONTEXT.md` plus the master strategy flag the continuum/kinetic track as
Gate-C-gated and the kinetic mass interpretation as *interpretation, not
theorem*. Recommendation: **exclude scalar/gauge kinetic reconstruction from
the P1.5 theorem spine**; mention it only as architecture/outlook. Including it
as a "theorem" would be an overclaim. The Abelian-Higgs file already models the
right discipline: the gauge-invariant link-stiffness identity is the theorem;
the `v²ε²A²` gauge-boson mass is explicitly labeled interpretation.

Anti-double-counting guardrail to state once in P1.5 (per `COMMON_CONTEXT.md`):
Plücker/null spread is the **kinetic-side** `Λ²` invariant; `Φ_H²` is the
**internal zero-order** block; on shell `K_null = Φ_H²`, *not*
`m_Plücker² + m_Higgs²`. Fermion masses live in `Φ_H²`; W/Z masses live in
`|∇^A H|²` / link stiffness / Higgs-orbit obstruction. The Yukawa file's sign
convention (`D² = −K + Φ²`, on shell `K = Φ²`) is already consistent with this.

---

## 4. Suggested edits to remove overclaiming

Concrete, minimal edits to the P1 manuscript
(`Sources__Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`). None change the
mathematics; they align labels with what is reproducible from the shipped Lean.

1. **§12 theorem-to-Lean table — fix two false `trusted` rows.** The rows
   `two_twistor_mass = wedge` (`two_twistor_mass_invariant_eq_plucker`) and
   `multi-twistor mass = pairwise` (`multi_twistor_momentum_det_eq_pairwiseMass`)
   are marked `trusted`, but `PhysicsSM.Spinor.TwistorPluckerMass` is not in the
   shipped bundle. Either (a) re-vendor that module and re-verify, or (b)
   change both rows' status from `trusted` to `draft**` / `cite` until promoted.

2. **Header line 9 ("Lean anchors (trusted unless noted)").** Four of the five
   listed anchors are not in this repository. Add an explicit note: only
   `PhysicsSM.Spinor.PluckerMass` ships in the trusted surface of this bundle;
   `TwistorPluckerMass`, `NullEdgeSpinorGeometryTargets`,
   `NullEdgeBundleDiracPluckerCore`, and the standalone
   `NullEdgeSpinorNetworkClosure` artifact are referenced from external
   packages and must be re-vendored or cited as appendices before submission.

3. **Provenance paragraph (line 17).** It states "Every Lean declaration named
   in Part II was confirmed to exist in the cited module." This is true of the
   *external* checkout it was written against, but is **not** reproducible from
   this repository for the absent modules. Add the toolchain + commit pin and a
   pointer to where each absent module lives, or vendor them.

4. **Abstract.** The phrase "checked by the Lean 4 proof kernel, is an exact
   identity" is accurate for the keystone (P1-e/-g). Keep it scoped to the
   determinant/Plücker identity and the massless-iff criterion (the
   `PluckerMass` module), and avoid implying the twistor/`SL(2,ℂ)`/Dirac-square
   wrappers are kernel-checked *in the submitted artifact* unless they are
   vendored. (See §5 for safe abstract wording.)

5. **Label hygiene throughout.** Keep Part I ("trapped, disagreeing light",
   QCD "mass without mass", Higgs flip) explicitly fenced as **speculation /
   interpretation** (it already is — preserve the Part I / Part II split). Ensure
   no Part II sentence promotes the interpretation to "theorem".

No deletions are recommended — only label/status corrections and a vendoring
note. Per repository policy, do not silently weaken or remove any user content;
these are additive status corrections.

---

## 5. Safe abstract-level claim boundary

### P1 — safe boundary statement

> **Established (finite linear algebra, kernel-checked in
> `PhysicsSM.Spinor.PluckerMass`):** For any finite family of visible null
> two-spinors `psiᵢ`, the determinant of the summed rank-one Hermitian momenta
> equals the total pairwise squared Plücker spread; this determinant mass is real
> and nonnegative; and it vanishes **iff** all spinors share one projective null
> direction. Equivalently, invariant mass is the failure of a bundle of lightlike
> momenta to be collinear.
>
> **Companion (kernel-clean but to be vendored/cited):** celestial
> monopole/dipole form `m²=(E²−|C|²)/4`, `SL(2,ℂ)` invariance, twistor-chart
> matching, and the static Dirac square root. These are auxiliary wrappers, not
> the headline, and must be promoted into the trusted surface or marked as
> appendix/citation before submission.
>
> **Not claimed:** no continuum Dirac dynamics, no Standard-Model mass spectrum
> or Yukawa values, no QCD confinement / proton mass, no neutrino mechanism, no
> cosmological source-visibility claim, and no projective-twistor geometry. Part
> I is intuition; the theorem is the finite kinematic identity of Part II.

### P1.5 — safe boundary statement

> **Established (finite linear algebra / representation theory, kernel-checked):**
> (i) in the observer-axis split, `m² = 4ab` vanishes iff one null component is
> absent; (ii) a constant Yukawa block `M` gives the chiral checkerboard square
> `K = MMᴴ` / `MᴴM` with matching nonzero spectra and `ker` descriptions; (iii)
> the finite Abelian-Higgs link-stiffness action is gauge invariant and, at
> frozen modulus, equals `v²Σ|wₑ−1|²`; (iv) the electroweak orbit-obstruction map
> has kernel `span{Q}=u(1)_em` and rank 3.
>
> **Labeled interpretation, not theorem:** the `v²θ²` gauge-boson mass term (a
> small-holonomy expansion of (iii)); photon "masslessness" read off from (iv)
> (it is the stabilizer statement, forced by group + representation + vacuum,
> **not** a prediction).
>
> **Anti-double-count:** Plücker spread is the kinetic-side `Λ²` invariant;
> `Φ_H²` is the internal block; on shell `K_null = Φ_H²`. Mass is not
> `m_Plücker² + m_Higgs²`.
>
> **Not claimed / excluded from the spine:** scalar/gauge kinetic
> reconstruction (architecture only, Gate-C-gated), continuum convergence, and
> any branch/Krein result (held as hedge, see §7).

---

## 6. Blocking Lean theorem promotions before submission

Exact files/names that must be promoted (re-vendored into the trusted
`PhysicsSM` surface of *this* repository and re-verified `#print axioms`) before
the corresponding paper ships.

### Blocking for **P1** (in priority order)
1. `PhysicsSM.Spinor.TwistorPluckerMass` →
   `two_twistor_mass_invariant_eq_plucker`,
   `multi_twistor_momentum_det_eq_pairwiseMass`,
   `twoTwistorMassSqDetConvention_eq_massInvariant`,
   `twoTwistorMassSqTraceConvention_eq_two_massInvariant`.
   **Blocking** because the manuscript labels these `trusted`. Until vendored,
   downgrade the labels (§4.1).
2. `NullEdgeSpinorNetworkClosure.Finite` →
   `pluckerMass_eq_energy_sq_sub_closureDefect_sq`,
   `closed_spinorFan_is_restFrame` (the `(E²−|C|²)/4` moment form and the
   rest-frame guardrail). Promote *or* clearly cite as a standalone-artifact
   appendix.
3. `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets` →
   `finBundleMomentum_det_sl2_invariant` (Lorentz covariance). Needs the
   convention/semantic review noted in the manuscript, then promotion out of
   `Draft`.
4. `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` →
   `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass`. Lowest priority for P1:
   it is explicitly a P2 forward pointer; keep as a flagged bridge, not a P1
   result.

P1 can ship on item-1-downgrade + the already-present `PluckerMass` module if
schedule forces it; items 1–3 should be vendored for the strongest version.

### Blocking for **P1.5**
**None.** The full spine
(`NullEdgeP1TwoNullMasslessIff`, `NullEdgeYukawaCheckerboard`,
`NullEdgeAbelianHiggsLink`, `NullEdgeElectroweakStabilizer`) is present,
kernel-backed, and standard-axiom-clean in this repository. Remaining work is
editorial: promote the four `Draft` namespaces to a stable `PhysicsSM.*` surface
(naming only) and write the anti-double-count and interpretation guardrails into
the prose. Do **not** add a scalar/gauge kinetic "theorem" (§3).

---

## 7. P1 → P1.5 paper-sequence recommendation

1. **Ship P1 first** (`The Origin of Mass`): headline = the kernel-checked
   determinant/Plücker mass identity and the massless-iff-collinear criterion
   (`PhysicsSM.Spinor.PluckerMass`, fully present here). Apply the §4 label
   fixes and vendor the §6 P1 anchors (or cite them as appendices). Claim
   boundary per §5.
2. **Ship P1.5 second** (finite quadratic obstructions): spine per §3 in the
   given order, with the anti-double-count guardrail and the
   interpretation-vs-theorem fences. No blocking Lean work; this is the most
   Lean-complete part of the bundle and de-risks the program quickly.
3. **Hold the branch/Krein audit as the standing hedge — not a dependency.**
   Per `COMMON_CONTEXT.md` and the master strategy, Gate C (flat branch
   count / determinant-zero classification) is the program kill switch and is
   the proposed home of the publishable hedge (the audit paper). Neither P1 nor
   P1.5 may take a logical dependency on the branch/Krein/`Γ_f` flavored-chirality
   results; those continuum/spectral claims stay gated until Gate C returns
   nonfatal. P1 and P1.5 are deliberately Gate-C-independent finite results, so
   they ship regardless of the Gate C verdict.
4. The unified-mass / manifesto paper (P8) and the continuum Dirac dynamics (P2,
   P4) remain skeletons behind Gates C/D/F and are out of scope for this
   crosswalk.

---

## 8. One-line status ledger

- P1 core (`PluckerMass`): **present, kernel-backed, ship-ready** (after §4 label
  fixes).
- P1 wrappers (twistor / `SL(2,ℂ)` / moment / Dirac-square): **absent from this
  bundle — vendor or cite** (§6); two table rows currently overclaimed as
  `trusted`.
- P1.5 spine (split / Yukawa / Abelian-Higgs / EW-stabilizer): **present,
  kernel-backed, ship-ready**; exclude kinetic reconstruction from the spine.
- Branch / Krein / `Γ_f`: **hedge only, Gate-C-gated, not a dependency**.
