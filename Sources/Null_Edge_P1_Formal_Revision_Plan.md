# Formal P1 claim-boundary and title rewrite plan

**No-build manuscript strategy artifact, 2026-06-26.**

Scope: this document is a rewrite plan for the formal P1 paper currently drafted
in
[`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`](Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md).
It is a planning artifact only. No Lean, Lake, pre-commit, or build command was
run to produce it, and it changes no Lean source.

Sources consulted:

- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` (current P1 draft).
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, Sections 18-21
  (grand-strategy integration, four principles, blocker gates, integration
  freeze; in particular 18.3, 19.6, 20.2, 20.10, 21.7, 21.8).
- `docs/CONVENTIONS.md` (locked metric, umbrella-language, claim-label, and
  QCD-boundary conventions).
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md` (A.4 claim
  boundary, A.5 outlook posture, E.1 P1 architecture, F.3/F.4 phrase lists).

Central instruction being executed (Working Plan 21.7):

```text
Rewrite P1 so it does not depend on the success of P1.5 or P2.
P1 should be publishable as:
finite kinematic theorem + formalization + carefully bounded
origin-of-mass motivation.
```

The single load-bearing principle of this rewrite: **P1 must stand entirely on
the trusted finite Plucker theorem and its kernel-checked wrappers.** Every
sentence whose truth value waits on P1.5 (toy mass mechanisms) or P2 (the
super-Dirac operator) must be demoted to clearly-labeled outlook, motivation, or
forward pointer, never stated as a result of this paper.

Throughout, formulas are plain ASCII to match repository text hygiene
(`docs/CONVENTIONS.md`); LaTeX conversion is a later step. Lean placeholder
tokens are spelled with spaces (for example `s o r r y`) outside code.

---

## 0. Guardrail summary (binding on the whole rewrite)

From the PROMPT and the locked conventions, the formal P1 must respect:

1. **What P1 proves.** A finite kinematic Plucker theorem: the invariant mass
   squared of a finite null-spinor bundle equals its total pairwise Plucker
   spread, and the bundle is massless if and only if its null directions are
   projectively collinear. Plus the kernel-checked wrappers (reality and
   nonnegativity, exact massless criterion, celestial moment form, `SL(2,C)`
   covariance, twistor-chart matching, static Dirac square root), each carried
   with its own status label.

2. **What P1 does not derive.** QCD confinement, electroweak symmetry breaking,
   Yukawa matrices, neutrino masses, or the observed Standard-Model mass
   spectrum. These are out of scope and must not appear as theorem content.

3. **Avoid `spectral gap`** for the P1 Plucker invariant except as an explicit
   forward pointer to operator-level (P2) language. For the P1 invariant use
   `finite invariant mass`, `rank-one obstruction`, `quadratic Plucker
   obstruction`, or `rest-frame invariant of a null bundle`
   (`docs/CONVENTIONS.md`, "Umbrella language").

4. **No P1.5/P2 dependence.** The paper must be complete and reviewable with
   zero reliance on any unproved downstream theorem. Downstream work appears
   only as a short labeled outlook (Working Plan 21.7; grand-strategy A.5).

---

## 1. Formal title recommendation

### 1.1 Recommended formal title

```text
Invariant Mass from Finite Null-Spinor Bundles: A Frame-Audited Plucker Theorem
```

This is the publication-plan contract title endorsed by the grand-strategy
report (A.4) and Working Plan 18.3. It is accurate, narrow, and reviewable:

- "Invariant Mass" names the actual quantity (the determinant of the summed
  bispinor), not "the origin of all mass."
- "Finite Null-Spinor Bundles" states the object class precisely; nothing here
  promises a continuum, a dynamics, or a spectrum.
- "Frame-Audited" advertises the genuinely distinguishing contribution beyond
  textbook spinor-helicity: the explicit separation of the invariant `det(P)`
  from frame-relative quantities (`det(rho_{p|u})`, `m/E`) and the `SL(2,C)`
  covariance audit.
- "Plucker Theorem" is honest about the mathematical content: a determinant /
  exterior-algebra identity.

### 1.2 Title alternatives (acceptable fallbacks)

```text
A Finite Plucker Theorem for Invariant Mass of Null-Spinor Bundles
Invariant Mass as Total Pairwise Plucker Spread: A Formally Verified Finite Theorem
The Mass of a Null-Spinor Bundle: A Machine-Checked Plucker Identity
```

### 1.3 Titles to reject in the formal venue

```text
The Origin of Mass: matter as trapped, disagreeing light   (current draft title)
The Origin of (All) Mass
Mass as Trapped Light
Mass as a Spectral Gap
```

The current draft title `The Origin of Mass: matter as trapped, disagreeing
light` overclaims for a formal venue (it implies QCD/Higgs/spectrum coverage
that P1 does not provide) and uses poetic language that a referee will read as a
promise. **Keep that title for the expository companion only** (see Section 8).
Do not use `spectral gap` in the formal title at all (guardrail 3).

### 1.4 Recommended formal subtitle line / running head

Running head: `Finite null-spinor Plucker mass`. Optional one-line descriptor
under the title:

```text
A finite, machine-checked identity m^2 = sum_{i<j} | psi_i wedge psi_j |^2,
with an exact massless-iff-collinear criterion and a frame audit.
```

---

## 2. Claim-boundary box (place immediately after the abstract)

Insert the following as a visually boxed callout right after the abstract, before
Part I / the introduction. It is adapted from grand-strategy A.4 and Working
Plan 16.5/19.6, tightened so it depends on nothing downstream.

```text
+--------------------------------------------------------------------------+
| Claim boundary                                                           |
|                                                                          |
| This paper proves a finite kinematic theorem: a bundle of null spinor    |
| momenta has invariant mass precisely to the extent that its null         |
| directions fail to remain projectively collinear, with mass squared      |
| equal to the total pairwise Plucker spread,                              |
|                                                                          |
|     det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 . |
|                                                                          |
| The right-hand side is real and nonnegative, and vanishes if and only    |
| if all null directions coincide projectively. We also give covariance,   |
| celestial-moment, twistor-chart, and static Dirac-square-root wrappers,  |
| each carried with an explicit trusted / draft / artifact status label.   |
|                                                                          |
| This paper does NOT derive the Standard-Model mass spectrum, QCD         |
| confinement, electroweak symmetry breaking, Yukawa couplings, or         |
| neutrino masses. Those belong to later operator and dynamics layers and  |
| are not used or assumed anywhere in the results below. The theorem here  |
| supplies the square-level invariant that any such later null-edge        |
| dynamics must reproduce.                                                 |
|                                                                          |
| Scope of "mass": invariant particle or bound-state mass, or a spectral   |
| mass parameter in a relativistic field theory. We do not address         |
| gravitational source energy, ADM/Bondi mass, black-hole mass, or         |
| cosmological vacuum energy.                                              |
+--------------------------------------------------------------------------+
```

Why this box (grand-strategy A.4): it (i) states exactly what is proved,
(ii) names the four mechanisms readers will assume are covered and disclaims
them, (iii) gives the theorem a forward role ("square-level invariant any
dynamics must reproduce") without making P1 depend on that dynamics, and
(iv) excludes gravitational/cosmological mass, the standard reviewer trap for
"origin of mass" framings.

Independence note to keep in the box's surrounding text: the phrase "are not
used or assumed anywhere in the results below" is the explicit P1.5/P2
non-dependence guarantee required by Working Plan 21.7.

---

## 3. Abstract rewrite

Replace the current abstract (draft lines 33-80) with the following. It removes
the "organizing proposal" paragraph's load-bearing role, keeps exactly one
labeled program sentence (grand-strategy A.5), and never states a downstream
result as fact.

```text
Abstract.

We give and formally verify a finite, exact answer to one clean version of an
old question: how can invariant mass arise from massless, lightlike motion? We
model a visible particle-like system as a finite bundle of null edges, each a
ray of light-speed motion carrying energy and momentum but no rest mass, encoded
by a null two-spinor psi. The total momentum is the sum of the rank-one
Hermitian bispinors psi_i psi_i^dagger, and the invariant mass squared is the
2 x 2 complex determinant of that sum.

Our central result, checked by the Lean 4 proof kernel, is the exact identity

    det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 ,

where psi_i wedge psi_j is the spinor Plucker bracket. The right-hand side is
manifestly real and nonnegative and vanishes if and only if all null directions
coincide projectively. Equivalently, on the celestial sphere energy is the
monopole and momentum the dipole of a weighted set of light rays, and mass is
exactly the deficit by which the dipole fails to saturate the energy,
m^2 = (E^2 - |C|^2)/4. We supplement the identity with a frame audit
distinguishing the invariant det(P) from frame-relative quantities such as
det(rho_{p|u}) and m/E, with SL(2,C) covariance, a twistor-chart matching with
explicit normalization conventions, and a static Dirac square root; each
companion result is reported with an explicit trusted, draft, or standalone-
artifact status.

The contribution is a finite kinematic core: a fully finite, machine-checked
theorem identifying invariant mass with the geometric disagreement in direction
among lightlike constituents, together with an exact massless criterion. We do
not derive the Standard-Model mass spectrum, QCD confinement, electroweak
symmetry breaking, Yukawa matrices, or neutrino masses; those are out of scope.
This theorem is intended as the finite kinematic core of a broader null-edge
origin-of-mass program, in which effective mass is expected to appear as a
quadratic obstruction to remaining a single free gapless null mode -- a program
direction we describe only as outlook.
```

Key edits versus the current abstract:

- Drops the standalone organizing-proposal paragraph ("elementary visible motion
  is null motion ...") as a separate claim; its content survives as motivation in
  the introduction, not the abstract.
- Adds the frame-audit sentence (the actual novelty over textbook
  spinor-helicity), matching the title.
- Compresses the program to exactly one closing sentence, explicitly tagged
  "outlook" and worded with "expected to" rather than asserted (grand-strategy
  A.5: program is one sentence in the abstract).
- Contains no `spectral gap` (guardrail 3) and no claim about QCD/Higgs/neutrino
  results (guardrail 2).

---

## 4. Introduction rewrite outline

Goal: an introduction that motivates "trapped light" honestly, states the
theorem, and bounds the claim, with no dependence on P1.5/P2. Recommended
section flow for the formal P1 (the long high-school Part I narrative moves to
the expository companion, grand-strategy A.5/E.1).

1. **Opening sentence (protected; Working Plan 19.6).** Use verbatim:

   ```text
   This paper proves one exact finite mechanism: a finite bundle of null spinor
   momenta has invariant mass precisely to the extent that its null directions
   fail to remain projectively collinear.
   ```

   Follow immediately with the disclaimer sentence:

   ```text
   We do not derive QCD confinement, electroweak symmetry breaking, Yukawa
   matrices, neutrino masses, or the observed mass spectrum; those belong to
   later operator and dynamics layers.
   ```

2. **The question, briefly (1 short paragraph).** "Mass without mass": invariant
   mass from lightlike constituents is a familiar idea in relativity,
   spinor-helicity, and twistor theory. State that the contribution is a finite,
   exact, machine-checked version with an exact massless criterion -- not a new
   physical mechanism and not a dynamics.

3. **Setup in one paragraph.** Null edge -> null two-spinor psi; bispinor
   psi psi^dagger (rank-one, Hermitian, future-pointing null); bundle momentum
   = sum of bispinors; mass squared = its 2 x 2 determinant. Defer full
   conventions to the conventions section.

4. **Statement of the main theorem (display).** The determinant/Plucker identity
   and the massless-iff-projectively-collinear criterion, stated as the two
   headline results, with a pointer to the kernel-checked Lean declarations.

5. **What is genuinely new here (1 paragraph).** The finite n-edge forward
   direction (mass as total pairwise spread, not a single two-spinor pairing),
   the exact massless criterion, the frame audit (invariant vs frame-relative
   normalization), and the machine-checked packaging. Explicitly contrast with
   textbook spinor-helicity bookkeeping (the reverse "split one massive momentum
   into two null momenta" move).

6. **Claim boundary pointer.** One sentence pointing to the claim-boundary box
   and the claim ledger (Section 7), restating that QCD/Higgs/neutrino appear
   only as motivation/outlook.

7. **Program outlook, clearly labeled (1 short paragraph, optional).** "This
   finite theorem is the kinematic core of a broader null-edge program; the
   operator-theoretic and dynamical layers (a finite Dirac square root, toy mass
   mechanisms, a continuum limit) are the subject of separate work and are not
   used here." This is the only place the program is named prominently, and it
   carries an explicit "not proved here" tag.

8. **Paper structure paragraph.** Map to: conventions; single edge; two edges;
   finite bundle; reality/nonnegativity and massless criterion; celestial
   moment; covariance; twistor chart; static Dirac square root (forward pointer
   to P2); prior art; claim ledger; theorem-to-Lean crosswalk; reproducibility.

Discipline checks for the introduction:

- No sentence may assert a P1.5 or P2 result. The Dirac square root is
  introduced only as a "static" square-level identity and forward pointer
  (Section 9 of the draft already does this; keep that framing).
- No `spectral gap` except, if desired, one parenthetical forward pointer of the
  form "(the operator-level spectral-gap form is deferred to P2)".

---

## 5. Theorem-status table: trusted / draft / artifact / future

Use a four-status convention (Working Plan 18.2, 20.2). The first three statuses
describe results that exist and kernel-check today; "future" lists what is
explicitly out of scope for P1. This table supersedes the draft's Section 12
"Theorem-to-Lean map" by adding the explicit four-way labels and a future row.

```text
Result                                    Lean declaration                                   Status
----------------------------------------  -------------------------------------------------  --------
single null edge is massless              det_rankOneHermitian_eq_zero                       trusted
two-edge mass = squared wedge             two_edge_plucker_mass_identity                     trusted
two-edge massless iff wedge zero          two_edge_mass_zero_iff_wedge_zero                  trusted
wedge zero iff projectively collinear     spinorWedge_eq_zero_iff_exists_smul_..._nonzero    trusted
finite bundle mass = pairwise spread      fin_bundle_plucker_mass_identity                   trusted
determinant mass real, nonnegative        fin_bundle_det_im_eq_zero / _det_re_nonneg         trusted
determinant mass = nonneg real            fin_bundle_det_eq_ofReal_nonneg                    trusted
massless iff common direction             fin_bundle_mass_zero_iff_common_direction          trusted
two-twistor mass = squared wedge          two_twistor_mass_invariant_eq_plucker              trusted
multi-twistor mass = pairwise spread      multi_twistor_momentum_det_eq_pairwiseMass         trusted
twistor det-vs-trace normalization        twoTwistorMassSqDetConvention_eq_massInvariant /   trusted
                                          ..._TraceConvention_eq_two_massInvariant
celestial moment form (E^2-|C|^2)/4       pluckerMass_eq_energy_sq_sub_closureDefect_sq      artifact*
closed fan is rest frame                  closed_spinorFan_is_restFrame                      artifact*
SL(2,C) invariance of det mass            finBundleMomentum_det_sl2_invariant                draft**
static Dirac slash squares to mass        chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass  draft**

*  kernel-clean, but in the standalone Aristotle package
   (AgentTasks/.../null-edge-spinor-network-closure-20260621), not yet in the
   trusted PhysicsSM namespace. Promote before submission or cite as a clearly
   labeled appendix; do not present as trusted.
** kernel-clean draft in PhysicsSM.Draft.*; needs convention/semantic review
   (metric signature, grading, kinetic sign, frame normalization per the
   integration invariant, Working Plan 21.8) before promotion.

Future (explicitly NOT in P1; listed only to bound the claim):
- continuum Dirac equation / continuum square limit                            future (P2+)
- finite dual-soldered super-Dirac operator and its graded square              future (P2)
- toy mass mechanisms: Yukawa checkerboard, Abelian Higgs link stiffness,
  electroweak stabilizer kernel/rank                                            future (P1.5)
- Standard-Model mass spectrum, Yukawa textures/predictions                     future (later)
- QCD confinement, trace anomaly, proton mass                                   future (open)
- neutrino mass mechanism (Dirac/Majorana/seesaw, PMNS, ordering)               future (later)
- moduli-rank / codimension prediction gate                                     future (later)
```

Status-label policy for P1:

- Only "trusted" rows may be stated as results of this paper without
  qualification.
- "artifact*" and "draft**" rows must each carry their footnote inline at first
  mention, and the pre-submission action (promote or quarantine as labeled
  appendix) is mandatory (grand-strategy E.1).
- "future" rows must never be phrased as achieved; they exist to make the claim
  boundary auditable.

A typeset version of this table (trusted / draft / artifact / future as a
color-coded status map) is one of the recommended figures (grand-strategy E.1,
figure 3).

---

## 6. Keeping QCD / Higgs / neutrino as motivation and outlook (not theorem content)

Guardrail 2 forbids these as results. Guidance for how they may still appear:

1. **Allowed locations.** QCD, Higgs, and neutrino material may appear only in:
   the introduction's one-paragraph motivation, a clearly labeled "outlook /
   relation to the broader program" section near the end, and the prior-art /
   relation-to-prior-work section. They must not appear in any theorem,
   corollary, lemma, or the claim-boundary box's "what is proved" list.

2. **QCD wording (locked; `docs/CONVENTIONS.md` "QCD and hadron mass", Working
   Plan 20.10).** Use exactly:

   ```text
   QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
   ```

   The QCD "mass without mass" picture (most hadron mass is the energy of nearly
   massless confined constituents) is permitted as the physical motivation for
   the finite kinematic skeleton, with the explicit disclaimer "our theorem is
   the clean kinematic skeleton of that picture, not a derivation of QCD." Do not
   define a `B_QCD` obstruction map; there is no finite color-gap theorem
   (Working Plan 20.2).

3. **Higgs wording.** The Higgs may be described as supplying elementary bare
   fermion masses through Yukawa couplings, and (in the null-edge reading) as
   the permission/amplitude for chirality-flip vertices, **only** as motivation
   for the later P1.5/P2 layers. Keep the two locked separations visible even in
   motivation text: fermion masses live in `Phi_H^2`; W/Z masses live in
   `|nabla^A H|^2` / link stiffness (`docs/CONVENTIONS.md` "Fermion mass versus
   W/Z mass"). Use gauge-invariant language: "the Higgs field defines a covariant
   internal reference section; holonomies that fail to preserve it acquire
   quadratic cost; stabilizer directions remain gapless." Do not say a local
   gauge redundancy "breaks" as an observable fact.

4. **Neutrino wording.** Neutrinos may appear only as a stress-test description
   for the future bridge: oscillations imply at least two nonzero masses while
   direct bounds keep the scale sub-eV, so the null-edge reading is "almost pure
   weak-visible null propagation plus tiny hidden chirality/sterile/Majorana
   bookkeeping," explicitly "not an explanation of the neutrino spectrum." No
   Dirac-vs-Majorana selection, seesaw scale, or PMNS claim may be asserted.

5. **No-double-counting reminder in motivation.** When motivation mentions both
   the Plucker kinetic invariant and a Higgs/Yukawa mass, state the locked
   on-shell relation `K_null = Phi_H^2`, and never write
   `m_Plucker^2 + m_Higgs^2` as two additive sources
   (`docs/CONVENTIONS.md` "No double counting"). This is a wording guardrail even
   in non-theorem text.

6. **One-line litmus test for every QCD/Higgs/neutrino sentence.** "If P1.5 and
   P2 never succeed, is this sentence still true and non-misleading?" If not,
   re-label it as outlook or delete it. This operationalizes the 21.7
   independence requirement.

---

## 7. Claim ledger for P1

A four-way claim ledger (`docs/CONVENTIONS.md` "Claim labels"; Working Plan
18.2). Labels: Representation, Reconstruction, Structural theorem, Prediction.
P1 contains only Representation and Reconstruction items; it contains no
Prediction (prediction begins only at the moduli-rank/codimension gate).

```text
P1 claim ledger
---------------------------------------------------------------------------
Item                                            Label            In scope?
---------------------------------------------   --------------   ----------
null edge -> null spinor; bundle -> sum of      Representation   yes (P1)
  bispinors; mass^2 = det of summed bispinor
  (standard data on null-edge variables, no
  reduction of freedom)
det/Plucker mass identity for a finite          Reconstruction   yes (P1)
  null-spinor bundle (finite identity;
  canonical rank-one obstruction B_Pl)
massless iff projectively collinear             Reconstruction   yes (P1)
reality and nonnegativity of det mass           Reconstruction   yes (P1)
celestial monopole/dipole moment form           Reconstruction   yes (P1, artifact*)
closed fan = rest frame guardrail               Reconstruction   yes (P1, artifact*)
SL(2,C) covariance of det mass                  Reconstruction   yes (P1, draft**)
twistor-chart matching + normalization audit    Reconstruction   yes (P1)
static Dirac square root of the mass            Reconstruction   forward pointer
  (square-level only, not dynamics)               (to P2)        only
---------------------------------------------------------------------------
Yukawa checkerboard / chirality-flip gap        Reconstruction   NO (P1.5)
Abelian Higgs link stiffness                    Reconstruction   NO (P1.5)
electroweak stabilizer ker/rank                 Structural       NO (P1.5)
super-Dirac graded square                       Reconstruction   NO (P2)
continuum limit / commuting square              (gate)           NO (P2+)
SM mass spectrum, Yukawa textures               Prediction       NO (later/open)
QCD confinement / proton mass                   (no clean B yet) NO (open)
neutrino mass mechanism                          Structural/      NO (later)
                                                 Prediction
moduli-rank / codimension constraint            Prediction       NO (gate)
---------------------------------------------------------------------------
```

Canonical obstruction datum for P1 (`docs/CONVENTIONS.md` "Canonical obstruction
datum"; Working Plan 20.2):

```text
S   = a finite family of null two-spinors psi : Fin n -> C^2 (a null bundle)
B   = B_Pl(Psi) = ( psi_i wedge psi_j )_{i<j}    (the pairwise Plucker brackets)
ker B  = the projectively-collinear / single-direction locus (massless)
B^dagger B  = sum_{i<j} | psi_i wedge psi_j |^2 = det(sum_i psi_i psi_i^dagger)
            = m^2 (the quadratic obstruction away from collinearity)
Status: finite identity; canonical rank-one obstruction.
```

This is the single canonical obstruction map P1 is allowed to claim. `B_Y`,
`B_EW`, `B_Higgs`, and `B_QCD` are explicitly out of scope for P1 (they belong to
P1.5 / later work) and appear in the ledger only as "NO (P1.5)" / open rows.

Ledger headline sentence for the paper (front-matter, grand-strategy F.5
posture):

```text
P1 is a reconstruction paper: a finite, formally verified Plucker mass identity
and its exact massless criterion. It is not a prediction paper, and it does not
depend on the success of the later toy-mechanism (P1.5) or super-Dirac (P2)
layers.
```

---

## 8. Expository-companion note: where poetic "disagreeing light" language can safely live

Recommendation (grand-strategy A.5, E.1; Working Plan 18.3): split the current
draft into two documents.

- **P1-F (formal).** Title from Section 1.1; contents per Sections 2-7 above;
  audience is referees of a formalized-mathematics or math-physics venue;
  tolerance for vision is low. Poetic language is excluded from theorems,
  abstract, and the claim-boundary box.
- **P1-E (expository companion).** Title may keep `The Origin of Mass: matter as
  trapped, disagreeing light`; audience is general/curious readers; tolerance for
  vision is high. This is the correct home for poetic framing.

What moves to P1-E (currently Part I of the draft, lines 82-358):

- the high-school narrative sections ("A question that sounds silly...", "Light
  has no mass -- and that is the clue...", "Two beams of light can weigh
  something", "This is where your weight actually comes from");
- the "disagreeing light" exposition ("Our contribution: making 'disagreeing
  light' exact");
- the "picture you can hold in your head" celestial-sphere arrow image;
- the full Higgs / QCD / neutrino narrative motivation, at length.

Rules for the poetic language even in P1-E:

1. Poetic phrasing ("trapped light", "disagreeing light", "the price of
   disagreement", "matter as trapped light") is allowed in P1-E prose and
   figures, but P1-E must still carry a short claim-boundary note pointing to
   P1-F for the precise statements, so a casual reader does not infer that QCD,
   Higgs, or neutrino masses are derived.
2. P1-E may describe the broader program prominently (this is its purpose), but
   must still mark unproved layers (P1.5, P2, predictions) as "not yet proved."
3. The exact theorem and the massless criterion should appear in P1-E too, in
   plain words, so the expository and formal papers agree.
4. Cross-reference both ways: P1-F cites P1-E as "expository companion"; P1-E
   cites P1-F as "the formal, machine-checked statements and proofs."

What stays out of both, as poetic language, in formal theorem text:

- `spectral gap` for the P1 invariant (guardrail 3);
- `We explain the origin of all mass`, `All mass is Plucker spread`,
  `The Plucker theorem derives the proton mass` (grand-strategy F.3);
- any wording implying observable breaking of a local gauge redundancy.

Phrases to prefer in P1-F (grand-strategy F.4; `docs/CONVENTIONS.md`):

```text
finite kinematic core
finite invariant mass / rest-frame invariant of a null bundle
quadratic Plucker obstruction / rank-one obstruction
obstruction to remaining a single free gapless null ray
mass as quadratic obstruction by a canonical B
QCD supplies confinement and dynamics; Plucker supplies invariant accounting
reconstruction / representation / structural theorem / prediction
```

---

## 9. Pre-submission action checklist (so P1 truly stands alone)

1. Apply the title from Section 1.1; move the poetic title to P1-E (Section 8).
2. Insert the claim-boundary box (Section 2) immediately after the abstract.
3. Replace the abstract (Section 3) and restructure the introduction (Section 4).
4. Replace the theorem-to-Lean map with the four-status table (Section 5); add
   the "future" rows.
5. Resolve every `artifact*` and `draft**` row: either promote into trusted
   `PhysicsSM` with a convention/semantic review (integration invariant, Working
   Plan 21.8 -- declare metric signature, grading, kinetic sign, frame
   normalization), or quarantine as a clearly labeled appendix. Do not present
   drafts as trusted.
6. Confine all QCD/Higgs/neutrino text to motivation/outlook per Section 6; run
   the Section 6.6 litmus test on each such sentence.
7. Insert the claim ledger (Section 7) and the canonical-obstruction datum box.
8. Grep the formal manuscript for `spectral gap`, `origin of all mass`,
   `all mass`, `derive(s) the proton mass`, `predict`, and `gauge symmetry
   breaks`; remove or re-label per guardrails 2-3 and grand-strategy F.3.
9. Verify the independence invariant: removing every "future" row and every
   P1.5/P2 reference must leave the paper's results and proofs intact. If any
   result breaks, it was mis-scoped and must be demoted to outlook.
10. (Editorial) ASCII-to-LaTeX conversion and the five recommended figures
    (two photons in a box; fanned celestial sphere with mass deficit; trusted/
    draft/artifact/future status map; theorem-to-Lean crosswalk; conventions
    table) per grand-strategy E.1.
