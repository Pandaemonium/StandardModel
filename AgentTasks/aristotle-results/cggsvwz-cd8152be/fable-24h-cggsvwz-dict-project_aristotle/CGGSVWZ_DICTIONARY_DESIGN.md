# CGGSVWZ index dictionary for the positional certificate (Paper C, rank-4)

**Type.** Design memo + exact-computation obligations. No finite-volume
Fredholm / topological index is claimed. Deliverable is a closed-form
DICTIONARY with an honest comparison verdict.

**Source.** Cedzich, Geib, Grünbaum, Stahl, Velázquez, Werner, Werner,
"The topological classification of one-dimensional symmetric quantum walks",
arXiv:1611.04439, Ann. Henri Poincaré 19 (2018). Abbreviated **CGGSVWZ**.

**Scope guard (Task 5).** Every symmetry-type label, index-group name, winding
number, and relative index quoted below is derived from the *stated* symmetry
data of our register walk and from a self-contained exact/numeric oracle
computation (see §2, §7). All sign and time-frame **conventions are flagged for
re-verification against arXiv:1611.04439 at harvest**; the qualitative verdict
(§3–§4) is convention-independent, the individual integers (§2) are not.

Companion typechecking artifact: `context/CGGSVWZDictionary.lean`
(self-contained, `import Mathlib` only; builds clean — the two sibling context
modules fail to build only because they import an external landed dependency
`PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding` not shipped in this project,
a pre-existing condition unrelated to this deliverable).

---

## Our object (recalled)

Four-site palindromic register walk `W(b) = S·C·S` on
`V8 = Fin 4 × Fin 2` (4 sites × 2 coin states) over `ℚ`, real orthogonal.
Per-site SO(2) coins with `cos = 4/5`, `sin = sign(b x)·3/5` (the `3-4-5`
coin). Chiral grading `Γ = I₄ ⊗ σ_x` (`gradeX`), with

    Γ² = 1,     Γ W Γ = Wᵀ = W⁻¹.

`b : Fin 4 → Bool` ranges over 16 sign fields. Landed facts we build on
(kernel-checked in the context modules):

* fixed-leg compression self-adjointness ⇔ two-wall ∧ ¬fixedSingleton
  (chart `{1,3}`), plus the mirror law for chart `{0,2}`;
* every two-wall field's complete walk has exact `±1` modes;
* the sector-resolved chirality indices are **all zero** (balanced) for every
  field;
* **the discriminator is the certificate boundary** (which chart applies),
  NOT any chirality index.

---

## Task 1 — Symmetry type and index group

We read off the CGGSVWZ symmetries from the stated data. Denote by `K`
entrywise complex conjugation in the standard (real) register basis.

1. **Chiral (sublattice) `Γ`** — unitary, `Γ = σ_x` per cell, `Γ² = +1`,
   `Γ W Γ = W⁻¹`. This is CGGSVWZ's chiral symmetry `γ` (their chunk 32). Since
   each cell is balanced, `tr Γ = 0` (kernel-checked: `trace_gradeX_zero`), so
   the `Γ`-eigenspaces have equal dimension and the off-diagonal block
   `W₁₂(k)` is square — exactly their setup.

2. **Particle-hole `η = K`** — antiunitary. `W` is *real*, so `K W K = W̄ = W`,
   i.e. `η W η⁻¹ = W`. Squares: `η² = K² = +1`.

3. **Time-reversal `τ = Γ·K`** — antiunitary. `τ W τ⁻¹ = Γ K W K Γ =
   Γ W Γ = Wᵀ = W⁻¹`. Squares: `τ² = (σ_x K)² = σ_x σ̄_x = σ_x² = +1`.

So `(η², τ², Γ) = (+1, +1, present)` — time-reversal `T² = +1`, particle-hole
`C² = +1`, chiral `S` present. In the Altland–Zirnbauer / CGGSVWZ tenfold
scheme this is class

> **BDI**, whose 1D index group is **ℤ**,

realised as the winding number of `det W₁₂(k)` (chunk 32: `W` is gapped at `±1`
iff `W₁₂(k)` is invertible for all `k`; then the winding is defined). For a
*symmetric* (palindromic) time-frame walk `W = S·C·S`, CGGSVWZ carry a **pair**
of such integers, one per symmetric time frame; the complete bulk invariant is
the pair `(n₁, n₂) ∈ ℤ²` (§2). The reality type (chunk 34) and combined type
(chunk 35) machinery are the `K`-real refinements of the same class; our `η = K`
places us squarely in the real chiral (BDI) column.

*Convention flag:* the assignment "reality of `W` ⟹ `η = K` is particle-hole,
`τ = ΓK` is time-reversal" uses the walk (Floquet) convention where `η` commutes
with `W` and `τ` inverts it. CGGSVWZ's opposite naming convention would swap the
`η ↔ τ` labels but leaves the class (BDI) and index group (ℤ) unchanged.

---

## Task 2 — Bulk winding formula, evaluated exactly

**Formula (transcribed).** In the `Γ`-eigenbasis (Hadamard `U`,
`U†ΓU = σ_z`), `W'(k) = U† W(k) U` is off-diagonal-dominant with square block
`W₁₂(k)`. The BDI invariant is

    n = winding of  det W₁₂(k)  as k : 0 → 2π   ∈ ℤ.

**Bulk model.** The infinite periodic extension of a constant sign `s` is the
translation-invariant coined walk with cell = coin space `Fin 2`,

    W(k) = S(k) · C · S(k),
    S(k) = diag(e^{-ik}, e^{ik}),   C = [[4/5, -s·3/5],[s·3/5, 4/5]],   s = ±1.

Chirality `Γ = σ_x` and unitarity verified symbolically (`gWg = W†`, `WW† = 1`).
In the chiral basis the (scalar) off-diagonal block is

    W₁₂(k) = s·(3/5) − (4/5)·i·sin(2k).

Gap check: `|W₁₂(k)|² = 9/25 + 16 sin²(2k)/25 ≥ 9/25 > 0`, so both bulks are
**gapped at `±1`** and the winding is defined.

**Exact evaluation** (real part is the constant `±3/5`, so the curve never
encircles the origin in the symmetric frame):

| bulk | frame 1  `S·C·S` | frame 2  `C·S·S` |
|------|:---------------:|:----------------:|
| `s = +1` | **0** | **−2** |
| `s = −1` | **0** | **+2** |

This reproduces the recorded momentum-frame winding table `(0 / ∓2)`.

**Relative index across a single `+ | −` wall** = difference of bulk windings:

    frame 1:  0 − 0  =  0
    frame 2:  (−2) − (+2)  =  −4.

The symmetric time frame (frame 1) sees **nothing** at a wall; the entire jump
lives in the second frame and depends only on the two bulk signs, **not on where
the wall sits**.

*Convention flag:* the two time frames `(S·C·S, C·S·S)` are our reading of
CGGSVWZ's symmetric-time-frame pair; the overall sign of the winding and the
choice of which frame is "first" are convention-dependent. The magnitudes
`{0, 2}` and the wall difference `{0, 4}` are the robust content.

---

## Task 3 — The decisive computation

**Question.** Over the 16 fields (equivalently the distinct wall
configurations), does *any* CGGSVWZ index of the periodic extension — bulk
winding, relative wall index, or the gentleness/compact-perturbation symmetry
index `si_±` (chunk 39) — reproduce our certificate discriminator
(protected-vs-blind = which chart certifies)?

**Structural obstruction.** Every CGGSVWZ index listed is an invariant of the
*infinite periodic extension*, hence invariant under lattice translation. On the
4-site register a one-cell translation is the cyclic rotation
`rot b = (i ↦ b(i+1))`. Two facts (kernel-checked, `decide`, in
`CGGSVWZDictionary.lean`):

* `wallCount_rot` — the wall count is translation invariant. Bulk windings,
  the relative wall index, and `si_± ≡ 0` all factor through the
  translation-class of the run structure, so each is translation invariant.
* `protectedField_rot_ne` — the discriminator is **not** translation invariant.

**Witness.** `wProtected = ![false,false,true,false]` (lone flip on the
`{0,2}`-axis site `2`) is **protected**; its one-cell translate `rot wProtected`
(lone flip on the `{1,3}`-axis site `3`) is **blind**. The two are the *same
periodic bulk* up to translation, so every CGGSVWZ periodic index assigns them
the *same* value, while the certificate assigns them *opposite* values.

**Theorem (strictly finer), `no_periodic_index_reproduces_discriminator`.**
For every translation-invariant index `I : (Fin 4 → Bool) → α` and every Boolean
decoder `d : α → Bool`,

    ∃ b,  d (I b)  ≠  protectedField b.

In particular the vanishing gentleness index `si_± ≡ 0` fails
(`gentleness_index_blind`): being identically `0`, it is a fortiori translation
invariant, so it cannot separate the protected from the blind singleton.

### Exact comparison table (representatives of the 16 fields)

`W#` = wallCount; `bulk pair` = winding pair of the periodic extension in the
two frames (translation class); `rel` = relative wall index (frame 2);
`si_±` = gentleness symmetry index (all zero, landed); `prot` = certificate.

| representative | W# | CGGSVWZ bulk pair | rel (frame 2) | si_+ | si_− | **prot** |
|----------------|:--:|:-----------------:|:-------------:|:----:|:----:|:--------:|
| `++++` (0-wall) | 0 | `(0,−2)` uniform | 0 | 0 | 0 | **F** |
| `++−−` block | 2 | one `+ \| −` wall class | −4 | 0 | 0 | **T** |
| `−+++` protected singleton (lone flip on `{0,2}`-site `0`) | 2 | one `+ \| −` wall class | −4 | 0 | 0 | **T** |
| `+++−` blind singleton (lone flip on `{1,3}`-site `3`) | 2 | one `+ \| −` wall class | −4 | 0 | 0 | **F** |
| `+−+−` (4-wall) | 4 | alternating class | 0 | 0 | 0 | **F** |

The two two-wall singletons `−+++` and `+++−` are translation-equivalent
(`rot(−+++) = +++−`): every
CGGSVWZ column is identical, yet `prot` differs (**T** vs **F**). That single
row-pair is the theorem-shaped negative.

**Verdict.** *Every* CGGSVWZ index of the periodic extension is
position-blind on the classified set (bulk/relative windings depend on bulk
signs only; the symmetry/gentleness indices `si_±` vanish identically). Our
positional discriminator distinguishes translation-equivalent defects that all
CGGSVWZ periodic indices identify. Therefore:

> **Our discriminator is strictly finer than the CGGSVWZ indices of the periodic
> extension.**

The mechanism is transparent: our certificate is anchored to a *fixed reflection
axis* of the finite register (chart `{1,3}` vs `{0,2}`), a datum the
translation-invariant bulk theory discards.

---

## Task 4 — Referee-facing dictionary sentences (verbatim)

**Outcome that holds here (strictly finer).**

> On the finite register we claim no Fredholm invariant; our
> protected-vs-blind discriminator is the fixed-reflection-axis chart boundary,
> which is strictly finer than the CGGSVWZ real-space symmetry indices of the
> infinite periodic extension. In the Altland–Zirnbauer/CGGSVWZ scheme our walk
> is class BDI (index group ℤ, winding of det W₁₂); the constant bulks of sign
> ±1 carry equal symmetric-frame windings (0, with the second-frame pair ∓2),
> so the relative index across any single wall is bulk-determined and
> position-blind, and the gentleness symmetry indices si_± vanish identically
> for every field. Consequently no CGGSVWZ index — bulk, relative, or
> gentleness — reproduces our discriminator: it separates
> translation-equivalent defects (a lone flip on a mirror-fixed {0,2}-axis site
> versus its one-cell translate onto a {1,3}-axis site) that every
> translation-invariant CGGSVWZ index necessarily identifies.

**Template for the other outcome (match found), NOT applicable here, retained
for completeness.**

> On the finite register we claim no Fredholm invariant; nevertheless our
> protected-vs-blind discriminator equals, field-for-field over the classified
> set, the CGGSVWZ index B of the periodic extension — the Lean-decidable
> identity `∀ b, protectedField b = decide (B b) `.

**Lean-ready decidable statements.** A positive (match) result *would* be the
single-line decidable identity
`theorem match : ∀ b, protectedField b = decide (indexPredicate b) := by decide`.
Since no such `indexPredicate` exists (it would have to be
translation-invariant yet agree with `protectedField`), the shipped decidable
statement is the *impossibility*:

    theorem no_periodic_index_reproduces_discriminator
        {α} (I : (Fin 4 → Bool) → α) (hI : ∀ b, I (rot b) = I b) (d : α → Bool) :
        ∃ b, d (I b) ≠ protectedField b

together with `wallCount_rot`, `protectedField_rot_ne`, and the `si_±`
corollary `gentleness_index_blind`, all in `context/CGGSVWZDictionary.lean`.

---

## Task 5 — Scope guards (restated)

* **No finite-volume index claim.** Nothing here asserts a Fredholm or
  topological index of the finite register `W(b)`. The CGGSVWZ integers are
  invariants of the *infinite periodic extension* only; the certificate is a
  finite, decidable positional predicate.
* **Convention/sign transcription.** The class label BDI is convention-robust;
  the `η ↔ τ` naming, the winding signs, and the "first/second time frame"
  labelling are transcription-level choices flagged for re-verification against
  arXiv:1611.04439 at harvest. The qualitative verdict (strictly finer) does not
  depend on any of these choices.
* **Source-chunk faithfulness.** Chunks 32/34/35/39 were used only for the
  symmetry-type setup, the `W₁₂`-invertibility gap criterion, and the
  gentleness-index framing; any residual transcription doubt is to be resolved
  at harvest.
