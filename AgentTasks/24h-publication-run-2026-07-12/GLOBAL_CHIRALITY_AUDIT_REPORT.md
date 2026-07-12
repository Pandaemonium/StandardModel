# Global chirality boundary — hostile semantic & algebra audit

Target: `FullBlochGlobalChirality.lean`
Supporting live sources read: `FullBlochSplitDeterminants.lean`,
`CubicWeylSectorCharge.lean`, `MEMO_3PLUS1_ATTACK.md` (§A1/§A2),
`Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
(chirality-gate paragraph, lines ≈1420–1466; abstract; no-go/QCA paragraphs).

Scope: attack the exact statement

```
splitStep_commutes_iff_sin_theta_zero :
  (Xi * splitStep qx qy qz theta = splitStep qx qy qz theta * Xi) ↔ Real.sin theta = 0
```

on multiplication order, signs, the determinant-one core, singular exceptions,
and θ-periodicity; check that the prose claims only "massless is globally split,
genuine mass angles mix sectors" and never "massful is alias-free / solves the
QCA problem". **No Lean was edited.**

## Bottom line

The central iff is **mathematically correct and unusually robust**. The forward
direction has **no singular momentum exceptions** because the spatial core is
determinant-one at *every* momentum, not merely generically. The commutator
sign, factor order, and anticommutation are all correct. The surrounding prose
(memo §A2 and manuscript) is **properly hedged**: it claims global splitting
only at `sin θ = 0`, sector mixing otherwise, and explicitly disclaims the
global charge-sum theorem, alias freedom, and a solved QCA problem. Findings
below are dominated by a packaging/build defect and a few small provable gaps
between the memo's descriptive language ("Hermitian involution", "globally
split") and what the target file literally proves.

---

## Verification of the attack surface (all pass)

**Multiplication order.** `splitStep = factor qx α₁ * factor qy α₂ * factor qz α₃
* factor θ β` (spatial word, then mass). `Xi` commutes with every spatial factor
(`Xi_commutes_alpha1/2/3` composed through `Xi_commutes_spatial_factor`), so the
entire commutator is carried by the mass factor alone. The result is therefore
**independent of the order of the three spatial factors** — reordering α₁,α₂,α₃
changes neither side of the iff. Commutator is written `Xi·U − U·Xi`; the
manuscript writes `[U,Xi]`, the negative — equivalent as a vanishing condition.

**Signs.** `commutator_eq` gives
`Xi·U − U·Xi = (−2 i sin θ) • (factor qx α₁ · factor qy α₂ · factor qz α₃ · (Xi·β))`.
Derivation checks: `factor θ β = cos θ·1 − (i sin θ)·β`; the identity part cancels;
`Xi·β − β·Xi = 2·(Xi·β)` from `Xi·β + β·Xi = 0` (`Xi_anticommutes_beta`), giving
scalar `−2 i sin θ`. The scalar sign is immaterial to the iff (only its vanishing
matters), so the result is sign-robust.

**Determinant-one core / singular exceptions.** `M_det` proves
`det(factor qx α₁ · factor qy α₂ · factor qz α₃ · (Xi·β)) = 1` for **all** momenta,
via `det(factor q αⱼ) = 1` (each is `cos²+sin² = 1` on two antidiagonal 2×2
blocks), `det Xi = 1` (the permutation `(0 2)(1 3)` is even), `det β = 1`
(diag(1,1,−1,−1)). Hence the core is invertible at *every* `(qx,qy,qz)` — there is
**no singular momentum** at which a nonzero `sin θ` could give a vanishing
commutator. The forward implication is exception-free. Independently reconfirmed
here: `−i·(α₁α₂α₃) = xiExplicit` and `Xi·β + β·Xi = 0` for the `FullBloch`
generators, and the two determinants equal 1.

**θ-periodicity.** `sin θ = 0 ⇔ θ ∈ πℤ`, so the commuting locus is the full
lattice `πℤ`, not `{0}`. This is faithfully captured (the goal is the real
equation `Real.sin theta = 0`; `quarter_mass_breaks_global_chirality` uses
`Real.sin_pi_div_two`). At `θ = π`, `factor π β = −1`, so `U = −(spatial word)`;
`Xi` commutes with it — correctly inside the locus.

**Reverse direction.** `smul_eq_zero` over the ℂ-module `Mat4` splits into
"scalar = 0" or "core = 0"; the core is ruled out by `det = 1 ≠ 0`; the scalar
`−2 i sin θ = 0` forces `sin θ = 0` since `I ≠ 0`. Correct and clean.

**Genuineness.** The `exfalso`/contradiction step in the reverse direction is a
legitimate `det ≠ 0 ⇒ M ≠ 0` argument, not a vacuous-hypothesis exploit. The
quarter-turn witness is a genuine nonzero control (`sin(π/2)=1`).

---

## Findings, severity-ranked

### F1 — MEDIUM (reproducibility / packaging, not mathematics)
The provided subset does **not** compile standalone. Two independent causes:

1. **Missing dependency modules.** `FullBlochGlobalChirality.lean` imports
   `PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants` and
   `…CubicWeylSectorCharge`; `CubicWeylSectorCharge.lean` imports
   `…Clifford3Plus1WalkSymbol` and `…SU2LocalCrossingCharge`;
   `FullBlochSplitDeterminants.lean` imports `…Compact3Plus1DiracRate`. None of
   `Clifford3Plus1WalkSymbol`, `SU2LocalCrossingCharge`, `Compact3Plus1DiracRate`
   are present in this project.
2. **Module-name mismatch.** `lakefile.toml` declares libraries/targets as bare
   names (`FullBlochGlobalChirality`, …), while the files live under and import
   the namespace path `PhysicsSM.Draft.NullEdge.*`. There is no `PhysicsSM/`
   directory.

Consequence: a hostile reviewer cannot reproduce the kernel check from this
folder alone; the `#print axioms` guards in `FullBlochSplitDeterminants.lean`
cannot fire here. This is an artifact-packaging defect, **not** a soundness
defect in the proofs themselves. Recommendation: ship the transitive
dependency files (`Clifford3Plus1WalkSymbol`, `SU2LocalCrossingCharge`,
`Compact3Plus1DiracRate`, plus `Compact3Plus1DiracRate`'s own imports) and align
`lakefile.toml` `globs`/module roots with the `PhysicsSM.Draft.NullEdge` path, or
state in the manuscript that these three files are excerpts of a larger verified
tree pinned at the cited Aristotle project/task IDs.

### F2 — LOW (memo language ahead of the proof: Hermiticity)
Memo §A2 and the manuscript describe `Xi` as a **"constant Hermitian
involution"** and speak of "Weyl-sector split". The target file proves the
*involution* half (`Xi_sq : Xi*Xi = 1`) but **does not prove Hermiticity**
(`Xiᴴ = Xi`). It is true — `xiExplicit` is a real symmetric permutation matrix —
but it is currently only asserted in prose. Until it is a lemma, "Hermitian
involution" is a claim, not a kernel fact, and the orthogonality of the two
`±1` sectors (needed for the sector language) is not established here.

### F3 — LOW (memo language ahead of the proof: "globally split" as invariance)
`[Xi,U]=0` together with `Xi²=1` *implies* block-diagonality of `U` in the
`Xi`-eigenbasis, i.e. `U` preserves each Weyl sector — but the file stops at the
commutator statement. The phrase "globally Weyl-sector split" (memo §A2;
manuscript line ≈1438) denotes the invariance/block-diagonal corollary, which is
**not** stated. This is the natural smallest successor (see below).

### F4 — INFORMATIONAL (cross-module convention: "mass" = sin θ vs internal `m = cos θ`)
In the chirality file the mass coin is `factor θ β = cos θ·1 − i sin θ·β`, so the
β ("mass") weight is `sin θ` and "massless" = `sin θ = 0` is the correct reading.
But `FullBlochSplitDeterminants.spectralBase` internally names `let m := Real.cos
theta`. These are **different quantities** (the coin's cosine vs. its β-weight;
cf. manuscript's `cos Ω = cos q cos θ`), so there is no contradiction — but the
coincidental reuse of the word/letter "m"/"mass angle" across modules invites
misreading. Worth one clarifying sentence; not an error.

### F5 — INFORMATIONAL (provenance of `Xi = −i α₁α₂α₃` across the two α-conventions)
The docstring calls `Xi` "the same constant chirality that splits the local cubic
tangent". `Xi` is *defined* as `CubicWeylSectorCharge.Xi = −i·(α₁α₂α₃)` using the
**`Clifford3Plus1WalkSymbol` α's**, and its explicit permutation form is proven
there; the target then reuses that explicit matrix against the **`FullBloch` α's**
in `Xi_commutes_alpha1/2/3`. The identity `−i·(α₁α₂α₃) = xiExplicit` was
reconfirmed here to also hold for the `FullBloch` α's, so the "same chirality"
narrative is in fact exact — but that reconciling identity is **not re-derived in
the target file**; it is inherited by matrix equality. If the two α-triples ever
diverge, the narrative would silently weaken. Consider an explicit
`Xi = (-I) • (alpha1*alpha2*alpha3)` lemma stated with the `FullBloch`
generators.

---

## Semantic verdict on over-claim risk (clean)

The prose does **not** claim the massive/massful case is alias-free or that it
solves the QCA problem. Evidence, verbatim intent:

- Chirality paragraph (≈1440–1442): "…globally Weyl-sector split, while every
  genuine mass angle mixes the sectors… It determines precisely when the
  sectorwise no-go can be invoked, **but it does not supply the missing global
  charge-sum theorem.**"
- `FullBlochSplitDeterminants.lean` header: "an all-momentum criterion, **not a
  claim that the regulator is alias-free.**"
- `CubicWeylSectorCharge.lean` header: "a local tangent statement only, **not
  global chirality of a full Bloch symbol or a Brillouin-zone charge sum.**"
- Memo §A1/§A2: "Global chirality of a full Bloch walk and a zone charge sum
  remain open"; "does not supply that global splitting."
- Abstract (≈149): "A strict alias-free discrete-time 3+1 regulator … remain
  open."
- Wilson paragraph (≈1490): "It does **not** yet close the stricter QCA problem."

All consistent with the proven content. No corrective edit to the claims is
required; only F2–F5 tightening is advisable.

---

## Exact safe wording (drop-in)

Use only statements backed by the current kernel content:

> For the ordered live 3+1 split step
> `U(q,θ) = factor(qx,α₁)·factor(qy,α₂)·factor(qz,α₃)·factor(θ,β)`
> and the constant chirality `Ξ = −i α₁α₂α₃` (the explicit permutation swapping
> the two Weyl pairs), the commutator is exactly
> `ΞU − UΞ = (−2i sin θ)·(factor(qx,α₁)·factor(qy,α₂)·factor(qz,α₃)·Ξβ)`,
> whose matrix factor is determinant-one at every momentum. Hence
> `[Ξ, U(q,θ)] = 0 ⇔ sin θ = 0`, with **no** momentum exception. Equivalently,
> `Ξ` commutes with the complete step exactly on the massless lattice `θ ∈ πℤ`,
> and at every genuine mass angle (`sin θ ≠ 0`) the step fails to commute with
> `Ξ`; an exact quarter-turn (`θ = π/2`) witnesses the failure.

Then state the scope in the same breath (all currently supported):

> This is the global-chirality **gate**: it fixes exactly when a sectorwise
> argument is available. It does **not** by itself give sector invariance as a
> block decomposition (that follows once `Ξ` is recorded as a Hermitian
> involution), a Brillouin-zone charge-sum theorem, doubler or alias removal, or
> a massive QCA. Those remain open.

Avoid, unless the corresponding lemma is added: "Ξ is a Hermitian involution"
(needs F2), "U is block-diagonal / preserves each Weyl sector" (needs F3),
"massless walk is globally split" used as invariance rather than as `[Ξ,U]=0`
(needs F3). Never write "massive/genuine-mass step is alias-free" or "the QCA
problem is solved".

---

## Smallest missing successor

The minimal, immediately provable lemma that closes the gap between "[Ξ,U]=0"
and the memo/manuscript phrase "globally Weyl-sector split" is a **Hermiticity +
sector-invariance pair**, in this order (F2 then F3):

1. `Xi_isHermitian : Xiᴴ = Xi` — the smallest single missing fact. `xiExplicit`
   is a real symmetric permutation matrix; provable by
   `rw [Xi_eq_explicit]; simp only [xiExplicit]; ext i j; fin_cases i <;>
   fin_cases j <;> simp [Matrix.conjTranspose_apply]`. This upgrades `Ξ` from a
   bare involution (`Xi_sq`) to the "Hermitian involution / Z₂ grading" the memo
   already names, and makes the two `±1` sectors orthogonal.

2. `massless_splitStep_preserves_sector` — with the projector
   `P₊ = (1 + Xi)/2`, prove `P₊ * splitStep qx qy qz 0 = splitStep qx qy qz 0 *
   P₊` (immediate from `massless_splitStep_commutes`), i.e. the massless step
   maps the `Ξ = +1` Weyl sector to itself. This is the exact content of
   "globally Weyl-sector split" and follows in a few lines from the already-proven
   commutation, needing no new algebra beyond F1's dependency modules being
   present.

Lemma (1) is the strictly smallest missing successor: one short finite-matrix
proof, no new imports, and it is the precise fact the prose currently assumes.
