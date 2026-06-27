# Gate H: Legal finite Dirac / Φ_H forbidden-operator plan (Wave 20 / H9)

Date: 2026-06-27.

Task: `AgentTasks/null-edge-wave20-h9-legal-finite-dirac-forbidden-operator-aristotle-2026-06-27.md`.
Kind: no-build strategy/audit (report-only). No Lean was modified by this task;
every Lean name cited below was read from the live tree, not assumed.

Target theorem this plan is a roadmap *for* (verbatim from the task):

```text
Every chi_E-odd, J_F-real, first-order, gauge-covariant finite Dirac/Phi_H
operator has exactly the SM Yukawa block form, with arbitrary generation
matrices, and no leptoquark, diquark, proton-decay, wrong-hypercharge, or
colored-Higgs blocks.
```

Working label for that statement: **`LegalFiniteDiracForbiddenOperator`**.

---

## 0. Verdict and claim-class up front

```text
CLAIM CLASS of LegalFiniteDiracForbiddenOperator: STRUCTURAL THEOREM,
upgraded to PREDICTION / CODIMENSION only for the forbidden-block half.
```

- The statement "the legal operator is *exactly* the SM Yukawa block form, with
  **arbitrary** generation matrices" is a **structural theorem** (a
  reconstruction-plus-rigidity result): it forces the *shape* of the operator
  once the algebraic inputs (χ_E grading, J_F real structure, first order,
  gauge covariance under the true SM group) are assumed. Generation matrices
  stay free, so no magnitude/rank/angle/hierarchy content is produced — this is
  the scope guardrail honored explicitly.
- The "no leptoquark / diquark / proton-decay / wrong-hypercharge / colored-Higgs
  blocks" half *is* prediction/codimension-grade: it states that a positive-
  codimension family of *a priori* allowed first-order operators is removed by
  the gauge + grading + real-structure constraints. The repo already proves the
  chirality-grading half of this style of statement
  (`forbidden_counterterm_codimension`,
  `ambient_eq_admissible_add_codimension`); the new content is the
  *gauge/charge* codimension on top of the chirality codimension.

The two halves are deliberately separated below because they need different
hypotheses (Q4) and carry different claim labels.

Gate-C firewall (scope guardrail #2): this plan never lets Gate H stand in for
Gate C. Everything here lives on the **internal** finite factor `H_F`. Per the
Pro digest and the repo's product architecture
(`NullEdgeFureyAlmostCommutativeProduct`, `H_total = H_N ⊗ H_F`), χ_E acts only
on `H_F`, so nothing in this roadmap assigns chirality to null-edge branches or
touches the `D_+` determinant-zero locus. See §7 for the explicit non-coupling
statement.

---

## 1. Q1 — Which existing modules to reuse

All of the following are present and (per their headers) sorry/axiom-free. The
roadmap is an *assembly* job, not a from-scratch build.

Internal grading χ_E and the grading-vs-complex-structure hygiene:
- `PhysicsSM/Draft/NullEdgeFureyChiE.lean` —
  `IsZ2Grading`, `IsOdd`, `IsEven`, `IsComplexStructure`,
  `complexStructure_cannot_fill_grading_slot`,
  `central_invertible_odd_block_zero`, `sign_bridge_with_grading`.
- `PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` —
  the concrete χ_E on the 8-dim occupation space: `chiEParity`,
  `chiEParity_isZ2Grading`, `occEven_card = occOdd_card = 4`,
  `oddBlock_sq_neg`, and the tachyonic-sign theorem
  `chiEParity_tachyonic_under_H7A` (records why a χ_E-*odd* Φ_H gives the
  unwanted sign — needed to state the convention correctly).

Φ_H block and its grading/gauge behavior:
- `PhysicsSM/Draft/NullEdgeFureyPhiH.lean` —
  `chiE`, `chiE_sq`, `phiH_chiE_odd`, `phiH_gammaS_even`,
  `gammaS_internal_ne_chiE`, `phiH_sq`, `phiH_sign_dichotomy`,
  `phiH_gauge_covariant`, `chiE_gauge_commutes`, `GaugeCovariantPhiH`,
  `isProperPhiH`.
- `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` —
  descent to the genuine SM group: `TrueGaugeGroup := SMCoveringQuotient`,
  `phiH_proper_trueQuotient`, `phiH_gauge_covariant_trueQuotient`,
  `CoverFactoringPhiH`, `descend`, `descend_isProperPhiH`.

Almost-commutative product (the operator whose block form we classify):
- `PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean` —
  `FureyInternalData`, `AlmostCommutativeProduct`, `dirac`,
  `product_square_eq_gateA`, `product_sign_dichotomy`,
  `CleanSquareHypotheses`.

Finite SM charge/Yukawa table (the *target* block list):
- `PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean` —
  `Multiplet`, `WeakPattern`, `ColorPattern`, `HiggsInsertion`, `YukawaFlip`,
  `CandidateYukawaVertex`, `CandidateGaugeLegal`,
  `candidateGaugeLegal_iff_exists_yukawaFlip`,
  `physicalYukawaFlip_gaugeLegal`, `scalarYukawaFlipOperator`,
  `scalarYukawaFlipOperator_anticommutes_chirality`,
  `scalarYukawaFlipOperator_sq_eq_massSq`.
- `PhysicsSM/Draft/NullEdgeYukawaFlip.lean` — `hyperchargeDefect`,
  `hyperchargeDefect_eq_zero`, `ClaimBoundary`.
- `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` —
  `PermittedChiralityFlip`, `permittedChiralityFlip_iff_yukawa_channel`.

Chirality/odd-block codimension engine (the proof pattern to imitate for the
forbidden-block half):
- `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` —
  `chirality`, `IsOdd`, `isOdd_iff_offDiagonal`, `diagBlocks`,
  `diagBlocks_surjective`, `forbidden_counterterm_codimension`,
  `ambient_finrank`, `admissible_odd_finrank`,
  `ambient_eq_admissible_add_codimension`.

Anomaly-free one-generation realization (the content side, *not* a hypothesis of
the forbidden-operator theorem but its physical justification):
- `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`,
  `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`,
  `PhysicsSM/Draft/StandardModelAnomalyPackage.lean`
  (`standardModelOneGeneration`, `fureyJ_anomalyFree`,
  `fureyStyleRealization_realizesOneGeneration`).

J_F real structure / charge conjugation and the conjugate ideal:
- `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` —
  `Cconj` (antilinear involution), `Cconj_involutive`, `Cconj_smul`,
  `Jstar`, `qJstar_eq_neg_qJ`, `RHSinglet`, `u_Rc/d_Rc/e_Rc`,
  Gell-Mann–Nishijima for the conjugate sector.
- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean` — `omega`, `alpha_i`,
  ladder action, `nu` (the singlet top state) — the ideal-preservation engine.
- `PhysicsSM/Algebra/Furey/HyperchargeBridge.lean` —
  `QValue`, `T3Value`, `YValue`, `Q_eq_T3_add_halfY` (the hypercharge bookkeeping
  that the wrong-hypercharge no-go uses).

Charge/anomaly/gauge-group quotient (the "true gauge" surface):
- `PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean`
  (`SMProductCoveringTriple`, `SMCoveringQuotient` plumbing used by
  `NullEdgeFureyTrueGaugePhiH`).

Baez/octonion side (optional, reconstruction-only; see Q2 no-go):
- `PhysicsSM/Draft/BaezStandardModelFromOctonions.lean`,
  `PhysicsSM/Draft/ExceptionalJordanProjectiveGeometry.lean`,
  `PhysicsSM/Draft/Spin10Stabilizer*`.

**Reuse verdict:** χ_E, Φ_H, the product operator, the SM Yukawa table, the
chirality-codimension engine, the anomaly realization, and J_F are *all already
present*. The roadmap adds (a) a single `LegalFiniteDirac` predicate package
that bundles them, (b) the gauge/charge forbidden-block lemmas, and (c) the
ideal-preservation bridge. No new physics module needs to be invented from
scratch.

---

## 2. Q2 — Minimal finite module representation

**Recommendation: the direct SM charge table as the primary carrier, with a
*thin, optional* bridge theorem to the Furey/Gresnigt ideal — not a full ideal
re-derivation.**

Rationale:
- The forbidden-operator theorem is a statement about **representations of the
  gauge group on a finite-dimensional space** plus a grading and a real
  structure. The cheapest faithful carrier of exactly that data is the explicit
  charge table already formalized: `NullEdgeInternalSpectrum` /
  `standardModelOneGeneration` (color rep, weak rep, hypercharge, chirality per
  multiplet) together with `chiEParity` for the grading and `Cconj`/`Jstar` for
  J_F. Proofs reduce to finite case splits / `decide` / `norm_num`, exactly the
  style that already closes `CandidateGaugeLegal` and the codimension theorems.
- The Furey/Gresnigt minimal-left-ideal model (`MinimalLeftIdeal`,
  `ConjugateIdeal`) is the *justification* that this table is not arbitrary
  (it is forced by ℂℓ(6) / octonionic ideal structure with the correct charges
  and anomaly cancellation). It should appear as a **bridge theorem**, already
  partly present as `fureyJ_realizes_nullEdgeInternalSpectrum` and
  `fureyStyleRealization_eq_computedJ`, not be re-expanded inside the
  classification proof.

So: **both, with a bridge — but the bridge is the existing realization theorem,
and the classification proof runs on the direct table.** Building the whole
forbidden-operator theorem natively inside the ideal algebra would multiply the
proof cost with no change in the conclusion.

Bridge obligation (already largely discharged, list it as a dependency):
`fureyJ_realizes_nullEdgeInternalSpectrum`,
`fureyStyleRealization_eq_computedJ`, plus a new
`chiEParity_matches_ideal_parity` lemma equating `chiEParity` (occupation
parity) with the Furey ideal grading.

---

## 3. Q3 — The `LegalFiniteDirac` predicate package

Proposed predicate, stated on a finite operator `D : Module.End ℂ H_F`
(equivalently a block matrix on `Sum L R` over the generation-tensored charge
table), bundling five clauses. Each clause already has a Lean prototype to copy.

```text
structure LegalFiniteDirac (D : Module.End ℂ H_F) : Prop where
  -- (1) FIRST ORDER / off-diagonal: D anticommutes with the chirality grading.
  --     Prototype: NullEdgeForbiddenCountertermCodim.IsOdd,
  --                NullEdgeFureyChiE.IsOdd, phiH_chiE_odd.
  chiE_odd      : chiEParity * D = - (D * chiEParity)
  -- (2) SUPER-DIRAC SIGN convention: D is Γ_s-even on the internal factor so
  --     that Φ_H² enters with the + sign (NullEdgeFureyPhiH.phiH_gammaS_even).
  gammaS_even   : Gs * D = D * Gs
  -- (3) J_F-REAL: D commutes (with the ε-sign of the KO real structure) with the
  --     antilinear charge conjugation. Prototype: ConjugateIdeal.Cconj,
  --     Cconj_involutive, Cconj_smul.
  jF_real       : Commutes D Cconj          -- D ∘ J = ε · J ∘ D
  -- (4) GAUGE COVARIANCE under the true SM group acting via (gL, gR).
  --     Prototype: NullEdgeFureyPhiH.GaugeCovariantPhiH / phiH_gauge_covariant,
  --                descend to TrueGaugeGroup = SMCoveringQuotient.
  gauge_cov     : ∀ g : SMCoveringQuotient, act g * D = D * act g
  -- (5) IDEAL / ORDER-ONE: [[D, a], b°] = 0 for a, b in the internal algebra,
  --     i.e. D is a first-order operator for the algebra representation and its
  --     opposite (J-conjugate). Prototype: MinimalLeftIdeal ladder action +
  --     ConjugateIdeal.Jstar; the genuinely new clause.
  order_one     : ∀ a b, ⁅⁅D, repr a⁆, jConj (repr b)⁆ = 0
```

Notes:
- Clauses (1)+(2) together are the existing super-Dirac convention; (1) is the
  chirality-codimension input, (2) fixes the sign so the result is a *mass* not a
  tachyon (`chiEParity_tachyonic_under_H7A` documents the wrong choice).
- Clause (3) is the half-missing piece: `ConjugateIdeal` gives `Cconj` but the
  *commutation of `D` with `Cconj`* (the order-zero real-structure axiom
  `[a, J b° J⁻¹] = 0` and the Dirac compatibility `DJ = εJD`) must be added as a
  predicate and proved for the SM table.
- Clause (5) is the *order-one condition* of a spectral triple — this is what
  actually does the heavy lifting of forbidding leptoquark/diquark/proton-decay
  blocks (those would require `D` to mix the ideal `J` with the conjugate ideal
  `J*` in a way that breaks `[[D,a],b°]=0`).

The package should be defined once in a new file and reused by every theorem
below.

---

## 4. Q4 — Which constraint kills which forbidden block

This is the load-bearing classification. Each forbidden block is tagged with the
*minimal* hypothesis subset that removes it. This dictates the dependency graph.

```text
Forbidden block          | Killed by                         | Claim half
-------------------------+-----------------------------------+-----------------
Diagonal Dirac masses    | chiE_odd  (grading)               | codimension
  (L-L, R-R)             |   = forbidden_counterterm_codim   | (already proved
                         |                                   |  for chirality)
-------------------------+-----------------------------------+-----------------
Wrong-hypercharge Higgs  | gauge_cov (hypercharge weight)    | codimension
  / colored Higgs        |   = hyperchargeDefect_eq_zero +   | (charge bookkeeping)
                         |     CandidateGaugeLegal color test |
-------------------------+-----------------------------------+-----------------
Leptoquark / diquark     | order_one (ideal vs conj-ideal),  | structural +
  vertices               |   NOT gauge_cov alone             | codimension
                         |   needs J_F + first-order         |
-------------------------+-----------------------------------+-----------------
Proton-decay operators   | order_one + J_F together          | structural
  (e.g. qqq-type)        |   (would need J↔J* mixing)        |
-------------------------+-----------------------------------+-----------------
Tachyonic / wrong-sign   | gammaS_even (super-Dirac sign)    | convention
  mass                    |   = phiH_gammaS_even              | (sign hygiene)
```

Key honesty points (these decide the claim grade):
- **Gauge equivariance alone is NOT enough** to forbid leptoquarks/diquarks. A
  leptoquark coupling can be perfectly gauge-covariant; what excludes it is the
  *first-order / order-one* condition relative to the **algebra and its opposite
  (J_F)** — exactly the Connes order-one axiom. This is why clauses (3) and (5)
  are mandatory and why the theorem is genuinely a spectral-triple statement, not
  a representation-theory triviality.
- **χ_E / first-order alone** removes only diagonal mass terms (the chirality
  codimension already in the repo). It does **not** see color/hypercharge.
- **Wrong-hypercharge / colored-Higgs** blocks fall to the hypercharge-weight and
  color-singlet constraints of `gauge_cov` (the existing `CandidateGaugeLegal`
  classifier already encodes exactly these as `WeakLegal`, `ColorNeutral`,
  `hyperchargeDefect = 0`).
- **Ideal-preservation** (clause 5, J↔J* non-mixing) is the *only* thing that
  forbids the proton-decay/diquark operators that survive gauge covariance.

Therefore the clean conclusion splits as:

```text
LegalFiniteDirac D  ↔  D = ⊕(Yukawa flip blocks) with arbitrary
                        generation matrices Y_u, Y_d, Y_e (, Y_ν)
                        and zero on every other block.
```

with the forbidden-block half carrying a codimension count in the spirit of
`ambient_eq_admissible_add_codimension`, now refined by color/hypercharge/ideal
data.

---

## 5. Q5 — Where ν_R enters

```text
Recommendation: ν_R is an OPTIONAL gauge-singlet slot, made canonical by the
finite triple's J_F real structure — NOT a separate axiom, NOT forced by the
forbidden-operator theorem itself.
```

- The conjugate ideal already contains a neutral top state: `MinimalLeftIdeal.nu`
  (the fully-raised `α₁α₂α₃ω`) and `ConjugateIdeal` carries the charge-conjugate
  singlets. So a right-handed neutrino slot *exists* in the finite module as the
  gauge-singlet entry; it is natural, not bolted on.
- The forbidden-operator theorem should be stated to be **agnostic**: it
  classifies legal blocks given whatever right-handed content is present. With
  ν_R present, the legal block list gains a Dirac `Y_ν` channel (and, if J_F is
  used to identify `J*`-states, a Majorana `M_R` channel on the singlet — which
  is *allowed*, being gauge-singlet and order-one-compatible). Without ν_R, the
  list is just `Y_u, Y_d, Y_e`.
- Concretely: parameterize `H_F` by a flag `withNuR : Bool` (or two instances of
  the charge table). Prove the classification once for each, sharing all lemmas.
  Do **not** introduce `axiom nu_R`; that violates the soundness guardrail and is
  unnecessary because `nu`/`Jstar` already supply the state.

Claim note: the *presence* of a Majorana option is a structural statement; its
*scale/seesaw* is not derived (scope guardrail).

---

## 6. Q6 — Which Lean job to launch first

**Launch first: the gauge/charge forbidden-block lemma on the existing SM table,
reusing the chirality-codimension proof pattern.** Concretely the first subagent
job is:

```text
theorem gauge_forbids_nonYukawa_blocks :
    ∀ (D : InternalBlock), GaugeCovariant D → ChiEOdd D →
      (∀ block ∉ smYukawaChannels, blockOf D block = 0)
```

specialized to the finite `CandidateYukawaVertex` enumeration, i.e. "the only
gauge-legal + odd off-diagonal channels are the four `YukawaFlip`
constructors." This is the smallest theorem that (a) is almost-certainly
provable now by finite case analysis (`candidateGaugeLegal_iff_exists_yukawaFlip`
is already proved — this lifts it from "vertex legal" to "operator block zero"),
(b) exercises the predicate package design, and (c) produces the first genuine
*forbidden-block* statement beyond the chirality codimension already in the repo.

Reasons not to start with order-one/J_F: clause (5) is the hardest and most
novel; validate the cheap gauge+grading half first so the package interface is
frozen before the expensive ideal lemma is attacked.

---

## 7. Gate H ⊥ Gate C non-coupling statement (guardrail)

To make scope guardrail #2 checkable, the roadmap includes one explicit
*separation* lemma (negative/structural), so Gate H cannot be mistaken for a
Gate C release:

```text
theorem chiE_does_not_polarize_external_branch :
    -- On H_total = H_N ⊗ H_F with χ_E = 1_N ⊗ chiEParity and any null-edge
    -- branch projector P = P_N ⊗ 1_F, χ_E commutes with P and therefore
    -- assigns no chirality sign to the external branch.
    (1 ⊗ chiEParity) * (P_N ⊗ 1) = (P_N ⊗ 1) * (1 ⊗ chiEParity)
```

This mirrors the Pro digest's "branch projectors act only on `H_N`" verdict and
the Wave-19 taste-involution audit conclusion. It is cheap (it is a tensor
commutation) and it is the formal guarantee that nothing in this Gate H plan
repairs the `D_+` determinant-zero locus.

---

## 8. Dependency-ordered theorem list

Ordered so each item depends only on earlier items + existing repo lemmas.
Claim label in brackets: [R]econstruction, [S]tructural, [P]rediction/codimension,
[C]onvention/hygiene, [N]o-go/separation.

```text
 0. (reuse) chiEParity_isZ2Grading, oddBlock_sq_neg,
            phiH_chiE_odd, phiH_gammaS_even, Cconj_involutive,
            forbidden_counterterm_codimension                      [already done]

 1. LegalFiniteDirac  (predicate package, Q3)                       [definition]

 2. chiE_does_not_polarize_external_branch  (Gate H ⊥ Gate C, §7)   [N]

 3. legalDirac_is_offDiagonal :
       LegalFiniteDirac D → IsOdd D  (lifts chiE_odd to block form) [C/S]

 4. gauge_forbids_nonYukawa_blocks  (Q6, FIRST JOB)                 [P]
       gauge_cov + chiE_odd ⇒ only YukawaFlip channels survive.

 5. wrong_hypercharge_block_zero
       (specializes hyperchargeDefect_eq_zero to operator blocks)   [P]

 6. colored_higgs_block_zero
       (color-singlet test ⇒ no colored-Higgs Yukawa)               [P]

 7. jF_real_compatible_yukawa :
       J_F real structure is consistent with the surviving blocks
       (DJ = εJD on the Yukawa channels)                            [S]

 8. order_one_forbids_leptoquark_diquark :
       order_one (J vs J*) ⇒ no L↔(conj ideal) mixing blocks        [P]
       (THE hard, novel lemma; needs MinimalLeftIdeal + ConjugateIdeal)

 9. order_one_forbids_proton_decay :
       corollary of 8 on the qqq/qql sectors                        [P]

10. legalFiniteDirac_block_classification :
       LegalFiniteDirac D ↔ D = ⊕ Yukawa-flip blocks with arbitrary
       generation matrices, zero elsewhere                          [S]
       (assembles 3–9)

11. legalFiniteDirac_forbidden_codimension :
       finrank count of the forbidden complement
       (gauge+grading+ideal), refining
       ambient_eq_admissible_add_codimension                        [P]

12. nuR_optional_channel :
       with/without ν_R variants of 10 (Q5)                         [S]

13. furey_ideal_bridge :
       fureyJ_realizes_nullEdgeInternalSpectrum +
       chiEParity_matches_ideal_parity  (Q2 bridge)                 [R]

14. LegalFiniteDiracForbiddenOperator (TOP-LEVEL, the task statement) [S + P]
       = 10 ∧ 11 ∧ 12, packaged for citation.
```

Critical path for difficulty: 8 (order-one leptoquark) is the bottleneck; 4–6
are near-term; 1–3 are interface; 13 is mostly already done.

---

## 9. Proposed Lean file / module names

Keep the existing module granularity (one theme per file, < ~1000 lines).

```text
PhysicsSM/Draft/NullEdgeGateHLegalFiniteDirac.lean
    -- LegalFiniteDirac predicate package (Q3), basic lemmas 1–3,
    -- and the separation lemma 2 (chiE ⊥ external branch).

PhysicsSM/Draft/NullEdgeGateHGaugeForbiddenBlocks.lean
    -- theorems 4,5,6 (gauge + hypercharge + color forbidden blocks).
    -- depends on NullEdgeYukawaMassOperator, NullEdgeYukawaFlip.

PhysicsSM/Draft/NullEdgeGateHRealStructureOrderOne.lean
    -- theorems 7,8,9 (J_F real structure + order-one, leptoquark/diquark/
    -- proton-decay no-go). depends on Furey.ConjugateIdeal, Furey.MinimalLeftIdeal.

PhysicsSM/Draft/NullEdgeGateHForbiddenCodimension.lean
    -- theorem 11, reusing the NullEdgeForbiddenCountertermCodim engine.

PhysicsSM/Draft/NullEdgeGateHLegalDiracClassification.lean
    -- theorems 10,12,13,14 (top-level classification + ν_R variants +
    -- Furey ideal bridge + citation package).
```

(If 8 proves large, split `...RealStructureOrderOne` into a `...OrderOneCore`
algebra file and a `...LeptoquarkNoGo` application file.)

---

## 10. Exact claim labels (summary)

```text
reconstruction        : furey_ideal_bridge (13); the charge table is the Furey
                        one-generation ideal realization.
structural theorem    : legalDirac_is_offDiagonal (3), jF_real_compatible (7),
                        legalFiniteDirac_block_classification (10),
                        nuR_optional_channel (12), and the assembled top-level
                        LegalFiniteDiracForbiddenOperator (14) — the *shape* is
                        forced, generation matrices remain free.
prediction/codimension: gauge_forbids_nonYukawa_blocks (4),
                        wrong_hypercharge_block_zero (5), colored_higgs_block_zero
                        (6), order_one_forbids_leptoquark_diquark (8),
                        order_one_forbids_proton_decay (9),
                        legalFiniteDirac_forbidden_codimension (11) — an a priori
                        positive-codimension family of first-order operators is
                        removed.
convention/hygiene    : the gammaS_even / super-Dirac sign clause (Φ_H² > 0,
                        not tachyonic).
no-go / separation    : chiE_does_not_polarize_external_branch (2).
```

Explicit non-claims (scope guardrails, restated in the deliverable so they ship
with the result):

```text
- No Yukawa magnitudes, ranks, textures, or zero-patterns are derived.
- No CKM/PMNS angles or phases are derived.
- No mass hierarchy and no generation number are derived (generation matrices
  are arbitrary; the table is one generation, tensored).
- Gate H does NOT release Gate C: χ_E lives on H_F and commutes with every
  external branch projector (theorem 2). No chirality is assigned to null-edge
  branches and the D_+ determinant-zero locus is untouched.
```

---

## 11. No-go conditions: when Furey/Baez stays reconstruction-only

The forbidden-operator theorem **degrades from structural/prediction to mere
reconstruction** under any of the following — these are the audit's stop
conditions:

```text
N1. Order-one fails to bite. If order_one_forbids_leptoquark_diquark (8) cannot
    be proved without *also* assuming the absence of the J↔J* mixing block it is
    supposed to forbid, the theorem is circular and only reconstructs the SM
    block list rather than predicting it. (Watch for a hypothesis that secretly
    encodes the conclusion, in the spirit of the Krein overlap sign-trap.)

N2. Gauge covariance is imposed on the *output* representation. If the SM
    representation content is assumed on H_F a priori rather than coming from the
    Furey ideal (furey_ideal_bridge), then "no leptoquark" is true by fiat about
    a hand-chosen rep, i.e. reconstruction, not prediction. The bridge (13) must
    be genuine for the prediction grade to hold.

N3. The real structure is added by hand. If jF_real cannot be derived from
    Cconj / the conjugate ideal but must be posited as an extra datum tuned to
    the SM, the proton-decay/Majorana statements are reconstruction.

N4. Baez/octonion route used as the carrier. The Baez E6/F4/Spin(10) octonionic
    modules (BaezStandardModelFromOctonions, Spin10Stabilizer*,
    ExceptionalJordanProjectiveGeometry) currently provide an *embedding /
    reconstruction* of SM charges, not an order-one finite spectral triple with a
    J_F that forbids blocks. Until an order-one + real-structure layer is built
    on top of them, anything proved via the Baez carrier is reconstruction only.
    Use the direct charge table (Q2) as the carrier; cite Baez/Furey as the
    justification, not the proof engine.

N5. Generation structure leaks into the forbidding. If any forbidden-block proof
    secretly uses a property of the (free) generation matrices, the codimension
    claim is not generation-blind and collapses to a reconstruction of a specific
    texture. The classification must hold for *arbitrary* Y_u, Y_d, Y_e.
```

If none of N1–N5 trigger, the assembled `LegalFiniteDiracForbiddenOperator` is a
legitimate **structural theorem with a prediction/codimension forbidden-block
half** — the first realistic Gate H prediction-grade target, while remaining
strictly separated from Gate C.

---

## 12. Pointers checked

Read against the live tree (not assumed):
`NullEdgeFureyAlmostCommutativeProduct`, `NullEdgeFureyChiE`,
`NullEdgeFureyOccupationParityChiE`, `NullEdgeFureyPhiH`,
`NullEdgeFureyTrueGaugePhiH`, `NullEdgeFureyInternalSpectrum`,
`NullEdgeYukawaMassOperator`, `NullEdgeYukawaFlip`,
`NullEdgePhysicsBridgeAristotle`, `NullEdgeForbiddenCountertermCodim`,
`NullEdgeInternalSpectrum`, `StandardModelAnomalyPackage`,
`BaezStandardModelFromOctonions`, `Algebra/Furey/ConjugateIdeal`,
`Algebra/Furey/MinimalLeftIdeal`, `Algebra/Furey/HyperchargeBridge`,
`Gauge/StandardModelProductCoveringTrueQuotientSMBlock`, the Wave-20 briefing
digest, and the Wave-19 taste-involution origin-polarization audit.
```
