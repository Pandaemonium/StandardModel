# Impact statement

**Null-edge reconstruction program, updated 2026-07-21**

## The central idea

The program asks whether relativistic physics can be reconstructed from a
smaller primitive package: events, causal adjacency, finite quantum state
spaces, local composition, and counting or density.

Its strongest current formulation is not that hidden particles follow
classical zigzags at the speed of light. It is this:

> **Elementary influence is carried by quantum causal transitions. Timelike
> propagation, invariant mass, proper time, phase transport, and eventually
> geometry are collective invariants of how those transitions compose.**

The project has not derived the Standard Model or general relativity from a
bare graph. It has, however, established a substantial finite mathematical
core, exposed several false shortcuts, and reduced the larger ontology to a
small number of decisive reconstruction theorems.

## The most important results

### 1. Invariant mass is exactly null-direction disagreement

For a finite family of two-spinors, with total Hermitian momentum

```text
P = sum_i psi_i psi_i^dagger,
```

the trusted Lean development proves

```text
det P = sum_{i<j} |psi_i wedge psi_j|^2.
```

Thus a single null contribution is massless, every mass contribution is
nonnegative, and the total mass vanishes exactly when all occupied null
directions lie on one projective ray. This turns the intuition that
misaligned massless momenta can form a massive system into an exact finite
theorem with a complete zero-locus classification.

**Anchor:** `PhysicsSM.Spinor.PluckerMass`.

### 2. The same area generates the Dirac rest operator

For two primitive spinors, their complex oriented area

```text
z = psi wedge phi
```

determines the two-channel Hermitian turning operator `B_z`. The formalization
proves

```text
B_z^2 = |z|^2 I = det(P) I,
H(k,z)^2 = (k^2 + det P) I.
```

No independent mass scalar is required inside this finite construction. The
same datum supplies the invariant mass, rest spectrum, channel conversion,
exact unitary evolution, and orientation-sensitive history weights. A
uniqueness result shows that, under the stated two-channel symmetry and
Hermiticity requirements, this rest operator is forced.

**Anchors:** `PluckerMassOperator`, `PluckerMassDynamics`,
`ComplexPlueckerCheckerboardPathSum`.

### 3. Null composition produces timelike aggregate observables

The position-space companion to the momentum theorem is also exact. In a
`1+1` null history with `N+` right-moving and `N-` left-moving steps of size
`epsilon`, Lean proves

```text
tau^2 = 4 epsilon^2 N+ N- = t^2 (1 - v^2).
```

One-direction support remains null; coexistence of both directions produces a
timelike aggregate displacement. Together with the Plucker identity, this
reveals one common Lorentzian mechanism: cross-relations among null
contributions generate both timelike duration and timelike momentum.

This is an aggregate norm theorem, not a claim that microscopic null segments
individually accumulate proper time or that corner count alone is a clock.

**Anchor:** `NullTickProperTime`.

### 4. The phase discarded by mass reappears as transport and holonomy

The mass spectrum sees `|z|`, but finite histories retain the orientation of
`z` versus its complex conjugate. Local phase changes induce exact endpoint
link transformations, while closed loops retain gauge-invariant holonomy.

The ring construction now proves, for every ring length `n > 2`, an exact
trace-power formula and a spectral discriminator between trivial and
winding-derived holonomy sectors. This is an operational distinction between
an arbitrary real mass parameter and mass data carrying oriented assembly
information.

**Anchors:** `VariablePlueckerPhaseConnection`, `RingHolonomyAllN`,
`DerivedWindingRingN`.

### 5. One carrier square separates four physical residues

The finite dual-soldered carrier has an exact Weitzenbock-type decomposition
into:

- **aperture:** failure of occupied null directions to align;
- **closure:** transport commutators and loop memory;
- **turn:** conversion among propagation channels;
- **soldering:** variation of the map between internal and spacetime
  directions.

The aperture block is exactly identified with the invariant Plucker mass. The
four-channel result is therefore not four analogies assembled after the fact;
it is a decomposition of one operator square. The formalization also proves
that decomposition coefficients are rigid for an explicit nondegenerate
carrier while abstract decompositions need additional selection principles.

**Anchors:** `Carrier/WeitzenbockMaster`, `Carrier/WeitzenbockMasterPair`,
`FourChannelRigidityCapstone`, `NondegenerateSolderingGeometry`.

### 6. The causal-operator route can produce Lorentzian geometry

The geometry program now has a concrete operator architecture:

```text
causal order + count -> causal wave operator -> corrected pairing -> metric.
```

The corrected pairing cancels arbitrary scalar zeroth-order potentials and
isolates the principal-symbol bilinear form. It is represented by a nonzero
self-adjoint weighted-difference operator on intrinsic zero-sum probes. A
five-event causal carrier supplies an exact rank-four mostly-minus Lorentzian
inertia witness. Separately, the concrete `SL(2,C)` spinor action is proved to
preserve the Minkowski form, land in the proper-orthochronous Lorentz group,
and have kernel `{I,-I}`.

These results prove possibility and covariance, not generic metric
reconstruction. Canonical sector selection, overlap transport, scale
agreement, and refinement persistence remain open.

**Anchors:** `CausalOperatorMetric`, `CorrectedPairingDifferenceOperator`,
`CorrectedPairingCarrierInertiaWitness`, `SL2CLorentzAction`.

### 7. The project has converted major objections into exact no-go results

Several tempting routes have been ruled out rather than hidden:

- homogeneous positive Plucker energy cannot select a nonzero absolute scale;
- a bare symmetric order cannot choose a preferred tetrad;
- polynomial filtering of the raw retarded operator cannot isolate the needed
  proper rank-four sector;
- the minimal successive-axis `3+1` walk has exact unwanted high-frequency
  sectors, and a simple stationary-amplitude repair fails under its stated
  assumptions;
- temporal blocking leaves the smallest walk family and generates additional
  operator words.

These no-go theorems sharply identify the missing ingredients: density or
clock data for scale, basis-free subspaces for frames, a corrected two-sided
operator for metric selection, a richer local architecture for `3+1`, and an
enlarged coupling space for renormalization.

### 8. A live local-unitary `3+1` regulator reaches the massive Dirac flow

The HNU/Floquet construction is now more than continuum scaffolding or an
infrared tangent. Its doubled, Pluecker-massive local unitary has a
kernel-checked changing-lattice position-space convergence theorem to the free
massive Dirac evolution, for fixed complex mass, finite time, and arbitrary
fixed square-integrable initial data.

The proof stack contains the exact finite local unitary, its full-zone massive
gap, a fixed-momentum `O(1/n)` many-step estimate, momentum-cell sampling and
interpolation, compact-momentum control, and an ultraviolet-tail argument.
On Schwartz spinors the limiting multiplier is exactly the Fourier image of
the massive Dirac differential expression, with Mathlib's `2*pi` convention
carried explicitly. The maximal momentum Hamiltonian and its exact
Fourier-conjugated position operator are self-adjoint and closed.

The onsite rest operator is determined by the same complex Pluecker area as the
finite null-spinor mass invariant; the walk does not introduce a second
independent rest coefficient. Finite exterior-Fock locality and a nontrivial
local quartic interaction control are also proved.

This is a complete free one-particle changing-lattice theorem, not an
interacting QFT. The full microscopic Floquet register retains its required
compensating sector. The next gate is to construct a gapped quasi-local
low-energy band whose accumulated interaction leakage vanishes, rather than
deleting that sector by hand.

**Anchors:** `HNUMassiveChangingLatticeContinuumCapstone`,
`HNUMassiveSchwartzPDE`, `HNUMassiveMaximalMultiplier`,
`HNUFourierPositionOperator`, `FiniteFermionicLocality`.

## Why this matters

The distinctive achievement is **explanatory compression with formal
accounting**. One finite null-spinor datum has been shown to control momentum,
mass, a Dirac rest operator, unitary turning, directed histories, and phase
transport. One causal operator architecture can organize metric, frame,
connection, and curvature questions. The same proof program records exactly
where extra assumptions enter and where an attractive interpretation fails.

The resulting ontology is economical but not simplistic:

> **Order supplies causal and conformal structure; number supplies scale;
> noncollinear quantum composition supplies timelike invariants; local frame
> comparison supplies gauge and geometric transport.**

The decisive next step is to prove that this architecture is selected by the
primitive causal system rather than merely compatible with it.

## Current scientific boundary

The project has no numerical mass-spectrum prediction and has not yet derived
the Standard Model, an interacting `3+1` QFT, or Einstein dynamics from order
and count alone. It has recovered the free massive Dirac flow from one exact
local-unitary `3+1` regulator, but has not yet proved interacting sector
stability or selected observed masses. Its strongest present status is:

> **A machine-checked finite origin-of-mass architecture with a rigorous free
> massive `3+1` continuum regulator, embedded in a constrained and falsifiable
> reconstruction program for interacting matter and geometry.**

The prioritized open program is recorded in
[`Sources/Null_Edge_Reconstruction_Priorities_2026-07-19.md`](Sources/Null_Edge_Reconstruction_Priorities_2026-07-19.md).
