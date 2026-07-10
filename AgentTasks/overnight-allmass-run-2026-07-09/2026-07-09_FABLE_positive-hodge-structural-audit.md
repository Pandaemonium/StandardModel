# Fable audit: positive Hodge and broader reconstruction

Source: Fable feedback supplied by the user on 2026-07-09.

## Accepted structural corrections

1. The formula `(ker Q / range Q)_{J>0}` is not a canonical definition.
   `Q#=Q` is required for the Krein form to descend, and an indefinite quotient
   has no preferred positive subspace. Physicalization needs extra data: a
   chosen nonzero `D`-invariant positive subspace. Maximality is natural;
   existence and uniqueness are model-dependent.
2. The Krein-adjoint Laplacian is not a Hodge Laplacian here. Since the charge
   is nilpotent and Krein-self-adjoint, it can collapse to zero. The new
   `KreinHodgeNoGo` module gives the exact `2x2` counterexample.
3. The correct positive construction has two stages. `GenericFiniteHodge`
   uses the auxiliary positive Hilbert adjoint to select unique harmonic
   representatives. The descended Krein form is then used to select additional
   positive physical data.
4. Rank supplies the massless/massive dichotomy; `det P`, Pluecker area, or the
   corresponding spectral gap supplies the continuous mass magnitude.
5. A reconstruction hypothesis may assume a stable critical point, but not
   `z=1`; linear conical scaling must be derived.
6. A three-sheeted generation cover cannot be inserted as input. The visible
   non-circular route is to derive exactly one physical CP phase, use the landed
   `KMFamilyRankBridge` equivalence to obtain `N=3`, and only then test
   irreducible three-sheeted monodromy.

## Smaller corrections

- The soldering-gradient `E` and Krein cross term `E_#` remain distinct; their
  physical gravity identification is grade C.
- Lorentzian/Krein distance claims use the causal spectral-distance avatar, not
  the Riemannian Connes supremum.
- Binding defects are nonpositive, with strict negativity only at nonzero
  coupling.
- Finite vacuum-shift sequestering is already M. Radiative, measure, refinement,
  and continuum stability remain open.
- Lorentzian count phases and Euclidean Gibbs weights use different analytic
  continuations/normalizations of the conjugate parameter and must be labeled.

## Developments and status

- **Spin fiber:** Aristotle `ccff7fc8-bba7-4260-a335-25597d622551` targets the
  `U(2)` fiber and determinant-fixed `SU(2)` torsor. The massless/helicity fiber
  and commuting left little-group action remain follow-ups.
- **Statistics:** the correct finite home is a discretized configuration space
  and graph braid group. The first dichotomy is whether attached 2-cells plus
  positivity collapse exchange representations to `+/-1`; a permutation group
  must not be assumed on a bare graph.
- **Decay/recovery:** the next finite theorem should identify the second
  derivative at zero of leaked norm with `2 ||H_QP psi||^2`, and pair that same
  off-diagonal block with the Schur binding shift.
- **Self-decoding:** `SelfConsistentDecoder` now proves scalar Gibbs-feedback
  fixed-point existence, weak-coupling uniqueness, and a nonboundary witness.
  Decoder-valued geometry and low-temperature bifurcation remain open.
- **Conjugacy schema:** `LambdaConjugacy` is the first finite Fourier support
  uncertainty instance. A generic finite-abelian schema and mass/winding
  instances remain useful but are not yet landed.

## Independent correction to the audit slogan

The phrase "positivity repairs Hodge theory" is too strong. Finite
Hilbert-Hodge theory already works for every nilpotent differential once an
auxiliary positive inner product is supplied. Positivity of the descended
Krein cohomology is a separate physical selection problem. The rigorous
architecture is therefore:

```text
constraint quotient -> Hilbert-harmonic representative -> descended Krein form
-> chosen invariant positive sector -> spectral decoder.
```
