# Adversarial load-bearing audit — "All mass from null edges" capstone

**Scope.** Source-grounded, claim-discipline red-team of
`PhysicsSM/Draft/NullEdge/GateI1/AllMassFromNullEdges.lean`
(`allMassFromNullEdges`) and its governing doc
`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`, plus the
four cited underlying theorems. **No Lean was modified; no build/prover was
run.** All five Lean files and the doc were read in full; supporting definitions
(`quarkMassParameter`, `Q_op`/`Q_v1`/`Q_v4`, `cNormSq`, `Γ5`/`Γ5_mul_Γ5`,
`wilsonDirac`) were inspected.

**Files accessed (all present):**
- `GateI1/AllMassFromNullEdges.lean` (capstone)
- `GateI1/CompositeApertureMass.lean` — (A)
- `GateI1/MassWithoutMass.lean` — (C)
- `GateI1/ChargeGradingMassCompatible.lean` — co-location
- `GateYM/ChiralMassStructure.lean` — (T)
- `NULL_EDGE_MASS_UNIFICATION.md` (governing doc)

**One-line bottom line.** The capstone is *technically honest at the theorem
level* (each conjunct is discharged by a real, `sorry`-free theorem and it hedges
"conjunction, not a single mechanism"), but it carries **one hard
claim-discipline defect** (it cites a taxonomy-separation guard,
`MassTaxonomySeparation`, that **does not exist**), **two mislabeled conjuncts**
(the (T) turn conjunct and the (C) "zero primitive mass" half are weaker than
their prose), and an **over-claiming name/thesis** (`allMassFromNullEdges` + the
doc's universal "every physical mass" language).

---

## Q1 — Is any conjunct VACUOUS or MISLABELED?

### (A) Aperture — `compositeMassSq_eq_zero_iff_collinear` — **SOUND**
Strongest conjunct. Genuine, fully-proved, frame-invariant kinematic identity:
for future-pointing null momenta, `minkowskiSq (∑ pᵢ) = 0 ↔` the bundle is
collinear. The nontrivial content (reverse Cauchy–Schwarz on the future cone via
the 3D Lagrange identity, plus the collinearity-extraction equality case) is
really proved, not asserted. The kernel statement fully supports the "(A)
aperture / massless iff one null edge" reading. Frame status is honest (Lorentz
invariants). No over-claim.

### (C) Closure — `massWithoutMass` — **SOUND (gap) / MISLABELED (the "zero mass" half is definitional)**
Two sub-claims:
- `0 < z2GlueballMass beta` (= `log coth beta`): **genuine** finite identity. The
  `2×2` operator is real-symmetric (`transfer2_transpose`), its two eigenvectors
  `(1,1)`, `(1,−1)` are orthogonal and span, so the two proven eigenvalues
  `e^β ± e^{−β}` are the *full* spectrum; the gap positivity is real.
- `quarkMassParameter = 0`: **definitional, not derived.**
  `noncomputable def quarkMassParameter : ℝ := 0`, and the conjunct is discharged
  by `rfl`. It asserts nothing about the model — it is a named constant equal to
  its own definition. As a "fact" ("zero primitive mass") it is essentially
  vacuous; the *content* is entirely in the gap.

Does it smuggle in a regulator? **No** — and the source's own claim on this is
correct: with no fermions there is no Wilson regulator and no bare fermion mass.
This is the honest reason the pure-gauge toy is cleaner than a fermionic one.

Residual caveat (not a soundness bug, but a labeling one): the identification
"this `2×2` matrix *is* the Z2 single-plaquette transfer operator" and "the
log-eigenvalue-ratio *is* the glueball mass" are **definitions by fiat**, not
derived from a lattice gauge action or a proved transfer-matrix/reflection-
positivity construction. The doc labels this correctly as a "TOY category-(3)
gap; NOT the physical YM mass gap," so the hedge is present — but a reader should
know the "mass" is a *chosen name* for `log coth β`, not a spectral quantity of a
reconstructed physical theory.

### (co-location) `charge_grading_mass_compatible` — **SOUND but a NEGATIVE result; equality rests on a norm coincidence**
The kernel statement bundles three facts: `Q_op v1 = (−2/3)•v1`,
`Q_op v4 = (−1/3)•v4` (both are real, kernel-checked eigenvalue theorems `Q_v1`,
`Q_v4` upstream — a genuine charge difference), and `massForm v1 psi = massForm
v4 psi`. The mass equality holds because `massForm z psi = cNormSq z *
spacetimeMass psi` and `cNormSq v1 = cNormSq v4 = 1/2`. So the equality is a
**norm coincidence** inside the ideal: `massForm` *can* see the octonion factor,
but only through the SU(3)-invariant norm, which is `1/2` for the whole family.
The theorem therefore shows "a mass built solely from the SU(3)-invariant
octonion norm cannot separate equal-norm states of different charge" — which is
close to true-by-construction of `massForm`. It is **not vacuous** (the
counterfactual `coupling_would_distinguish` shows a charge-coupled mass *would*
separate `−2/3` from `−1/3`), and the source honestly labels it "co-location,
not coupling." Correctly labeled; the only risk is the capstone gloss "mass is
blind to the Q_op charge" reading as a universal claim (it is a property of *this*
norm-weighted form, not of every mass mechanism — Higgs/Yukawa would not be
blind).

### (T) Turn — `gamma5_mass_diff_comm` — **MISLABELED (weaker than "mass IS the turn channel, cleanly separated")**
This is the audit's headline mislabel. The bundled theorem states
`Γ5 (D_m − D_{m'}) Γ5 = D_m − D_{m'}` ("mass content is chirality-even"). But
the companion lemma `wilsonDirac_mass_diff` (same file) proves
`D_m − D_{m'} = (m − m')•1`, a **pure scalar operator**. Conjugating a scalar
multiple of the identity by the involution `Γ5` (`Γ5² = 1`, via `Γ5_mul_Γ5`)
returns it unchanged **trivially**. So the conjunct is a near-tautology: it is
chirality-even because the mass difference is a scalar, and *all* transport /
gauge-hop terms have already cancelled out of the difference and are never
examined.

Consequently the capstone docstring's reading —
> "The entire mass dependence commutes with chirality, i.e. it lives in the
> 'turn' channel, cleanly separated from the chirality-odd null-transport
> channel"

is **not supported by the bundled conjunct.** `gamma5_mass_diff_comm` establishes
only "mass content is chirality-even"; it does **not** establish that transport
is chirality-odd, nor that the two channels are separated. The genuine
separation (transport `γ_μ` is purely chirality-odd, mass/Wilson scalar purely
chirality-even) *is* proved — but only at spin-vertex grade in the same file
(`chiralOdd_γ`, `chiralEven_γ`, `chiralOdd_massVertex`, `chiralEven_massVertex`),
and **those lemmas are not the one bundled into the capstone.** The capstone
imports the weakest of the family and describes it with the strongest prose.

**Verdict Q1:** (A) SOUND; (C) SOUND on the gap, definitional/near-vacuous on
"zero primitive mass"; (co-location) SOUND negative result resting on a norm
coincidence; (T) MISLABELED — the bundled statement is "mass content is
chirality-even" (and near-trivial, since the difference is a scalar), not "mass
is the turn channel cleanly separated from transport."

---

## Q2 — Does the CONJUNCTION over-claim?

**Partly. The in-body disclaimer is honored; the NAME and the doc's thesis prose
are not.**

Honored:
- The capstone docstring says explicitly: "This is a CONJUNCTION, NOT a proven
  single mechanism"; "What this capstone is NOT: … NOT the physical Yang-Mills
  mass gap … NOT a continuum statement … NOT a numerical mass value"; and marks
  the octonion conjunct as "the honest NEGATIVE co-location verdict." Claim label
  is "program synthesis (a bundling of proved finite identities; no new
  mathematics)." This is good discipline.

Over-claim vectors an external reader would take as "all mass is now derived from
null edges":
1. **The theorem/module name `allMassFromNullEdges` / "The all-mass-from-null-
   edges capstone."** The name asserts universality the proof does not deliver:
   four specific finite/kinematic facts about four different toy functionals are
   not "all mass." This is the single most quotable over-claim.
2. **Governing doc §1:** "on a substrate whose primitive transport is null,
   **every physical mass in the taxonomy** arises as one of three RELATIONAL
   OBSTRUCTIONS." Flagged as "Mechanism hypothesis," but the universal quantifier
   ("every physical mass") reads as a theorem.
3. **Governing doc §4 CAN-list:** "The keystone kinematic identity: **all
   composite mass** = aperture obstruction." Only the *massless-iff-collinear*
   direction is proved; "all composite mass = aperture" as an equation of
   physical mass with the kinematic functional is interpretation.
4. **Governing doc §5:** "For hadrons — most of the mass in the visible universe
   — mass is the aperture of confined null constituents." True as physics folklore,
   but stated adjacent to the kernel-checked list in a way that lends it borrowed
   authority.

**Verdict Q2:** OVER-CLAIM localized to the name and the doc's universal-
quantifier prose; the capstone's own body disclaimer is adequate. Fixes are
docstring/name-level, not proof-level.

---

## Q3 — F-YM-CONFLATE check (does bundling borrow evidence across taxonomy rows?)

**The proof does not actively conflate, but the guard the capstone invokes to
prove it does not — is ABSENT.**

- No active conflation in the *proof*: each conjunct is discharged by its own
  independent theorem over its own functional (`z2GlueballMass`, `massForm`,
  `minkowskiSq`, `wilsonDirac`); the conjunction is a plain `⟨…,…,…,…⟩` with no
  cross-row inference. So no evidence is literally transported from one row to
  another inside `allMassFromNullEdges`.
- **But the discipline requires the four functionals to be provably DISTINCT, and
  that guard is only PROMISED, not present.** The capstone docstring says:
  > "the taxonomy rows are kept distinct as theorems (see `MassTaxonomySeparation`
  > for their provable independence)."

  **`MassTaxonomySeparation` does not exist anywhere in the project** (grep across
  all `*.lean`: the only occurrence is this docstring reference to itself). The
  doc §4 CAN-list further promises "a theorem-level mass taxonomy:
  `quarkMassParameter`, `hadronSpectralMass`, `regulatorMass`,
  `compositeApertureMass` as provably distinct named functionals (QMF7 + NE-U1
  merge point)" — of these, **`hadronSpectralMass`, `regulatorMass`, and
  `compositeApertureMass` do not exist as declarations either.** Only
  `quarkMassParameter` (a definitional `0`) exists.

This is the report's top defect: the capstone *cites a nonexistent theorem as if
the F-YM-CONFLATE guard were already discharged.* An external reader following
the citation would find nothing. The separation guard is genuinely **needed** to
make the four-way bundle honest (otherwise "closure gap," "aperture," "chirality-
even mass," and "charge-blind norm mass" could be silently read as four views of
one quantity), and it is **not present — merely promised.**

**Verdict Q3:** OVER-CLAIM / dangling citation. The bundling is safe *only if* the
distinctness guard exists; it does not. Either add `MassTaxonomySeparation` (a
theorem exhibiting the four functionals as provably non-equal, e.g. a point where
their values disagree) or delete the citation and downgrade the "kept distinct as
theorems" claim to "kept distinct by construction / informally."

---

## Q4 — Hidden physical premises

- **(A) aperture.** `IsFutureNull p := minkowskiSq p = 0 ∧ 0 ≤ p 0`. The energy-
  positivity `0 ≤ p 0` (future cone) is a real physical premise, but it is stated
  explicitly as a hypothesis and is required for reverse Cauchy–Schwarz, so it is
  *disclosed*, not hidden. The `(+,−,−,−)` signature is a fixed convention. No
  hidden positivity/RP/continuum. Clean.
- **(T) turn.** Depends only on `Γ5² = 1` and on the mass dependence being
  diagonal; the docstring's "independent of link unitarity" is accurate (no
  unitarity of `U` is used). Euclidean-gamma convention is disclosed. No hidden
  reflection-positivity. The only "hidden" gap is *conceptual*, already covered
  in Q1(T): the "transport is chirality-odd / channels separated" reading needs
  the spin-vertex lemmas, which are not the bundled statement.
- **(C) closure.** No RP or continuum is used or claimed. The **unstated premise**
  is the *identification* of the hand-written `2×2` matrix with the physical Z2
  transfer operator and of `log coth β` with a glueball mass — i.e. transfer-
  matrix positivity / reflection positivity of the actual Z2 plaquette theory is
  assumed by naming, not proved. Disclosed as "toy," but the physical bridge is a
  convention.
- **(co-location).** Is the verdict non-vacuous — real `Q_op` eigenvalue
  difference or a trivial norm coincidence? **Both, on different sides.** The
  charge difference is *real* (`Q_v1 = −2/3`, `Q_v4 = −1/3` are genuine kernel-
  checked eigenvalue theorems), so the "different charges" side is non-vacuous.
  The *mass-equality* side, however, is exactly a **norm coincidence**
  (`cNormSq v1 = cNormSq v4 = 1/2`), and `massForm` is charge-blind essentially by
  construction (it only reads the SU(3)-invariant norm). So the co-location
  verdict is honest and non-vacuous as a *negative* result, but a reader should
  understand the equality is "these two states happen to have equal invariant
  norm," not "no mass mechanism could ever couple to this charge."

**Verdict Q4:** No undisclosed positivity/frame/continuum premise inside the
proofs. The two "soft" premises are (i) the toy's naming of a `2×2` matrix and a
log-ratio as the physical transfer operator/glueball mass, and (ii) the co-
location equality being a norm coincidence. Both are acknowledged in the sources;
neither is a hidden-axiom-style defect.

---

## Q5 — The honest headline

**Most defensible one-sentence claim the capstone supports:**
> In four independent finite/kinematic models on a null-transport substrate,
> physical or invariant mass appears as a *relational* quantity with **no
> primitive mass parameter inserted** — a strictly positive pure-gauge transfer
> gap at zero fermion mass, a composite that is massless **iff** its null
> constituents are collinear, a Wilson–Dirac mass-content term that is chirality-
> even, and a norm-weighted mass that is blind to the octonion charge grading —
> bundled as a *conjunction of separate proved facts*, not as one derivation of
> all mass.

**Most likely over-claim to avoid:**
> "All physical mass is now derived from null edges as a single unified
> mechanism." — Unsupported: the four are distinct toys (one conjunct is
> definitional, one is a near-trivial scalar identity), the "one mechanism"
> reading is explicitly disclaimed, and the taxonomy-separation theorem the
> capstone cites to license the bundle (`MassTaxonomySeparation`) **does not
> exist.** The theorem *name* `allMassFromNullEdges` is itself the chief carrier
> of this over-claim.

---

## Ranked claim-discipline fixes needed

1. **(BLOCKER) Resolve the dangling `MassTaxonomySeparation` citation.** Either
   (a) add the promised theorem exhibiting the four mass functionals
   (`z2GlueballMass` / `massForm` / `minkowskiSq`-aperture / `wilsonDirac`-mass,
   or the doc's named `compositeApertureMass`/`regulatorMass`/`hadronSpectralMass`)
   as provably distinct — e.g. a lemma giving inputs on which two of them
   disagree — or (b) delete the citation and downgrade "kept distinct as
   theorems (see `MassTaxonomySeparation`)" to an accurate statement ("kept
   distinct by construction; a formal independence theorem is not yet in-tree").
   As written, the capstone cites a nonexistent guard for the very
   F-YM-CONFLATE risk that bundling creates. **This is a companion theorem the
   discipline requires, currently only promised.**

2. **(HIGH) Fix the (T) conjunct's docstring.** Change the conjunct-4 gloss from
   "mass IS the turn channel … cleanly separated from the chirality-odd null-
   transport channel" to what `gamma5_mass_diff_comm` actually proves: "the
   Wilson–Dirac **mass-difference** is chirality-even (indeed a scalar `(m−m')•1`,
   so trivially `Γ5`-invariant)." If the separation reading is wanted in the
   capstone, **bundle the spin-vertex lemmas** `chiralOdd_massVertex` /
   `chiralEven_massVertex` (which do prove transport is chirality-odd and mass
   chirality-even) alongside it, rather than describing the scalar identity with
   their content.

3. **(HIGH) Retitle / re-scope the universal claim.** Rename or subtitle
   `allMassFromNullEdges` to signal a bundle of four toys (e.g. "four null-edge
   mass obstructions, bundled") and soften doc §1 "every physical mass in the
   taxonomy arises as …" and §4 "all composite mass = aperture obstruction" to
   the mechanism-hypothesis register they claim to be in. The proof supports
   "these four facts," not "all mass."

4. **(MEDIUM) Flag the (C) "zero primitive mass" conjunct as definitional.** Note
   in the docstring that `quarkMassParameter = 0` holds by definition (`rfl`) — it
   is a named constant, not a derived property — so the content of the conjunct is
   the gap positivity alone. Also state plainly that the `2×2` matrix is *named*
   the Z2 transfer operator and `log coth β` is *named* the glueball mass (no
   transfer-matrix reconstruction is proved).

5. **(LOW) Qualify the co-location gloss.** In the capstone, change "mass is blind
   to the `Q_op` charge grading" to "this norm-weighted mass form is blind to the
   `Q_op` charge grading (equal octonion norm `1/2`)" so it is not read as a claim
   about every possible mass mechanism. (The underlying module already states this
   correctly; only the capstone gloss needs the qualifier.)

---

## Summary table

| # | Item | Verdict | Core evidence |
|---|------|---------|---------------|
| Q1(A) | `compositeMassSq_eq_zero_iff_collinear` | **SOUND** | Real proved kinematic identity; frame-invariant; future-cone hypothesis disclosed |
| Q1(C) | `massWithoutMass` | **SOUND (gap) / MISLABELED** | `0 < log coth β` genuine; `quarkMassParameter = 0` is `rfl` (definitional); no regulator smuggled |
| Q1(co) | `charge_grading_mass_compatible` | **SOUND (negative result)** | Real charge diff (`Q_v1`,`Q_v4`); mass equality = norm coincidence `cNormSq = 1/2` |
| Q1(T) | `gamma5_mass_diff_comm` | **MISLABELED** | Proves only "mass-diff chirality-even"; diff is a scalar `(m−m')•1`, so near-trivial; does NOT show transport chirality-odd / channel separation |
| Q2 | Conjunction over-claim | **OVER-CLAIM (name/doc)** | Body disclaimer honored; name `allMassFromNullEdges` + doc "every physical mass" not |
| Q3 | F-YM-CONFLATE guard | **OVER-CLAIM (missing guard)** | `MassTaxonomySeparation` and named distinct functionals **do not exist**; guard merely promised |
| Q4 | Hidden premises | **SOUND / disclosed** | Future-cone & Euclidean conventions explicit; toy-naming and norm-coincidence acknowledged; no hidden axioms |
| Q5 | Honest headline | see above | Defensible: "four independent no-primitive-mass facts, bundled"; avoid: "all mass unified from null edges" |

*Method note: this is a source-grounded review; `#print axioms` output in the
capstone (`[propext, Classical.choice, Quot.sound]`) was read but not re-run, and
no `lake build`/prover was invoked, per the task constraints.*
