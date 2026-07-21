# Gate A4: gap-to-pole reconstruction ladder

## Scope and logical status

The three landed results settle only the negative implication: spectral location
does not determine physical overlap.  The positive implication therefore has to
carry overlap, dispersion, and continuum-limit hypotheses explicitly.  In the
statements below, `gapEdge` is the selected internal spectral edge and `m` is a
candidate rest energy.  No rung asserts that a bare internal gap is a mass.

Grades used below:

* **(a) landed:** one of the supplied, already kernel-checked obstruction
  results;
* **(b) Mathlib-now:** a conditional mathematical rung that can be expressed
  and proved with current Mathlib;
* **(c) open analytic bridge:** not supplied by Mathlib or the landed inputs.

There is one missing analytic bridge, named
`osterwalderSeiler_AFN_gap_to_KL_atom` below.  Rungs 1 and 4 are hypotheses of
that bridge; its conclusion supplies the nontrivial KL existence/identification
part of rung 2.  The elementary residue and dispersion consequences are proved
in `RequestProject/GapToPoleLadder.lean`.

## Common exact interfaces

A continuum reconstruction should produce the following data.

* A complex Hilbert space `H`, vacuum `Ω : H`, and physical-sector orthogonal
  projection `Pphys : H →L[ℂ] H`.
* A densely defined self-adjoint Hamiltonian `Hgen` (or, equivalently for the
  discrete transfer branch, a bounded positive self-adjoint contraction `T`
  with `T = exp (-a Hgen)` on its spectral support).
* Momentum operators and a joint one-particle sector on which the energy is a
  function `E : ℝ^d → ℝ`.
* A positive Borel KL measure `ρ` on `[0,∞)` and a two-point distribution.

The exact positivity bookkeeping required at rung 1 is

```lean
IsSelfAdjoint Hgen
Pphys.IsIdempotent
IsSelfAdjoint Pphys
∀ x, 0 ≤ reInner x (Pphys x)
```

with the understood domain condition `Ω ∈ Dom(Hgen)` where needed.  For the
Euclidean input, the corresponding pre-Hilbert-space hypothesis is exactly
Osterwalder--Seiler reflection positivity:

```text
∀ F in A₊, 0 ≤ S₂(Θ F, F),
```

more generally `Σᵢⱼ conj(cᵢ)cⱼ S(ΘFᵢ Fⱼ) ≥ 0`, together with Euclidean
translation invariance, reflection covariance, regularity/temperedness, and a
transfer-semigroup bound.  The null space of this positive semidefinite form is
quotiented out and completed; the induced time translations must be a strongly
continuous self-adjoint contraction semigroup.  Merely saying “positive
sector” without this quadratic-form condition is insufficient.

## Rung 1 — positive physical dynamics

**Statement.** From the OS data above, reconstruct `(H, Ω, Pphys, Hgen)` such
that

1. `Hgen` is densely defined and self-adjoint;
2. `spectrum(Hgen) ⊆ [0,∞)` and `exp(-t Hgen)` is the reconstructed Euclidean
   transfer semigroup;
3. `Pphys` is an orthogonal projection (`P²=P`, `P†=P`), hence
   `Re ⟪x,Px⟫ = ‖Px‖² ≥ 0`;
4. the selected gap-edge spectral subspace lies in `range Pphys`.

**Grade: (c).** The finite-dimensional/projection bookkeeping is
Mathlib-expressible, but OS reconstruction from Schwinger functions is not a
landed theorem.  This is the reconstruction-input part of
`osterwalderSeiler_AFN_gap_to_KL_atom`.

## Rung 2 — the gap edge is visible to the physical correlator

Let `OΩ := Pphys (O Ω)` and let `Qedge` be the spectral projection of `Hgen`
onto the isolated edge eigenspace.  Require the **nonzero physical overlap**

```text
w := ‖Qedge OΩ‖² > 0.
```

Equivalently in KL language, for the isolated one-particle shell require

```text
ρ({m²}) = w > 0.
```

The two-point/resolvent response must then split locally as

```text
G(z) = w / (z - gapEdge) + R(z),
lim[z→gapEdge, z≠gapEdge] (z-gapEdge) R(z) = 0,
```

so

```text
lim[z→gapEdge, z≠gapEdge] (z-gapEdge) G(z) = w ≠ 0.
```

This condition explicitly excludes the landed zero-overlap model.  The landed
results `gap_does_not_fix_pole`,
`transfer_gap_does_not_fix_correlation_mass`, and
`resolvent_residue_pole_vs_zero` justify why `w ≠ 0` is indispensable, but do
not prove it for a new model.

**Grade: (a)+(b)+(c).** Necessity is **(a) landed**.  Given the displayed local
split, the nonzero-residue implication is **(b) Mathlib-now** and is proved by
`poleResponse_hasNonzeroResidueAt_iff` and
`add_regular_preserves_nonzero_residue`.  Obtaining the positive KL measure and
proving that its atom equals the reconstructed overlap is **(c)**, the output
part of `osterwalderSeiler_AFN_gap_to_KL_atom`.

## Rung 3 — identify rest energy through dispersion

On the selected one-particle sector require a momentum-energy graph and, in the
relativistic case,

```text
E(p) = sqrt (m² + ‖p‖²),    m ≥ 0,
E(0) = m,                   ∀ p, m ≤ E(p).
```

A nonrelativistic application may replace the formula by an explicitly stated
`E`, but must retain `E(0)=m`, `IsLocalMin E 0` (preferably the global bound
`m ≤ E(p)`), and the symmetry/covariance assumptions that identify `p=0` as
rest.  The gap edge must satisfy `gapEdge = E(0)`; matching only the numerical
minimum without identifying the selected sector is not enough.

**Grade: (b) Mathlib-now, conditional on the dispersion identity.** The exact
finite-dimensional theorem
`relativisticEnergy_rest_and_minimum` is proved in the Lean file.  Deriving the
dispersion identity from a concrete lattice model belongs to rung 4 and the
single open bridge.

## Rung 4 — changing-lattice continuum limit

Use lattice spacings `aₙ > 0` with `aₙ → 0`, Hilbert spaces `Hₙ`, normalized
vacua `‖Ωₙ‖=1`, lattice observables `Oₙ`, and nonzero wave-function
renormalizations `Zₙ`.  Let `Iₙ : Hₙ → S'(ℝ^d)` be interpolation maps whose
Fourier normalization and lattice-cell factor are fixed once and for all.
One precise weak Schwartz-domain target is:

```text
∀ f g : SchwartzMap (ℝ^d) ℂ,
  Tendsto (fun n => Zₙ * Cₙ (sampleₙ f) (sampleₙ g)) atTop
    (𝓝 (C f g)).
```

Require in addition:

1. uniform tempered/Sobolev control, for some fixed `s` and `C`,
   `|Zₙ Cₙ(sampleₙ f,sampleₙ g)| ≤ C ‖f‖_{H^s} ‖g‖_{H^s}`;
2. normalization `‖Ωₙ‖=1`, `Zₙ>0`, and a fixed Fourier/cell-volume convention;
3. convergence of reconstructed evolutions on a common core (or uniformly on
   each fixed momentum band), for every fixed `T`,
   `sup_{|t|≤T} ‖Iₙ Uₙ(t) Sₙf - U(t)f‖_{H^s} → 0`;
4. isolation uniform enough to prevent the selected spectral atom from
   dissolving into continuum, and convergence `wₙ → w` with `w>0`;
5. convergence `Eₙ(p) → E(p)` locally uniformly near `p=0`.

This follows the changing-lattice continuum template used by Arrighi,
Forets, and Nesme: compare discrete and continuum evolutions after
sampling/interpolation on a regular (Sobolev or band-limited) domain, with
uniform finite-time error control.  Reference: P. Arrighi, V. Nesme, and
M. Forets, *The Dirac equation as a quantum walk: higher dimensions,
observational convergence*, J. Phys. A 47 (2014), 465302.  The citation is a
template for the convergence architecture, not a claim that it proves the KL
conclusion for the present model.

**Grade: (c).** Mathlib supplies Schwartz spaces, distributions, measures, and
operator topology components, but no theorem connecting this entire
changing-lattice/OS package to persistence of a KL atom.  This is the
continuum-limit-input part of `osterwalderSeiler_AFN_gap_to_KL_atom`.

## Rung 5 — exact mass predicate and conclusion

The limiting number `m` is called the physical mass of the selected sector
**iff all three tests hold**:

```text
IsPhysicalMass(C, ρ, E, m) : Prop :=
  0 ≤ m
  ∧ 0 < ρ({m²})
  ∧ (∀ p near 0, E(p) = sqrt (m² + ‖p‖²))
  ∧ E(0) = m
  ∧ (∀ p near 0, m ≤ E(p))
  ∧ Cₙ ⟶ C                         -- on the stated Schwartz/Sobolev domain
  ∧ Eₙ ⟶ E                         -- locally uniformly near zero momentum
  ∧ ρₙ({Eₙ(0)²}) ⟶ ρ({m²}).
```

The last limit must have a positive limit; convergence to zero does not qualify.
For a stable relativistic particle, `0 < ρ({m²})` is the nonzero KL delta weight
and produces the pole.  A continuum threshold without an atom may describe a
mass threshold, but is not a one-particle pole and does not satisfy this
predicate.

**Grade: (b) as a definition/assembly theorem once rungs 1–4 are supplied; (c)
for deriving those inputs from a concrete lattice theory.** Thus rung 5 does
not add another analytic theorem.

## The single named missing analytic lemma

The needed project theorem should be named

```text
osterwalderSeiler_AFN_gap_to_KL_atom
```

and should have the following exact mathematical contract.

**Hypotheses:**

1. an OS-positive, Euclidean-invariant, reflection-covariant tempered family of
   lattice Schwinger functions at every `aₙ`, with the uniform transfer bound
   needed for reconstruction;
2. `aₙ→0` and the normalization, uniform Sobolev/Schwartz bounds, and
   sampling/interpolation evolution convergence stated in rung 4;
3. isolated lattice edge sectors with normalized spectral projections `Qₙ`,
   energies `Eₙ`, and overlaps
   `wₙ = ‖Qₙ Pphysₙ(OₙΩₙ)‖²` satisfying `wₙ→w` and `w>0`;
4. local uniform dispersion convergence
   `Eₙ→(p ↦ sqrt(m²+‖p‖²))`, with `m≥0`.

**Conclusion:** there exist reconstructed continuum data
`(H,Ω,Hgen,Pphys,C,ρ,E)` such that

```text
Hgen is positive self-adjoint;
Pphys is an orthogonal positive projection;
C has a KL representation with positive Borel measure ρ;
ρ({m²}) = w > 0;
lim[z→m, z≠m] (z-m) G(z) = w;       -- in the chosen energy variable
E(p) = sqrt(m²+‖p‖²) near p=0;
Cₙ ⟶ C, Eₙ ⟶ E, and wₙ ⟶ ρ({m²}).
```

For a convention using invariant momentum squared, replace the energy-variable
factor `(z-m)` by `(q²+m²)` (Euclidean) or `(p²-m²)` (Minkowski); the residue
normalization must be fixed consistently.  This convention change must not be
silently mixed with the energy-resolvent statement.

This single lemma is deliberately the only open analytic bridge: splitting it
later into OS reconstruction, compactness, and atom-persistence lemmas is an
implementation refinement, not an additional assumption.

## New finite closure

`FiniteReflectionPositiveGapPoleBridge.lean` now composes the finite positive
spectral kernel and finite resolvent rungs. For transfer eigenvalues in
`(0,1]`, observable norm-square weights, a simple selected transfer energy,
and nonzero overlap, one theorem proves all of the following for the same
data:

1. every finite reflected positive-time Hankel quadratic form is nonnegative;
2. the selected transfer energy `-log lambda_k` is nonnegative;
3. the selected spectral weight is strictly positive; and
4. the energy resolvent has a simple residue equal to that positive weight.

The exact two-level fixture uses `lambda = (1,1/2)` and an observable that sees
only the second channel. It obtains mass `log 2` and unit residue while retaining
an invisible vacuum channel. This closes the finite implication from positive
spectral data plus visible isolated gap to reflected correlation plus pole.
It does not discharge the named OS/changing-lattice lemma above, because the
positive finite spectral representation remains an input rather than a result
derived from an interacting lattice action and continuum limit.

## Machine-checked artifacts and axioms

`RequestProject/GapToPoleLadder.lean` is Mathlib-only and contains no `sorry`,
`admit`, new `axiom`, `opaque`, `unsafe`, or `native_decide`.  It proves:

* `poleResponse_hasNonzeroResidueAt_iff`;
* `add_regular_preserves_nonzero_residue`;
* `relativisticEnergy_rest_and_minimum`.

`#print axioms` verification for each theorem reports exactly
`propext`, `Classical.choice`, and `Quot.sound`, all standard permitted axioms.

`FiniteReflectionPositiveGapPoleBridge.lean` is root-imported and carries
build-enforced standard-assumption guards on both its general capstone and its
nondegenerate two-level control.
