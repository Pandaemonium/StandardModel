# Aristotle semantic context pack

Generated: 2026-06-25T15:07:16
Query: `NullStrand synchronization holonomy path independence commuting kernels internal holonomy defect curvature`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md` [Area 2: Causal-diamond holonomy and gauge curvature on a causal DAG]

Score: `0.803`

```text
e diamond boundary) agree up to a 2-morphism; the failure of agreement IS the surface holonomy, and the fake-curvature defect F − t(B) measured across the diamond defines the discrete F. This reframes the treatise's "phase differences between competing null histories across a causal diamond" as precisely a 2-group surface holonomy / fake-curvature measurement, giving it rigorous content. The theorem to prove: that this discrete F converges (in the BHS-Lorentz-invariant sprinkling sense) to the continuum NAST flux, and in the mean reproduces Sverdlov's triangle-holonomy F. This is a concrete, novel, simulation-free target. (Caveat: "competing null histories" is not established terminology in the literature; it is treated here as a description to be formalized.)
```

### 2. `PhysicsSM/Gauge/CausalDiamondHolonomy.lean` [pathPairDefect_horizontalCompose]

Score: `0.803`

```text
theorem pathPairDefect_horizontalCompose [Group G]
    (P Q : PathPair G) (h : P.right = Q.left) :
    pathPairDefect (horizontalComposePathPair P Q) =
      pathPairDefect P * pathPairDefect Q := by
  simp [pathPairDefect, horizontalComposePathPair, h, mul_assoc]

/-- A path-pair defect is trivial exactly when the two branch holonomies agree. -/
```

### 3. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [Pillar 5 — Causal-diamond holonomy instead of plaquettes]

Score: `0.794`

```text
laws for the holonomy
defect and the Abelian multiplication specialization. Literature additions
from this pass: Wilson `QDII2KHM` in Neo4j, plus Zotero keys `AHK54SN9`,
`K9XTAJUM`, and `Z38RZX2Q` for higher-gauge/surface-holonomy context.

**New target after the categorical feedback.** The trusted vertical and
horizontal composition laws should be tested against the interchange law of a
double category:

```lean
pathPairDefect_interchange
```

If it holds, the next layer is a crossed-module 2-group wrapper with:

```lean
fakeFlatness_iff_surfaceTransport_welldefined
crossedModule_action_eq_endpoint_covariance
```

Here fake-flatness means the `H`-valued 2-cell label maps under
`partial : H -> G` to the ordinary path-pair defect, and the non-Abelian
endpoint covariance is the `G`-action on `H`. If interchange fails, that is a
useful obstruction: the causal-diamond API may be a weaker categorical object
rather than a 2-group.

**Falsification.** Path-comparison defects are not gauge invariant, the
vertical/horizontal laws fail interchange, or their continuum limit fails to
reproduce field strength.

---
```

### 4. `PhysicsSM/Gauge/CausalDiamondHolonomy.lean` [PathPair]

Score: `0.790`

```text
structure PathPair (G : Type*) where
  left : G
  right : G

/-- The path-comparison defect of a pair of parallel branch holonomies. -/
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Trusted causal-diamond holonomy layer]

Score: `0.788`

```text
### Trusted causal-diamond holonomy layer

`PhysicsSM.Gauge.CausalDiamondHolonomy` gives a trusted finite gauge-curvature
carrier for causal DAGs:

- Abelian diamond defects are gauge invariant;
- non-Abelian defects are endpoint-covariant;
- class functions of non-Abelian defects are gauge invariant;
- path-pair defects compose under vertical and horizontal gluing.

This makes "curvature as disagreement of competing causal histories" a
kernel-checked finite theorem, not just a metaphor.
```

### 6. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [P3. Causal-diamond holonomy: finite gauge curvature without plaquettes]

Score: `0.787`

```text
### P3. Causal-diamond holonomy: finite gauge curvature without plaquettes

Core claim. Gauge curvature on a causal graph can be measured by holonomy
defects across causal diamonds, with finite, kernel-checked invariance and
composition laws, replacing the lattice plaquette.

Banked Lean. `PhysicsSM.Gauge.CausalDiamondHolonomy` (trusted): Abelian gauge
invariance, non-Abelian endpoint covariance, gauge invariance of class functions
of the defect, and vertical and horizontal composition laws for path-pair
defects. `PhysicsSM.Draft.NullEdgeP3CrossedModule` (draft, kernel-checked)
adds the first higher-gauge wrapper: fake-flatness is preserved by vertical and
horizontal 2-cell composition, and the crossed-module 2-cell labels satisfy the
double-category interchange law.

Remaining. The decisive structural test is no longer "does interchange hold?"
at the abstract 2-cell level; that is now banked. The next step is semantic and
geometric: identify which finite `H`-valued 2-cell labels, endpoint actions,
surface-transport rules, and fake-flatness constraints are actually forced by
the trusted path-pair API and by physically meaningful causal diamonds. This is
finite higher-gauge algebra, not a continuum Stokes theorem.

Lead venue. An interactive-theorem-proving venue or a discrete-gravity /
classical-and-quantum-gravity venue.

Literature anchors. Sverdlov causal-set gauge fields; Baez-Schreiber higher
gauge theory; Wilson lattice gauge theory as the contrast object.

Claim boundary. These are finite gauge-invariant defects and their composition
algebra, not a continuum Stokes theorem.
```

### 7. `PhysicsSM/Draft/NullEdgeOvernightSynthesisAristotle.lean` [pathPairDefect_verticalStack_transport]

Score: `0.786`

```text
theorem pathPairDefect_verticalStack_transport [Group G]
    (Ps : List (PathPair G)) :
    pathPairDefect (verticalStack Ps) = transportedDefectProduct Ps := by
  induction' Ps with P Ps ih <;> simp_all +decide [ verticalStack, transportedDefectProduct ];
  · exact pathPairDefect_flatPathPair 1
  · convert PhysicsSM.Gauge.CausalDiamondHolonomy.pathPairDefect_verticalCompose P ( verticalStack Ps ) using 1 ; aesop

/-
Finite Abelian vertical Stokes theorem: in a commutative gauge group, all
transport corrections disappear and the stack defect is the product of the
individual cell defects.
-/
```

### 8. `AgentTasks/null-edge-super-dirac-conjecture-attack-plan-2026-06-23.md` [Layer 4: diamond holonomy equals curvature block]

Score: `0.786`

```text
### Layer 4: diamond holonomy equals curvature block

Existing triangle curvature:

```text
kappa(i,j,k) = U_ij U_jk - U_ik.
```

For a minimal diamond with two paths `p -> a -> q` and `p -> b -> q`, plus a
direct comparison edge `p -> q`, target:

```text
diamond defect = kappa(p,a,q) - kappa(p,b,q)       -- Abelian/additive version
```

or multiplicatively:

```text
Delta = (U_pa U_aq U_pq^{-1}) * (U_pb U_bq U_pq^{-1})^{-1}.
```

Lean targets:

```lean
diamondDefect_eq_triangleCurvature_ratio
diamondHolonomy_linearized_eq_triangleCurvature_difference
covariantOrderDifferential_sq_eq_diamondCurvature
```

The first target should probably be a focused standalone Aristotle job in the
Abelian scalar transport setting.
```

## Scoped paper hits

No paper hits returned.
