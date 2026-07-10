# Aristotle semantic context pack

Generated: 2026-07-09T17:34:37
Query: `3+1 tetrahedral Weyl checkerboard spin projector ordered path amplitude bend phase`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/context-packs/null-edge-generation-blindness-port-20260621-175331.md` [3. Spin on a 4D Feynman Checkerboard]

Score: `0.800`

```text
### 3. Spin on a 4D Feynman Checkerboard

Score: `0.718`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
```

### 2. `AgentTasks/context-packs/null-edge-bargmann-phase-port-20260621-181804.md` [3. Spin on a 4D Feynman Checkerboard]

Score: `0.799`

```text
### 3. Spin on a 4D Feynman Checkerboard

Score: `0.694`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
```

### 3. `AgentTasks/context-packs/null-edge-core-definition-consolidation-20260621-173119.md` [1. Spin on a 4D Feynman Checkerboard]

Score: `0.797`

```text
### 1. Spin on a 4D Feynman Checkerboard

Score: `0.717`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.
```

### 4. `Sources/Luminal_Motion_Checkerboard_Research_Program.md` [WP3: Lean formalization of the spin-holonomy lemma chain]

Score: `0.788`

```text
### WP3: Lean formalization of the spin-holonomy lemma chain

WP2b is finite-dimensional complex linear algebra -- formalizable
independently of any analysis:

- $2\times 2$ rank-one projectors $P(\hat n) = (1 + \sigma\cdot\hat n)/2$;
- the product-collapse identity;
- the discrete solid-angle phase (Pancharatnam) for spherical triangles,
  via explicit spin-coherent states.

This sits directly on the repo's Clifford/spinor layer
(`PhysicsSM/Clifford/`, `PhysicsSM/Spinor/`) and doubles as reusable Berry-
phase infrastructure. Natural namespace:
`PhysicsSM.Spinor.CoherentProjector` or similar.
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/ARISTOTLE_SUMMARY.md` [The explicit projector]

Score: `0.778`

```text
### The explicit projector
`branchProj a v = ½ (v + (g5 a) • γ₅ v)` — the explicit Weyl/chirality projector onto the `γ₅`-eigenline with eigenvalue `g5 a ∈ {±1}`.
```

### 6. `PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean`

Score: `0.774`

```text
import Mathlib

/-!
# Draft.SpinCoherentProjectorAristotle

Aristotle handoff: the exact algebraic identities for spin-1/2 coherent-state
projectors `P(a) = (1 + sigma . a) / 2` on `Matrix (Fin 2) (Fin 2) C`.

## Mathematical intent

WP3 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: in the
null-polygon expansion of the 3+1D Dirac propagator, the numerator of the
massless chiral propagator along a null step of direction `a` is the
rank-one projector `P(a)`, and the spin transport along a polygon is a
product of such projectors.  The two structural facts are:

- the **sandwich collapse** `P(a) P(b) P(a) = ((1 + a.b)/2) P(a)`, whose
  scalar is the squared modulus of the spin-coherent overlap (the "bending
  suppression" of Foster--Jacobson, arXiv:1610.01142), and
- the **Bargmann invariant** `tr (P(a) P(b) P(c))
  = (1 + a.b + b.c + c.a + i a.(b x c)) / 4`, whose argument is half the
  signed solid angle of the geodesic triangle `(a, b, c)` on the direction
  sphere -- the discrete Berry/Pancharatnam phase.  The identity itself is a
  *polynomial* identity in the components, requiring no unit-norm
  hypotheses (oracle-checked with non-unit vectors).

These are finite-dimensional matrix algebra, independent of any analysis,
and are the reusable Berry-phase layer for the checkerboard program.
All statements were validated numerically in
`Scripts/oracle/validate_checkerboard.py` (section "Pauli projector
identities"); the oracle justifies the statements, not the proofs.

## Conventions

- Pauli matrices in the standard basis:
  `pauliX = !![0, 1; 1, 0]`, `pauliY = !![0, -I; I, 0]`,
  `pauliZ = !![1, 0; 0, -1]`.
- Real 3-vectors are `Fin 3 -> R`; `dot3` and `cross3` are the Euclidean
  dot and cross products with the right-handed orientation
  (`cross3 a b 0 =
```

### 7. `PhysicsSM/Draft/WeylCliffordBridgeAristotle.lean`

Score: `0.773`

```text
import Mathlib
import PhysicsSM.Draft.SpinCoherentProjectorAristotle
import PhysicsSM.Draft.SpinorHelicityRankOneAristotle

/-!
# Draft.WeylCliffordBridgeAristotle

Aristotle handoff (wave 2): the bridge between the spin coherent projector
layer (`PhysicsSM.Draft.SpinCoherentProjectorAristotle`) and the
spinor-helicity layer (`PhysicsSM.Draft.SpinorHelicityRankOneAristotle`),
both proved in wave 1 and available s o r r y-free.

## Mathematical intent

WP2b of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: the 2x2
Weyl form of the Clifford algebra and the null-step/projector dictionary.

- `minkHerm p = sigma . p` and the second chirality
  `minkHermBar p = sigmabar . p = p0 - sigma . p`;
- the **Clifford relation** `(sigma.p)(sigmabar.p) = (p,p) 1` with `(p,p)`
  the Minkowski norm: the algebraic seed of the chirality-alternating
  Neumann series (each `S_0` numerator alternates `sigma`/`sigmabar`, and
  squaring along a ray reproduces the norm);
- the **trace pairing** `tr ((sigma.p)(sigmabar.k)) = 2 (p,k)`: the
  Minkowski inner product recovered from the spinor algebra;
- the **null-step factorization** `sigma.(r, r a) = 2r P(a)`: the numerator
  of the massless chiral propagator along a null step of direction `a` is
  the coherent projector -- the exact statement "spin transport along a
  null polygon is a product of coherent projectors" at the single-step
  level.  This is a polynomial identity: no unit-norm hypothesis is needed
  (the radius `r` simply scales).

## Conventions

Signature `(+,-,-,-)`; `minkHerm p = !![p0 + p3, p1 - i p2; p1 + i p2,
p0 - p3]` (from the spinor-helicity file); Pauli matrices and
`pauliVec`/`dot3` from the projector file; `minkHermBar` is defined below as
`sigmabar . p`, i.e. `!![p0 - p3, -(p1 - i p2); -(p1 + i p2), p0 + p3
```

### 8. `AgentTasks/checkerboard-wave2-aristotle-2026-06-12.md` [Aristotle wave 2: checkerboard structure + projector calculus + d=6 helicity]

Score: `0.769`

```text
# Aristotle wave 2: checkerboard structure + projector calculus + d=6 helicity

Date: 2026-06-12

Second wave of the luminal-motion checkerboard program
(`Sources/Luminal_Motion_Checkerboard_Research_Program.md`), built on the
integrated wave-1 results (recursion package, spin coherent projectors,
complex spinor-helicity; the wave-1 corner-count job `edfab07a` is still
running and is NOT superseded by this wave).

All statements oracle-validated:
`Scripts/oracle/validate_checkerboard.py` (ALL OK, 2026-06-12, including the
new wave-2 section: general collapse with arbitrary non-Hermitian `M`,
antipodal completeness/orthogonality, quaternionic rank-one and the chart
construction).

Submission package created with
`Scripts/prepare_aristotle_submission.ps1 -JobName checkerboard-wave2-20260612`
(package checks: no `.lake`/`.git`/output state, no compiled artifacts,
proof-sorry counts as expected).
```

## Scoped paper hits

### 1. Spin on a 4D Feynman Checkerboard

Score: `0.802`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 2. Notes on The Feynman Checkerboard Problem

Score: `0.712`
Zotero key: `7Z3X3HMK`
arXiv: `1012.1564`
URL: https://www.zotero.org/19894138/items/7Z3X3HMK

Abstract:

The Feynman checkerboard problem is an interesting path integral approach to the Dirac equation in `1+1' dimensions. I compare two approaches reported in the literature and show how they may be reconciled. Some physical insights may be gleaned from this approach.

### 3. Weyl-van der Waerden formalism for helicity amplitudes of massive particles

Score: `0.708`
Zotero key: `986CC8CS`
arXiv: `hep-ph/9805445`
DOI: `10.1103/PhysRevD.59.016007`
URL: https://www.zotero.org/19894138/items/986CC8CS

Abstract:

The Weyl-van-der-Waerden spinor technique for calculating helicity amplitudes of massive and massless particles is presented in a form that is particularly well suited to a direct implementation in computer algebra. Moreover, we explain how to exploit discrete symmetries and how to avoid unphysical poles in amplitudes in practice. The efficiency of the formalism is demonstrated by giving explicit compact results for the helicity amplitudes of the processes gamma gamma -&gt; f fbar, f fbar -&gt; gamma gamma gamma, mu^- mu^+ -&gt; f fbar gamma.

### 4. Discrete physics and the Dirac equation

Score: `0.707`
Zotero key: `WBGEISNI`
arXiv: `hep-th/9603202`
DOI: `10.1016/0375-9601(96)00436-7`
URL: https://www.zotero.org/19894138/items/WBGEISNI

Abstract:

We rewrite the 1+1 Dirac equation in light cone coordinates in two significant forms, and solve them exactly using the classical calculus of finite differences. The complex form yields ``Feynman's Checkerboard''---a weighted sum over lattice paths. The rational, real form can also be interpreted in terms of bit-strings.

### 5. Scattering Amplitudes For All Masses and Spins

Score: `0.697`
Zotero key: `zotero:SZJE69PE`
arXiv: `1709.04891`
URL: http://arxiv.org/abs/1709.04891
