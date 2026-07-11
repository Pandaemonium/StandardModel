# HOSTILE REFEREE REPORT — Paper C

**Manuscript:** *Winding Is Not Enough: Involutive Compression and Exact
Defect Modes in a Spinor-Derived Quantum Walk* (M. Schwab),
`Null_Edge_HalfWinding_Defect_Paper_Draft_2026-07-11.tex`.

**Packet Lean anchors examined:** `ThetaFamilyProtection.lean`,
`CGGSVWZDictionary.lean`, `PinnedSpecProjectors.lean`,
`PlueckerPairGenerator.lean` (all under `context/`).

**Scope caveat.** Of the ~15 modules the manuscript anchors to, only three
of the four packet files are actually cited by the manuscript
(`ThetaFamilyProtection`, `CGGSVWZDictionary`, `PinnedSpecProjectors`).
The fourth packet file is *not* cited anywhere (Finding 1). All other
anchors (`PlueckerWindingDerived`, `ModeInvariantHalfWinding`,
`HalfPeriodInvariant`, `HalfWindingFieldPositionClassification`,
`HalfWindingFullWalkControls`, `WallModeWitness`, `PinnedMirrorChart`,
`PinnedSectorIndex`, `PinnedLocalization`, `PinnedControlAndBlind`,
`ChiralFlipMode`, `SignWallDefectRouteB[Concrete]`, `GaugeClassification`)
are **not in the packet** and could not be verified; findings about them
are limited to what the three cited packet files reveal about them
(e.g. the names the θ-file actually imports and uses).

Grades: **FATAL** (blocks publication) / **MAJOR** (must fix before
acceptance) / **MINOR** (fix requested) / **NITPICK**.

---

## Surface 1 — Claim/anchor mismatch

### Finding 1 — `PlueckerPairGenerator.lean` is an un-cited orphan and contradicts the "derived" framing. **MAJOR**

The packet is described as "four of its newest Lean anchors," yet
`PlueckerPairGenerator` (and every identifier in it: `Kop`, `pairKick`,
`quarticPairTransfer`, `Uop`, `halfpulse_*`) appears **nowhere** in the
manuscript — not in a theorem marker, not in the appendix module list
(`grep` of the `.tex` for `pairKick|Kop|quartic|PairGen` returns nothing;
the only Plücker anchor is `PlueckerWindingDerived`). Either this file
belongs to the companion derivation paper and was mis-shipped in the Paper C
packet, or Paper C's Setup silently rests on it. Worse, its own header
states the opposite of the manuscript's headline adjective:

> "This does **not** derive the generator `Kop` from the free walk. `Kop`
> remains a supplied coupling."

whereas the abstract opens

> "the zeros of the field ... are geometrically distinguished defects. We
> prove, machine-checked, an exact mode mechanism"

and calls the link data "\emph{derived}." A referee cannot map this anchor
to any claim, and its boundary note undercuts the paper's central verb.
*Fix:* either cite the module and its scope explicitly, or remove it from
the Paper C artifact manifest and state that the coin's dynamical origin is
companion-paper material.

### Finding 2 — All-θ "classification / precisely" is only sufficiency + three spot-checks; the iff is a fixed-coin `native_decide` fixture. **MAJOR**

Abstract:

> "it is now a machine-checked family-level law: the reflection-fixed-leg
> compression is self-adjoint precisely for the twelve minus four two-wall
> fields whose lone flip does not sit on a reflection-fixed site"

and Theorem (Protection across the whole coin family):

> "the classification is scoped precisely to the massive family
> $\sin\theta\neq0$"

For the *entire coin family* `θ : ℝ`, the packet proves only the **forward
(sufficiency) direction** and three fixed-field negative controls, never
the iff:

- `ThetaFamilyProtection.M13_selfadj_of (theta) (b) (h : signB (b 0) + signB (b 2) = 0) : M13 theta b = (M13 theta b)ᵀ` — sufficiency only.
- `control_blind_not_selfadj`, `control_zero_not_selfadj`, `control_four_not_selfadj` — necessity checked at exactly **three** hand-picked fields (`![T,T,T,F]`, `![T,T,T,T]`, `![T,F,T,F]`), not for all 16.
- `modes_persist (theta) (b) (hb : … wallCount b = 2) : Modes theta b` — again a one-way implication (two walls ⟹ modes); it never shows non-two-wall fields lack modes.

The genuine 16-field **iff** ("precisely for") lives only at the *fixed
rational coin* in `HalfPeriodInvariant.selfadj_iff_protected`, whose own
marker in the manuscript says "the 16-field decisions use the compiled
evaluator" — i.e. `native_decide` at a fixed angle. So the "family-level
law … precisely" sentence fuses a fixed-angle `native_decide` iff with an
all-θ *sufficiency-only* result. This is exactly the "all-θ phrasing
anchored to fixed-angle fixtures / iff where Lean gives only sufficiency"
pattern. *Fix:* say "for every θ the criterion is **sufficient** for the
modes; the exhaustive iff over the 16 fields is decided at the fixed
rational coin."

### Finding 3 — "spectral projectors **onto** $\ker(W\mp1)$" overstates the Lean, which proves *into* + rank. **MINOR**

Body:

> "the chart projectors are genuine orthogonal spectral projectors onto
> $\ker(W\mp\id)$ … instantiated on all three chart types
> (\texttt{PinnedSpecProjectors})"

`PinnedSpecProjectors.eigProj13_is_spectral` proves `P*P=P`, `Pᵀ=P`,
`(Wof b - (sgn se) • 1) * P = 0`, and `P.trace = 2`. That is: `range P ⊆
ker(W-ε)` and `rank P = 2`. It does **not** prove `range P = ker(W-ε)`
(surjectivity onto the eigenspace); "onto" additionally needs
`dim ker(W-ε) = 2`, which is not in this file (it is asserted elsewhere as
"domain blocks: 4"). For the rank-4 block case (`eigProjW_is_spectral`,
`trace = 4`, whole 8-space split 4+4) "onto" is justified; for the rank-2
chart cases it is not, within the packet. *Fix:* "projectors **into**
$\ker(W\mp1)$ of the certified rank," or cite the separate
dimension-counting lemma.

### Finding 4 — `Modes` gives $\dim\ker\ge1$, not the body's "$\dim\ker(W\mp\id)=2$". **MINOR**

Body (determinant section):

> "the two-wall walk has $\dim\ker(W\mp\id)=2$ while the zero-wall control
> has none"

The packet's mode predicate is existential:
`ThetaFamilyProtection.Modes theta b := (∃ V ≠ 0, (toCR (Wth θ b)).mulVec V = -V) ∧ (∃ V ≠ 0, … = V)`,
i.e. $\dim\ker \ge 1$ in each sign sector. The "$=2$" (and the "domain
blocks: 4") is not established in any packet file; it is a landed-module /
un-formalized-run-record claim. Not a contradiction, but the equality is
carried by prose the packet does not back.

---

## Surface 2 — Trust-label accuracy

### Finding 5 — Appendix "Assumption footprints are build-enforced … throughout" is false for the packet. **MAJOR**

Appendix:

> "Assumption footprints are build-enforced: the standard three axioms
> throughout, plus the documented compiled-evaluator pair on explicit
> rational instantiations only."

Of the four packet files, **only the un-cited orphan**
(`PlueckerPairGenerator`) actually carries `#print axioms` guards (11 of
them, via `#guard_msgs`). The three *cited* modules
(`ThetaFamilyProtection`, `CGGSVWZDictionary`, `PinnedSpecProjectors`)
contain **no** `#print axioms`/`#guard_msgs` footprint guard at all. So the
axiom footprints of precisely the modules that anchor the paper's theorems
are *not* build-enforced. The census/splitting-law sentences the brief asks
to be "visibly oracle-grade" therefore rest on modules whose footprints are
asserted in prose headers, not enforced by the build. *Fix:* add
`#print axioms` guards to the cited modules, or soften "build-enforced …
throughout" to name exactly where guards exist.

### Finding 6 — `PinnedSpecProjectors` instantiations are `native_decide`-dependent; "kernel-only abstract lemmas instantiated" can mislead. **MINOR**

Body: "two kernel-only abstract lemmas instantiated on all three chart
types." Accurate for the abstract lemmas (`bproj_spectral`,
`invproj_spectral`, closed by ring algebra), but every *instantiation*
(`eigProj13_is_spectral`, `eigProj02_is_spectral`) consumes
`Mfix_involution`/`Mfix0_involution`, both `by native_decide`
(lines 43, 46). Thus the instantiated results are Kernel+Eval, not
kernel-only. The dual `\Kernel/\DraftTrust` marker technically covers this,
but the sentence should not imply the *instantiations* are kernel-only.

### Finding 7 — The "gentleness index" object in `CGGSVWZDictionary` is the literal constant `0`; "vanish identically" is asserted, not derived here. **MINOR**

Body: "the gentleness indices vanish identically." In the cited file,

```lean
def siPlus (_b : Fin 4 → Bool) : ℤ := 0
def siMinus (_b : Fin 4 → Bool) : ℤ := 0
theorem si_translation_invariant : … := by constructor <;> intro b <;> rfl
theorem gentleness_index_blind : ∃ b, (decide (siPlus b ≠ 0)) ≠ protectedField b := …
```

These are transcriptions defined **by fiat** (the file header: "TRANSCRIBED
from landed results," "oracle-transcribed constants … flagged for source
re-verification"). `si_translation_invariant` is `rfl` on `0=0`, and
`gentleness_index_blind` is content-free (any constant index fails to match
a non-constant discriminator). The actual vanishing is claimed in the
non-packet `PinnedSectorIndex`. A referee will read `def siPlus := 0` +
"machine-checked" as circular. *Fix:* label these explicitly as
placeholders and anchor "vanish identically" solely to `PinnedSectorIndex`.

### Finding 8 — The CGGSVWZ winding table is oracle-transcribed data under a `\Kernel` module marker. **MAJOR (label conflation)**

Boundaries: "the constant bulks carry equal symmetric-frame windings
(second-frame pair $\mp2$)." In `CGGSVWZDictionary`:

```lean
def bulkWindingPair (s : Bool) : ℤ × ℤ := if s then (0, -2) else (0, 2)   -- ORACLE-TRANSCRIBED
theorem relativeIndexAcrossWall_eq : relativeIndexAcrossWall = (0, -4) := by decide
```

The winding *values* are hand-entered constants (header: "flagged for
source re-verification"); `relativeIndexAcrossWall_eq` merely subtracts two
transcribed constants. The module carries a `\Kernel` marker in the body
("plain \texttt{decide}"), which correctly describes the *impossibility*
theorem but risks reading as if the winding numbers themselves are
kernel-certified. They are not. *Fix:* segregate the impossibility theorem
(genuinely kernel-`decide`) from the transcribed winding table (unverified
data) in the trust labelling.

### Finding 9 — Abstract census sentence lacks the "not yet formalized" caveat carried in the body. **MAJOR**

Abstract states as flat fact, adjacent to machine-checked results:

> "Exact computation further decides all 16 complete walks: every two-wall
> field --- blind ones included --- carries modes, so the positional law
> delimits the reach of the reflection certificate, not mode existence."

The body concedes it is **not machine-checked**:

> "In fact, exact rational computation (run record; not yet formalized)
> decides the complete walks of all 16 fields: \emph{every} two-wall field
> … has $\dim\ker(W\mp\id)=2$".

The packet confirms only $\dim\ker\ge1$ for two-wall fields
(`modes_persist`) and contains no 16-walk census. The brief demands the
census be "visibly oracle-grade"; the abstract presents an un-formalized
run record without its caveat. *Fix:* add "(exact-arithmetic run record,
not yet machine-checked)" to the abstract sentence.

---

## Surface 3 — Novelty honesty (Cedzich-school lens)

### Finding 10 — The "strictly finer / settled … in a universal form" claim reduces to one within-orbit separation. **MINOR→MAJOR (framing)**

`CGGSVWZDictionary.no_periodic_index_reproduces_discriminator` is a clean,
kernel-`decide` theorem, and the manuscript's parenthetical is admirably
honest:

> "(The Lean theorem quantifies over translation-invariant functions; no
> CGGSVWZ index object is itself constructed in the formalization.)"

However, `rot b := fun i => b (i+1)` is the cyclic $\mathbb Z/4$ action, and
the witness pair `wProtected = ![F,F,T,F]` and `rot wProtected = ![F,T,F,F]`
lie in the **same** orbit. So the theorem is, in substance, "the
discriminator is not constant on one translation orbit; hence no
orbit-invariant reproduces it." That is real and universal over indices,
but its entire force is a single within-orbit sign change — considerably
more modest than the rhetoric:

> "The relation to the real-space symmetry indices of Cedzich et al. … is
> now settled at this size, in the negative and in a universal form."

Moreover the bridge to "every CGGSVWZ index" ("by the standard fact that
the CGGSVWZ indices are translation invariant") is an **un-formalized**
appeal to the literature — the one inferential link in "settled" that the
machine does not check. A Cedzich-school referee will accept the honest
parenthetical but push back on "settled … universal form" as overselling a
one-orbit combinatorial observation plus a cited (not proved) invariance
fact. *Fix:* "for the periodic-extension indices, via one explicit
translation-orbit separation (using the standard translation-invariance of
the CGGSVWZ indices, not formalized here)."

### Finding 11 — Imported-vs-new split is stated well; the residual risk is the "derived" verb (see Finding 1). **MINOR**

The Relation section ("we import that classification and claim none of it")
and the itemized (i)–(vi) new-contributions list are the strongest part of
the framing and would likely satisfy a Cedzich-school referee **provided**
the "derived" origin (contribution (i), Theorem "Derived winding") is
actually anchored — it is anchored to the non-packet `PlueckerWindingDerived`,
while the packet's Plücker file explicitly disclaims deriving the coupling
(Finding 1). The novelty rests on a module not in the packet; a referee
cannot presently confirm contribution (i).

---

## Surface 4 — Internal consistency

### Finding 12 — Two body-cited modules are absent from the appendix module list. **MAJOR**

The appendix opens "Modules (all under `PhysicsSM/Draft/NullEdge/`):" and
enumerates 15 modules — but **omits** both `ThetaFamilyProtection` (carries
the entire Theorem "Protection across the whole coin family," `\Kernel`) and
`CGGSVWZDictionary` (carries the "machine-checked impossibility"
`no_periodic_index_reproduces_discriminator`, cited by full name in the
body). An appendix that claims to list the machine-verification modules and
omits two theorem-bearing ones is a self-contradiction. *Fix:* add both to
the appendix list.

### Finding 13 — Appendix modules not cited in the body. **MINOR**

Cross-check of the 15 appendix modules against body citations:
- `ChiralFlipMode` ("determinant-parity engine") — **never** referenced in
  the body (the determinant blindness is anchored to `signWalk_det_eq_one`,
  `sector_dets_all_one`).
- `PinnedLocalization` ("exact $\lambda=\pm1$ transfer matrices with
  eigendata") — **never** referenced in the body.
- `PinnedControlAndBlind` ("exact polynomial inverses certifying the control
  annihilators") — **never** referenced in the body (controls are anchored
  to `HalfWindingFullWalkControls`).

*Fix:* cite each in the body where its result is used, or drop from the
manifest.

### Finding 14 — "Two further theorems complete the picture" miscounts. **MINOR**

Abstract: "Two further theorems complete the picture at this size,"
introducing (a) the θ-family protection theorem and (b) the
translation-invariance impossibility. But (b) is **not** a theorem
environment — it appears only as inline prose in the Boundaries paragraph
(`no_periodic_index_reproduces_discriminator`), while every other named
result uses `\begin{theorem}`. So only one of the "two further theorems" is
formatted as a theorem. *Fix:* promote the impossibility to a numbered
theorem or reword ("one further theorem and one machine-checked
impossibility").

### Finding 15 — Overloaded word "family." **NITPICK**

"family-level law" (abstract) means the 16-field sign-pattern family, while
"the entire coin family," "θ-family," "mass family" mean the continuum of
angles. The same word carries both senses within one abstract, aiding the
Finding-2 conflation. *Fix:* reserve "family" for the θ-continuum; use
"the 16-field census" for the sign patterns.

---

## Surface 5 — The five worst sentences (verbatim, with a one-line fix)

1. **Abstract, census.** "Exact computation further decides all 16 complete
   walks: every two-wall field --- blind ones included --- carries modes,
   so the positional law delimits the reach of the reflection certificate,
   not mode existence."
   *Fix:* mark it "(exact-arithmetic run record, not yet machine-checked)" —
   the packet proves only $\dim\ker\ge1$ (`modes_persist`), and the body
   itself calls this "not yet formalized" (Finding 9).

2. **Appendix.** "Assumption footprints are build-enforced: the standard
   three axioms throughout, plus the documented compiled-evaluator pair on
   explicit rational instantiations only."
   *Fix:* "build-enforced" holds only in the un-cited `PlueckerPairGenerator`;
   add `#print axioms` guards to `ThetaFamilyProtection`,
   `CGGSVWZDictionary`, `PinnedSpecProjectors` or drop the word (Finding 5).

3. **Abstract, family law.** "it is now a machine-checked family-level law:
   the reflection-fixed-leg compression is self-adjoint precisely for the
   twelve minus four two-wall fields whose lone flip does not sit on a
   reflection-fixed site".
   *Fix:* the all-θ result is sufficiency only; state that the "precisely"
   iff is decided at the fixed rational coin, not across θ (Finding 2).

4. **Boundaries.** "The relation to the real-space symmetry indices of
   Cedzich et al.\ … is now settled at this size, in the negative and in a
   universal form."
   *Fix:* downgrade "settled … universal form" to a single explicit
   translation-orbit separation relying on the (un-formalized) standard
   invariance of the CGGSVWZ indices (Finding 10).

5. **Abstract, mechanism.** "the zeros of the field --- collinearity points
   of the primitive spinors --- are geometrically distinguished defects. We
   prove, machine-checked, an exact mode mechanism … the link data of any
   nowhere-zero field is \emph{derived}".
   *Fix:* the packet's only Plücker file disclaims derivation ("`Kop`
   remains a supplied coupling"), and the deriving module is not in the
   packet; qualify "derived" or anchor it to a citable, present module
   (Finding 1).

---

## Statement-level red flags in the four Lean files

- **`ThetaFamilyProtection`.** *Witness reused as control.* The blind
  singleton `![true,true,true,false]` is simultaneously (a) a
  wrong-chart negative control (`control_blind_entry`/`_not_selfadj`,
  antisymmetric entry $-2\sin\theta$) and (b) a two-wall field that
  `modes_persist` certifies as *carrying* modes (via the `{0,2}` chart).
  Listing it as a "control" beside the genuine no-mode zero/four-wall
  fields (`![T,T,T,T]`, `![T,F,T,F]`) invites the misreading that it is a
  no-mode control. The manuscript's "self-adjointness failures" wording is
  technically correct, but the reuse should be flagged in prose. **NITPICK.**
  *No vacuous hypotheses*; `control_blind_massless`'s `sin θ = 0` is the
  intended scoping hypothesis. The header's "no `native_decide` … kernel
  decide" is accurate (`two_wall_chart` uses kernel `decide`; only comments
  mention `native_decide`).

- **`CGGSVWZDictionary`.** `no_periodic_index_reproduces_discriminator` is
  genuine and airtight over translation-invariant `I` + arbitrary decoder
  `d` (kernel `decide`). But `siPlus/siMinus := 0`,
  `si_translation_invariant` (`rfl`), `gentleness_index_blind`, and
  `relativeIndexAcrossWall_eq` are **trivial corollaries of hand-entered
  constants** presented in the same breath as content (Findings 7–8).
  `protectedField_compat` (kernel `decide`) is a good, load-bearing bridge.
  **MINOR.**

- **`PinnedSpecProjectors`.** `bproj_spectral`/`invproj_spectral` are clean,
  general, load-bearing (every hypothesis used). The instantiations prove
  `range ⊆ ker` + rank, not `range = ker` — do not read them as surjective
  spectral projectors onto the eigenspace without the separate dimension
  count (Finding 3). Instantiations depend on `native_decide`
  (`Mfix_involution`, `Mfix0_involution`) → Kernel+Eval (Finding 6).
  **MINOR.**

- **`PlueckerPairGenerator`.** Cleanest provenance discipline of the four
  (explicit kill-condition record: `naive_halfpulse_false` proved instead
  of silently repairing the false submitted headline; 11 `#print axioms`
  guards). Its statements are internally sound, but the file is **orphan to
  Paper C** and its "supplied coupling" boundary note contradicts the
  paper's "derived" framing (Finding 1). Separately, the abstract's
  "site probabilities … $3277/64$" (for `WallModeWitness`, not in packet)
  are un-normalized $|\text{amplitude}|^2$ exceeding 1 — call them relative
  weights, not probabilities. **NITPICK.**

---

## Summary of grades

| # | Finding | Grade |
|---|---------|-------|
| 1 | `PlueckerPairGenerator` orphan; "derived" contradicted | MAJOR |
| 2 | All-θ "classification/precisely" is sufficiency + 3 spot-checks; iff is fixed-coin `native_decide` | MAJOR |
| 3 | "projectors **onto** ker" overstates "into + rank" | MINOR |
| 4 | body "$\dim\ker=2$" vs packet's $\ge1$ (`Modes`) | MINOR |
| 5 | "footprints build-enforced throughout" false for cited modules | MAJOR |
| 6 | spectral instantiations are `native_decide`, not kernel-only | MINOR |
| 7 | "gentleness index" = literal `0`; blindness corollary vacuous | MINOR |
| 8 | winding table is unverified transcription under `\Kernel` marker | MAJOR |
| 9 | abstract census lacks the body's "not formalized" caveat | MAJOR |
| 10 | "settled … universal" = one within-orbit separation + un-formalized invariance fact | MINOR→MAJOR |
| 11 | novelty (i) "derived" rests on a non-packet module | MINOR |
| 12 | `ThetaFamilyProtection`, `CGGSVWZDictionary` missing from appendix list | MAJOR |
| 13 | `ChiralFlipMode`, `PinnedLocalization`, `PinnedControlAndBlind` uncited in body | MINOR |
| 14 | "two further theorems" — one is inline prose, not a theorem | MINOR |
| 15 | "family" overloaded (16 fields vs θ-continuum) | NITPICK |

**No FATAL findings** (no false theorem, no vacuous main statement, no
sorry/axiom abuse detected in the four packet files). The dominant issues
are **provenance/label integrity** (Findings 1, 5, 8, 9, 12) and
**quantifier scope** (Finding 2): several abstract/Boundaries sentences
claim more (all-θ iff, build-enforced footprints, oracle-grade census,
"settled universally") than the cited Lean, in the packet, delivers.
Recommendation: **major revision** — the mathematics and the three cited
proofs are sound at the level checked, but the manuscript's trust labelling
and quantifier phrasing must be brought into exact correspondence with the
anchors before a rigorous-venue referee would sign off.
