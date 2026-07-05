# The octonion / null-edge unification: how the two programs fit together

Author: claude (run agent), 2026-07-05. A grounded synthesis of how the
division-algebra / Standard-Model-structure work (lane A) and the null-edge
mass / dynamics work (lane B) fit into one picture, with the concrete bridge
theorems to formalize it and honest claim boundaries.

Claim label for the THESIS: **program synthesis / interpretation**. The
individual pillars cited are kernel-checked; the unifying reading and the
proposed bridges are the research thesis. Bridges carry their own claim labels.

## 1. The thesis: one spinor, two structures

The whole picture rests on a single object - the **spinor**, realized as a
**minimal left ideal** on the internal side and as a **Weyl spinor** on the
spacetime side - carrying two commuting structures:

- **Internal (division-algebra) structure -> CHARGES.** `ℂ⊗𝕆` generates
  `Cl(6)` acting on the minimal left ideal `J` (`Furey/CliffordConnection`); the
  ladder operators ARE the Clifford generators, and the octonion automorphisms
  fixing the complex unit ARE `SU(3)`. This fixes WHICH particles exist and WHAT
  they are charged under.
- **Spacetime (null-edge) structure -> MASS + PROPAGATION.** Primitive transport
  is null (massless); mass is the **Plucker obstruction** `det(sum psi psi^dag)
  = m^2` on the same spinors. This fixes WHY they are massive and HOW they move.

This is the standard **spacetime (x) internal** factorization - but here BOTH
factors are division-algebraic (the Dixon-Furey `ℝ⊗ℂ⊗ℍ⊗𝕆` program):
`ℂ⊗ℍ` on the Lorentz/Weyl side, `ℂ⊗𝕆` on the color side.

One line: *the division algebras say which particles exist and what they are
charged under; the null-edge geometry says why they are massive and how they
move - and they are the same spinor.*

## 2. The bridge that already exists in the repo: the Plucker mass

This is the concrete anchor, not an aspiration. BOTH lanes independently define
the SAME construction and one already cites the other:

- **Lane B (null-edge):** `Draft/NullEdge/GateI1/Core` has
  `minkHerm p : Herm2` and `det_minkHerm_eq_minkowskiSq : det (minkHerm p) =
  minkowskiSq p`; `CompositeApertureMass` (NE-U1) proves a composite of null
  momenta is massless iff collinear.
- **Lane A (octonion/spinor):** `Spinor/PluckerMass` has
  `rankOneHermitian psi = psi psi^dag`, `twoEdgeMomentum psi phi =
  psi psi^dag + phi phi^dag`, and
  `two_edge_plucker_mass_identity : det (twoEdgeMomentum psi phi) =
  complexAbsSq (spinorWedge psi phi)`; `two_edge_mass_zero_iff_wedge_zero`
  is the same "massless iff collinear".
- **The wiring:** `GateI1/Core` line 28 explicitly names
  `PhysicsSM.Spinor.PluckerMass` as the source spinor-helicity algebra.

Both `minkHerm p` and `twoEdgeMomentum psi phi` are Hermitian `2 x 2` matrices
whose determinant is the mass squared. So the null-edge Minkowski mass and the
spinor Plucker mass are the SAME number in two languages. **Bridge B0 (below)
makes this an equation.**

## 3. The three structural bridges

### B0. Plucker-mass unification (mass, both languages). TRACTABLE - built first.

Every Hermitian `2 x 2` matrix `H` equals `minkHerm p` for the real
`p = momentumOfHerm2 H` with `p0 = (H00+H11)/2`, `p3 = (H00-H11)/2`,
`p1 = re H01`, `p2 = -im H01`. Since `twoEdgeMomentum psi phi` is Hermitian,

    minkowskiSq (momentumOfHerm2 (twoEdgeMomentum psi phi))
      = det (twoEdgeMomentum psi phi) = complexAbsSq (spinorWedge psi phi).

i.e. the null-edge Minkowski mass of a two-null-edge momentum EQUALS the
octonion-lane spinor Plucker mass. Claim label: **finite identity**. This is the
first kernel-checked stitch between the lanes.

### B1. Shared spinor module (Clifford identification). MEDIUM.

`Cl(6)`-on-`J` (charges) tensored with the spacetime Weyl-Clifford (null-edge
mass): the unified module is `J (x) (Weyl spinor)` with `Cl(6) (x) Cl(spacetime)`
acting. `Furey/CliffordConnection` already flags the full Mathlib
`CliffordAlgebra` identification as its medium-term target. Formalizing the
tensor is the structural core.

### B2. Chirality/mass <-> conjugate ideal (the deepest bet). HARD/CONCEPTUAL.

The null-edge "turn" - the chirality flip that IS mass
(`ChiralMassStructure`, NE-U2; the gamma5-even mass channel) - corresponds to
the `omega <-> omega*` conjugation between `J` and `J*`
(`Furey/ConjugateIdeal`, `omega* = (1 + i e7)/2`, `J* = (ℂ⊗𝕆) omega*`), which
is ALSO where the right-handed sector and the extra generations live. So **mass,
chirality, and generation structure may be one phenomenon**: conjugation between
the ideal and its conjugate. This is the highest-originality, least-formalized
claim; keep it label **conjecture** until a theorem forces it.

### B3. Confinement <-> color. MEDIUM/CONCEPTUAL.

The `SU(3)` of null-edge CLOSURE (the confinement/glueball mass, `NE-U3`
`ClosureObstruction` + `NE-U5` `MassWithoutMass`) is the SAME `SU(3)` that
emerges from octonion automorphisms (`G2AutomorphismSU3ActionPackage`). The color
group that produces confinement mass IS the octonion structure - dynamics and
kinematics of one object.

## 4. Where they meet: Spin(10) pure spinors

`Spinor/PureSpinor10` (Krasnov's `Spin(10)` two-pure-spinor characterization) is
the natural summit: the **16 of `Spin(10)` is exactly one generation**, the
octonions build it (`ℂ⊗𝕆 ~ Cl(6) ⊂ Cl(10)` spinor), and the Plucker mass lives
on it. GUT structure, generations, and null-edge mass could all converge there.
`Gauge/GUTSquare` already has the `G_SM -> SU(5)` embedding on the group side.

## 5. The lane-A internal chain (independent of null-edge): 1a, 1b

Separately from the null-edge bridges, lane A's own consolidation:

- **1a (group iso, TRACTABLE).** The octonion `SU(3)` is
  `su3Submonoid : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)`, carrier
  `{M | MatrixActsUnitaryOnC3 M ∧ det M = 1}`; and
  `matrixActsUnitaryOnC3_iff_conjTranspose_mul : MatrixActsUnitaryOnC3 M ↔
  M^dag * M = 1`. So the carrier is exactly `{M | M^dag M = 1 ∧ det M = 1}` =
  `Matrix.specialUnitaryGroup (Fin 3) ℂ`. The missing link is
  `MulEquiv su3Submonoid (Matrix.specialUnitaryGroup (Fin 3) ℂ)` - a predicate
  repackaging, identity on the underlying matrix. Claim label: **finite
  identity**. Connects the octonion `SU(3)` to the `Gauge/` and Mathlib `SU(3)`.
- **1b (fundamental rep <-> color triplet, CONCEPTUAL).** The Furey package is at
  the multiplet-DATA level (`colorDim`, `weakDim`, hypercharge matching
  `standardModelOneGeneration`), not the group-action level. Linking the `SU(3)`
  fundamental rep (`ℂ^3`, the complement of the complex line in `ℂ⊗𝕆`) to the
  Furey color-triplet STATES is the real content: the fundamental rep IS the
  color-triplet action. Claim label: **reconstruction** (statement layer first).

## 6. The unified statement being built toward

    (complex octonions)
       -> Cl(6) on the minimal ideal J           [Furey/CliffordConnection]
       -> SU(3) color (group)                     [1a: su3Submonoid ~ SU(3)]
       -> one anomaly-free generation of charges  [fureyRealizesOneGeneration]
    and the SAME spinors carry
       -> null-edge Plucker mass  det P = m^2      [B0: GateI1 ~ Spinor/PluckerMass]
       -> chirality/mass = omega<->omega* turn     [B2, conjecture]
       -> SU(3) closure = confinement mass          [B3]

read as: *the complex octonions yield `G_SM` acting on one anomaly-free
generation of spinors, and the null-edge geometry supplies the mass those same
spinors carry.*

## 7. Honest boundaries

- PROVED: the kinematics on both sides (charges from octonions; Plucker mass on
  spinors) and that they share the spinor and the Plucker construction.
- BUILT NEXT (tractable): B0 (Plucker unification) and 1a (SU(3) group iso).
- CONCEPTUAL/UNFORMALIZED: B1 (shared module tensor), B2 (chirality<->conjugate
  ideal - the deepest and most speculative), B3 (confinement<->color), 1b.
- SPECULATIVE (not a target): why transport is null; derived (vs inserted) mass
  scales; the full `ℝ⊗ℂ⊗ℍ⊗𝕆` synthesis. These stay reconstruction / conjecture
  labeled until a theorem forces them. The claim discipline is what keeps the
  unification defensible.

## 8. Implementation status (this session)

- B0 Plucker-mass unification: IN PROGRESS (draft
  `GateI1/PluckerUnificationBridge.lean`).
- 1a `su3Submonoid ~ specialUnitaryGroup`: IN PROGRESS.
- 1b fundamental-rep <-> color-triplet: statement-scoping.
