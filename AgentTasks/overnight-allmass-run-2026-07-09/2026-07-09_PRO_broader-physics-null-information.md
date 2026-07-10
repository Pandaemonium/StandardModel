# Pro synthesis: a broader physics of finite null information

Source: Pro analysis supplied by the user on 2026-07-09.

## Organizing proposal

The memo reframes the mature target as a reconstruction of physics from a
small set of information operations: encoding, quotienting, positive decoding,
holonomy, spectral cost, coarse-graining, and recovery. Its proposed dictionary
is useful as a research organizer, but most entries are interpretations or
conditional reconstructions rather than consequences of the current carrier.

The strongest safe synthesis is:

> Physical observables should live in chosen invariant positive subspaces of
> cohomology and be unchanged by decoder-presentation gauge, while interactions
> record transport, holonomy, spectral response, and coarse-graining.

Fable's subsequent audit sharpens "positive cohomology": `Q#=Q` is required
for the Krein form to descend to `ker Q / range Q`, and that indefinite quotient
has no canonical positive part. Physicalization requires a chosen nonzero
`D`-invariant positive subspace as extra data. `GenericFiniteHodge` supplies
Hilbert-harmonic representatives, while `KreinHodgeNoGo` rules out replacing
the Hilbert adjoint by the Krein adjoint.

## Immediate theorem harvest

### Gauge-mass Gram theorem: landed

`PhysicsSM/Draft/NullEdge/GaugeMassGram.lean` proves the finite core of the
reference-frame account of gauge mass:

- the coupling-weighted gauge-orbit tangents are `v_a = g_a T_a phi`;
- their Gram matrix is Hermitian and positive semidefinite;
- its full quadratic form is the squared norm of the combined reference
  displacement;
- at nonzero coupling, a diagonal mass vanishes exactly when the corresponding
  generator stabilizes the reference state;
- an explicit two-generator witness produces `diag(0,1)`, with one unbroken
  and one genuinely broken direction.

This does not derive the electroweak representation, couplings, Weinberg angle,
Higgs potential, or the radial Higgs boson's own mass.

### Null-factorization spin fiber: submitted

The focused Aristotle target
`ARISTOTLE_PROMPT_codex_null_factorization_spin_fiber_20260709.md` asks for the
exact finite theorem

```text
M M^H = M0 M0^H  <->  M = M0 U,  U in U(2),
```

relative to an invertible base factor `M0`, with uniqueness of `U`. Fixing
`det M = det M0` reduces the fiber to `SU(2)`. The package includes an explicit
nontrivial determinant-fixed witness. Aristotle project:
`ccff7fc8-bba7-4260-a335-25597d622551`.

This identifies the algebraic little-group fiber. Deriving spin
representations, Wigner holonomy, and spin-statistics remains later work.

## Existing anchors for the eight targets

1. **Null-factorization spin:** new focused job above; the representation layer
   remains open.
2. **Exchange-holonomy spin-statistics:** open. It requires a configuration
   history groupoid, locality, framed rotations, and a theorem identifying two
   loop classes. Finite antisymmetry alone is not a spin-statistics theorem.
3. **Higgs reference resource:** substantially anchored by `WAYTurnNoGo.lean`:
   `way_nogo` and `chirality_requires_nontrivial_ancilla` prove the finite
   conservation obstruction. Identifying a physical Higgs channel still needs
   the Standard Model charge representation and a constructive coherent
   reservoir.
4. **Gauge-mass Gram:** finite theorem landed above.
5. **Anomaly as decoding obstruction:** `IndexAnomalyInterface.lean` supplies a
   finite index/winding interface and `CarrierWardDescentWitness.lean` supplies
   a quotient action. A determinant line or phase cocycle, gluing law, and the
   equivalence between cocycle triviality and functorial gauge descent are open.
6. **Resonance-recovery:** open. Current Schur decimation is finite and real; a
   decay width needs an open-channel or resolvent framework with a complex pole,
   followed by a separately defined recovery/leakage quantity.
7. **Equivalence-principle Ward identity:** current WEP trace and soldering
   response theorems are anchors. Equality of inertial and gravitational
   response requires a simultaneous state/frame covariance action and its
   differentiated Ward identity.
8. **Horizon capacity:** `HolographicEdgeBound.lean` proves one explicit
   `dim Phys <= boundary edges` witness and a matching interior nonexample. A
   general region theorem, logarithmic code capacity, gluing, and area scaling
   remain open.

## Required operator correction

The memo's BRST/Hodge formula must not be imported verbatim. In this program the
finite Kugo-Ojima charge is Krein-self-adjoint and nilpotent. Therefore

```text
Q#Q + QQ# = 2 Q^2 = 0.
```

Harmonic representative theory must instead use the auxiliary positive Hilbert
adjoint:

```text
Delta_Q = Q*Q + QQ*.
```

The spectral mass operator remains `D#D`. `PositiveHodgeDecoder.lean` already
implements and tests this two-adjoint distinction.

## Wider research boundary

The memo's interpretations of fields, scattering, virtual particles,
thermodynamics, hydrodynamics, measurement, gravity, horizons, cosmology,
duality, and coupling-count conjugacy are promising architecture. They are not
yet theorem consequences. Their common missing layer is a functorial category
of causal histories with gluing, positive physicalization, states/channels,
and a refinement or continuum law. That infrastructure should be built before
the manuscript promotes the dictionary beyond conjectural grade.
