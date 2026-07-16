# Aristotle semantic context pack

Generated: 2026-07-15T05:55:57
Query: `spin lift edge re-signing ordered face walks central holonomy defect cochain incidence coboundary closed cycle obstruction w2`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [10. Current theorem ledger]

Score: `0.888`

```text
ivity/kernel as a group theorem, and global cocycle compatibility |
| Residual spin-lift signs are gauge-trivial on a path and have one `ZMod 2` cycle invariant on a square | M [orig] | Every three-edge path assignment is removed by vertex signs; square assignments are gauge equivalent iff their cycle parities agree, giving exactly two boundary sectors. A supplied defect on one filled face selects one nonempty gauge class. For two square disks glued along one boundary, a shared correction exists exactly when the two defects agree, equivalently when their sum vanishes; `(0,1)` is an exact obstruction witness. The boundary sectors have identical Hermitian Lorentz action but different nonzero spinor action | Prove local Lorentz lift existence, derive graph coframes and face attachments, identify the obstruction with `w2`, and prove continuum spin-bundle convergence |
| A finite `ZMod 2` face-edge boundary matrix gives a complete closed-cycle criterion for spin-lift sign correction | M [orig] | A defect is an edge-sign coboundary exactly when every closed formal face cycle pairs with it to zero, equivalently exactly when there is no nonzero closed-cycle obstruction certificate. The glued-square mismatch realizes the obstructed case nontrivially | Relate the finite class to graph-derived local lifts, `w2`, and refinement/continuum compatibility |
| Ordered finite face walks and chosen group lifts derive the incidence matrix and central face-defect cochain | M [orig] | For a supplied nontrivial central involution and base face products in `{1,c}`, edge re-signing factors through the derived incidence coboundary. All corrected face holonomies are trivial exactly when the derived defect is correctable, equivalently when no closed face cycle detects it. A four-edge square gives
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G3. Nondegenerate coframe and spin structure]

Score: `0.870`

```text
rrection exists exactly when the two `ZMod 2` defects
agree, equivalently when their sum on the closed two-face cycle vanishes. The
assignment `(0,1)` has obstruction bit one and admits no correction. This is
the expected shape of a degree-two obstruction evaluation on the minimal
two-cell sphere, but the checked theorem does not identify that bit with
\(w_2\) or generalize it to an arbitrary cell complex.

The obstruction calculation now generalizes to every supplied finite face-edge
incidence matrix over `ZMod 2`. Edge-sign corrections map to face defects by
matrix-vector multiplication. A formal face sum is closed when its boundary
row vanishes. Associativity proves that every closed face cycle pairs to zero
with every correctable defect. Finite-dimensional duality proves the converse:
if all closed-cycle pairings vanish, the defect lies in the range of the
edge-to-face coboundary map. Thus correction exists exactly when every pairing
vanishes, equivalently exactly when no nonzero closed-cycle certificate exists;
the glued-square mismatch is a nonzero obstructed instance.

The first transport-to-cochain bridge is now checked. Supplied ordered face
walks determine their mod-two face-edge incidence matrix, while chosen
group-valued edge lifts determine ordered face holonomies. Assume a supplied
nontrivial central involution \(c\) and that every base face product lies in
\(\{1,c\}\). Identity versus nonidentity then extracts a unique defect bit.
Multiplying each edge lift by a central sign factors those signs through the
ordered product, and their sum along the face is exactly the derived incidence
coboundary. Hence one edge re-signing makes every face product equal to the
identity exactly when the derived defect is correctable, equivalently exactly
when no closed face
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G3. Nondegenerate coframe and spin structure]

Score: `0.824`

```text
tly the derived incidence
coboundary. Hence one edge re-signing makes every face product equal to the
identity exactly when the derived defect is correctable, equivalently exactly
when no closed face cycle has nonzero pairing with it. An explicit four-edge
square has base product \(c\), derived defect one, and a displayed correction
with trivial corrected product, so the bridge is nonvacuous.

The program still owes surjectivity onto the proper orthochronous Lorentz
group, derivation of face attachments and local `SL(2,C)` lifts from bare graph,
coframe, and Lorentz data, proof that Lorentz-flat face products land in the
central kernel, invariance under lift choices and refinement, identification of
the resulting obstruction with the second Stiefel--Whitney class, derivation
of gauge-relative coframes from graph data, and continuum spin-bundle
convergence.

**Success:** nondegeneracy, local Lorentz covariance, and patch compatibility.  
**Kill:** unavoidable frame singularities or non-equivariant preferred
directions.
```

### 4. `PhysicsSM/Draft/NullEdgePhysicsBridgeAristotle.lean` [exactEdgePhase]

Score: `0.806`

```text
def exactEdgePhase {V G : Type*} [Group G]
    (a : V -> G) (e : OrientedEdge V) : G :=
  (a e.source)⁻¹ * a e.target

/--
The smallest closed exact path has trivial holonomy.  This is the finite
seed of "exact 1-cochains are gauge-null on cycles".
-/
```

### 5. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G3. Nondegenerate coframe and spin structure]

Score: `0.802`

```text
### G3. Nondegenerate coframe and spin structure

Construct a measurable or gauge-relative coframe field and the associated spin
bundle data.

The local boundary is also explicit. A nonidentity rational Lorentz frame
change produces a distinct nondegenerate coframe with the same induced metric,
so metric reconstruction can determine only a Lorentz-gauge class. The
Hermitian part is now stronger than the initial generic conjugation witness.
Using the trusted `(+---)` Pauli lift, determinant-one `A` and `-A` produce the
same congruence action `X -> A X A^dagger`, preserve the Minkowski determinant,
and act oppositely on every spinor with nonzero image. This establishes the
local central-sign algebra.

The first graph-global sign layer is now exact as well. Vertex signs remove
every edge-sign assignment on a three-edge path. On an oriented square
boundary, the sum of the four `ZMod 2` lift signs is invariant, and two
assignments are vertex-gauge equivalent exactly when those cycle parities
agree. Hence the boundary has two inequivalent central-sign sectors. They are
invisible to the Hermitian Lorentz action but distinguished by a spinor with
nonzero image. If the square is instead treated as one filled face with a
supplied central defect from chosen base lifts, every defect has a correction
and all corrections of that defect form one gauge class. Thus this is not a
claim of two spin structures on a disk.

The first simultaneous-face obstruction is also explicit. Glue two square
disks along the same boundary, so one edge-sign correction must satisfy both
face defects. Such a correction exists exactly when the two `ZMod 2` defects
agree, equivalently when their sum on the closed two-face cycle vanishes. The
assignment `(0,1)` has obstruction bit one and admits no correction.
```

### 6. `AgentTasks/null-edge-core-round2-aristotle-2026-06-20.md` [Selected targets]

Score: `0.800`

```text
## Selected targets

1. **Three-edge Pluecker mass.**  Add `threeEdgeMomentum` and prove that its
   determinant is the sum of the three pairwise squared spinor wedges.  This
   is the first genuinely multi-edge visible-bundle theorem after the two-edge
   identity.
2. **Diamond curvature API.**  Add reusable laws for trivial labels, pointwise
   multiplication/inversion where feasible, and pure-gauge triviality.  These
   make the Abelian diamond defect usable as a finite curvature observable.
3. **Cochain coboundary square-zero.**  Add a cochain-side operator dual to
   the existing formal chain boundary and prove the coboundary squares to zero
   where feasible.
```

### 7. `AgentTasks/aristotle-p9-diamond-visibility-api-design-report.md` [3. Curvature / holonomy-defect cochain (replacing `unitTest`)]

Score: `0.797`

```text
## 3. Curvature / holonomy-defect cochain (replacing `unitTest`)

The abstract `unitTest : Cochain 1` is replaced by an *observer family of
curvature defects*. A curvature defect is a closed test (zero codifferential)
built from a holonomy comparison around each face — the additive linearization
of `diamondDefect` from `PhysicsSM.Gauge.CausalDiamondHolonomy`.

```lean
/-- An (abelian/linearized) curvature defect cochain on the screen: a face test
    that is *closed*, i.e. `codiff = 0`, and is exact-of-a-loop, i.e. equals the
    coboundary-comparison of a face potential `θ`. Physically: holonomy mismatch
    around each face's two branches. -/
structure CurvatureDefect (S : DiamondScreen) where
  test    : S.FaceCochain
  closed  : S.codiff test = 0
  /-- realized as a holonomy/branch defect of a face potential -/
  potential : S.FaceCochain
  isDefect  : ∀ f, test f = potential f - (S.codiff S.dFace? potential) f  -- schematic; see note

/-- The set of curvature-defect observers. -/
def DiamondScreen.curvatureDefects (S : DiamondScreen) : Set S.FaceCochain :=
  { t | S.codiff t = 0 }

/-- A source is *visible to a curvature defect* if it pairs non-trivially with
    some closed defect test. -/
def DiamondMeasure.VisibleToCurvature (μ : DiamondMeasure S)
    (source : S.FaceCochain) : Prop :=
  ∃ t ∈ S.curvatureDefects, μ.geomPairing source t ≠ 0
```

Note on `isDefect`: the additive model takes a *defect = closed cochain* as the
honest minimal object (`closed` field), with the `potential`/holonomy realization
as the bridge to the nonabelian `diamondDefect`. The handoff theorem
`curvatureDefect_is_holonomy_linearization` (§6) connects `CurvatureDefect.test`
to `pathPairDefect` of `CausalDiamondHolonomy` in the abelian limit, so the
"unitTest" of the toy modules is reco
```

### 8. `AgentTasks/null-edge-physics-bridge-aristotle-2026-06-21.md` [4. Observable-relative nullity diagnostics]

Score: `0.793`

```text
### 4. Observable-relative nullity diagnostics

```lean
quotient_incidence_internal_edge_eq_zero
exact_two_step_cycle_holonomy_trivial
homology_null_boundary_chain
exact_cochain_is_cocycle
```

Guidance:

- `quotient_incidence_internal_edge_eq_zero`: use `funext`; reduce to integer
  `if` expressions and rewrite `h`.
- `exact_two_step_cycle_holonomy_trivial`: unfold `exactEdgePhase`; `group`
  should close it.
- `homology_null_boundary_chain`: exact wrapper around
  `chainBoundary_simplexBoundary_eq_zero`.
- `exact_cochain_is_cocycle`: exact wrapper around `coboundary_is_cocycle`.
```

## Scoped paper hits

### 1. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.744`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 2. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.737`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 3. Superconnections and the Chern character

Score: `0.732`
Zotero key: `WNATKBT5`
DOI: `10.1016/0040-9383(85)90047-3`
URL: https://doi.org/10.1016/0040-9383(85)90047-3

### 4. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.729`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728

### 5. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.721`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.
