# Literature pass: FMS and the observable meaning of electroweak mass

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: primary-source bridge; scalar and finite vector reconstruction landed

## Question

When may a Higgs/Yukawa/gauge-orbit coefficient be promoted from a
gauge-fixed action term to the mass of a physical particle?

## Primary source

Axel Maas, *The Froehlich-Morchio-Strocchi mechanism: A underestimated
legacy*, arXiv:2305.01960v2 (2024 version).

- Zotero key: `5PE7S5PT`.
- Neo4j full-text chunks consulted: 4-7 and 15, especially section
  "The FMS mechanism."
- Online cross-check: <https://arxiv.org/abs/2305.01960>.

The library currently contains a duplicate Zotero record under `FW9IHACH`.
Do not add another item; the canonical project key used here is `5PE7S5PT`.

## What the source changes

1. Physical local states in a non-Abelian gauge theory must be represented by
   manifestly gauge-invariant composite operators. The Higgs split is applied
   to their matrix elements after gauge fixing, not to redefine the physical
   asymptotic state as an elementary gauge-dependent field.
2. For the scalar singlet, the leading FMS term in the gauge-invariant
   two-point function is the elementary Higgs propagator. In the stated
   perturbative/pole scheme, the leading composite and elementary poles
   coincide; the omitted terms are part of the physical composite correlator.
3. For the custodial vector triplet, a gauge-invariant operator of the form
   `X^dagger D_mu X` has a leading term proportional to the gauge field. A map
   between custodial/global and gauge indices is what transports the familiar
   degeneracy to physical states.
4. This matching is structurally special to the Standard Model Higgs sector.
   The source explicitly warns that more general gauge/global groups can have
   a different gauge-invariant spectrum even at weak coupling.
5. The FMS expansion is not a QCD mass mechanism: it requires a suitable Higgs
   expansion point. Manifest gauge invariance remains mandatory in QCD, but
   the same expansion is unavailable.

## Consequence for the origin-of-mass claim

FMS dressing is not a fifth electroweak mass source. It is an **observable
acceptance layer** shared by the Higgs-radial, broken-gauge-orbit, and fermion
rows:

```text
action coefficient / finite Hessian / Gram / Yukawa block
    -> gauge-invariant composite interpolating operator
    -> nonzero overlap and positive spectral measure
    -> pole or stable threshold in the physical channel
```

The leading FMS equality explains why the ordinary perturbative mass formula
can correctly locate a physical Standard Model pole. It does not derive the
vacuum, couplings, Yukawa texture, or higher composite corrections, and it is
not a proof that every beyond-Standard-Model elementary spectrum equals the
observable spectrum.

## Formal targets

### FMS-1: scalar leading-term identity - landed

`HiggsFMSRadialObservable.lean` already proves the exact finite radial identity,
the induced four-term connected-form decomposition, positivity of the leading
coefficient for a propositionally nonzero vacuum, and preservation of a finite
resolvent identity under that leading scaling. The weighted connected form is
explicitly unnormalized unless the supplied weights sum to one, and the module
claims neither an LSZ residue nor a physical pole. A nonzero composite-remainder
witness remains useful as an anti-vacuity supplement.

### FMS-2: custodial/gauge index bridge - landed

For the concrete `SU(2)` doublet matrix representation, define the finite
analogue of `O_W^i = tr(tau^i X^dagger D X)`. Prove that its leading term is a
nonzero scalar multiple of the gauge response and that the global-to-gauge
index map is invertible in the Standard Model-sized witness. Then exhibit a
mismatched representation where the map is not bijective.

`HiggsFMSVectorObservable.lean` now proves the finite matrix core: simultaneous
local-gauge cancellation, the exact leading/mixed/quadratic expansion,
bijectivity of the leading two-by-two bridge for nonzero vacuum, and an
explicit noninjective three-to-two compression with a nonzero hidden
direction. The return was completed by Aristotle task
`823b672e-6b4e-447d-83e5-98733e22b5e4` and integrated with axiom guards. It is
an index/observable bridge, not a pole theorem.

### FMS-3: pole transfer is conditional

Compose the exact expansion with the finite spectral/overlap API. The theorem
must assume or prove that the leading term has nonzero overlap with an isolated
physical atom and that the remainder does not move/create the relevant pole in
the declared approximation. Equality of action coefficients alone is not
enough.

### FMS-4: grammar correction

Extend the origin-of-mass mechanism grammar with a typed
`GaugeInvariantInterpolator`/observable map. The relative exhaustiveness
theorem should classify action-level mechanisms separately from the common
physical-observable reconstruction layer.

## Kill conditions

- If no gauge-invariant composite operator realizes a proposed elementary
  channel, the action-level mass coefficient is not yet a physical mass.
- If the global-to-gauge representation map is non-bijective, do not infer the
  elementary multiplicity or degeneracy for the physical spectrum.
- If the composite remainder carries another lower pole or the leading overlap
  vanishes, the elementary pole cannot be promoted by the leading FMS term.
- Do not export the Standard Model FMS correspondence to QCD or arbitrary BSM
  Higgs sectors without a separate dynamical and representation audit.

## Next move

Keep the root-built scalar and vector FMS modules as complementary semantic
anchors. The next proof target is FMS-3: compose the finite expansion with a
positive spectral/overlap API while displaying nonzero overlap and remainder
control as hypotheses. The mass manuscript should place this common observable
layer immediately after the action-level mechanism classification and before
any physical pole claim.
