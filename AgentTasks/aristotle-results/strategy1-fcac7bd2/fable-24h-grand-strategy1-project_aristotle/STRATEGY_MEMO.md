# STRATEGY MEMO — Fable lanes C & E, 24 h publication run (2026-07-11/12)

Review-only. No proofs, no source edits. This memo ranks targets, gives exact
Lean statement shapes, names the required analytic API, and sets gates + kill
conditions per target. All claims about "the overnight run" are taken from the
run report in `PROMPT.md`, not re-audited here — see §0.

---

## 0. Epistemic caveat (read first — this is itself a referee risk)

The working copy handed to this review contains only `RequestProject/Main.lean`
(an empty preamble: `import Mathlib`, option-setting, no declarations). None of
the Paper-C / one-particle / sea-level / Paper-E artifacts described in the run
report are present in this tree. Consequently **this memo cannot certify any of
the cited results as kernel-checked**; it reasons from the report at face value.

- **Action before the audit:** point the reviewer at the actual `.lean` sources
  and run `#print axioms` on every headline theorem. A memo that ranks targets
  is worthless if the "landed" results are fixtures. This is the single highest
  leverage 30-minute task in the next 24 h.
- Everywhere below, "SOURCE CHECK" flags a claim (repo result or external
  citation) that must be confirmed against actual source before it enters an
  abstract.

---

## 1. Ranked target board (value-per-effort)

| # | Lane | Target | Effort | Value | Verdict |
|---|------|--------|--------|-------|---------|
| 1 | C | Q1(a) coin-angle involution family: `W(θ)² = I` symbolic ⇒ modes ±1 persist ∀θ | LOW | HIGH | **DO FIRST** |
| 2 | E | Disjoint-cone ⇒ exact (Trotter-free) layer composition | LOW-MED | HIGH | **DO** |
| 3 | E | `K³ = |z|²·K` cubic relation ⇒ closed-form pair gate | LOW | HIGH | **DO** |
| 4 | C | Q2 CGGSVWZ *index dictionary* (finite discriminator = closed-form sᵢ of infinite extension), as a numeric-coincidence theorem over the classified set | MED | MED-HIGH | **DO, gated on formula source check** |
| 5 | C | Q1(c) exact splitting law (2×2 block eigenvalues), gated on oracle turning 0.6 into an exact constant | MED | MED-HIGH | **ORACLE FIRST, then decide** |
| 6 | E | One phase-sensitive quantity: 2-particle bound-state energy on a small ring | MED | MED | **DO after #2/#3, oracle first** |
| 7 | C | Q1(b) eigenvalue pinning by *continuity* under Γ,R-respecting perturbation + gap | HIGH | LOW-MED | **AVOID as continuity; fold into #1 as algebra** |
| — | E | Trotter *error bound* via BCH/`Matrix.exp` calculus | HIGH | LOW | **KILL** (Mathlib API too thin for 24 h; #2 makes it unnecessary) |

Rationale for the ordering: everything in the top half is *finite symbolic
algebra* (ring identities in `Matrix (Fin n) (Fin n) K`), which the fleet closes
fast and the kernel checks cleanly. Everything demoted requires analytic
spectral-perturbation API that Mathlib does not carry at the strength needed.

---

## 2. Q1 — strongest honest C-stability statement in 6–12 h

Verdict: **(a) ≫ (c) > (b)**. The honest maximum is an *exact algebraic
protection* statement, not an analytic continuity statement. The finite 8-dim
register makes continuity a red herring: the ±1 modes are pinned by an
*exact involution / symmetry* identity, so you never need eigenvalue
perturbation theory to state or prove persistence.

### 2a. (a) Coin-angle family — RANK 1, DO FIRST

Builds on: Paper-C "blocks (4,4) are exact involutions W²=1" and
"self-adjoint iff two walls and not fixedSingleton."

The strongest honest claim: the whole two-wall protected block is an exact
involution *for every coin angle θ*, so the ±1 spectrum is θ-independent and the
modes persist by construction — no gap hypothesis, no continuity.

Statement shape (symbolic, over ℝ with `cos`/`sin`):
```lean
noncomputable def W (θ : ℝ) : Matrix (Fin 8) (Fin 8) ℝ := …   -- fixed-leg compression, two-wall field

theorem W_isHermitian (θ : ℝ) : (W θ).IsHermitian := …
theorem W_involution   (θ : ℝ) : (W θ) * (W θ) = 1 := …        -- the load-bearing identity
-- consequences, all free once the involution holds:
theorem W_sq_eigenvalues (θ : ℝ) : ∀ μ ∈ spectrum ℝ (W θ), μ = 1 ∨ μ = -1
theorem W_has_plus_mode  (θ : ℝ) : ∃ v ≠ 0, (W θ) *ᵥ v = v
theorem W_has_minus_mode (θ : ℝ) : ∃ v ≠ 0, (W θ) *ᵥ v = -v
```
Analytic API needed: **none.** `W_involution` is a `Matrix.mul` entrywise
computation whose only nonlinear fact is `Real.sin_sq_add_cos_sq θ = 1` (or
`Real.cos_sq_add_sin_sq`). `W_isHermitian` is `Matrix.IsHermitian` unfolded to
`Wᵀ = W` (real) / `Wᴴ = W`. The mode existence lemmas are best proved by
**exhibiting the explicit eigenvector family** `v(θ)` and computing `W θ *ᵥ v θ`,
again reducing to `sin²+cos²=1`; do not route them through the spectral theorem.
- Gate: `W_involution` must hold as a *ring identity for the symbolic θ*, i.e.
  after `simp [Matrix.mul_apply, Fin.sum_univ_succ]` the residual goal is a trig
  Pythagorean identity. If it is not (i.e. an extra θ-dependent term survives),
  the "involution for all θ" claim is false and you retreat to θ = θ₀ only.
- Kill: if any single protected field needs `W(θ)²` to differ from `1` at
  generic θ (i.e. the involution is only at the fixture angle), drop the
  "for all θ" billing entirely; ship the fixed-angle involution and state the
  θ-family as numerics only.

Why this is the honest maximum: it upgrades "the certificate survives smooth
sign-pattern-preserving deformation" from an analytic wish to an **exact identity
family**. A referee cannot attack a `W(θ)² = 1` proved symbolically.

### 2b. (c) Exact splitting law — RANK 2, ORACLE FIRST

Builds on: transfer matrices at ±1 exact with eigenvalues {1/2, 2} (decay 1/2 per
site); numerics "hybridization splitting ≈ 0.6·2^{-sep}".

The "0.6" is a red flag: an *exact* splitting law cannot contain an empirical
0.6. The internal consistency hint is strong — decay `2^{-sep}` is exactly the
transfer eigenvalue `1/2` per site — so the true law is very likely
`Δ(sep) = c · 2^{-sep}` with `c` an *exact algebraic constant* (rational, or
rational × a fixed surd) that the fit rounds to 0.6.

Do this in two strictly ordered phases:
1. **Sympy oracle (do before any Lean):** compute the two hybridizing modes'
   eigenvalues symbolically as a function of `sep` for the R-breaking family;
   read off the closed form of `c`. Confirm `Δ(sep)·2^{sep} → c` exactly.
2. Only if `c` is exact, formalize the 2×2 effective-block eigenvalue formula:
```lean
def Heff (sep : ℕ) (g : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![1, ε sep g; ε sep g, 1]
theorem splitting_exact (sep : ℕ) (g : ℝ) :
    spectrum ℝ (Heff sep g) = {1 - |ε sep g|, 1 + |ε sep g|}
theorem coupling_decay (sep : ℕ) : ε sep g₀ = c * (2 : ℝ)^(-(sep : ℤ)) := …
```
Analytic API: **none** — 2×2 eigenvalues are `Matrix.det`/`trace` + the quadratic
formula (`Matrix.charpoly` or explicit). The content is entirely in identifying
`ε sep g` and proving `coupling_decay`, which is a transfer-matrix power
computation leaning on the exact `{1/2,2}` eigenvalues.
- Gate: oracle must return an exact `c`. If `c` stays transcendental/irrational-
  with-no-closed-form after the oracle, there is **no exact splitting law** to
  formalize.
- Kill: if the oracle shows `0.6·2^{-sep}` is only asymptotic (subleading
  corrections at small sep), then downgrade to "asymptotic splitting, numerics
  only" — do **not** dress a fit as a theorem.

### 2c. (b) Continuity/rank eigenvalue pinning — RANK 3, AVOID as stated

Builds on: nothing that needs it.

The pinning is a *symmetry* fact, not a *continuity* fact: eigenvalues sit at ±1
because the perturbed operator still anticommutes/commutes with Γ (and respects
R), not because they are dragged continuously from ±1. State it algebraically and
it collapses into §2a:
```lean
-- protection by the commutant, exact, no gap/continuity needed:
theorem mode_protected_under_symmetry
    (P : Matrix (Fin 8) (Fin 8) ℝ) (hΓ : Γ * (W₀ + P) = - (W₀ + P) * Γ) (hR : R * (W₀+P) = (W₀+P) * R) :
    ∃ v ≠ 0, (W₀ + P) *ᵥ v = v := …
```
Analytic API if you insist on the *literal* continuity form: you would need
eigenvalue-continuity-under-norm-perturbation with a spectral gap. Mathlib's
`Matrix.IsHermitian.eigenvalues` + `spectral_theorem` give you a spectrum, but
there is **no ready `‖A−B‖ small ⇒ eigenvalues close` API** at usable strength
(no Bauer–Fike, no Weyl inequalities packaged for this). Building that inside
6–12 h is a poor bet.
- Kill: if the argument cannot be recast as an exact commutant statement (i.e. it
  genuinely needs eigenvalue continuity), **do not attempt it this run**; ship
  §2a instead and note perturbative stability as future work.

---

## 3. Q2 — CGGSVWZ (arXiv:1611.04439) relation on a finite ring

Verdict: **comparison, upgraded to a numeric-coincidence theorem — not a
finite-volume Fredholm claim.**

The CGGSVWZ indices (`sᵢ`, left/right symmetry indices) are Fredholm indices of
half-line-restricted symmetric walks and are defined only for infinite chains
with an essential spectral gap; their stability is the *gentle-perturbation*
theorem. On a **finite ring every operator is finite-dimensional, so every
Fredholm index is 0** — there is no finite-volume topological invariant to claim.
Do not manufacture one.

What IS honest and is in fact kernel-provable: CGGSVWZ give **closed-form
evaluations** of `sᵢ` in terms of a bulk walk's asymptotic data (you do not need
to build a Fredholm operator to *evaluate* the index on a translation-invariant
bulk). So the defensible deliverable is an **index dictionary**: prove, over the
finite classified set of bulks, that your discriminator equals the CGGSVWZ index
of the infinite periodic extension, computed by their formula.

Referee-acceptable sentence (use verbatim in the paper):
> "On the finite palindromic register we claim no Fredholm invariant; instead we
> exhibit a dictionary: for each classified bulk `B`, our positional
> discriminator `D(B)` equals the CGGSVWZ symmetry index `sᵢ` (arXiv:1611.04439)
> evaluated in closed form on the infinite periodic extension of `B`. We verify
> this dictionary on all classified bulks and make no claim of a finite-volume
> topological index."

Theorem shape (numeric coincidence, kernel-checkable):
```lean
def cggsvwz_index (B : Bulk) : ℤ := …   -- their explicit sign formula, NOT a Fredholm index
theorem discriminator_eq_index : ∀ B ∈ classifiedBulks, discriminator B = cggsvwz_index B := by decide
```
- **SOURCE CHECK (blocking):** the exact `sᵢ` formula, sign convention, and
  left/right split in arXiv:1611.04439 §(indices). The theorem is only as honest
  as `cggsvwz_index` faithfully transcribing their formula. Get a second reader
  on this transcription before it ships.
- Gate: the dictionary must be surjective onto the classified set with no case
  patched by hand. `by decide`/`by native_decide` over the finite set is the
  right closer.
- Kill: if their formula requires data your finite register does not determine
  (e.g. genuinely needs the essential gap of the infinite extension, which the
  periodic extension may close for some bulk), then it is **comparison only, no
  theorem** for those bulks — say so explicitly and scope the dictionary to the
  gapped bulks.

Do NOT state any theorem asserting the ring "has index equal to theirs," any
"finite Fredholm index," or bulk-boundary correspondence as a finite-volume
theorem. Those are the over-claims a hostile referee will hunt (see §5.1).

---

## 4. Q3 — E dynamics: minimal kernel-checkable derivation

Builds on: repo "pair kick with 4/5-vs-1 discriminator," "pairwise-disjoint
layer-depth cone," "determinant-minor lift functoriality," "scheduled
propagation." Interaction is SUPPLIED (see §5.2).

`K(z) = z·a†_i a†_j a_l a_k + z̄·(h.c.)` on 4 modes. Represent it as a fixed
16×16 (2⁴) matrix in the occupation basis with a fixed Jordan–Wigner ordering
(pin the ordering once; it only affects an overall sign that must be tracked).

### 4a. Exact gate via a cubic relation — RANK: DO (low effort)

`K` is nonzero only on the 2-dim subspace `span{|…k l…⟩, |…i j…⟩}`, where it acts
as `[[0, z],[z̄, 0]]`. Hence `K² = |z|²·P` (`P` the projector onto that block)
and the minimal polynomial closes at degree 3:
```lean
theorem K_cubic (z : ℂ) : (K z) ^ 3 = (Complex.normSq z : ℂ) • (K z) := …
```
This is the whole "finite-dim exponential" story — cleaner than a nilpotency
claim (`K` is **not** nilpotent; `K³ = |z|²K`, not 0). The exact gate is then a
2-level rotation with closed form:
```lean
noncomputable def pairGate (α : ℝ) (z : ℂ) : Matrix (Fin 16) (Fin 16) ℂ :=
  1 + ((Real.cos (α * Complex.abs z) - 1) / Complex.normSq z) • (K z)^2
    - (Complex.I * Real.sin (α * Complex.abs z) / Complex.abs z) • (K z)
theorem pairGate_unitary (α : ℝ) (z : ℂ) : (pairGate α z) ∈ Matrix.unitaryGroup (Fin 16) ℂ := …
theorem pairGate_eq_exp  (α : ℝ) (z : ℂ) :
    pairGate α z = Matrix.exp ℂ (-(α : ℂ) • Complex.I • K z) := …   -- analytic step, see gate
```
Analytic API: `K_cubic` and `pairGate_unitary` need **none** (pure matrix ring +
`normSq`/`abs` algebra). `pairGate_eq_exp` is the only analytic step: it needs
`Matrix.exp` (exists in Mathlib) and summing the exponential series using the
cubic relation. That series manipulation is the real work.
- **Recommended honest fallback:** if `pairGate_eq_exp` does not close in time,
  ship `K_cubic` + `pairGate_unitary` + define the gate *as* `pairGate`, and
  present exp-equivalence as "the closed form satisfies the cubic recursion that
  characterizes `exp(−iαK)`" with the full `Matrix.exp` identity flagged as the
  remaining analytic lemma. Do not claim `= exp(...)` unless `pairGate_eq_exp`
  is kernel-checked.
- Sympy oracle first: build the 16×16 `K` for a fixed JW ordering, verify
  `K³ = |z|²K` numerically at random `z`, and confirm the closed-form `pairGate`
  matches `expm(-iαK)`. This pins the sign conventions before Lean.

### 4b. Layer composition — EXACT, not Trotter — RANK: DO FIRST in E

Do **not** pursue a Trotter *error bound* (needs BCH/`Matrix.exp` calculus that
Mathlib carries too weakly for 24 h — KILL that line). Instead exploit the repo's
**pairwise-disjoint layer-depth cone**: disjoint mode support ⇒ the free
minor-lift and the pair gate (or two pair gates) **commute exactly**, so their
composition is exact with zero Trotter error.
```lean
theorem gates_commute_on_disjoint (h : Disjoint (supp A) (supp B)) : A * B = B * A := …
theorem layer_compose_exact :
    Matrix.exp ℂ (-Complex.I • (Hfree + K z)) = Matrix.exp ℂ (-Complex.I • Hfree) * pairGate 1 z := …
    -- valid exactly when [Hfree, K z] = 0 on the disjoint cone; otherwise scope to the cone
```
Analytic API: `Matrix.exp_add_of_commute` (Mathlib has `exp` additivity for
commuting elements — SOURCE CHECK the exact name/hypothesis form). This is the
elegant, honest composition law and it directly reuses a landed result.
- Gate: the commutation `[Hfree, K z] = 0` must hold on the disjoint cone. Verify
  with the oracle first; if they do NOT commute even on disjoint support, the
  exact law is false and you fall back to "single-layer exact gate only."
- Kill: any layer that mixes overlapping supports has genuine BCH content — do
  not attempt an error bound this run; state single-layer exactness only.

### 4c. One phase-sensitive quantity — RANK: DO after 4a/4b

Pick the **two-particle bound-state energy on a small ring** (cleanest single
number; a scattering phase needs a scattering-state normalization apparatus that
is heavier). On an L = 4 or L = 6 ring, the 2-particle sector is a small explicit
Hermitian matrix `H₂(α)`; the bound state is its isolated eigenvalue below the
2-magnon continuum.
```lean
def H2 (L : ℕ) (α : ℝ) : Matrix (Fin (L.choose 2)) (Fin (L.choose 2)) ℝ := …
theorem bound_state_energy (α : ℝ) :
    IsGreatest {E | (H2 4 α).det ... } E ∧ E = Ebound α := …   -- E = explicit algebraic function of α
```
- Sympy oracle first (blocking): diagonalize `H₂(α)` symbolically at L = 4 (and
  6 if it stays small), extract `Ebound(α)` in closed form and the continuum
  edges, and confirm a bound state exists (energy strictly below the continuum)
  for the target `α` range. Only formalize once you have the exact `Ebound(α)`.
- Gate: a genuine bound state must exist (isolated eigenvalue outside the
  continuum) for the claimed `α` window. If the oracle shows the "bound state"
  merges into the continuum, there is no threshold theorem — report the threshold
  `α_c` instead and prove `Ebound(α) < continuum_min ↔ α > α_c`.
- Kill: if even L = 4/6 sectors are too large for exact diagonalization, drop to
  reporting the *characteristic-polynomial factorization* (bound-state factor
  splits off) rather than a closed-form energy.

Statement-shape note: keep everything over ℚ/algebraic reals where possible so
the finite checks close by `decide`/`native_decide`; introduce ℝ only for the
final `Ebound` value.

---

## 5. Q4 — Top 3 over-claim risks + prophylactic sentences

### 5.1 Finite-vs-infinite topology conflation (HIGHEST risk)
A hostile referee's first strike: "you call a finite-register discriminator a
topological index; on a finite ring every topological/Fredholm index is trivial."
- Prophylactic sentence: *"All invariants in this paper are finite-dimensional
  algebraic discriminators on an explicit register; we claim no Fredholm or
  finite-volume topological index, and every comparison to the CGGSVWZ indices is
  made through their closed-form evaluation on the infinite periodic extension of
  each bulk (§Q2 dictionary)."*

### 5.2 "Interaction derived" when it is SUPPLIED
The pair kick `K` is postulated, not derived from a microscopic
symmetry/action/locality principle (open in the Thirring-QCA literature too).
Claiming a derivation is the second strike.
- Prophylactic sentence: *"The pair interaction `K(z)` is supplied as the most
  general even, Hermitian, 4-mode kick consistent with the CAR support and layer
  schedule; we derive its exact gate, unitarity, and composition law, but we do
  not derive the interaction itself from a microscopic principle, and we flag
  this as open."*

### 5.3 Fixture / oracle results presented as kernel-checked
The report already mixes registers: "census exact (not yet formalized),"
"Lean job still running," "compiled fixture checks," "exact oracle." Any slippage
between oracle-computed and kernel-checked is the third strike — and §0 shows the
working tree currently has *no* sources to back the headline claims.
- Prophylactic sentence: *"Each result is tagged [kernel] (machine-checked in
  Lean 4 / Mathlib, `#print axioms` clean) or [oracle] (computer-algebra
  computation, not yet formalized); no [oracle] result is stated as a theorem, and
  the classification/census results are [kernel] over the explicitly enumerated
  finite set."*
- Concrete action: produce an axiom-audit table (`#print axioms` for every
  headline theorem; only `propext`, `Classical.choice`, `Quot.sound`,
  `Lean.ofReduceBool`, `Lean.trustCompiler` permitted) and attach it as an
  appendix. The `native_decide`/`ofReduceBool`-backed results in particular must
  be labelled, since a hostile referee distrusts `native_decide`.

(Watchlist 4th, lower: the "winding / half-period / mirror-graded winding proven
blind/ill-defined" claims must be scoped to *this specific register* — say
"ill-defined on this register," never "ill-defined in general.")

---

## 6. Paper A abstract-billing flags (lane 3, flag-only)

Bill in the abstract only results that are [kernel] and *self-contained*:
- The 4×4 phase-defect spectrum theorem (equal-moduli load-bearing, zero-mode
  iff, conjugacy) — clean, self-contained, strong billing.
- The coin-angle involution family (§2a) *if it lands* — "certificate persists
  for all coin angles" is quotable and honest once `W(θ)²=1` is kernel-checked.
- The two-chart reflection atlas classification — bill as a *finite
  classification*, not a topological theorem (per §5.1).
Do NOT bill: the CGGSVWZ dictionary as a "topological index theorem"; the
sea-level half-charge while the Lean job is "still running" (bill only after
[kernel]); any splitting law before the oracle confirms an exact constant.

---

## 7. Source-check checklist (blocking items in bold)

- **arXiv:1611.04439**: exact `sᵢ` index formula, sign convention, left/right
  split (§Q2 / §4-dictionary). Second reader required.
- **Repo audit (§0)**: locate actual `.lean` sources; `#print axioms` on every
  headline theorem; confirm [kernel] vs [oracle] tags.
- `Matrix.exp` additivity for commuting matrices — confirm exact lemma name and
  hypothesis shape (`exp_add_of_commute` or similar) before relying on §4b.
- Mathlib eigenvalue-continuity / Weyl / Bauer–Fike availability — expected
  ABSENT at usable strength; confirm so §2c stays killed.
- Sea-level "−1/2 per gap sector at L=8" — bill only once the running Lean job
  is [kernel]; re-check on completion.

---

## 8. One-paragraph bottom line

Spend the 6–12 h of fleet time on **finite symbolic algebra**, where the kernel
is decisive: the coin-angle involution family (§2a), the exact disjoint-cone
layer composition + cubic-relation pair gate (§4a–b), and the CGGSVWZ *dictionary*
as a numeric-coincidence theorem (§Q2), plus the two oracle-gated numbers
(splitting constant §2c, bound-state energy §4c). Refuse every analytic target
that needs eigenvalue-continuity or Trotter/BCH error bounds — Mathlib will not
carry them in 24 h and §2a/§4b make them unnecessary. Guard the three over-claims
in §5 with the verbatim prophylactic sentences, and — before anything else —
resolve §0 by pointing the audit at real, axiom-clean sources.
