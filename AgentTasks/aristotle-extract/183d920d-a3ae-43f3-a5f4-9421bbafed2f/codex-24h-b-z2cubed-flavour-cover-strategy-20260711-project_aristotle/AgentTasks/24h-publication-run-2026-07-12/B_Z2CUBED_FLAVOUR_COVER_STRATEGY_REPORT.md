# Strategy report: exact `Z2^3` flavour-cover successor

Date: 2026-07-12
Owner: Codex (B-lane)
Mode: review-only strategy. No project files were edited; no broad build was run.
Small algebraic/finite claims below were sanity-checked in a scratch elaboration
against the pinned toolchain (`import Mathlib` + the live
`Compact3Plus1DiracRate` module); every such check is marked **[checked]**.
Signatures for the two proposed packages are written but left as design targets,
not landed theorems.

---

## 0. Sources read and the one fact that governs everything

Read in full: `DIRECT_LIT_MINIMAL_DOUBLING_RECIPROCAL_2026-07-11.md`,
`MasslessBlochCrossingClassification.lean`,
`MasslessChargeCensusComposition.lean`,
`PositiveWeylBranchCompleteness.lean`, `FiniteNoSignaling.lean` (finite
translation/register pattern), and `MEMO_3PLUS1_ATTACK.md`.

The direct-literature pass ranks the Bakircioglu–Arnault–Arrighi eight-sheeted
Brillouin-zone covering (arXiv:2505.07900) as the concrete successor to the
failed reciprocal P1. Its promise is explicitly *not* a single-cone
four-component symbol: it "preserves linearity and chiral symmetry by changing
the lattice/translation representation" and "solves doubling by reinterpreting
multiplicity as flavour; it does not derive the Standard Model family count or
eliminate extra physical degrees of freedom." The covering-route Lean target is
already named in that memo: `flavourCover_preimage_census` and
`flavourCover_intertwines_walk`.

**The single governing fact about the repository symbol.** The live symbol is
the successive-axis product
`splitStep qx qy qz 0 1 = factor(qx) α1 · factor(qy) α2 · factor(qz) α3` with
`factor(q) g = cos q · I − i sin q · g` (from `Compact3Plus1DiracRate.lean`,
massless slice `m = 0`, `eps = 1`). Because
`factor(q + π) g = −factor(q) g` **[checked]**, a `π`-translation on any one
axis multiplies the whole symbol by the scalar `−1`:

```
splitStep (qx + π) qy qz 0 1 = − splitStep qx qy qz 0 1      -- [checked]
```

So the deck action of the eight-sheeted cover on *this* symbol is a **scalar
sign character**, not a nontrivial internal-register conjugation. This is the
honest pivot of the entire report: the `Z2^3` cover is real and provable, but on
the successive-axis family it degenerates to `±1` copies. Any manuscript
sentence claiming the cover produces genuine internal flavour mixing, or a
unique physical cone, is false for this symbol and must not be written.

---

## 1. Exact finite types

Reference conventions taken from the live modules: `V3 := Fin 3 → Real`
(`LiveWeylJacobian`), `Mat4 := Matrix (Fin 4) (Fin 4) ℂ`
(`Compact3Plus1DiracRate`). The corner sublattice of the massless crossing set
is `{0, π}^3` (from `MasslessBlochCrossingClassification`, the `cos^2 = 1`
branch); the body-centre set `{±π/2}^3` is a *separate* orbit and is discussed
in §4/§8, not folded into the corner cover.

```lean
/-- The eight doubler corners of the full Brillouin zone.  Component `j = 0`
means `q_j = 0`, `j = 1` means `q_j = π`. -/
abbrev PhaseCorner : Type := Fin 3 → ZMod 2      -- Fintype, card 8  [checked]

/-- The `Z2^3` sheet/flavour label. -/
abbrev Flavour : Type := Fin 3 → ZMod 2          -- Fintype, card 8  [checked]

/-- Reduced-zone representative of the corner sublattice.  Folding `{0,π}^3` by
the `π`-translation subgroup leaves a single Γ point, so the corner reduced
zone is a singleton.  (For the full zone one would use the reduced torus
`[0,π)^3`; for the corner census `PUnit` is the exact representative type.) -/
abbrev ReducedRep : Type := PUnit

/-- Real-coordinate realisation of a corner: `cornerAngle c j = π · (c j)`. -/
noncomputable def cornerAngle (c : PhaseCorner) : V3 :=
  fun j => Real.pi * (c j).val

/-- The covering map on the corner sublattice: reduced point × flavour ↦ corner.
On the singleton reduced zone this is `(_, f) ↦ f`. -/
def cover : ReducedRep → Flavour → PhaseCorner := fun _ f => f

/-- The deck-transformation (translation) action of `Z2^3` on corners, by
componentwise addition in `ZMod 2` (i.e. `π`-translation per axis). -/
def deck (g : Flavour) : PhaseCorner → PhaseCorner := fun c => g + c

/-- Real-coordinate translation action used by the intertwiner:
`tau f q j = q j + π · (f j)`. -/
noncomputable def tau (f : Flavour) (q : V3) : V3 :=
  fun j => q j + Real.pi * (f j).val

/-- Parity character of a flavour, valued in `ℤ` (or `ℂ`): the sign the deck
element contributes to the scalar intertwiner. -/
def chi (f : Flavour) : ℤ := (-1) ^ (f 0 + f 1 + f 2).val
```

Cardinalities `Fintype.card PhaseCorner = Fintype.card Flavour = 8` are
`by decide` **[checked]**.

---

## 2. Theorem 1 — corner census (every old alias has one reduced representative
and one flavour label)

The deck action is free and transitive on the eight corners, so the orbit space
is the single reduced point and the flavour label is unique.

```lean
/-- The corner cover is a bijection: every corner has exactly one flavour label
over the single reduced representative. -/
theorem cover_bijective :
    Function.Bijective (cover PUnit.unit) := by decide     -- [checked: id form]

/-- Existence-and-uniqueness form (the `∃!` requested by the contract). -/
theorem corner_unique_rep_and_flavour (c : PhaseCorner) :
    ∃! f : Flavour, cover PUnit.unit f = c

/-- The deck action is free and transitive: for every pair of corners there is a
unique flavour taking one to the other. Equivalent to: `g ↦ g + c` is bijective
for each `c`. -/
theorem deck_regular (c : PhaseCorner) :
    Function.Bijective (deck · c) := by decide             -- [checked]
```

All three are pure finite statements over `(ZMod 2)^3` and close by `decide`
(the `∃!` form via `Fintype`/`deck_regular`). **This is genuinely a census, not
a no-go: it relabels eight corner solutions as one Γ point with eight flavour
tags. It removes nothing physical.**

---

## 3. Theorem 2 — intertwining (pulled-back symbol = enlarged-register block)

The honest content of the intertwiner for the successive-axis symbol: pulling
`splitStep` back along the cover multiplies it by the scalar parity character.
The "enlarged-register block symbol" is therefore the block-diagonal
`⊕_{f} chi(f) · splitStep(q)` — eight signed copies, with **no** off-diagonal
mixing.

```lean
/-- One-axis `π`-shift flips the overall sign (the atom of the intertwiner). -/
theorem splitStep_pi_shift_axis0 (qx qy qz : ℝ) :
    splitStep (qx + Real.pi) qy qz 0 1 = - splitStep qx qy qz 0 1   -- [checked]

/-- Full deck intertwiner: the pulled-back symbol equals the scalar-`chi` block. -/
theorem splitStep_cover_intertwines (q : V3) (f : Flavour) :
    splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1
      = (chi f : ℂ) • splitStep (q 0) (q 1) (q 2) 0 1
```

Proof shape: iterate `splitStep_pi_shift_axis*` over the (at most three) axes
where `f j = 1`; `factor(q+π) g = −factor(q) g` **[checked]** on each active
axis, and matrix-scalar bookkeeping (`Matrix.neg_mul`, `module`) collects the
sign into `chi f`. Needs matrices + real `cos_add_pi`/`sin_add_pi`; no topology.

> Honesty note for the manuscript. In the Bakircioglu–Arnault–Arrighi target
> the intertwiner is a genuine internal-register unitary that reorganises eight
> sheets into one enlarged spinor. For the repository's successive-axis symbol
> the intertwiner collapses to the scalar `chi f ∈ {±1}`. That collapse is the
> proof that this symbol's "flavours" are signed copies, not a physical
> eight-component species. Report it as a *diagnostic*, not a construction.

---

## 4. Theorem 3 — determinant / root-census corollary (stated honestly)

Because the intertwiner is scalar, the alias determinant transforms cleanly, and
even/odd flavours swap the two quasienergies:

```lean
/-- Even-parity flavours preserve the zero/pi determinant; odd-parity flavours
swap them. For a `4×4` symbol, `det((−U) − 1) = det(U + 1)`. -/
theorem cover_det_alias (q : V3) (f : Flavour) :
    (splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1).det
      = (if Even (f 0 + f 1 + f 2).val
          then (splitStep (q 0) (q 1) (q 2) 0 1 - 1).det
          else (splitStep (q 0) (q 1) (q 2) 0 1 + 1).det)
```

**What multiplicity actually remains (say it plainly).** The eight corner
solutions of `det(U∓1)=0` are exactly one reduced-zone crossing at Γ carrying
all eight flavour labels: four even flavours sit at quasienergy `0`, four odd
flavours at quasienergy `π` (matches `MasslessChargeCensusComposition`: four
`c*` corners + four `p*` corners, opposite-charge partners with cancelling
sums). The cover reinterprets `4 + 4` aliases as `4 + 4` flavour tags of one
momentum. **The physical multiplicity is unchanged at eight** (equivalently a
`0/π` Floquet-paired octet). No degree of freedom is deleted; the doubling is
made explicit and chirality-labelled, nothing more. The body-centre orbit
`{±π/2}^3` is *not* covered by this `π`-translation group (a `π`-shift maps
`π/2 ↦ 3π/2`, still a body centre, but the corner reduced point is Γ, not a body
centre); body centres remain a separate eight-node orbit and must be covered, if
at all, by a distinct construction. Do not claim the single corner cover
disposes of them.

---

## 5. Nonidentity witness and wrong-cover negative control

**Nonidentity explicit witness.** `f = ![1,0,0]` (a single-axis `π`-shift,
`chi f = −1`, an odd deck element). It acts nontrivially by swapping the
quasienergy of Γ. This is already witnessed by a landed theorem in
`MasslessBlochCrossingClassification.massless_corner_parity_controls`:
`(splitStep 0 0 0 0 1 − 1).det = 0` while `(splitStep π 0 0 0 1 − 1).det ≠ 0`.
Concretely `splitStep π 0 0 0 1 = − splitStep 0 0 0 0 1 = −I`, so
`det(−I − 1) = 16 ≠ 0` (a `π`-crossing), while Γ is a `0`-crossing — the deck
element genuinely moved the sheet. Package it as:

```lean
theorem deck_nonidentity_witness :
    deck ![1,0,0] ≠ id ∧
    (splitStep (tau ![1,0,0] (fun _ => 0) 0) 0 0 0 1 - 1).det ≠ 0 ∧
    (splitStep 0 0 0 0 1 - 1).det = 0
```

**Wrong-cover negative control (two flavours; use the first, keep the second).**

*(a) Too-coarse cover — finite `decide`.* Replacing `Z2^3` by a single diagonal
`Z2` (one flavour bit shared across all three axes, `g ↦ ![g,g,g]`) fails to
label all eight corners:

```lean
theorem wrongCover_diagonal_not_surjective :
    ¬ Function.Surjective (fun g : ZMod 2 => (fun _ => g : PhaseCorner)) := by
  decide                                                    -- [checked]
```

This is the sharp control: an under-powered cover cannot be a census; only the
full `Z2^3` (card 8) matches the eight corners.

*(b) Wrong-period cover — analytic.* A `π/2`-translation is *not* a deck
transformation of the doubling cover: `factor(q + π/2) g = −sin q · I − i cos q · g`
is not a scalar multiple of `factor(q) g`, so `splitStep(π/2,0,0)` is not
`c · splitStep(0,0,0)` for any scalar `c`, and `π/2` maps the Γ crossing to a
generic non-corner point. State as the failure of the scalar intertwiner:

```lean
theorem wrongCover_halfperiod_not_scalar :
    ¬ ∃ c : ℂ, splitStep (Real.pi/2) 0 0 0 1 = c • splitStep 0 0 0 0 1
```

Use (a) as the primary control (cheap, `decide`); (b) documents that even the
*period* of the cover is load-bearing.

---

## 6. Which statements are finite `decide`, which need matrices, which need
topology

| Statement | Tool | Notes |
|---|---|---|
| `cover_bijective`, `corner_unique_rep_and_flavour`, `deck_regular` | **finite `decide`** | pure `(ZMod 2)^3`; `∃!` via `Fintype`/`deck_regular` |
| `wrongCover_diagonal_not_surjective`, card = 8, `chi` values | **finite `decide`** | [checked] |
| `splitStep_pi_shift_axis0`, `splitStep_cover_intertwines`, `cover_det_alias`, `deck_nonidentity_witness`, `wrongCover_halfperiod_not_scalar` | **matrices + real trig** | `cos_add_pi`/`sin_add_pi`, `Matrix.neg_mul`, `module`, `Matrix.det` on `4×4`; no analysis. Reuse `massless_corner_parity_controls`, `live_massless_det_sub_one_eq_zero_iff`. |
| "these eight are *all* crossings of the reduced zone / Γ is a unique cone / total chiral charge forces the octet" | **topology / analysis — DO NOT claim as covered** | winding/Chern/homotopy; `MEMO_3PLUS1_ATTACK §3` states the full-Dirac null-homotopy is the *topological reading*, not a kernel theorem. Out of scope for tonight. |

The `PositiveWeylBranchCompleteness` and `FiniteNoSignaling` modules confirm the
house style: global trig biconditionals + finite `decide` controls, with an
explicit disclaimer that no Chern/topological theorem is claimed. Match that
discipline exactly.

---

## 7. Two focused Aristotle proof packages that can land tonight

Both are small, self-contained, and reuse landed results. Recommended order:
Package 1 first (pure finite, unblocks the census language), then Package 2
(matrix intertwiner, reuses Package-1 types and the existing corner-parity
theorem).

### Package 1 — `Z2CubedFlavourCorner.lean` (finite census)

```lean
import Mathlib

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

abbrev PhaseCorner : Type := Fin 3 → ZMod 2
abbrev Flavour : Type := Fin 3 → ZMod 2
abbrev ReducedRep : Type := PUnit
def cover : ReducedRep → Flavour → PhaseCorner := fun _ f => f
def deck (g : Flavour) : PhaseCorner → PhaseCorner := fun c => g + c
def chi (f : Flavour) : ℤ := (-1) ^ (f 0 + f 1 + f 2).val

theorem card_corner : Fintype.card PhaseCorner = 8 := by decide
theorem cover_bijective : Function.Bijective (cover PUnit.unit) := by sorry
theorem corner_unique_rep_and_flavour (c : PhaseCorner) :
    ∃! f : Flavour, cover PUnit.unit f = c := by sorry
theorem deck_regular (c : PhaseCorner) : Function.Bijective (deck · c) := by sorry
theorem wrongCover_diagonal_not_surjective :
    ¬ Function.Surjective (fun g : ZMod 2 => (fun _ => g : PhaseCorner)) := by sorry

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner
```

All bodies are `by decide` (the `∃!` via `Fintype.existsUnique_iff` or from
`deck_regular`). Imports: `import Mathlib` only.

### Package 2 — `Z2CubedFlavourIntertwine.lean` (scalar intertwiner + honest census)

```lean
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
import PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine

open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

noncomputable def tau (f : Flavour) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  fun j => q j + Real.pi * (f j).val

theorem factor_pi_shift (q : ℝ) (g : Mat4) :
    factor (q + Real.pi) g = - factor q g := by sorry            -- [checked]
theorem splitStep_pi_shift_axis0 (qx qy qz : ℝ) :
    splitStep (qx + Real.pi) qy qz 0 1 = - splitStep qx qy qz 0 1 := by sorry  -- [checked]
theorem splitStep_cover_intertwines (q : Fin 3 → ℝ) (f : Flavour) :
    splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1
      = (chi f : ℂ) • splitStep (q 0) (q 1) (q 2) 0 1 := by sorry
theorem cover_det_alias (q : Fin 3 → ℝ) (f : Flavour) :
    (splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1).det
      = (if Even (f 0 + f 1 + f 2).val
          then (splitStep (q 0) (q 1) (q 2) 0 1 - 1).det
          else (splitStep (q 0) (q 1) (q 2) 0 1 + 1).det) := by sorry
theorem deck_nonidentity_witness :
    (splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 ∧
    (splitStep 0 0 0 0 1 - 1).det = 0 := by sorry               -- reuse massless_corner_parity_controls
theorem wrongCover_halfperiod_not_scalar :
    ¬ ∃ c : ℂ, splitStep (Real.pi/2) 0 0 0 1 = c • splitStep 0 0 0 0 1 := by sorry

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine
```

`factor_pi_shift` and `splitStep_pi_shift_axis0` are **[checked]**
(`Real.cos_add_pi`, `Real.sin_add_pi`, `push_cast`, `module`, `Matrix.neg_mul`);
the rest follow by iterating the axis lemma and matrix determinant bookkeeping,
with `deck_nonidentity_witness` discharged from the landed
`massless_corner_parity_controls`. No topology or analysis is required.

Both packages together give: exact types (§1), the `∃!` census (§2), the
intertwining theorem (§3), the honest determinant corollary (§4), a nonidentity
witness and a wrong-cover control (§5) — the full contract deliverable list,
landable tonight, with an explicit non-topological scope.

---

## 8. Audit — does an eight-flavour register help or hurt the paper's claim to
*derive* observed particle multiplicities?

**Verdict: for the repository's successive-axis symbol it hurts that claim, and
must not be presented as a derivation of physical multiplicity.**

Reasons, from strongest to weakest:

1. **The deck action is a scalar `±1`, so the register carries no dynamics.**
   `splitStep_cover_intertwines` shows the eight sheets differ only by the parity
   sign `chi f`. There is no off-diagonal mixing between flavours, no
   flavour-dependent dispersion, and hence no mechanism that could *select* a
   subset of flavours or *predict* a family count. Eight signed copies of one
   cone is exactly "multiplicity relabelled as flavour," precisely the caveat in
   `DIRECT_LIT_MINIMAL_DOUBLING_RECIPROCAL_2026-07-11.md`.

2. **It does not reduce physical degrees of freedom (§4).** The `4 + 4`
   quasienergy octet survives; the cover only tags it. A claim to "derive
   observed particle multiplicities" would require *removing* or *dynamically
   distinguishing* copies, which the free cover cannot do. The route that could
   remove them is the interacting Route C in `MEMO_3PLUS1_ATTACK §5b`
   (Wilson/SMG-style gapping), which is separate, open, and adversarially
   constrained (Golterman–Shamir), not delivered by any covering theorem.

3. **The observed count is not eight (or four).** Neither the raw octet nor the
   even/odd `4 + 4` split matches three fermion generations or the Standard
   Model species count. The register produces a number fixed by lattice
   combinatorics (`2^3`), not by any input reproducing experiment. Selling
   `2^3` as a derived multiplicity is numerology.

4. **What the register legitimately buys.** It is honest, useful *bookkeeping*:
   it makes doubling explicit, tracks chirality per sheet (the even/odd split
   aligns with the opposite-charge partners already proved in
   `MasslessChargeCensusComposition`), and preserves linearity and the chiral
   labelling while changing only the translation representation. That is the
   correct, defensible claim: **an exact flavour-labelling / census of the
   doublers, with an explicit `0↔π` Floquet pairing** — not a unique-cone
   theorem and not a derivation of physical family number.

**Manuscript-safe sentence.** "The eight-sheeted `Z2^3` cover exactly relabels
the corner doublers of the successive-axis symbol as a flavour octet with an
explicit even/odd quasienergy pairing; on this symbol the deck action reduces to
a scalar parity sign, so the construction is a faithful bookkeeping of
multiplicity, not a single-species unique-cone theorem and not a derivation of
observed particle multiplicities." Anything stronger is unsupported by the
kernel and contradicted by the scalar-intertwiner diagnostic.
