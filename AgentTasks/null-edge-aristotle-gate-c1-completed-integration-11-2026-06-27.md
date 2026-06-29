# Null-edge Aristotle Gate C1 completed integration 11

Date: 2026-06-27

Integrated jobs:

```text
C154: sector-signature reference audit
C156: range-k/path-shell Neumann locality theorem
C160: mass-window/sign-straddling theorem package
C161: overlap linearization and bad-sector inverse-gap theorem package
C162: concrete null-edge point-split W_branch construction
C163: point-split W_branch sector-signature table
C164: point-split gapped homotopy/reference bridge
C165: generator-level SMActsInternally checklist
C166: Gate C1_NU strategy synthesis
```

## Executive result

This integration materially changes the Gate C1 status.

The point-split route is real, but the naive product point-split mass is not by
itself a one-sector release. In four branch directions it depends only on corner
parity, so it produces an eight-sector negative multiplet. To isolate one
physical sector we need a level-resolving Adams/Wilson-style term layered with
or replacing the pure product parity mass.

The current bottleneck is therefore no longer the existence of a point-split
`W_branch`. The bottleneck is:

```text
one-sector level-resolving W_branch
  + sector-signature match
  + uniformly gapped homotopy to a reference kernel.
```

## C154: finite sector-signature GO framework

C154 gives a machine-checked finite go/no-go framework:

```text
matching sector signatures + norm gap bounds
  <-> straight-line gapped homotopy class.
```

It compared the C145 seed with a flavor-matched reference and found a finite
GO in the illustrative model. It also proved the obstruction: a mismatched
sector forces a zero crossing and blocks the straight-line gapped homotopy.

Next use:

```text
replace the illustrative reference sign pattern with actual point-split / Adams
reference sign data, then rerun the signature check.
```

## C156: path-shell locality/control theorem

C156 proves the null-edge path-shell control theorem:

```text
finite propagation range for H
  + row l1 amplitude bound M
  + summable coefficients |c_n| M^n
  -> uniform far-field control for polynomial/Neumann/sign approximants.
```

This is the combinatorial non-ultralocal control certificate we wanted. It does
not require ultralocality of the final operator, but it does require a summable
tail. If shell growth/amplitude gives `M >= 1`, the certificate fails.

## C160: mass-window/sign-straddling

C160 turns the C138 lesson into finite theorems:

```text
sector mass margin + smaller perturbation
  -> sector sign is stable;

sub-gap even background + odd block
  -> sign-straddling / indefinite kernel;

even-dominant background
  -> positive definite kernel and odd sign content dies.
```

This confirms that nonzero `Odd_J(W_branch)` is not enough. We need an explicit
mass window or odd-dominance/sign-straddling condition.

## C161: overlap bad-sector gap and conditional Weyl linearization

C161 proves the overlap release algebra once the sign alignment hypotheses are
available:

```text
T v = Gamma v
  -> D_ov v = 2 rho v
  -> true bad-sector inverse-propagator gap;

T v = - Gamma v
  -> D_ov v = 0
  -> physical sector is light;

linearization certificate
  -> D_ov approximates the Weyl symbol with explicit bound.
```

It keeps anomaly/index, determinant-line, and locality outside the theorem,
which is exactly the C159 architecture.

## C162: concrete point-split W_branch

C162 formalizes the construction:

```text
BranchCorner n = Fin n -> Bool
edgeSign : one-edge branch Pauli sign
cornerSign = product of edge signs
Wbranch a = diagonal point-split mass
shiftedMass d a m0 = d + a cornerSign - m0
```

It proves that point-split `W_branch` sign-straddles under the appropriate
window and that constant scalar mass cannot sign-straddle. It also proves the
`n = 1` slice is exactly the C145 branch-Pauli seed.

## C163: multiplet obstruction and Adams/Wilson fix

C163 is the key new warning.

The pure product point-split mass has:

```text
pointSplitMassSign(c) = (-1)^(level(c)).
```

In four dimensions this creates eight negative and eight positive branches. It
sign-straddles, but it cannot isolate one physical Weyl sector by itself.

A one-sector window requires a level-linear Wilson/Adams-style term. In the
reported model the standard windows yield light-sector counts:

```text
m0 in (0,2): 1 light sector
m0 in (2,4): 5 light sectors
m0 in (4,6): 11 light sectors
m0 in (6,8): 15 light sectors
m0 > 8: 16 light sectors
```

So the next real construction is not pure product mass. It is:

```text
point-split parity/flavored mass
  + level-resolving Adams/Wilson-style branch term.
```

## C164: reference bridge

C164 recommends direct flavored-overlap reference first, with abstract block
reference as proof scaffolding and domain-wall as fallback.

The bridge criterion is:

```text
H_t = H_ref + t (H_ne - H_ref)

if H_ref has gap gamma and ||H_ne - H_ref|| < gamma,
then H_t is uniformly gapped with residual gap gamma - ||H_ne - H_ref||.
```

Sector signatures are preserved along a continuous gapped path, provided the
signature/index invariant is locally constant on the gapped set.

## C165: SM internality checklist

C165 promotes C157's assumption into a generator-level checklist:

```text
SMActsInternally:
  every SU(3), SU(2)_L, U(1)_Y, and flavor/generation generator has form
  id_B tensor g_i relative to the null-edge branch factor.
```

If any generator has a nonzero branch-mixing block, native mode fails.

The weak chirality factor must stay distinct from the null-edge branch grading.
This is now a named convention/audit gate, not an informal hope.

## C166: strategy synthesis

C166 recommends:

```text
1. abstract block-reference import first;
2. domain-wall reference second;
3. native overlap last.
```

The shortest credible path is to make the C159 interface compile with abstract
certificates, then discharge certificates one by one. The ranked bottleneck is
uniform gapped homotopy and sector-signature correctness, with the multiplet
problem upstream.

## Literature pass

Targeted web and Neo4j searches reinforce this route:

```text
Creutz/Kimura/Misumi 1011.0761 and 1110.2482:
  point splitting implements flavored mass terms for naive/minimally doubled
  overlap kernels, spectral flow detects index, and a single-flavor naive
  overlap kernel is possible with the right mass choice.

Adams 1008.2833:
  staggered-overlap uses a flavored mass to reduce tastes and convert flavored
  chiral symmetry into Ginsparg-Wilson symmetry.

Chreim/Hoelbling/Zielinski 2203.06116:
  staggered overlap locality can be proved under an admissibility condition,
  supporting locality/control as an explicit certificate rather than an
  automatic consequence.
```

## Updated blocker list

The biggest blockers are now:

```text
1. Define a level-resolving null-edge Adams/Wilson-style W_branch that isolates one sector.
2. Prove its mass-window/sign-straddling certificate.
3. Compute and match its sector signature to a direct flavored-overlap or abstract block reference.
4. Prove the norm-difference bound for a uniformly gapped homotopy.
5. Instantiate the C159 assembly theorem with abstract certificates.
6. Discharge or explicitly assume SMActsInternally generator-by-generator.
7. Import anomaly/index and determinant-line data from the chosen reference.
8. Attach C156 path-shell or HJL/Chreim-style locality/control certificate.
```

## Lean promotion note

Several returned Lean artifacts are strong candidates for promotion:

```text
C156 path-shell locality theorem;
C160 mass-window/sign-straddling finite package;
C161 overlap bad-gap and linearization package;
C162 point-split W_branch;
C164 gapped homotopy bridge;
C165 SM internality checklist.
```

They were not promoted in this integration pass. Promotion should be a dedicated
Lean pass with local checks, namespacing cleanup, and semantic review.
