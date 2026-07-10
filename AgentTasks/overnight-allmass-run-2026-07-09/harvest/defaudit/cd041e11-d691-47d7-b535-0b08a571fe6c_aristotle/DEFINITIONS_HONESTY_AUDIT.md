# Definitions Honesty Audit — do the model DEFINITIONS encode the physics, or beg the question?

**Scope.** Prior audits checked prose and theorem *statements*. This one checks the five model
*definitions*: for each, is the specific form (a factor, a sign, an entry) the honest encoding of the
intended physics object, or is it chosen so the headline is true by construction — such that a
different, equally-defensible definition would flip it?

**Method.** For each definition I (a) reconstruct what the physics *forces*, (b) name the ONE alternative
definition that would break the headline and judge whether it is more/less defensible, and (c) decide
whether the content lives in the definition (question-begging) or in the proof. The load-bearing
arithmetic for the contested cases (2, 3, 4) was checked in Lean (`Matrix.det_fin_three`, trace of
`Mᵀ M`, and the four chiral gap entries) — all confirmed.

---

## (1) Lambda exponent — `lamExp α := α/2 − 1`

**Verdict:** FAITHFUL (but tautological) · content-in-DEFINITION.

`Λ_rms = √(Var N)/N`. With `Var N = N^α` (this is the *definition* of α as the count-**variance**
exponent), `√(Var N) = N^{α/2}` and `/N` subtracts 1, giving `N^{α/2−1}`. The `/2` (from the square
root) and the `−1` (from `/N`) are both **forced** once you accept the two upstream inputs
`Λ_rms = √(Var N)/N` and `Var N = N^α`. Sanity check: Poisson (α = 1) → `lamExp = −1/2`, i.e. the
textbook `1/√N` shot-noise scaling. The theorem `lamExp α = α/2 − 1` is a verbatim restatement of the
`def`, so it is a tautology — but a *harmless* one: nothing is smuggled in, the algebra is the only
defensible algebra. **Breaking alternative:** redefine α as the **standard-deviation** exponent
(`std ∼ N^α`), giving `lamExp = α − 1` (no `/2`). Less defensible: it contradicts the stated
"count-variance exponent" label. The real physics content (that this exponent *is* the `Λ_rms` scaling)
sits upstream of this definition and is not what the theorem certifies.

## (2) Budget vs det — `budget a b x := a²+b²+2x²`, `detP a b x := a·b − x²`

**Verdict:** FAITHFUL · content-in-PROOF.

For symmetric `M = [[a,x],[x,b]]`, `‖M‖_F² = tr(Mᵀ M) = a²+b²+2x²` (verified) — the `2` is *forced* by
the matrix having **two** off-diagonal `x` entries; it is the honest Frobenius / `tr(D#D)` value, not a
sharpening knob. `detP = ab − x²` is the honest Gram determinant. Decisive test of honesty: the
sign-mismatch headline (`x` raises the budget, lowers the det) survives **any** positive coefficient on
`x²` — replace `2` by `1` and it still holds (`+x²` vs `−x²`). So the `2` does **not** carry the
headline; the mismatch is the structural fact that off-diagonal correlation increases Frobenius mass but
decreases determinant. **Breaking alternative:** flip a sign to `detP = ab + x²` or drop the off-diagonal
in `budget` — both are indefensible (wrong determinant / not the Frobenius norm). The mismatch is real.

## (3) Pairwise mass vs Gram det — `massPair a b c := 2(a+b+c)`, `detG := det!![0,a,b;a,0,c;b,c,0] (=2abc)`

**Verdict:** massPair FAITHFUL & forced; detG a semi-STRAW comparator · content-in-DEFINITION.

With three **null** edges (`p_i·p_i = 0`) and `a,b,c = p_i·p_j`, the true invariant mass is
`m² = (Σp_i)² = Σ p_i·p_i + 2Σ_{i<j} p_i·p_j = 0 + 2(a+b+c)`. So `massPair = 2(a+b+c)` is **forced** by
the physics — this side is genuinely faithful. `detG = 2abc` (verified) is a real object (the zero-diag
Gram determinant, which detects linear dependence / rank), but **nobody computes rest mass as a 3×3 Gram
determinant** — its identification with "mass" is the questionable framing. The theorem `massPair ≠ detG`
(linear `2(a+b+c)` vs cubic `2abc`) is then trivially true, and its *content* is entirely the choice of
what to call "mass". Because `2(a+b+c)` is forced, the mass claim is honest, but the *contrast* with detG
is rhetorical: it refutes a conflation only if someone actually proposed detG-as-mass. **Breaking
alternative:** there is none for the mass itself (it is forced); the "result" is fragile only in that
detG is a comparator chosen to lose.

## (4) Chiral protection — `Γ=diag(1,−1)`, `A=[[0,1],[0,0]]`, `v=[1,0]`, `Podd s=[[0,s],[0,0]]`, `Peven m=diag(m,−m)`, `Hmass m=(A+Peven m)ᴴ(A+Peven m)`

**Verdict:** RIGGED · content-in-DEFINITION. **This is the smoking gun.**

Label checks pass: `A` is odd (`ΓA=−AΓ`), `Podd=sA` is odd, `Peven=mΓ` is even (`ΓPeven=PevenΓ`),
`v` is a `+`-chirality zero mode of `A` (`Av=0`, `Γv=v`). `A` being rank-1/nilpotent is *not* the rig —
a chiral zero mode in 2D **requires** a rank-deficient off-diagonal, so `A` is a fair "odd operator with
a zero mode". The rig is in the **perturbation representatives**. The gap of `v` is `|Mv|² = |Pv|²`
(since `Av=0`), and for these matrices `[MᵀM]₀₀` is (all verified in Lean):

| perturbation `P` | parity | `[MᵀM]₀₀` (gap of v) |
|---|---|---|
| `Peven = diag(m,−m)` (chosen "even mass") | even | `m²`  → **gapped** |
| `diag(0,m)` (equally even) | even | `0`  → **NOT gapped** |
| `Podd = [[0,s],[0,0]]` (chosen "odd") | odd | `0`  → **protected** |
| `[[0,p],[q,0]]`, `q≠0` (generic odd = physical Dirac mass `[[0,m],[m,0]]`) | odd | `q²` → **GAPPED** |

So **neither parity determines gapping**: gapping depends only on whether `P` has support on `v`'s
chirality slot (even: the `(0,0)` entry `a`; odd: the `(1,0)` entry `q`). The headline "odd protects, even
gaps" is manufactured by picking the even representative with `a=m≠0` and the odd representative with
`q=0` (`Podd` is upper-triangular — the *same* block shape as `A`, which is exactly why it annihilates
`v`). **Breaking alternatives, both more defensible than the chosen ones:** (i) the genuine symmetric
Dirac mass `[[0,m],[m,0]]` is odd yet gaps `v` by `m²` — killing "odd = protected"; (ii) the even term
`diag(0,m)` does not gap `v` — killing "even = gaps". The only true statement lurking here is "adding
more of `A`'s own shape can't gap `A`'s kernel", which is trivial and has nothing to do with the Γ-grading.
The entire chiral-protection headline is a definitional artifact.

## (5) Null edge + quadratic space — `edge v := v vᵀ` (rank-1), `Qform` = 6-coeff quadratic in the 3 entries of symmetric P

**Verdict:** FAITHFUL · content-in-PROOF. **The cleanest of the five.**

`edge v = v vᵀ` is exactly the set of rank-1 PSD symmetric `2×2` matrices — every null edge, none
excluded. The 3 independent entries `(P₀₀,P₀₁,P₁₁)` give exactly 6 quadratic monomials, so the
6-coefficient `Qform` genuinely spans **all** quadratic forms on `Sym(2×2)` — no rigged subspace. The
uniqueness (`det` is the unique-up-to-scale quadratic vanishing on all null edges) is a real
`6-dim → 1-dim` fact: rank-1 sym matrices satisfy `P₀₀P₁₁ − P₀₁² = 0`, that quadric is irreducible, and a
degree-2 form vanishing on an irreducible degree-2 hypersurface must be a scalar multiple of it. **Breaking
alternative:** restrict `Qform` to a proper subspace of the 6 monomials — but that would be an obviously
rigged domain, and the definition does not do this. Content is in the proof, not the definition.

---

## TOP 2 definitions most at risk of question-begging

1. **(4) Chiral protection — RIGGED (highest risk).** The Γ-grading is a decoration; gapping is governed
   by whether the perturbation touches the zero mode's chirality slot, not by parity. Both halves of the
   headline are flipped by equally- or more-defensible representatives (generic odd operator / physical
   Dirac mass gaps; the even `diag(0,m)` does not). The physics lives entirely in the un-argued choice of
   `Podd` (upper-triangular, `q=0`) and `Peven` (`a=m≠0`). This is a tautology dressed as chiral
   protection.

2. **(1) Lambda exponent — tautological (but honest).** The theorem is a verbatim restatement of the
   `def` (`content = 100%` in the definition), so as a standalone proposition it certifies nothing beyond
   the definition. It ranks second only because, unlike (4), the definitional choice is *forced* honest
   algebra with no hidden rigging. *Runner-up:* **(3)**, where the mass side is forced/faithful but `detG`
   is a comparator chosen to lose, so the "mass ≠ Gram-det" result is content-in-definition and refutes
   only a conflation nobody need have made.

**Faithful and safe:** (2) budget/det (headline survives any positive coefficient) and (5)
det-uniqueness (genuine 6→1 dimensional uniqueness over the full quadratic space).
