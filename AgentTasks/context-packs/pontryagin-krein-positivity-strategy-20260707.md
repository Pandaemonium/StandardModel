# Strategy audit: finite Pontryagin route for Krein positivity

Date: 2026-07-07
Scope: strategy / adversarial audit only (no proof integration).
Conventions taken from `PhysicsSM/Draft/NullEdgeSuperDiracKreinCore.lean` and
`docs/NULLSTRAND.md`. All Lean fragments below were checked against the pinned
Mathlib in this repo; the counterexample in §1 is machine-verified.

Notation used throughout (matching the repo):
`J = J^† = J^{-1}` (so `J^2 = I`, `J` Hermitian, nondegenerate), Krein form
`[u,v]_J = u^† J v`, `A^# = J A^† J`. "J-self-adjoint" means `A^# = A`, which the
repo encodes equivalently as `IsKreinSelfAdjoint J A : J * A = Aᴴ * J`.

---

## 1. Mathematical truth audit of the Fable claim

**Fable claim (paraphrased).** In finite dimension, treat the carrier as a
Pontryagin space; a Pontryagin/Krein–Langer theorem guarantees an *invariant
maximal nonnegative subspace* for a `J`-self-adjoint operator.

**Verdict: TRUE as a classical existence theorem, but only in its weak
(nonnegative, possibly degenerate) form — and that weak form does not deliver
the physical positivity the program actually wants.** Three separate things must
be kept apart, and Fable's one sentence silently merges them.

### 1a. The classical theorem does hold — with these hypotheses made explicit

The finite-dimensional Pontryagin theorem states: on a Krein space with
fundamental symmetry `J` (`J = J^† = J^{-1}`), signature `(p,q)`, a
`J`-self-adjoint operator `A` admits an `A`-invariant subspace `L` that is
*maximal nonnegative*, i.e. `[x,x]_J ≥ 0` for all `x ∈ L` and `dim L = p`.
(Dually, a maximal nonpositive invariant subspace of dimension `q` exists.)

Hidden hypotheses the sentence omits, all of which the repo actually satisfies:

- **`J` nondegenerate.** Required for "Krein/Pontryagin space" to mean anything.
  Supplied here by `J = J^{-1}` (invertible ⇒ nondegenerate). If a future model
  ever lets `J` acquire a kernel (e.g. a degenerate soldering), the theorem is
  false as stated and one is in a *Krein–space-with-degeneracy* / almost-Pontryagin
  setting where invariant maximal nonnegative subspaces can fail to exist.
- **Complex scalars.** The proof needs an eigenvalue to exist, i.e. algebraic
  closure. The repo is over `ℂ` (`Matrix Idx Idx Complex`), so this is fine.
  Over `ℝ` the statement needs extra care (real Jordan structure) and should not
  be assumed.
- **Finite negative index.** Automatic in finite dimension (both indices finite),
  so the "Pontryagin" qualifier is free here; the object is really a finite Krein
  space.

Under exactly these three, the existence theorem is a genuine classical result
(Pontryagin 1944; finite-dim it is pure linear algebra over `ℂ`).

### 1b. "Nonnegative" ≠ "positive-definite": the physics gap is real, not rhetorical

This is the load-bearing subtlety and the one Fable's phrasing hides. A *maximal
nonnegative* invariant subspace may be **degenerate**: it can contain nonzero
null vectors (`[x,x]_J = 0`). Such an `L` is *not* a pre-Hilbert sector — the
restricted form is only positive *semi*-definite, so there is no inner product,
no unitary dynamics, no Hilbert completion. The guardrail in
`docs/NULLSTRAND.md` ("Krein self-adjointness does not by itself imply
positivity, real spectrum, stability, or a physical Hilbert sector") is exactly
this gap, and it survives the Pontryagin theorem intact.

Getting a genuine positive-*definite* (uniformly positive) invariant subspace
requires strictly more than `J`-self-adjointness — e.g. `A` **definitizable**
with the neutral part of its real spectrum semisimple, or `A` having a
`J`-orthonormal eigenbasis (the "regular"/diagonalizable case). These extra
hypotheses are precisely what a physical Hilbert sector needs, and the general
theorem does not provide them.

### 1c. Machine-verified counterexample to the *strong* reading

The following 2-dimensional example (verified in Lean against this repo's
Mathlib; entries integral so `star = id`, `ᴴ = transpose`) shows the strong
reading — "a positive-definite invariant sector exists" — is **false** for a
generic `J`-self-adjoint operator.

```
J = [[0,1],[1,0]]      A = [[1,1],[0,1]]      e1 = (1,0)ᵀ
```

Verified facts:

- `J = Jᴴ` and `J*J = 1`  → legitimate fundamental symmetry, signature `(1,1)`.
- `J * Aᴴ * J = A`        → `A` is `J`-self-adjoint (`A^# = A`).
- `A * e1 = e1`           → `A` has the single eigenvalue `1` (a Jordan block),
                            unique eigendirection `span(e1)`.
- `e1ᴴ * J * e1 = 0`      → that eigendirection is **null** (`[e1,e1]_J = 0`).

The unique 1-dimensional (`= p`) invariant maximal nonnegative subspace is
`span(e1)`, which is *neutral/degenerate*. So the Pontryagin theorem's conclusion
holds (a nonnegative invariant subspace exists), **but there is no invariant
positive-definite subspace at all** — the only invariant line is null. This is a
Jordan block sitting on a null vector: the canonical shape of the obstruction.
Any claim of a "positive sector" must therefore be read in the weak
(`≥ 0`, possibly degenerate) sense unless a definitizability hypothesis is added.

**Summary of §1.** Fable is right that an invariant maximal *nonnegative*
subspace exists (given nondegenerate `J`, `ℂ`, finite dim). Fable is wrong, or
at best dangerously imprecise, if "positive sector" is read as
positive-definite / Hilbert: the smallest missing hypothesis for that stronger
statement is roughly *"`A` is definitizable / has a `J`-orthonormal eigenbasis"*,
and the counterexample above is the shape that breaks it.

---

## 2. Sharpest first formal theorem worth proving in Lean

Do **not** open with the full unconditional Pontryagin existence theorem (see §5
for why). Open with the honest *conditional* positive-sector theorem, whose
hypothesis is exactly the gap identified in §1b, plus a small structural layer
that is cheap and immediately reusable. Prefer `Matrix (Fin n) (Fin n) ℂ` (or a
finite-dim `LinearMap`) with explicit `J`.

Recommended headline statement (finite matrices, explicit `J`):

```lean
open Matrix
-- carrier: V = (Fin n → ℂ),  form [u,v]_J = uᴴ J v,  A^# = J Aᴴ J.
-- Hypotheses that are actually needed (the honest ones):
--   hJherm : J = Jᴴ
--   hJinv  : J * J = 1              -- fundamental symmetry, nondegenerate
--   hA     : J * A = Aᴴ * J         -- A is J-self-adjoint (A^# = A)
--   hdef   : ∃ (P : Matrix (Fin n) (Fin n) ℂ),   -- J-orthogonal spectral
--              <A is J-unitarily diagonalizable with real spectrum>
-- Conclusion: there is an A-invariant subspace on which [x,x]_J > 0 for x ≠ 0,
--             of dimension = positive index p of J.
```

The point of stating it this way is that the theorem is **true**, its hypothesis
`hdef` is exactly the physical assumption that must be paid for, and dropping
`hdef` is provably impossible (the §1c counterexample is the witness). This keeps
the statement faithful and non-vacuous while separating "a positive sector
exists" from "the sector is natural/physical" (§4).

A slightly weaker but *unconditional* companion theorem that is also worth
locking (and much cheaper): the maximal nonnegative subspace of the **form
alone** — the `+1`-eigenspace of `J` — has dimension `p` and is nonnegative. This
is not about `A`, but it pins the signature and the target dimension `p` that the
conditional theorem must hit.

---

## 3. Decomposition into 3–5 Lean lemmas / proof jobs

Names are namespaced under the existing
`PhysicsSM.Draft.NullEdgeSuperDiracKreinCore` (reuse `IsKreinSelfAdjoint`; do not
redefine it). "ML-adjacent" = generic linear algebra that could even be upstreamed;
"project" = uses the repo's Krein API.

1. **`sharp_involutive` / `sharp_antihom`** (ML-adjacent, trivial, cheap).
   With `J = Jᴴ`, `J*J = 1`: `(A^#)^# = A`, `(A*B)^# = B^# * A^#`,
   `(A + B)^# = A^# + B^#`, `(1)^# = 1`. APIs: `Matrix.conjTranspose_mul`,
   `conjTranspose_conjTranspose`, `Matrix.mul_assoc`, rewrite with `hJinv`.
   *Purpose:* makes `#` a usable involutive anti-automorphism; needed everywhere.

2. **`isKreinSelfAdjoint_iff_form`** (project, easy).
   `A^# = A ↔ ∀ x y, [A x, y]_J = [x, A y]_J`, i.e.
   `(A ·)ᴴ J · = ·ᴴ J (A ·)`. APIs: `Matrix.mulVec`, `Matrix.dotProduct`,
   `star`/`conjTranspose` lemmas. *Purpose:* the semantic meaning of the
   predicate; downstream orthogonality proofs use this form, not the matrix
   identity.

3. **`krein_orthocomplement_invariant`** (project / ML-adjacent, moderate).
   If `A^# = A` and `W` is `A`-invariant, then the `J`-orthogonal complement
   `W^{[⊥]} = {y | ∀ x ∈ W, [x,y]_J = 0}` is `A`-invariant. APIs:
   `Submodule`, `Module.End.invtSubmodule`, `LinearMap.iInf_invariant`
   (found in Mathlib), plus lemma 2. *Purpose:* the structural engine behind any
   invariant-subspace induction, and the honest replacement for "just diagonalize".

4. **`krein_eigenspaces_Jorthogonal`** (project, moderate).
   For `A^# = A`, eigenvectors with eigenvalues `λ, μ` and `λ ≠ conj μ` are
   `J`-orthogonal; in particular distinct **real** eigenvalues give `J`-orthogonal
   eigenspaces. This is the indefinite analogue of Mathlib's
   `LinearMap.IsSymmetric.orthogonalFamily_eigenspaces'` (which is inner-product
   specific and does **not** apply to an indefinite `J`, so it must be reproved).
   APIs: `Module.End.eigenspace`, plus lemma 2. *Purpose:* builds the block
   decomposition used by the conditional positive-sector theorem.

5. **`krein_positive_sector_of_definitizable`** (project, the headline, hard-ish).
   Under `hJherm, hJinv, hA` and the definitizability/`J`-orthonormal-eigenbasis
   hypothesis `hdef`, produce an `A`-invariant subspace of dimension `p` on which
   `[x,x]_J > 0` for `x ≠ 0`. Assembles lemmas 3–4: split into eigenspaces, on
   each real eigenspace the restricted form is nondegenerate Hermitian, take its
   positive part; sum the positive parts. APIs: `Module.End.eigenspace`,
   `Submodule.iSup`, the repo's Krein form. *Purpose:* the deliverable — "a
   positive sector exists **given** definitizability", with the gap explicit.

Optional companion (cheap, unconditional): **`Jplus_eigenspace_nonneg_dim_p`** —
the `+1`-eigenspace of `J` is nonnegative of dimension `p`. Pins signature/target
dimension.

Lemmas 1–2 are near-free and should be submitted immediately. Lemma 3 is the
reusable structural core. Lemmas 4–5 are the real work; 5 depends on `hdef`.

**Not recommended as a first job:** the full unconditional Pontryagin existence
of a maximal *nonnegative* invariant subspace. Mathlib has invariant-subspace
plumbing (`Module.End.invtSubmodule`, `LinearMap.iInf_invariant`) and
inner-product spectral theory, but **no** indefinite/Krein/Pontryagin
invariant-maximal-nonnegative-subspace theorem and **no** Krein-space fundamental
symmetry API. That theorem's standard proofs go through a fixed-point argument
(Phillips/Krein–Shmulian on the operator ball) or the canonical form of
`J`-self-adjoint pencils — neither is in Mathlib, so it is a from-scratch build.

---

## 4. Connection to `D^#D` — and the explicit non-claims

`D^#D` is *always* `J`-self-adjoint (no hypotheses): `(D^#D)^# = D^# (D^#)^# =
D^# D` by lemma 1. Moreover its diagonal Krein form collapses cleanly:

```
[x, (D^# D) x]_J = x^† J (J D^† J) D x = x^† D^† J D x = (D x)^† J (D x)
                 = [D x, D x]_J .
```

So the "energy" of `D^#D` at `x` equals the **Krein norm of `D x`**. This is the
exact bridge — and exactly where positivity is *not* free: `[Dx,Dx]_J ≥ 0`
holds iff `Dx` lands in the nonnegative cone of the indefinite form, which is
**not automatic** because `J` is indefinite. (In the §1c space, pick `x` with
`Dx = e1 + ε·(0,1)`; the form is indefinite and takes both signs.) This should
be its own small lemma, `krein_form_DsharpD_eq_form_D`, and it is the honest
statement of what `D^#D` buys: it is a `J`-self-adjoint mass-form operator whose
positivity is *equivalent to* `D` mapping into the nonnegative cone — a separate,
unproved condition.

Non-claims to state explicitly wherever `D^#D` / the positive-sector theorem is
cited (consistent with `docs/NULLSTRAND.md` and the Working-Plan §20.6 list):

- **No positivity of `D^#D`** from `J`-self-adjointness alone; positivity ⇔
  `Dx` nonnegative-cone condition, which is unproved.
- **No real spectrum** of `A` or `D^#D` (the §1c operator has a real spectrum
  but is *not* diagonalizable; other `J`-self-adjoint operators have genuinely
  complex conjugate-paired spectra).
- **No stability / no growing modes** (nonreal paired eigenvalues admitted).
- **No naturality**: even when a positive-definite invariant sector exists
  (under `hdef`), it need not be *unique* or canonical.
- **No gauge invariance / grading compatibility**: nothing forces the sector to
  commute with `Γ_s`, `χ_E`, or the gauge action. Must be proved separately.
- **No locality**: the sector is a linear-algebra object; nothing makes the
  projector local / quasi-local on the null-edge graph.
- **No spectral mass / mass-shell claim**: `D^#D` being a `J`-self-adjoint
  mass-form operator is a finite identity, not a spectral positivity or
  mass-gap statement.

In claim-boundary labels (`docs/NULLSTRAND.md`): lemmas 1–4 and the `D^#D`
bridge are **finite identities**; lemma 5 is a **conditional existence theorem**
whose hypothesis is a physical input, not a derived fact.

---

## 5. Recommendation

**Split the decision by tier — do all three of the following.**

1. **Submit a proof job now** for the cheap, unconditionally-true structural
   layer: lemmas 1–3 above plus the `D^#D` bridge (`krein_form_DsharpD_eq_form_D`)
   and the `+1`-eigenspace companion. These are finite identities, they are
   certainly true, they are directly reusable by the `KPON` board thread, and
   they cost little. This also hardens the existing `NullEdgeSuperDiracKreinCore`
   API. Low risk, immediate value.

2. **Ask Fable to ratify before committing to lemma 5's exact hypothesis.**
   Lemma 5 is true and worth proving, but its content lives entirely in the
   choice of `hdef` (definitizable vs. `J`-orthonormal eigenbasis vs.
   "no non-semisimple neutral eigenvalue"). Fable should confirm which physical
   input the program is willing to assume, because that choice *is* the theorem.
   State the §1c counterexample to Fable as proof that some such hypothesis is
   mandatory — this reframes the KPON deliverable from "prove a positive sector
   exists" to "prove a positive sector exists **given** the definitizability
   input, and record that input as an explicit physical assumption."

3. **Park the full unconditional Pontryagin invariant-maximal-*nonnegative*
   subspace theorem** for now. Two independent reasons: (a) it is a from-scratch
   Mathlib build (no Krein fundamental-symmetry API, no indefinite invariant
   subspace theorem, standard proofs need Phillips-type fixed points or
   `J`-self-adjoint canonical forms) — a large, high-uncertainty formalization;
   and (b) even if proved, its conclusion is only a *nonnegative* (possibly
   degenerate) subspace, which by §1b does **not** answer the physical positivity
   question the program cares about. Spending the big budget there buys a
   subspace the guardrail already warns is not a Hilbert sector. Revisit only if
   Fable explicitly wants the abstract existence statement for its own sake.

**One-line bottom line.** Fable's claim is true in its weak form and false in the
form the physics needs; the smallest missing hypothesis is definitizability, the
§1c null Jordan block is the machine-verified witness that it is missing, and the
right first move is to lock the finite-identity shadow (lemmas 1–3 + `D^#D`
bridge) now while asking Fable to ratify the definitizability hypothesis before
investing in lemma 5 or the full Pontryagin existence theorem.
