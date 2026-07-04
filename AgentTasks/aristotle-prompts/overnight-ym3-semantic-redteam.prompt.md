# Aristotle red-team job: YM3 reflection-positivity chain, statement-vs-intent audit

TEMPLATE - the submitting agent must fill every <<PASTE ...>> slot with
VERBATIM Lean source (not paraphrase) before submission. A prose
paraphrase cannot expose a semantic mismatch between the intended math
and the kernel-checked statement, which is this review's whole point.

You are acting as an adversarial semantic auditor of Lean 4 theorem
STATEMENTS, not as a prover. Do NOT attempt a Lean build. The Lean kernel
checks proofs; it cannot check that a statement says what its authors
intend. Your job is the gap between the two.

Formatting requirements for the report: ASCII only, LF line endings. In
prose, write Lean escape-hatch tokens in spaced form (`s o r r y`,
`a x i o m`), never raw.

## Standalone context (assume you are blind to the repository)

A Lean 4 project is formalizing, for lattice gauge theory with an
arbitrary FINITE gauge group G, the chain: character positivity of Wilson
weights -> finite Bochner theorem -> transfer-operator positivity ->
LINK-reflection positivity -> reconstruction and a finite-lattice
mass-gap definition.

STATUS AS OF THIS SUBMISSION (be precise about this - do not assume more
is proved than is pasted below): the "character positivity of Wilson
weights -> finite Bochner theorem" step (the historical/paper-facing
proof route, via character expansion) has NOT been formalized yet. What
HAS been kernel-checked is a DIFFERENT, self-sufficient route to the same
PSD conclusion that finite Bochner's theorem would supply - bypassing
character theory entirely via a vectorized Gram-matrix argument plus an
in-repo proof of the Schur product theorem (absent from this project's
pinned Mathlib under any name, so it was proved from more basic PSD
facts). Transfer-operator positivity (the diagonal-weight-conjugation
and compression steps) is also kernel-checked, ABSTRACTLY (independent
of the concrete lattice link/site indexing, which is a separate module
not yet built). LINK-reflection positivity itself (the cut-factorization
argument, the actual probability/ensemble/reflection apparatus) has NOT
been formalized yet - only its PSD "engine" (the two pieces above) is
ready and waiting to be consumed by it. Audit exactly what is pasted
below; do not credit the chain with steps that are not there.

Normative conventions (pinned by a numerical oracle, 36/36 fixtures):

- C-1: finite oriented lattice; link variables on positively oriented
  edges; reversed traversal uses the group inverse.
- C-2: plaquette holonomy counterclockwise, based at s:
  hol(p) = U(s,mu) U(s+mu,nu) U(s+nu,mu)^{-1} U(s,nu)^{-1}.
- C-4: weight per plaquette w(h) = exp(beta * Re chi_f(h)), beta >= 0,
  chi_f the character of a UNITARY representation.
- C-5: character coefficient w_hat_R = (1/|G|) sum_h w(h) chi_R(h^{-1});
  this is the EXPANSION coefficient (w = sum_R w_hat_R chi_R). Fusion
  identities must use the convolution argument order
  sum_h w(h) chi_R(h^{-1} A); the order sum_h w(h) chi_R(A h) is valid
  only for inversion-symmetric weights (all Wilson weights are; general
  class functions are not - an oracle guard row exhibits the failure).
- C-8: transfer matrix T = V^(1/2) K V^(1/2), V diagonal
  spatial-plaquette weight, K tensor product of per-link temporal
  kernels K1(s,s') = w(s s'^{-1}); Gauss projector = average over local
  spatial gauge transformations; pinned identity
  Z_torus = 2^(L*nt) Tr[(T P_G)^{nt}] for Z2 in 1+1D.
- Intended RP statement (LINK reflection ONLY - SITE reflection is a
  DIFFERENT theorem and must not be conflated): for the time reflection
  theta through a plane bisecting a layer of temporal links, and A_+ the
  algebra of functions of links strictly on the positive side,
  <(theta F)* F> >= 0 for all F in A_+, for any per-plaquette
  class-function weight with all w_hat_R >= 0.
- The finite-lattice mass gap is defined on the transfer operator
  restricted to the Gauss-invariant, zero-spatial-momentum, TRIVIAL
  't Hooft-flux sector (on small tori the naive Gauss-sector gap is
  saturated by a winding electric flux line, not a glueball - omitting
  the flux quantum number makes the definition measure the wrong
  excitation).
- Hard claim discipline: spectral mass gap, Wilson-loop area law, and
  entanglement area law are three distinct notions; results are
  finite-lattice statements, never the continuum Millennium problem.

## Statements under audit (VERBATIM Lean source)

### Definitional layer (link fields, holonomy, weights, kernels)

```lean
-- File: WilsonWeightPositivity.lean
-- Context: `variable {G : Type*} [Group G] [Fintype G]` and
-- `variable {n : ℕ}` are in scope for everything below unless a theorem
-- explicitly says `omit [Fintype G] in`.
open scoped ComplexConjugate Matrix ComplexOrder Kronecker Nat

/-- Real part of the character of `rho` at `g`: `Re tr(rho g)`. For the
Wilson weight this is the `Re chi_f` of convention C-4. Carried on a bare
function `rho`; multiplicativity/unitarity enter as explicit hypotheses on
each theorem (design decision `design:ym3-unitarity`, option 1). -/
noncomputable def reChar (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  (Matrix.trace (rho g)).re

/-- The Wilson per-link kernel `K(g, h) = exp(beta * Re chi(g * h^{-1}))`
on `G x G` - the object whose positive semidefiniteness is the entire
engine of link-reflection positivity (freeze sections 5-6). -/
noncomputable def wilsonKernel (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : Matrix G G ℝ :=
  Matrix.of fun g h : G => Real.exp (beta * reChar rho (g * h⁻¹))
```

The unitarity hypothesis, as actually stated on every theorem below that
needs it (there is no bundled "UnitaryRep" structure - each theorem takes
these as separate explicit hypotheses):

```lean
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
```

```lean
-- File: TransferPositivity.lean
-- Context: `import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity`
open scoped Matrix Kronecker
-- No new definitions in this file - it operates directly on `Matrix ι ι ℝ`
-- and on `WilsonWeightPositivity.wilsonKernel` (above).
```>

### Theorem statements

**`rho_inv_eq_conjTranspose`** - intended reading: for a unitary
representation, the group inverse of `rho g` equals its conjugate
transpose.

```lean
theorem rho_inv_eq_conjTranspose (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) : rho g⁻¹ = (rho g)ᴴ
```

**`reChar_inv_of_unitary`** - intended reading: for a unitary
representation, `Re chi(g^{-1}) = Re chi(g)` (this is the bridge Mathlib
does not package; it makes the Wilson weight inversion-symmetric and
makes `wilsonKernel` symmetric).

```lean
theorem reChar_inv_of_unitary (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) : reChar rho g⁻¹ = reChar rho g
```

**`reCharGram_posSemidef`** - intended reading: `M(g,h) := Re chi(g h^{-1})`
is positive semidefinite as a real matrix, for any unitary representation.

```lean
theorem reCharGram_posSemidef (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (Matrix.of fun g h : G => reChar rho (g * h⁻¹)).PosSemidef
```

**`hadamard_posSemidef`** - intended reading: the Schur product theorem -
the entrywise (Hadamard) product of two real positive-semidefinite
matrices is positive semidefinite. Note: `ι` here is an ARBITRARY finite
index type, not necessarily `G` - this lemma is not gauge-group-specific.

```lean
theorem hadamard_posSemidef {ι : Type*} [Fintype ι] {A B : Matrix ι ι ℝ}
    (hA : A.PosSemidef) (hB : B.PosSemidef) : (A ⊙ B).PosSemidef
```

**`hadamard_pow_posSemidef`** - intended reading: the entrywise `k`-th
power of a real PSD matrix is PSD, for every natural number `k`
(including `k = 0`, the all-ones matrix).

```lean
theorem hadamard_pow_posSemidef {ι : Type*} [Fintype ι] {M : Matrix ι ι ℝ}
    (hM : M.PosSemidef) (k : ℕ) :
    (Matrix.of fun i j : ι => (M i j) ^ k).PosSemidef
```

**`wilsonKernel_posSemidef`** (THE Route B deliverable) - intended
reading: for `beta >= 0` and a unitary representation `rho`, the Wilson
per-link kernel `K(g,h) = exp(beta * Re chi(g h^{-1}))` is positive
semidefinite on `G x G`. This is freeze Corollary 3a's PSD conclusion for
Wilson weights, reached without any character-expansion/Bochner
argument.

```lean
theorem wilsonKernel_posSemidef (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (wilsonKernel beta rho).PosSemidef
```

**`transferMatrix_posSemidef`** - intended reading: conjugating any PSD
kernel `K` by the diagonal square root of a nonnegative weight `v` (the
C-8 spatial-plaquette weight `V`) is PSD - i.e. `T = V^{1/2} K V^{1/2}`
is PSD. `ι` here is an arbitrary finite index type (the concrete
site/link indexing is a separate, not-yet-built module).

```lean
theorem transferMatrix_posSemidef {ι : Type*} [Fintype ι] [DecidableEq ι]
    {K : Matrix ι ι ℝ} (hK : K.PosSemidef) {v : ι → ℝ} (hv : ∀ i, 0 ≤ v i) :
    (Matrix.diagonal (fun i => Real.sqrt (v i)) * K
      * (Matrix.diagonal (fun i => Real.sqrt (v i)))ᴴ).PosSemidef
```

**`compression_posSemidef`** - intended reading: any compression
`B * T * Bᴴ` of a PSD matrix `T` is PSD - the abstract shape of "the
Gauss projector commutes into a PSD compression" (`B` will be
instantiated at the Gauss-averaging matrix by the concrete lattice
module; not yet done).

```lean
theorem compression_posSemidef {ι κ : Type*} [Fintype ι] [Fintype κ]
    {T : Matrix ι ι ℝ} (hT : T.PosSemidef) (B : Matrix κ ι ℝ) :
    (B * T * Bᴴ).PosSemidef
```

**`transferPositivity_wilsonKernel_diag`** - intended reading: the
finite-G instance of Corollary 3b's headline claim - the transfer matrix
`T = V^{1/2} K V^{1/2}` is PSD when `K` is specifically the Wilson-weight
kernel above and `v` is any nonnegative diagonal weight, PENDING only the
concrete C-8 lattice indexing (not the mathematical content).

```lean
theorem transferPositivity_wilsonKernel_diag {G : Type*} [Group G] [Fintype G] [DecidableEq G]
    {n : ℕ} (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    {v : G → ℝ} (hv : ∀ g, 0 ≤ v g) :
    (Matrix.diagonal (fun g => Real.sqrt (v g)) * WilsonWeightPositivity.wilsonKernel beta rho
      * (Matrix.diagonal (fun g => Real.sqrt (v g)))ᴴ).PosSemidef
```

### Consumers (how downstream code uses them)

None yet. `transferPositivity_wilsonKernel_diag` (above) is itself the
only "consumer" statement built so far - it is the innermost consumer of
`wilsonKernel_posSemidef` via `transferMatrix_posSemidef`. Nothing
downstream of it exists: no lattice-concrete instantiation (the actual
`G^E` configuration space, Wilson action, partition function,
expectation, reflection `theta`, or `A_+` sub-algebra), no RP-LINK
statement, and no C-8 acceptance-test identity
(`Z = 2^(L*nt) Tr[(T P_G)^{nt}]`). Please treat the ABSENCE of these as
itself worth commenting on in your report (per the DEMOTION TEST
question) - the flagship claim cannot yet be made about an actual
lattice ensemble, only about the abstract kernel/matrix objects above.

## Deliverable

Return a report named `YM3_RedTeam_Report.md` answering, numbered, for
EACH statement:

1. INTENT MATCH. Does the Lean statement say what the stated intended
   reading says? Identify every mismatch, however small (quantifier
   scope, implicit coercions, wrong side of an equivalence, direction of
   an inequality, real-vs-complex scalar field, which group element is
   inverted).
2. CONVENTION DRIFT. Check against C-1..C-8 above, especially: the
   argument order in every character sum (the C-5 trap); inverse
   placement in holonomy and kernels (K(g,h) = w(g h^{-1}), not
   w(h g^{-1}) - or is the statement invariant under that swap, and if
   so, is THAT proved or assumed?); where the unitarity hypothesis
   enters and whether any lemma silently needs it where it is not
   assumed.
3. HIDDEN HYPOTHESES. What is assumed by the formalization that the
   paper proof does not need (or vice versa)? Nonempty/Fintype/
   DecidableEq instances that secretly restrict generality; connectivity
   assumptions; beta >= 0 vs beta real; the weight being strictly
   positive vs nonneg.
4. VACUITY AND STRENGTH. Could the statement be TRUE FOR THE WRONG
   REASON (vacuous quantifier, degenerate instance, zero object)? What
   concrete small-instance evaluation would detect it? What is the most
   ambitious defensible STRENGTHENING of the statement?
5. DEMOTION TEST. What single discovery would demote the flagship claim
   ("reflection positivity for lattice gauge theory with arbitrary
   finite gauge group, kernel-checked") to something weaker, and does
   any statement above contain the seed of that discovery?

Close with a ranked list of the three most dangerous findings and the
one-line fix for each.
