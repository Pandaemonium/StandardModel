# Aristotle semantic context pack

Generated: 2026-07-17T18:31:03
Query: `right logarithmic derivative Lorentz group plaquette holonomy bivector Lie algebra Palatini link variation`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean` [PlaquetteCoordinatization]

Score: `0.805`

```text
structure PlaquetteCoordinatization (Λ : OrientedLattice) (G : Type) [Group G]
    {ι : Type} (P : ι → Plaquette Λ) (τ : Type) where
  /-- The change of variables from link fields to plaquette + residual
  coordinates. -/
  coord : Λ.LinkField (G := G) ≃ (ι → G) × (τ → G)
  /-- Plaquette holonomies ARE the plaquette coordinates. -/
  hol_coord : ∀ (U : Λ.LinkField (G := G)) (i : ι), (P i).hol U = (coord U).1 i
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.1 Order/operator variational route (primary)]

Score: `0.788`

```text
lies the additive tangent action
needed to audit the variational shape. A real connection variation lives on
directed links, its curvature is the oriented plaquette curl, and an ordered
face field supplies an abstract bivector/dual-volume weight. Commuting shifts
make the curl and action invariant under additive vertex-gauge shifts. Exact
periodic summation by parts rewrites the first response as the pairing of arbitrary
link variations with local Euler coefficients. When the face field is
antisymmetric, stationarity is equivalent to vanishing of its backward
discrete divergence. This is exactly the discrete-adjoint form missing from
the failed pointwise architecture, and site-constant face fields provide a
nonvacuous stationary control. It remains a linearized theorem: the
Lorentz-group holonomy variation, the coframe-derived face weight, and the
Levi-Civita selection theorem are not yet present.

`FinitePeriodicCovariantLinkPalatiniVariation` lifts the same argument to an
arbitrary finite real fiber and arbitrary real transport matrices on links.
The exact periodic adjoint uses the transpose of the predecessor transport,
with no orthogonality assumption. Site/direction/component probes identify
stationarity with vanishing of every local transported Euler component; face
antisymmetry again reduces this to covariant backward divergence. Identity
transport and site-constant fiber-valued face data give an explicit stationary
control. This closes the transported finite algebra, while also isolating the
next convention debt: a Lorentzian bivector fiber requires the corresponding
Krein adjoint rather than the Euclidean transpose used here.

`FinitePeriodicKreinLinkAdjoint` closes the abstract indefinite-pairing step.
A finite fundamental symmetry `J` defines the symmetric pa
```

### 3. `PhysicsSM/Draft/NullEdge/GateYM/CenterFluxSector.lean` [plaquetteHol]

Score: `0.788`

```text
def plaquetteHol (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) (j : Fin Ly) :
    G :=
  U.hLink i j * U.vLink (finRotate Lx i) j *
    (U.hLink i (finRotate Ly j))⁻¹ * (U.vLink i j)⁻¹

/-- The full plaquette-holonomy field of a torus link field. -/
```

### 4. `PhysicsSM/Draft/NullEdge/GateYM/Z2GaugeCore.lean` [plaq]

Score: `0.782`

```text
def plaq (U : LinkField V) (a b c d : V) : Bool := hol U a [b, c, d, a]

/-- **L2′ (plaquette gauge invariance).** -/
```

### 5. `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean` [hol]

Score: `0.780`

```text
def hol (p : Plaquette Λ) (U : Λ.LinkField (G := G)) : G :=
  OrientedLattice.hol U p.walk

/-- Plaquette holonomy is conjugated by the gauge value at its basepoint. -/
```

### 6. `AgentTasks/aristotle-prompts/ym1-treegauge-rect.prompt.md` [What to do]

Score: `0.773`

```text
## What to do

1. Replace the single `s o r r y` (spelled normally in the file) in
   `rectCoordinatization` with a construction. Everything else in the file
   already compiles; the conventions (link orientations, plaquette walk,
   holonomy parenthesization, tree choice) are pinned in the module
   docstring and kernel-pinned by the `rfl` lemma
   `rectPlaquette_hol_formula` - keep that lemma compiling unchanged.
2. The designed-in easy path (see the target's docstring): take
   `coord := Equiv.ofBijective toCoord hbij` with
   `toCoord U := (fun p => (rectPlaquette Lx Ly p).hol U, fun t => U (treeLink Lx Ly t))`,
   which makes the interface field `hol_coord` definitional (`rfl`). Then
   the entire content is `Function.Bijective toCoord`, which you can get
   from injectivity plus `Fintype.bijective_iff_injective_and_card`
   (cardinalities: both sides are functions from types of equal finite
   cardinality `2*Lx*Ly + Lx + Ly` into `G`, via `Fintype.card_fun`,
   `Fintype.card_sum`, `Fintype.card_prod`, `Fintype.card_fin`), or from an
   explicit per-row recursive inverse - your choice.
3. Injectivity sketch (row independence is the key structural fact): two
   link fields with equal tree restrictions agree on all horizontal links
   and on the leftmost vertical column (`i = 0`). If they also have equal
   plaquette holonomies, then by induction along `i : Fin (Lx+1)` (per row
   `j`), they agree on vertical column `i`: the induction step solves the
   vertical link `(i+1, j)` from the plaquette holonomy at `(i, j)` and the
   three links already known equal, using `rectPlaquette_hol_formula`
   (group cancellation; note the formula's exact parenthesization).
4. Do NOT weaken the statement: no added hypotheses (no abelian `G`, no
   `Nonempty`, no `DecidableEq` beyo
```

### 7. `PhysicsSM/Draft/NullEdge/FinitePalatiniEinsteinHilbertVariation.lean`

Score: `0.773`

```text
import PhysicsSM.Draft.NullEdge.CoframeVolumeMetricVariation

/-!
# Finite Palatini-to-Einstein-Hilbert variation bridge

This module composes the two noncircular channels needed for the finite
Einstein-Hilbert first variation.

1. The inverse-metric volume response is
   `delta volume = -(volume/2) <g, h>`.
2. The integrated curvature response is a Ricci pairing plus a boundary
   response:
   `sum volume * delta R = sum volume * <Ric, h> + boundary`.

Substitution into

```text
delta sum_x volume(x) (R(x) - 2 Lambda)
```

gives exactly

```text
sum_x volume(x) <Ric - (R/2) g + Lambda g, h> + boundary.
```

The second premise is the finite Palatini gate. It is strictly weaker than
assuming the Einstein tensor as the action derivative: it mentions only the
independently constructed Ricci tensor and an explicit boundary response.

Because a genuine finite action carries local volume weights, the module also
proves the weighted stationarity theorem. If every local oriented volume is
nonzero, stationarity against all site-supported symmetric variations is
equivalent to the pointwise finite Einstein equation.

The module does not prove the Palatini gate from null-edge connection data or
show that the boundary response vanishes. Those are now isolated as the next
geometric obligations.
-/
```

### 8. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [6.1 Order/operator variational route (primary)]

Score: `0.772`

```text
the existing null-edge APIs. Its ordered coefficient at `(0,0,0,0)` is exactly
`-95`, so the Christoffel candidate fails even the torsion-free equation. The
canonical flat control remains stationary, but the general pointwise
architecture is false as a finite Palatini bridge.

`NullEdgePalatiniJointAction` places the aggregate generator and independent
connection in one displayed two-field action. Its metric partial at the
null-edge Levi-Civita connection is exactly the existing aggregate action and
hence gives the finite Einstein equation. Its connection partial is exactly
the newly derived connection Euler-Lagrange functional. The combined theorem
therefore returns both finite field equations without inserting either as a
premise.

The corrected connection branch is now explicit at the kinematical level.
`FinitePeriodicLinkConnection` attaches group-valued transports to the four
periodic directed links at each site. It proves endpoint covariance of
two-step transport, conjugation covariance of plaquette holonomy when the
shifts commute, gauge invariance of class-function observables, and the exact
equivalence between flatness and elementary path independence. A bridge theorem
identifies the periodic loop with the conjugated inverse of the trusted
causal-diamond path-comparison defect, so the two conventions are not competing
curvature definitions.
`GraphPlaquetteCurvatureLimit` then gives a nonzero matrix control in which
identity-subtracted square holonomy divided by shrinking plaquette area
converges to a commutator curvature.

`FinitePeriodicLinkPalatiniVariation` supplies the additive tangent action
needed to audit the variational shape. A real connection variation lives on
directed links, its curvature is the oriented plaquette curl, and an ordered
face field sup
```

## Scoped paper hits

### 1. Connections on non-abelian Gerbes and their Holonomy

Score: `0.752`
URL: http://arxiv.org/abs/0808.1923

### 2. Trace dynamics and division algebras: towards quantum gravity and unification

Score: `0.739`
Zotero key: `C5DVEZRE`
arXiv: `2009.05574`
DOI: `10.1515/zna-2020-0255`
URL: https://www.zotero.org/19894138/items/C5DVEZRE

Abstract:

We have recently proposed a Lagrangian in trace dynamics at the Planck scale, for unification of gravitation, Yang–Mills fields, and fermions. Dynamical variables are described by odd-grade (fermionic) and even-grade (bosonic) Grassmann matrices. Evolution takes place in Connes time. At energies much lower than Planck scale, trace dynamics reduces to quantum field theory. In the present paper, we explain that the correct understanding of spin requires us to formulate the theory in 8-D octonionic space. The automorphisms of the octonion algebra, which belong to the smallest exceptional Lie group G 2 , replace space-time diffeomorphisms and internal gauge transformations, bringing them under a common unified fold. Building on earlier work by other researchers on division algebras, we propose the Lorentz-weak unification at the Planck scale, the symmetry group being the stabiliser group of the quaternions inside the octonions. This is one of the two maximal sub-groups of G 2 , the other one being SU (3), the element preserver group of octonions. This latter group, coupled with U (1) em , describes the electrocolour symmetry, as shown earlier by Furey. We predict a new massless spin one boson (the ‘Lorentz’ boson) which should be looked for in experiments. Our Lagrangian correctly describes three fermion generations, through three copies of the group G 2 , embedded in the exceptional Lie group F 4 . This is the unification group for the four fundamental interactions, and it also happens to be the automorphism group of the exceptional Jordan algebra. Gravitation is shown to be an emergent classical phenomenon. Although at the Planck scale, there is present a quantised version of the Lorentz symmetry, mediated by the Lorentz boson, we argue that at sub-Pla
...[truncated]

### 3. Division algebraic symmetry breaking

Score: `0.734`
Zotero key: `CZJ5T2J3`
arXiv: `2210.10126`
URL: https://arxiv.org/abs/2210.10126

Abstract:

Reframes particle models in terms of normed division algebras and identifies a sequence of complex structures inducing symmetry breaking from Spin(10) through Pati-Salam and left-right symmetric stages to the Standard Model plus B-L. Also demonstrates left-right symmetric Higgs representations from quaternionic triality.

### 4. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.733`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 5. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.732`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.
