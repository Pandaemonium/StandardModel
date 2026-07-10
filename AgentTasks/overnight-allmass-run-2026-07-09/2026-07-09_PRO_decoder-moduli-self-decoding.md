# Pro synthesis: moduli theory of self-decoding null information

Source: Pro analysis supplied by the user on 2026-07-09.

## New core proposal

Replace a privileged finite carrier by a moduli problem of admissible decoders.
Presentations related by constraint-preserving chain homotopy should define the
same physical action on positive cohomology. A causal amplitude functor,
physicalization quotient, spectral mass, deformation classes, and geometry sum
would then be organized over that moduli space.

## Landed finite theorem

`PhysicsSM/Draft/NullEdge/Carrier/DecoderChainHomotopy.lean` proves:

- `D' = D + QR + RQ` preserves the chain-map condition when `Q^2=0`;
- `D` and `D'` act cohomologously on every closed representative;
- a cross-carrier map with `UQ=Q'U` and `D'U-UD=Q'R+RQ` transports closed and
  exact representatives and intertwines decoder actions on cohomology;
- the positive-Hodge decoder and the genuinely distinct shift `D+2Q` act
  identically on the surviving positive harmonic class.

This is a theorem-backed channel-gauge freedom. It does not classify all
carrier decompositions or prove invariance of the full prephysical spectrum.

## Required correction

The constraint Hodge Laplacian must use the positive Hilbert adjoint:

```text
Delta_Q = Q^*Q + QQ^*.
```

The Kugo-Ojima charge is Krein-self-adjoint and nilpotent. Therefore a formula
using its Krein adjoint would collapse to `Q#Q+QQ#=2Q^2=0`. The spectral mass
operator separately uses `D#D`. The proposed superconnection must preserve this
two-adjoint distinction.

## Triage of the larger program

- Causal Bloch/proper-time algebra: substantially landed; the homogeneous-space
  isometry and rapidity-distance theorem remain open.
- Positive cohomological Rayleigh mass: high-value next theorem, requiring
  representative independence, positivity, and finite attainment.
- Four tangent deformation types: conjectural upgrade of the landed four square
  types.
- Spectral-cover monodromy: strongest post-no-go generation mechanism and a
  clean finite kill test.
- Vacuum shift, recovery-Compton, and equivalence-principle Ward identities:
  theorem-shaped but conditional on new dynamics/channel APIs.
- Causal amplitude functor, geometry measure, self-consistent free energy,
  proliferation criticality, holography, and arrow of time: reconstruction-level
  conjectures rather than consequences of the current finite carrier.
