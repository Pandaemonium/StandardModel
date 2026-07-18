# Null-edge restricted Lorentz transition gate

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked finite reduction; graph sign selectors open

## Result

`PhysicsSM/Draft/NullEdge/CarrierProbeRestrictedLorentzTransition.lean`
continues the overlap-transition construction from `O(1,3)` to an explicit
proper-orthochronous gate.  At matrix level it defines:

```text
IsEtaLorentz M          := transpose M * eta * M = eta
IsProperLorentz M       := det M = 1
IsOrthochronousLorentz M := 0 <= M[0,0]
IsRestrictedLorentz M   := all three conditions
```

These conventions align with PhysLean's `LorentzGroup.IsProper`,
`LorentzGroup.IsOrthochronous`, and `LorentzGroup.restricted`.  The project
does not import PhysLean because its pinned Lean version differs; this is a
clean-room matrix-level port grounded in the existing
`MinkowskiConvention.eta`.

Eta-orthogonality proves the exact time-column identity

```text
M[0,0]^2 = 1 + M[1,0]^2 + M[2,0]^2 + M[3,0]^2.
```

Consequently `1 <= |M[0,0]|`: the time sign cannot vary continuously through
zero.  Together with `det M = +1 or -1`, the finite Lorentz transition has two
independent discrete signs.  Nonnegative determinant forces determinant `+1`;
nonnegative `M[0,0]` selects the orthochronous sector.  The predecessor's
graph-derived pair transition is therefore bundled as restricted Lorentz data
once precisely these two sign hypotheses are supplied.

## Theory consequence

Orientation and time orientation are not consequences of metric compatibility.
They should be treated as separate `ZMod 2` atlas gluing problems:

1. determinant signs form the spatial-orientation transition cochain;
2. time-component signs form the time-orientation transition cochain;
3. vertex frame reversals act as coboundaries;
4. triviality of the two classes permits reduction from `O(1,3)` to
   `SO^+(1,3)`;
5. only then does the existing central-sign spin obstruction become the next
   obstruction layer.

The causal order has a plausible native route to the time sign through the
ordered past/future endpoints of each carrier.  It does not automatically
supply a spatial orientation; that is an orientability condition on the
derived atlas unless a separate graph decoration or theorem selects it.

## PhysLean audit

Semantic search in package label `Physlib` found:

- `LorentzGroup.IsProper` (`det = 1`);
- `LorentzGroup.IsOrthochronous` (`0 <= Lambda[0,0]`);
- `LorentzGroup.restricted` (their conjunction inside the Lorentz group);
- `LorentzGroup.one_le_abs_timeComponent`;
- `Lorentz.SL2C.toLorentzGroup`;
- `Lorentz.SL2C.toRestrictedLorentzGroup`.

The searched API did not expose a theorem that this `SL(2,C)` homomorphism is
surjective onto the restricted Lorentz group, nor a theorem identifying its
kernel as the central pair `{+I,-I}`.  Therefore the existence of a homomorphism
must not yet be described as a formally established double cover in this repo.

## Claim boundary

- Eta-orthogonal sign splits: finite `M [comp]`.
- Pair transition reaches `SO^+(1,3)`: `M|H`, conditional on explicit graph
  orientation and time-orientation inequalities.
- Graph derivation and global trivialization of both sign cochains: open.
- Concrete `SL(2,C)` surjectivity and kernel theorem: open.
- Spin lift, connection, curvature convergence, and Einstein dynamics: closed.

## Verification record

- Module SHA-256:
  `53693ded40abde869fb81ac91a52b8928d9bcfbff5abce2bd2a5e8c9c8a45a21`.
- `lake env lean PhysicsSM/Draft/NullEdge/CarrierProbeRestrictedLorentzTransition.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition`
  passed (`8040` jobs).
- Targeted pre-commit passed.

## Next theorem targets

1. Prove determinant-sign cocycle and vertex-frame gauge laws on an exact
   carrier-atlas Cech cocycle.
2. Define a causal-endpoint future functional and test whether selected frames
   can be made future-adapted consistently on all retained overlaps.
3. Port or independently prove the `SL(2,C)` restricted-Lorentz surjectivity
   and central-kernel package before connecting to
   `SpinLiftDefectFromTransport.lean`.
