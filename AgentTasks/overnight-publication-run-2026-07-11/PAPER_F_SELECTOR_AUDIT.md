# Hostile audit — Paper F residual moduli (F1) and selector sufficiency (F2)

Review-only. No source file under review was edited; no build of the live
repository is claimed. All Lean-level statements below were read directly from
the delivered files; the convention-sensitive facts (shear composition law,
column-sum/total preservation, joint-grade distinctness, triviality of
`mix_mem_submodule`) were re-checked independently in an isolated Mathlib
session.

Files in scope:
- `ChannelShearModuli.lean` — self-contained (`import Mathlib`), F1 headline.
- `ChannelSelectorUniqueness.lean` — F2 headline; imports the **absent** module
  `PhysicsSM.Draft.NullEdge.GradedDecompUniqueness`.
- `CarrierRigidity.lean` — self-contained (`import Mathlib`); the F2 boundary.
- `FourChannelRigidityCapstone.lean` — imports the **absent** modules
  `PhysicsSM.Draft.NullEdge.{UnifiedMassBudget,CarrierRigidity,GradedDecompUniqueness}`.

---

## 0. Findings: FATAL / MAJOR / MINOR / CLEAR

### CLEAR (genuine, load-bearing, correctly framed)

- **`ChannelShearModuli.shear_add`, `shear_zero`, `shear_mul_neg`,
  `shear_injective`, `shear_det`, `shear_column_sum`.** A faithful additive
  homomorphism `ℚ → GL₃(ℚ)`, image in `SL₃`, injective. Elementary but honest.
  Independently reconfirmed: `shear (s+t) = shear s * shear t` and every column
  sums to `1`.
- **`ChannelShearModuli.sum_mix_shear` + `mixed_shear_injective`.** The total of
  the three components is preserved, and with `b 1 ≠ 0` the *map* `t ↦ mix
  (shear t) b` is injective. This is a genuine nondegenerate one-parameter family,
  **not** a mere parameter identity (that weaker fact is `shear_injective`). See Q2.
- **`CarrierRigidity.parity_decomposition_unique`.** The Γ-even/Γ-odd split of a
  ring element is unique (needs `2` invertible). This is the one honest
  *uniqueness* result at the axiom level.
- **`CarrierRigidity.square_oddPart` / `square_evenPart`.** Sharp: the odd part of
  the square equals `2·E_#`; the even part is `Q_A + Q_C + 2·Q_T`. Correctly says
  chirality isolates soldering and **lumps** aperture+closure+turn.
- **`CarrierRigidity.Concrete.shared_type_but_distinct` /
  `channels_pairwise_distinct`.** A real non-rigidity witness: an explicit `4×4`
  rational Krein carrier satisfying every axiom in which `Q_A,Q_C,Q_T` are
  pairwise distinct, nonzero, and share the identical `(Γ,#)`-type.

### MINOR

- **`ChannelShearModuli.mix_mem_submodule` is trivial and mis-billed.** The prose
  headline advertises "preserving … every linear type submodule" as a *property
  of the shear*. The Lean lemma quantifies over **an arbitrary matrix `M`**:
  `(∀ j, b j ∈ W) → mix M b i ∈ W`. This is just "a submodule is closed under
  linear combinations" (independently reproduced as a one-liner
  `Submodule.sum_mem … Submodule.smul_mem`). It carries **zero** shear-specific or
  determinant-one content and must not be cited as evidence that the *shear*
  respects type constraints.
- **`shear_det = 1` is decorative.** Under the stated `mix i = ∑ j M i j • b j`
  convention, total preservation is equivalent to **column sums = 1**
  (`shear_column_sum`), not to `det = 1`. "Determinant-one … preserving the total"
  in prose conflates two independent facts; det-one is not what preserves the
  total.
- **F1 is abstract linear algebra with only interpretive ties to the carrier.**
  `Coord := Fin 3` and `b : Fin 3 → V` are an arbitrary triple in an arbitrary
  `ℚ`-module. Nothing in the file connects `b 0, b 1, b 2` to the actual
  aperture/closure/turn channels of `CarrierRigidity`/`UnifiedMassBudget`. The
  phrase "three ordered even channels" is unsubstantiated decoration on a generic
  statement.

### MAJOR

- **F2's core is imported from an absent module.**
  `two_sign_gradings_decomposition_unique` is a thin wrapper reducing to
  `NullEdgeCloser.decomposition_unique`, which lives in
  `PhysicsSM.Draft.NullEdge.GradedDecompUniqueness` — **not present in this
  package**. As delivered here, F2's decisive content is *not* kernel-checked; the
  `#print axioms` pin can only fire in a repo that supplies that module. The
  wrapper itself is correct *conditional on* that lemma.
- **`FourChannelRigidityCapstone.lean` cannot elaborate in this package.** It
  imports `PhysicsSM.Draft.NullEdge.{UnifiedMassBudget,CarrierRigidity,
  GradedDecompUniqueness}` (unknown module prefix `PhysicsSM` here) and depends on
  `UnifiedMassBudget.{QA,QC,QT,Es,D,square_splits}` and
  `NullEdgeCloser.split_not_forced`. Its payloads
  (`four_channels_linearIndependent`, `carrier_square_coefficients_recovered`,
  `four_channel_rigidity_with_boundary`) are therefore **not kernel-checked in the
  delivered project**, even though `lakefile.toml` lists it in `defaultTargets`.
  Note the additional namespace hazard: the local file is module `CarrierRigidity`
  (namespace `CarrierRigidity`), *not* `PhysicsSM.Draft.NullEdge.CarrierRigidity`,
  so the capstone's `CarrierRigidity.Concrete.*` references resolve against the
  imported (absent) copy, not the local one.
- **`FourChannelRigidity` coefficient recovery is circular.** `readA/readC/readT/
  readE` are single-entry selectors *normalized by the target channel's own
  value* (`/8, /20, /40, /12`); linear independence of `QA,QC,QT,Es` is immediate
  from disjoint supports. "Coefficient rigidity once coordinate/support selectors
  are supplied" = "after fixing the answer's support, the answer is determined."
  The file honestly flags this, but the phrase must never be read as canonicity.
- **The "exact four-term expansion" is definitional, not rigidity.**
  `CarrierRigidity.square_decomposition` proves `2·(D#D) = Q_A + Q_C + 2E_# +
  2Q_T`, but the four channels are *defined* as those monomial groupings and the
  proof is a `noncomm_ring` rearrangement using only `Γ²=1, star Γ=Γ, star φ=φ`
  (it does **not** use `cₑ²=0` or `{Γ,cₑ}=0`). "No fifth block" is a bookkeeping
  identity about a chosen grouping.

### FATAL (only against over-strong *readings*; the checked math itself is sound)

- **No FATAL against verified content.** F1 (self-contained) is true; F2's wrapper
  is a correct reduction. The FATAL-level problems are all *packaging/claim-shape*:
  (i) F2 and the capstone are advertised as landed/kernel-checked headlines but
  their decisive lemmas are not present in this repo; (ii) any reading of F1 as a
  *carrier-channel* moduli result, or of the capstone as *canonicity*, is false.
  A prose headline of "four-channel classification / canonical split" would be
  FATALLY stronger than the Lean; only the boundary reading survives.
- **Documentation drift.** `FOUR_CHANNEL_CLASSIFICATION_REVIEW.md` cites a
  companion `ChannelClassificationReview.lean` and theorems
  `even_sector_moduli_nontrivial`, `commuting_involutions_decomposition_unique`
  as "checked"; none of these names exist in the delivered tree (the landed names
  are `mixed_shear_injective` and `two_sign_gradings_decomposition_unique`, and no
  companion file is present). Reconcile names before publication.

---

## Audit questions

### Q1. Are either headline vacuous / hollow / falsely shaped / stronger in prose?

- **F1 (`ChannelShearModuli`)** — not vacuous, not hollow. The nondegeneracy
  hypothesis `b 1 ≠ 0` is real (with `b 1 = 0` the family collapses, so the
  statement is not vacuously true). *Prose > Lean* in three places: (a) "every
  linear type submodule" over-reads the trivial `mix_mem_submodule` (any `M`);
  (b) "determinant-one … preserving the total" conflates det-one with the actual
  column-sum condition; (c) "three ordered even channels" attaches physics to an
  arbitrary module triple. Correctly stated, F1 is: *the additive group `(ℚ,+)`
  acts faithfully by a fixed unipotent shear on ordered triples in any
  `ℚ`-module, fixing the sum, and the orbit map is injective whenever the middle
  vector is nonzero.*
- **F2 (`two_sign_gradings_decomposition_unique`)** — not vacuous, correctly
  shaped as a **conditional uniqueness** (the file says so). But *as delivered
  here it is not self-contained*: its content is the imported
  `NullEdgeCloser.decomposition_unique`. See Q3 for the hypothesis-strength issue.

### Q2. Does the shear preserve the total under this convention, and is `mixed_shear_injective` a nondegenerate family?

Yes and yes. With `mix M b i = ∑ j M i j • b j`, `∑ᵢ mix i = ∑ⱼ (∑ᵢ M i j) bⱼ`,
so total preservation ⇔ every column sums to 1 — proved by `shear_column_sum`
and reconfirmed independently. `sum_mix_shear` states exactly this. And
`mixed_shear_injective` proves `Function.Injective (fun t => mix (shear t) b)`
under `b 1 ≠ 0`: from the first component `s • b 1 = t • b 1 ⇒ (s−t)•b 1 = 0 ⇒
s = t`. This is injectivity of the **orbit map into `Coord → V`**, i.e. a genuine
nondegenerate family, strictly stronger than `shear_injective` (parameter
identity of the matrices). *Caveat:* it is one 1-parameter unipotent subgroup,
not the full residual stabilizer; "moduli family" should read "a
one-dimensional subgroup of the residual mixing symmetry."

### Q3. Is F2 sufficient as stated, or does scalar-action-on-all-components encode more than a grading?

It is **sufficient but strong**, and the strength is honest, not hidden. The
hypotheses `∀ ij, ∀ x ∈ W ij, P x = sgn ij.1 • x` (and for `Q`, and for `W'`)
say each block is contained in a **joint ±1 eigenspace** of `(P,Q)`. Combining to
`D = P + 2Q` with distinct eigenvalues `{3,1,−1,−3}` (`sgn_grade_injective`,
reconfirmed), each `W ij` is forced to equal `D.eigenspace (μ ij)`; the same for
`W' ij`; hence `W = W'`. So the theorem is essentially "the joint eigenspace
decomposition of a fixed operator is unique." It **does encode more than a loose
"grading"**: it presupposes the blocks are exact simultaneous eigenspaces of two
given operators — i.e. the two sign operators are already simultaneously
diagonalized *with these blocks as their eigenspaces*. It does **not** construct
the second grading, and it is not vacuous. The honest reading is: *given two
commuting sign involutions whose joint eigenspaces are the blocks, the block
decomposition is unique* — the sufficiency half of a selector theorem, with the
existence of the second intrinsic grading left open (as the file states).

### Q4. Exact full affine/torsor theorem to replace the one-subgroup witness

Replace the single-subgroup `mixed_shear_injective` with the statement that the
even-sector refinements form a torsor under the full total-preserving mixing
group. Lean-shaped:

```lean
variable {V : Type*} [AddCommGroup V] [Module ℚ V]

/-- Ordered even-sector refinements of a fixed triple `b`, i.e. `mix M b` for
`M` in the total-preserving group. -/
def totalPreserving : Submonoid (Matrix (Fin 3) (Fin 3) ℚ) := -- {M | ∀ j, ∑ i, M i j = 1}
  sorry
def Ref (b : Fin 3 → V) : Set (Fin 3 → V) := { c | ∃ M ∈ totalPreserving, c = mix M b }

/-- The residual mixing group: unipotent, total-preserving, det-one, GL. -/
def MixG : Subgroup (Matrix (Fin 3) (Fin 3) ℚ) := -- {M | (∀ j, ∑ i, M i j = 1) ∧ IsUnit M.det}
  sorry

/-- ACTION + FREENESS + TRANSITIVITY (nondegenerate carrier). For `b` with the
three components ℚ-linearly independent, `MixG` acts on `Ref b`, the action is
free (trivial stabilizer) and transitive; hence `Ref b` is a torsor under the
stabilizer-quotient, an affine space of dimension `dim MixG = 2` (the two
independent shears among three total-preserving generators). -/
theorem even_refinement_is_torsor
    (b : Fin 3 → V) (hb : LinearIndependent ℚ b) :
    -- transitive & free action of MixG on Ref b:
    (∀ c ∈ Ref b, ∃! M : MixG, mix (M : Matrix _ _ ℚ) b = c) := by
  sorry

/-- STABILIZER: exactly the identity on a nondegenerate carrier. -/
theorem mix_stabilizer_trivial
    (b : Fin 3 → V) (hb : LinearIndependent ℚ b) (M : MixG)
    (h : mix (M : Matrix _ _ ℚ) b = b) : (M : Matrix _ _ ℚ) = 1 := by
  sorry

/-- QUOTIENT BOUNDARY: after quotienting by selector-preserving equivalence
`SelectorEquiv`, `Ref b / SelectorEquiv` is a single point IFF a separating
grade exists (link to Q5); otherwise it retains the affine `MixG`-torsor. -/
theorem ref_quotient_boundary (b : Fin 3 → V) (hb : LinearIndependent ℚ b) :
    (Nonempty (Unique (Quotient (SelectorEquiv b)))) ↔ (∃ sep : SeparatingGrade b, True) := by
  sorry
```

Prohibited weakenings for Q4: do **not** replace `LinearIndependent ℚ b` by the
weaker `b 1 ≠ 0` (that only gives the 1-parameter sub-orbit, i.e. the current
`mixed_shear_injective`, not the full torsor/freeness); do **not** state
transitivity without freeness (an affine *torsor* needs both); do **not** drop the
stabilizer computation (freeness is the content); do **not** phrase the quotient
as `True`/`Unique` unconditionally.

### Q5. Necessary-and-sufficient selector theorem (not merely sufficient)

The current F2 is only the `⇐` half. The N&S target:

```lean
/-- An ordered four-channel refinement of the even sector is unique up to
`SelectorEquiv` IFF the carrier admits commuting, `#`-self-adjoint,
`Γ`-commuting operators whose joint spectrum separates the channels. -/
theorem four_channel_refinement_unique_iff_separating
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (Γ : Module.End ℝ V) (chan : Fin 4 → Submodule ℝ V) :
    (∃! W : Fin 4 → Submodule ℝ V, DirectSum.IsInternal W ∧ SelectorEquiv W chan) ↔
      (∃ E N : Module.End ℝ V,
        Commute Γ E ∧ Commute Γ N ∧ Commute E N ∧
        IsSelfAdjoint E ∧ IsSelfAdjoint N ∧
        Function.Injective (fun i : Fin 4 => jointGrade Γ E N i)) := by
  sorry
```

- `⇐`: generalize `two_sign_gradings_decomposition_unique`/
  `NullEdgeCloser.decomposition_unique` from `Bool×Bool` to `Fin 4` grades
  (`D = Γ + 2E + 4N` with 8/4 distinct eigenvalues).
- `⇒`: contrapositive of `Concrete.shared_type_but_distinct` — if no separating
  grade exists, exhibit two internal decompositions with the same
  selector-data that differ (the aperture/closure/turn ambiguity), refuting
  uniqueness.

Prohibited weakenings for Q5: the theorem must be a real `↔`; do not deliver only
`⇐` and call it N&S; do not make `SelectorEquiv` so fine that it already encodes
the channel supports (that recreates the circular reader problem); do not let
`jointGrade` reference the desired channel names.

### Q6. Candidate intrinsic selectors — which are definable without naming channels?

| Selector | Definable without naming target channels? | Verdict |
|---|---|---|
| **Chirality `Γ`** | Yes — `Γ²=1`, `star Γ=Γ`, commuting with transports/turn is intrinsic | **Intrinsic.** Supplies the first (odd/even) grade only. |
| **Word/solder degree `N`** (# of `c`-letters) | Only on the *free presentation*; it is a filtration, not a conjugation-invariant operator on the algebra | **Not intrinsic** (presentation-dependent). Would separate `Q_T` from `{Q_A,Q_C}` if made into a genuine commuting operator. |
| **Edge exchange `E`** (symmetric `Q_A` vs antisymmetric `Q_C`) | Requires a chosen `Sₙ`-action on the edge index `Fin n`; not `(Γ,#)`-definable and not guaranteed to commute with `Γ` | **Not intrinsic.** `shared_type_but_distinct` shows no `(Γ,#)`-definable involution separates the three. |
| **Locality / causal support** | Requires the graph (edge/star) structure as extra data | **Not intrinsic to `(Γ,#)`**, but physically canonical once the graph is part of the carrier; the natural home of `E` and `N`. |
| **Physical (reflection) positivity** | Definable from the Krein form without naming channels | **Semi-intrinsic**, weak: can pick a positive cone favouring `Q_A`, but `Q_C` is genuinely signed (`closure_val`), so it cannot canonicalize `Q_C`. |
| **Information monotonicity** | Definable on coarse-grainings without naming channels | **Intrinsic-ish but weak** on the *fine* split; a consistency check, not a separator. |
| **Refinement / RG naturality** | Definable via a blocking/refinement functor, channel-agnostic | **Conditionally intrinsic**; potentially high power if a refinement functor is fixed. |

Only **chirality** is definable purely from the current carrier `(Γ,#)` data
without naming channels, and it yields a *single* grade. Degree and edge-exchange
are the two that *would* separate the even sector but are **not** obtainable from
`(Γ,#)` alone — they must be added as explicit structure, with intrinsicness and
commutation proved, not assumed.

### Q7. Smallest exact no-go theorem if no intrinsic second selector exists

```lean
/-- If every `Γ`-commuting, `#`-self-adjoint operator acts by a scalar on the
even sector, then the even-sector refinements are a nontrivial affine
`MixG`-torsor that no `SelectorEquiv` collapses: the residual moduli is exactly
`MixG` (dimension ≥ 1). -/
theorem residual_moduli_no_go
    {V : Type*} [AddCommGroup V] [Module ℝ V] (Γ : Module.End ℝ V)
    (evenSector : Submodule ℝ V)
    (hscalar : ∀ N : Module.End ℝ V, Commute Γ N → IsSelfAdjoint N →
        ∃ c : ℝ, ∀ x ∈ evenSector, N x = c • x) :
    ¬ (∃! W, DirectSum.IsInternal W ∧ SelectorEquiv W refChannels) ∧
      Nonempty (Ref refChannels ≃ MixG) := by
  sorry
```

This is minimal: its single hypothesis is exactly "no intrinsic second separator"
(all commuting self-adjoint operators are scalar on the even sector), and its
conclusion is non-uniqueness plus the torsor identification. It is not vacuous:
the `dim ≥ 1` lower half is already witnessed by `mixed_shear_injective` on a
concrete carrier, and the "scalar on even sector" hypothesis is realized by
`Concrete.shared_type_but_distinct` (three even channels share the `(Γ,#)`-type).

### Q8. Publication verdict + top-3 submissions — see below.

---

## Safe replacement language

| Unsafe word/phrase | Retained data | Safe replacement |
|---|---|---|
| "**exhaustive** word-source expansion" | monomial grouping | "the chosen grouping accounts for every monomial; 'no fifth block' is a **definitional bookkeeping identity** (uses only `Γ²=1, star Γ=Γ, star φ=φ`), not a rigidity theorem" |
| "**canonical** four-channel split" | `(Γ,#)` only | "canonical **odd/even (soldering vs bulk)** split; the four-channel refinement is canonical **only relative to an added locality/degree/edge grading**, not intrinsically" |
| "the split is **unique**" (axiom level) | `(Γ,#)` only | "the odd/even split is unique (`parity_decomposition_unique`); the even sector is **not** unique — an affine `MixG`-torsor of refinements (dim ≥ 1)" |
| "the split is **unique**" (with a grade) | `(Γ,#)` + separating grade | "**unique given a separating grading operator with distinct joint spectrum** (`decomposition_unique`)" |
| "the split is **unique**" (with readers) | `(Γ,#)` + support coords | "**determined once the support/coordinate selectors are fixed** — presupposes the answer's support (circular reading)" |
| "**faithful … shear preserving every submodule**" | column-sum-1 unipotent | "faithful unipotent one-parameter subgroup fixing the component sum; submodule-closure is generic linear algebra (holds for every matrix), not a shear property" |
| "**determinant-one preserving the total**" | column sums = 1 | "unipotent (hence det-one); **the total is preserved because every column sums to 1**, independently of the determinant" |

At every level: name the retained structure in the same sentence as the strength
word. "Unique/canonical" is licensed **only** with an explicit separating grade
named in the statement.

---

## F3 Lean-shaped theorem statements (with prohibited weakenings)

1. **`even_refinement_is_torsor`** (Q4) — full free+transitive `MixG`-action;
   stabilizer trivial. *Prohibited:* using `b 1 ≠ 0` instead of
   `LinearIndependent ℚ b`; transitivity without freeness; omitting the
   stabilizer; quotient stated as `True`.
2. **`four_channel_refinement_unique_iff_separating`** (Q5) — genuine `↔`.
   *Prohibited:* delivering only `⇐`; `SelectorEquiv` encoding channel supports;
   `jointGrade` naming target channels.
3. **`residual_moduli_no_go`** (Q7) — non-uniqueness + torsor identification under
   "all commuting self-adjoint operators scalar on the even sector." *Prohibited:*
   defining any channel as `0`/`True`/behind an unsatisfiable hypothesis;
   asserting `dim = 1` without proof (only `≥ 1` is witnessed).
4. **Normalization bridge** — a single carrier instantiating the abstract
   identity (`CarrierRigidity`, `2·`), the parity theorem, and the concrete
   coordinate witness (`UnifiedMassBudget`, `(1,1,1,1)`) together. *Prohibited:*
   presenting the three differently-normalized carriers (`2·` vs manuscript `4·`
   vs `(1,1,1,1)`, with inconsistent supports — `apertureC = diag(0,0,4,10)` on
   indices 2,3 vs `QA = diag(8,0,0,0)` on index 0) as one result.

---

## Dependency DAG (honest, as delivered)

```
                [Γ²=1, star Γ=Γ, star φ=φ]
                            │
                square_decomposition            (definitional regrouping)
                            │
     {aperture,closure,turn,solder}_selfadjoint
                            │
   {aperture,closure,turn}_even   solder_odd    (uses {Γ,c}=0, [Γ,g]=0)
            │                          │
            ▼                          ▼
     square_evenPart            square_oddPart  ◄─ parity_decomposition_unique
      (even = A+C+2T)            (odd = 2E_#)       (2 invertible)  [CLEAR]
            │
            ▼
  Concrete.shared_type_but_distinct   ── channels_pairwise_distinct   [CLEAR]
  (no intrinsic 2nd separator from (Γ,#))

  ── F1 (self-contained, checked here) ─────────────────────────────
   shear_add/zero/mul_neg/injective/det/column_sum
            │
   sum_mix_shear ──► mixed_shear_injective  (b 1 ≠ 0; 1-param sub-orbit)
   mix_mem_submodule  (TRIVIAL: holds ∀ M)  ── off critical path

  ── F2 (NOT self-contained here) ─────────────────────────────────
   sgn_grade_injective ──► two_sign_gradings_decomposition_unique
                                     │  (reduction D = P + 2Q)
                                     ▼
        NullEdgeCloser.decomposition_unique      [ABSENT MODULE]

  ── Capstone (NOT self-contained here; defaultTarget) ────────────
   UnifiedMassBudget.{QA,QC,QT,Es,D,square_splits}  [ABSENT]
   NullEdgeCloser.split_not_forced                  [ABSENT]
            │
   channel_coordinates_recover ─► four_channel_coefficients_unique
            └─► four_channels_linearIndependent, carrier_square_coefficients_recovered
                        └─► four_channel_rigidity_with_boundary   (circular readers)

  ── F3 TARGETS (sorry) ───────────────────────────────────────────
   even_refinement_is_torsor ─┐
   four_channel_refinement_unique_iff_separating ─┤─► STANDALONE CLASSIFICATION
   residual_moduli_no_go ─────┘
   normalization bridge ─────► one-carrier consistency
```

---

## Publication verdict

**`SECTION EARNED`** (a complete, honest boundary section of Paper F — not yet
`STANDALONE CLASSIFICATION`).

Rationale. The self-contained content proves exactly one honest positive
uniqueness (odd/even parity), one sharp negative witness (three even channels
share `(Γ,#)`-type yet differ), a genuine nondegenerate one-parameter residual
family (F1), and a correct conditional selector reduction (F2). That is a
publishable *boundary*: "chirality fixes the odd/even split; the even-sector
refinement is a nontrivial moduli that only a separating locality/degree/edge
grade collapses." It falls short of `STANDALONE CLASSIFICATION` because: (i) the
moduli is *witnessed* (dim ≥ 1) not *classified* (torsor/dimension computed);
(ii) no *intrinsic* second selector exists, so the N&S theorem currently imports
the grade as a hypothesis (only `⇐` is done, and it is only in an absent module);
(iii) the capstone and F2 are not kernel-checked in the delivered package, and
three normalizations are never reconciled. It is well past `NOT YET A PAPER`.

**Three highest-value theorem submissions for the next six hours:**

1. **Restore self-containment and re-pin axioms.** Retarget/inline the absent
   `PhysicsSM.Draft.NullEdge.*` dependencies (or vendor
   `NullEdgeCloser.decomposition_unique`, `UnifiedMassBudget.*`) so
   `ChannelSelectorUniqueness` and `FourChannelRigidityCapstone` elaborate and
   their `#print axioms` guards actually fire. Prerequisite for any "landed"
   claim. Also reconcile `FOUR_CHANNEL_CLASSIFICATION_REVIEW.md` names with the
   landed declarations and the missing companion file.
2. **`even_refinement_is_torsor` + `mix_stabilizer_trivial`** (Q4): upgrade
   `mixed_shear_injective` from a 1-parameter sub-orbit to the full free,
   transitive `MixG`-torsor under `LinearIndependent ℚ b`, with the stabilizer
   computed. Converts "a witness" into "the moduli is the affine space `MixG`."
3. **`four_channel_refinement_unique_iff_separating`** (Q5): the genuine `↔` —
   `⇐` by generalizing `two_sign_gradings_decomposition_unique` to `Fin 4` grades,
   `⇒` by the contrapositive of `shared_type_but_distinct`. This is the
   publishable classification core; pair it with `residual_moduli_no_go` (Q7) as
   the sharp negative.
```
