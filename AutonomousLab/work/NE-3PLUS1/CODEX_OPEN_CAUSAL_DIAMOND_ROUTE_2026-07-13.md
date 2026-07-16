# Open causal diamond route to 3+1

## Lateral diagnosis

The recurring 3+1 aliases are not merely defects of particular coins. Every
live construction has asked for a globally translation-invariant unitary on a
periodic spatial lattice, so its symbol lives on a Brillouin torus. That is
exactly the setting in which zero/`pi` balance and lattice-fermion doubling
become unavoidable.

The checkerboard interpretation does not require a torus. It naturally asks an
initial-boundary-value question on a finite causal diamond: given amplitudes on
an initial layer, sum local null histories to a later layer. The lateral move is
therefore to remove microscopic periodicity, not to hide its extra valleys.

## Mathematical seed

For an open path with `N` sites, let `Q_N` be the centered nearest-neighbor
difference with no wraparound edge. Its spectral parameters are

```text
lambda_N(k) = cos(pi * k / (N + 1)),  1 <= k <= N.
```

When `N` is odd, `lambda_N(k) = 0` exactly at
`k = (N + 1) / 2`. More importantly, `lambda_N` is strictly monotone on the
whole index range. Each scalar momentum value therefore has at most one open
mode preimage, whereas the periodic sine symbol folds distinct lattice modes
onto the same momentum. For Euclidean anticommuting Clifford generators, the
open four-dimensional slash

```text
D_N = sum_mu gamma_mu tensor Q_N(mu)
```

has square controlled by the sum of the four scalar squares. Hence its
Euclidean bulk zero requires all four coordinates to occupy their unique
central mode. In the Lorentzian null-edge carrier the determinant must instead
vanish on a physical mass shell. The relevant no-doubling statement is then
injectivity of the four-coordinate spectral map: each physical momentum tuple,
including each mass-shell tuple, has at most one lattice preimage. Do not
confuse the Euclidean unique-zero corollary with a Lorentzian mass-shell census.

This observation is discussed by Yumoto and Misumi, *Lattice fermions as
spectral graphs*, arXiv:2112.13501. Their later Betti-number program sharpens
the topology statement: arXiv:2301.09805 conjectures a cumulative-Betti species
count, and arXiv:2311.11320 proves the graph-matrix result for Cartesian
products of directed paths and cycles. Thus `T^4` and contractible `B^4` sit on
opposite sides of an exact topology-sensitive count in the relevant product
class. The present project should clean-room formalize the mathematics and then
replace their Euclidean box interpretation with the stronger null-edge question
below.

## Null-edge reconstruction

The physical object should be a finite directed acyclic causal complex, not a
four-torus:

1. decorate every edge by a primitive null displacement;
2. use the dual-soldered carrier, keeping null displacement and Clifford
   covector distinct;
3. impose initial data on the past boundary and an explicit local boundary
   rule on the sides;
4. define the propagator by the finite sum over directed histories;
5. prove that the induced layer-to-layer map is an isometry or unitary after
   the declared boundary register is included;
6. exhaust Minkowski space by larger diamonds and prove convergence on compact
   spacetime regions before signals reach the boundary.

The finite-volume spectral theorem is not by itself a physical 3+1 solution.
It removes the periodic-torus premise and supplies a one-valley bulk control.
The causal update, boundary sector, gauge coupling, and exhaustion theorem are
separate gates.

## Lean theorem ladder

### OD0: one-dimensional open spectrum

Define the open centered-difference matrix and explicit sine-wave eigenvectors.
Prove its eigenvalue law and, for odd `N`, the exact unique-zero theorem. Include
an even-`N` negative control: no exact zero, with the two nearest modes
approaching zero under refinement.

### OD1: one-valley spectral embedding

Prove that `k |-> cos(pi*k/(N+1))` is strictly decreasing, hence injective, on
the open index range. Prove the product map on four coordinates is injective.
Contrast it with the global non-monotonicity/folding of the periodic sine map,
plus an explicit collision when the periodic size is even. Odd finite cycles
need not have an exact duplicate value; their high-index partner becomes light
asymptotically. This is the primary species theorem because it remains
meaningful for a Lorentzian mass-shell zero set.

### OD2: Euclidean four-dimensional Clifford control

For four anticommuting generators, prove that the tensor-sum slash squares to
the scalar sum of coordinate squares. Conclude that the odd-`N` bulk kernel is
one coordinate-mode sector (times the unavoidable internal spinor kernel
multiplicity). State species count separately from spinor dimension and label
this result Euclidean.

### OD3: no hidden second valley

Prove that the scalar open-path spectrum is strictly monotone and has only one
sign change. Give a quantitative lower bound outside a declared central window.
This is the correct finite replacement for a full-Brillouin-zone census.

### OD4: causal-diamond history theorem

Construct the finite directed null complex and prove exact equality between
the recurrence and its path sum, strict finite domain of dependence, and the
one-step norm law including boundary channels.

### OD5: interior exhaustion

For compactly supported initial data and times shorter than the distance to the
boundary, prove equality of two sufficiently large finite-diamond evolutions.
Then compose this stabilization with the existing continuum estimates. This
avoids making a global periodic regulator fundamental.

### OD6: gauge and anomaly audit

Dress open edges with gauge transport and prove covariance. Identify every
boundary mode and show whether it supplies anomaly inflow, must be paired, or
invalidates the single-bulk-species reading.

## Kill conditions

- `Q_N` has an additional exact or asymptotically independent low valley.
- The four-dimensional kernel count confuses spinor multiplicity with species.
- A norm-preserving layer update requires nonlocal boundary feedback.
- Gauge transport revives a second light bulk species or violates the Ward
  identities in the exhaustion limit.
- Boundary modes cannot be separated from bulk observables on compact regions.
- A local norm-preserving boundary completion necessarily carries an ungappable
  zero- or `pi`-quasienergy boundary mode.
- The exhaustion limit disagrees with the target Dirac propagator.

## Execution priority

OD0 is the provenance-checked spectral seed. After OD0, skip directly to a
minimal **OD4-min** boundary experiment before spending heavily on the remaining
Euclidean composition rungs: take the smallest odd open null chain, add an
explicit finite local boundary register, prove the complete layer update
unitary, and classify its zero/`pi` boundary-localized eigenmodes. This is the
decisive fork. Absorbing boundaries lose norm; reflecting boundaries may exile
the partner to an edge. A theorem or counterexample here has much higher
information value than another bulk spectral identity.

The first explicit OD4-min candidate uses directed edges as states. Order the
right-moving path edges and then the left-moving edges; advancing one null edge
and reflecting at an endpoint gives one cycle of length `2 * (N - 1)`. Its
permutation matrix is automatically unitary. The decisive extra theorem is that
every eigenvector has constant coordinate magnitude around this transitive
orbit, so the zero and `pi` modes are global standing/alternating modes rather
than boundary-localized states. This candidate is in Aristotle project
`e4fb5dcd-9415-42f1-aadc-a6e7bc630cfd` as `OpenPathNullBilliard.lean`.

## First 3+1 directed-edge oracle

`Scripts/experiments/directed_edge_open_diamond.py` constructs the spatial L1
ball in `Z^3`, places amplitudes on all directed nearest-neighbor edges, and
builds the global update from a unitary incoming-to-outgoing scattering block
at each vertex. Every update traverses one edge; there is no boundary waiting
state. This is an external numerical oracle, not a proof or a Dirac-tangent
construction.

The first census is discriminating:

- Global unitarity holds to numerical precision for both tested local coin
  families at radii 1 through 5.
- The Grover coin fails decisively. At radius 2 it has 13 exact zero and 13
  exact pi modes; at radius 3 it has 53 of each. The compressed boundary
  projector has eigenvalue one in both eigenspaces, proving numerically that
  each contains a fully boundary-supported direction.
- A degree-adapted discrete-Fourier coin removes exact zero/pi modes at radii
  2 through 5, but does not clear the boundary gate. Its nearest zero and pi
  modes carry roughly 92--95 percent boundary weight. At radius 5 their phase
  distance is about `5.1e-6`, so the absence of an exact finite-size root is
  not evidence for a persistent gap.

Disposition: kill the naive Grover completion as a globally gapped finite
model. Do not require the Fourier completion to remove its surface spectrum:
the reproduced zero/pi pattern is consistent with anomalous-Floquet
bulk-boundary correspondence. The positive gate is now whether these modes
decouple from fixed deep-interior observables as the boundary recedes.

## OD5-min interior-decoupling result

The oracle now propagates a fixed directed edge entering the origin, monitors
a fixed neighboring target edge, and compares the entire finite-time target
amplitude across increasing radii. For both Grover and degree-adapted Fourier
coins, radii 2 through 6 agree through four steps to at most `2.8e-17`, while
global unitarity remains at approximately `1.5e-15`. Boundary probability at
step four is nonzero for small diamonds but becomes exactly zero to floating-
point precision at radii 5 and 6.

This does not prove a single Weyl continuum limit. It does establish the right
regulator principle: fixed finite-time interior amplitudes stabilize once the
causal buffer is large enough, even though the finite operator has surface
modes. The theorem target is correspondingly sharper and easier than spectral
gap removal:

```text
if two finite diamonds agree on the radius-t causal neighborhood of the source
and target, their t-step interior matrix element is exactly equal.
```

That finite-propagation identity should be proved before any further boundary-
coin search. The eventual physical claim must combine it with a bulk single-
Weyl tangent and a scaling schedule in which boundary distance grows faster
than observation time.

The generic identity is now kernel-checked in
`PhysicsSM/Draft/NullEdge/OpenDiamondCausalExhaustion.lean`. Its
`evolveAlong_eq_on_head` theorem permits the two finite matrices to differ
arbitrarily outside the declared backward causal chain. A nonzero singleton
witness and an explicit pair of globally different off-cone updates are
included. Independent Claude review accepted the recursion, non-vacuity,
outside-cone independence, scope, and standard-three guards. The module is now
in the draft root and aggregate guard. The theorem still does not identify the
interior update with a Weyl or Dirac continuum propagator, nor prove asymptotic
decay of both zero- and pi-surface sectors.

## Claim boundary

Until OD0-OD6 land, say only: open non-torus spectral graphs provide a concrete
route around the *periodic-momentum formulation* of the current obstruction.
Do not say that the project has evaded Nielsen-Ninomiya, built an interacting
3+1 QFT, or proved that physical spacetime has a boundary. In particular, the
single bulk pole is a Euclidean spectral/Betti statement, not yet a single
physical species of a real-time unitary null-edge evolution.
