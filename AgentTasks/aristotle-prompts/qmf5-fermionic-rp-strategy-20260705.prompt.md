# QMF5 strategy/design: finite fermionic reflection positivity + the "mass without mass" toy

You are a proof-strategy and formalization-design agent. This is a DESIGN job,
not a proof job: I want a complete Lean 4 (Mathlib, pinned `v4.28.0`) design -
theorem SHAPES, definitions, and a lemma DAG - for the next rung of a finite
lattice-QCD mass-formalism ladder, plus a concrete model proposal. Assume you
are blind to the repository; all context you need is below.

## Context: the project

A Lean formalization of finite (fixed-coupling, fixed-volume, NO continuum)
lattice gauge theory on the reflection-positivity / transfer-operator route to
the mass gap. Everything is draft-trust, kernel-checked, standard axioms only.
There is a strict mass taxonomy (constitution-grade): (1) physical fermion rest
mass, (2) Wilson regulator mass (a lattice artifact, never physical), (3)
Yang-Mills gap = minimal transfer energy of closed gauge-flux composites, (4)
gravitational (out of scope). Conflating any two is a hard error.

A parallel "null-edge" reading holds that all mass is a relational obstruction
to primitively-null transport: TURN (fermion mass = chirality flip), CLOSURE
(gauge mass = no gauge-invariant single edge), APERTURE (composite/hadron mass =
non-collinearity of null constituents). We have just kernel-checked, in finite
form: the aperture identity `M^2 = sum of pairwise null Gram products, = 0 iff
collinear`; and the chirality decomposition showing the physical mass and the
Wilson regulator occupy the same chirality-even ("turn") channel while the
kinetic term is the sole chirality-odd part.

## What is already PROVED and available (finite, kernel-checked)

### A. Abstract reflection-positivity kernel (RP-KER), over `[Fintype A] [Fintype C]`

```lean
-- reflection form in mirror coordinates; `W a c b` = ensemble weight with
-- positive side `a`, cut `c`, mirror of `b`; starRingEnd = reflection antilinearity
def reflectionForm (W : A → C → A → ℂ) (f : A → C → ℂ) : ℂ :=
  ∑ c : C, ∑ b : A, ∑ a : A, (starRingEnd ℂ) (f b c) * W a c b * f a c

def cutKernel (W : A → C → A → ℂ) (c : C) : Matrix A A ℂ := Matrix.of fun b a => W a c b

def IsReflectionPositive (W : A → C → A → ℂ) : Prop := ∀ f, 0 ≤ reflectionForm W f

-- MASTER LEMMA: kernel PSD at every cut  =>  reflection positivity
theorem reflectionForm_nonneg (W : A → C → A → ℂ)
    (hK : ∀ c : C, (cutKernel W c).PosSemidef) : IsReflectionPositive W

-- factorized (no-cut-plaquette) weights have rank-one-Gram PSD cut kernels
theorem cutKernel_posSemidef_of_factorized (h : A → C → ℂ) (c : C) :
    (cutKernel (fun a c' b => h a c' * (starRingEnd ℂ) (h b c')) c).PosSemidef

-- PSD closure under pointwise product (Schur/Hadamard) and finite products
theorem cutKernel_mul_posSemidef ... ; theorem cutKernel_finset_prod_posSemidef ...
-- convex-mixture route to a PSD cut kernel
theorem cutKernel_posSemidef_of_mixture {K} [Fintype K] ...
-- block-matrix transfer form (OS/GNS): PSD block matrix from reflection positivity
def rpBlockMatrix [DecidableEq C] (W : A → C → A → ℂ) : Matrix (A × C) (A × C) ℂ
theorem rpBlockMatrix_posSemidef_of_reflectionPositive ...
```

### B. Finite Grassmann / Berezin (QMF3), over a char-zero comm ring / `ℂ`

```lean
-- finite Grassmann algebra model: shuffleSign, GrassmannElem, gmul, gexp, bilinear
def berezinGaussian (M : Matrix (Fin n) (Fin n) R) : R  -- Berezin Gaussian integral
theorem berezinGaussian_eq_det (M : Matrix (Fin n) (Fin n) R) : berezinGaussian M = M.det
```

### C. Wilson-Dirac operator (QMF4), Euclidean, r = 1, unitary links

```lean
abbrev Site (L : ℕ) := Fin 4 → Fin L
abbrev Idx (L nc : ℕ) := Site L × Fin 4 × Fin nc
noncomputable def wilsonDirac [NeZero L] (m : ℝ)
    (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ) : Matrix (Idx L nc) (Idx L nc) ℂ
noncomputable def Γ5 (L nc : ℕ) : Matrix (Idx L nc) (Idx L nc) ℂ
theorem gamma5_hermiticity [NeZero L] (m) (U) (hU : ∀ mu x, (U mu x)ᴴ * (U mu x) = 1) :
    Γ5 L nc * wilsonDirac m U * Γ5 L nc = (wilsonDirac m U)ᴴ
theorem det_wilsonDirac_real ... : (wilsonDirac m U).det.im = 0
theorem pairedFlavor_det_nonneg ... : 0 ≤ ((wilsonDirac m U).det ^ 2).re ∧ ...
-- Euclidean gamma matrices proven: γ_sq, γ_anticomm ({γμ,γν}=2δ), γ_herm, γ5_sq, γ5_herm, γ5_anticomm
```

## DELIVERABLE 1 (primary, super-stretch): finite fermionic reflection positivity

Design the cleanest KERNEL-CHECKABLE finite statement of fermionic (Grassmann /
Wilson-quark) reflection positivity that REUSES the RP-KER stack (A), the
Berezin=det identity (B), and the Wilson-Dirac gamma5-hermiticity (C). The
physics targets are Osterwalder-Seiler (1978) Sec. 4-5 and Menotti-Pelissetto
(1987) (Wilson-fermion RP). I want:

1. The exact Lean DEFINITIONS for the fermionic reflected weight (after
   integrating out the Grassmann fields, so the weight is a determinant / ratio
   of determinants of a REFLECTED block of `wilsonDirac`), phrased so that the
   existing `reflectionForm` / `cutKernel` / `rpBlockMatrix` API applies with
   the fermionic determinant playing the role of `W`.
2. The theorem SHAPE(S): signature, hypotheses (time-reflection symmetry of the
   link field, positivity of the Wilson hopping across the cut, mass-degenerate
   flavor pairing), and conclusion (`IsReflectionPositive` of the fermionic
   weight, or PSD of the fermionic `cutKernel`/`rpBlockMatrix`).
3. The full lemma DAG from (A)+(B)+(C) to that conclusion, each node a named
   Lean lemma with a one-line proof strategy and its dependency edges, marking
   which nodes are direct from the existing API and which are genuinely new.
4. The key mathematical crux (I expect it is: the reflected Wilson-Dirac block
   factorizes as `Mᴴ M` or a convex mixture of such, so `cutKernel_posSemidef_
   of_factorized`/`_of_mixture` fires) - state it precisely and prove the
   linear-algebra core, or give the smallest missing lemma.

## DELIVERABLE 2 (the "mass without mass" toy, NE-U5): smallest tractable model

Propose the SMALLEST explicit finite gauge+fermion model - single plaquette, or
a 2-site/2x2 chain, finite or compact group, Wilson quarks via the above
determinant algebra - for which one can KERNEL-CHECK, with NO numerics:

- a named `quarkMassParameter` that is set to ZERO, and
- a sector-restricted transfer/correlation "mass" (spectral gap of the positive
  transfer operator, or exponential decay rate of a gauge-invariant composite
  correlator) that is provably STRICTLY POSITIVE.

That is, composite (confinement-like) mass with zero bare fermion mass, in one
diagonalizable model. Give: the model's definition, the sector definitions it
needs (flavor/parity/charge), the exact positive-gap theorem shape, and the
route to a kernel proof (explicit eigenvalues, or a strict-inequality bound).
If the smallest gauge+fermion model that has a nondegenerate hadron sector is
still too large to diagonalize in-kernel, say so and give the minimal
PURE-GAUGE glueball-sector analogue instead (strong-coupling single-plaquette
transfer gap), clearly labeled as the fallback.

## DELIVERABLE 3 (fallback + risks)

If Deliverable 1's full fermionic RP is too heavy for a single package: give the
minimal honest fragment that IS tractable (e.g. RP for the free Wilson
determinant with trivial links, or PSD of the reflected free Wilson-Dirac block
alone), and the two or three highest-risk semantic pitfalls (e.g. the one-flavor
sign problem; the difference between reflection about a link-plane vs a
site-plane; whether the Grassmann reflection introduces an extra sign that
breaks the `Mᴴ M` factorization).

## Output format

Markdown. For each deliverable: the Lean definitions and theorem shapes in fenced
`lean` blocks (must be well-formed signatures, `s o r r y` bodies acceptable for
shapes), then the lemma DAG as a list with dependency edges, then prose on the
crux and risks. Prefer a correct honest design with an explicit tractable
fallback over an ambitious design that hides the hard step. Do not weaken the
mass taxonomy. This is a lead for our own kernel work, not a final proof.
