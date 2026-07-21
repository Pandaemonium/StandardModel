# Literature audit: from a finite gap to a physical mass pole

Date: 2026-07-20
Role: Codex / Archivist + Research Scientist
Status: primary-source theorem audit; 26 full-text chunks indexed in Neo4j

## Question

Which hypotheses are actually needed to turn a finite transfer or Hamiltonian
gap into a positive physical two-point response, and then into a continuum
one-particle mass?

## Primary anchors

1. K. Osterwalder and E. Seiler, *Gauge field theories on a lattice*,
   Annals of Physics 110 (1978), 440-471,
   DOI `10.1016/0003-4916(78)90039-8`, Zotero `SMH5768W`.
   The paper verifies physical positivity for Euclidean lattice gauge and
   fermion approximations. It is the source-level reason that reflection
   positivity, rather than matrix positivity of an arbitrary finite carrier,
   is the relevant reconstruction input.

2. M. Luscher, *Construction of a selfadjoint, strictly positive transfer
   matrix for Euclidean lattice gauge theories*, Communications in
   Mathematical Physics 54 (1977), 283-292,
   DOI `10.1007/BF01614090`, Zotero `99FVMMKD`.
   This is the transfer-matrix anchor for obtaining a physical Hilbert-space
   dynamics from a suitable Euclidean lattice gauge theory. The title's
   positivity statement does not by itself identify which observable sees the
   first excitation.

3. K. Usui, *A Note on Reflection Positivity and the
   Umezawa-Kamefuchi-Kallen-Lehmann Representation of Two Point Correlation
   Functions*, arXiv `1201.3415v3`, Zotero `R3JICUIK`.
   Theorem 2.1 assumes four separate conditions: Hermiticity, translation
   invariance, reflection positivity, and polynomial boundedness. It concludes
   that the lattice two-point function is the Fourier/Laplace transform of a
   unique positive measure on nonnegative energy and Brillouin momentum.
   Section 3 reconstructs the Hilbert space and energy-momentum operators;
   equation (88) displays the correlation as a positive spectral-projection
   measure. The overlap-boson example proves the contrapositive warning:
   nonpositive spectral density diagnoses failure of at least one reconstruction
   hypothesis, and there specifically reflection positivity fails.

Primary full text for arXiv `1201.3415` was ingested into Neo4j on this date as
26 chunks. Claims above were checked against Sections 2-4, not inferred from
the abstract alone.

## Consequence for the Null-Edge mass claim

A finite algebraic gap is only the location of a candidate excitation. The
literature supports the following implication ladder and no shorter one:

```text
Euclidean axioms including reflection positivity
  -> reconstructed positive Hilbert-space dynamics
  -> positive spectral measure for a declared observable
  -> nonzero overlap with an isolated edge
  -> positive atom / finite response residue
  -> persistence under the changing-lattice limit
  -> relativistic dispersion with rest energy m
  -> physical one-particle mass m
```

The landed Null-Edge controls at the middle arrow are therefore structural,
not cosmetic. Equal internal spectra can give zero or nonzero values for a
fixed external readout that is not determined by the spectrum. One transfer
operator can also give different raw correlations for observables with
different overlaps; the present witness does not distinguish their connected
normalized decay rates. Reflection positivity guarantees positivity of the
spectral measure; it does not prove a chosen observable has nonzero mass-shell
weight. A physical-mass conclusion starts only after the observable and its
reconstruction map have been declared.

## Theorem-queue change

The current umbrella name `osterwalderSeiler_AFN_gap_to_KL_atom` should remain
the capstone contract, but its implementation must expose at least three
independent gates:

1. `os_reconstruction_to_positive_spectralMeasure`: formalize the declared
   Euclidean axioms and reconstruct a positive spectral measure. Do not replace
   reflection positivity by positivity of a finite matrix.
2. `isolated_edge_overlap_iff_positive_atom`: for the reconstructed spectral
   projection, identify atom weight with the squared physical overlap and
   require that overlap to be nonzero.
3. `changing_lattice_atom_persistence`: under uniform isolation, normalization,
   tightness/regularity, and overlap convergence, prove that the positive atom
   does not dissolve into a continuum threshold.

The Arrighi-Forets-Nesme continuum estimate can supply evolution convergence,
but it does not supply reflection positivity or atom persistence. Those must
remain separate hypotheses or separate theorems.

## Claim boundary

The following wording is now source-audited:

> A positive finite transfer gap is a candidate mass scale. It becomes a
> physical particle mass only for a reconstructed positive sector, an
> observable with nonzero weight at the isolated edge, a surviving continuum
> spectral atom, and the intended relativistic dispersion.

Do not say that every finite gap is a pole, that exponential decay alone fixes
an observable-independent mass, or that the current finite QCD bridge proves
the continuum Yang-Mills mass gap.

## Source-quality note

The search also returned several 2026 manuscripts claiming complete
four-dimensional Yang-Mills mass-gap constructions. None is used here. Such a
claim requires independent expert validation well beyond metadata or abstract
inspection; it cannot be allowed to redefine this program's continuum gate.

## Evening follow-up: the exact finite reflection-positive target

The primary-source audit was repeated after the finite FMS residue theorem
landed.  Usui's Section 2 makes the dependency order load-bearing:

```text
Hermiticity + translation invariance + link reflection positivity
  + polynomial correlation bound
  -> reflected positive semidefinite form on positive-time observables
  -> quotient by null vectors and Hilbert completion
  -> self-adjoint contraction transfer matrix
  -> positive joint energy-momentum spectral measure
  -> Euclidean Kallen-Lehmann representation
```

Link reflection positivity alone gives a self-adjoint contraction whose sign
may still matter at odd Euclidean times; site reflection positivity is the
extra source hypothesis that makes the one-step transfer operator
nonnegative.  Usui reconstructs the Hamiltonian from the absolute transfer
operator and obtains the clean exponential relation automatically at even
times.  This distinction must be visible in any later continuum statement.

This confirms that `A3FiniteGlueballSector.ReflectionPositive` is only a
positive-definite transfer-matrix predicate.  It is not the Osterwalder-Seiler
reflected form.  The smallest honest next theorem is therefore a finite
two-point analogue, not a renamed matrix-positivity lemma:

```text
K(t,s) = sum_a w_a lambda_a^(t+s),
w_a >= 0, 0 <= lambda_a <= 1

sum_{t,s} c_t K(t,s) c_s
  = sum_a w_a (sum_t c_t lambda_a^t)^2 >= 0.
```

This is a genuine positive-time Hankel/reflection kernel and exposes its
positive spectral measure term by term.  An explicit channel with
`lambda = 1/2`, positive weight, and mass `log 2`, together with a zero-weight
control, will connect it to the existing finite transfer and residue modules.
It still does not prove full polynomial-field OS positivity, a Wilson `SU(3)`
action, or continuum atom persistence.

### External Lean API check

`lean-explore` was queried over Mathlib and PhysLean for reflection positivity,
Euclidean transfer kernels, and Kallen-Lehmann reconstruction.  No reusable OS
or lattice-transfer reconstruction API was found.  The useful Mathlib anchors
are generic positive-semidefinite kernel/matrix declarations, especially
`Matrix.PosSemidef`, `Matrix.posSemidef_conjTranspose_mul_self`, and
`RKHS.posSemidef_kernel`.  PhysLean returned no domain-specific result for this
query.  The finite Hankel theorem should therefore be a clean-room local module
built on ordinary finite sums; a full OS reconstruction remains a larger
future library project.

### Queue action

Submit `FiniteReflectionPositiveKL` as a focused proof job with three required
outputs: the sum-of-squares identity, positivity of the reflected kernel, and a
nondegenerate two-level mass/zero-overlap control.  Promote only the phrase
"finite two-point reflection-positive analogue" if it lands.  Reserve
"Osterwalder-Schrader reconstruction" for the full algebraic quotient and
transfer construction supported by the source hypotheses above.

## Late-evening transfer-operator refresh

The next search used both public primary records and Neo4j full-text chunks.
The result supports a stricter theorem order than merely postulating positive
spectral weights.

- Luscher's 1977 construction proves positivity at the transfer-operator level
  for Wilson lattice gauge theory: a self-adjoint strictly positive transfer
  matrix gives physical positivity and real Hamiltonian energies
  ([DOI 10.1007/BF01614090](https://doi.org/10.1007/BF01614090)).
- Osterwalder and Seiler verify physical positivity for lattice gauge and
  fermion approximations and obtain a positive self-adjoint transfer matrix
  ([DOI 10.1016/0003-4916(78)90039-8](https://doi.org/10.1016/0003-4916(78)90039-8)).
- Usui proves that Hermiticity, translation invariance, reflection positivity,
  and polynomial boundedness imply a positive Kallen-Lehmann spectral measure
  ([arXiv:1201.3415](https://arxiv.org/abs/1201.3415)). Neo4j chunk retrieval
  ranked the reflected-form assumptions, reconstructed transfer operator, and
  positive spectral-density argument as the closest internal matches.
- The Luscher-Weisz improved-action analysis is a useful kill control: adding
  higher-dimensional action terms can lose physical positivity, produce
  complex transfer eigenvalues, and introduce negative spectral weights
  ([DOI 10.1016/0550-3213(84)90270-0](https://doi.org/10.1016/0550-3213(84)90270-0)).

The corresponding finite theorem target is therefore:

```text
self-adjoint positive contraction T
  -> reflected kernel K(t,s) = <T^t v, T^s v>
  -> Gram sum-of-squares positivity
  -> eigenmode decay lambda^n for a visible eigenvector
  -> energy -log lambda and positive resolvent residue
```

This is precisely stronger than `FiniteReflectionPositiveGapPoleBridge`: it
derives the positive spectral data from `T` and an observable vector. Aristotle
project `51983ddf-7ca0-4881-8127-9fa112822814` was submitted for that finite
operator-level bridge. It still does not derive `T` from a concrete Wilson or
Null-Edge interacting action.

## Operator-level bridge landed

`FiniteSelfAdjointTransferReflectionPole.lean` now implements the next finite
rung. For an actual self-adjoint matrix `T` and observable vector `v`, it
proves

```text
correlation T v (t+s) = <T^t v, T^s v>,
sum_{t,s} c_t correlation(t+s) c_s
  = ||sum_t c_t T^t v||^2 >= 0.
```

Thus the finite reflected Hankel kernel is derived from one observable orbit,
not postulated through diagonal weights. A visible eigenvector gives the exact
correlation `lambda^n ||v||^2` and a simple resolvent pole with positive
residue `||v||^2`. The explicit `diag(1, 1/2)` fixture has energy `log 2`,
nonnegative reflected form, and unit residue. The module is hole-free,
guard-pinned, root-imported, and passed its 8,026-job target build.

The distinction from the literature's stronger hypotheses is explicit:
self-adjointness alone supplies this finite orbit-Gram identity, but it does
not make the entire transfer matrix a positive contraction. Positive transfer
energy requires a visible eigenvalue in `(0,1)`; action-level reflection
positivity, infinite-volume reconstruction, and changing-lattice atom
persistence remain separate gates.

## 2026-07-21 reflected-action and many-body locality refresh

Neo4j full-text retrieval and a fresh primary-source check sharpen the order of
the remaining claims.

Usui's reconstruction assumes Hermiticity, translation invariance, link
reflection positivity, and polynomial boundedness before concluding a positive
spectral representation for two-point functions
([arXiv:1201.3415](https://arxiv.org/abs/1201.3415)). The paper's construction
also distinguishes link reflection positivity, which gives the reconstructed
time-translation contraction, from the additional site-reflection hypothesis
used to prove positivity of the transfer operator. This supports four separate
formal obligations:

```text
reflected field-algebra form >= 0
  -> reconstructed Hilbert space and time translation
  -> positive/self-adjoint transfer operator when the stronger hypotheses hold
  -> strict spectral gap only with an additional dynamical input
  -> observed decay edge only with nonzero observable overlap
```

`FiniteTransferPositivity.lean` now formalizes the last two distinctions in a
finite spectral model. Positive definiteness does not imply a uniform gap, and
two operators with the same gap can have different top spectral projectors.
Consequently neither a positive numerical matrix nor the scalar size of its
gap can replace the action-level reflected form and observable linkage.

The 3+1 many-body literature supplies a parallel warning. Mlodinow and Brun
construct a one-dimensional free-fermion QCA but prove that their common
many-particle construction does not extend with the same properties in two or
more spatial dimensions
([arXiv:2006.08927](https://arxiv.org/abs/2006.08927)). Brun and Mlodinow later
show that strict locality and positive-energy selection can conflict once
fermion-boson interactions are introduced; finite interaction range suppresses
the unwanted production only in their stated one-dimensional control
([arXiv:2503.05998](https://arxiv.org/abs/2503.05998)).

`FiniteFermionicLocality.lean` closes the corresponding free finite rung for
the current project: determinant-minor second quantization sends every local
CAR algebra into the declared one-step neighborhood, and a finite sparse
schedule with an explicit inverse pair sends it into the recursively composed
finite light cone. It does not prove locality of an interacting update or
preservation of a selected positive-energy sector. Those two properties must
be tested together on an explicit even local interaction; neither follows from
free one-particle unitarity.

The highest-value action target remains a genuinely reflected finite action,
not another postulated positive matrix. The target should construct its
time-slice quotient and transfer operator, prove a nonzero strict gap for one
explicit nonabelian fixture, and exhibit a gauge-invariant observable with
nonzero first-excited overlap. A failure at any one of those arrows is a useful
scoped obstruction rather than a license to merge the hypotheses.
