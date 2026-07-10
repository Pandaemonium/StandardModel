# Aristotle semantic context pack

Generated: 2026-07-09T16:01:50
Query: `finite soldering coframe local frame covariance connection defect torsion holonomy transform orthogonal action`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `docs/NULLSTRAND.md` [Frame term and tetrad compatibility]

Score: `0.817`

```text
## Frame term and tetrad compatibility

The finite square should be decomposed as:

```text
D_N^2 = Box_null + C_diamond + T_frame
```

with:

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

The finite tetrad postulate is:

```text
[nabla_a, C_b] = 0
```

or the corresponding edge-transport compatibility equation. If this fails,
classify the defect rather than hiding it:

- Nonmetricity or bad soldering if metric compatibility fails.
- Curvature or holonomy if metric compatibility holds but connection
  commutators survive.
- Torsion-like defect if edge parallelograms fail to close or antisymmetric
  displacement defects appear.
- Smooth-limit contamination if `C_b` jumps by order one across `h`-edges.
```

### 2. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_commutator]

Score: `0.798`

```text
theorem holonomyDefect_swap_eq_commutator {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = A * B - B * A := by
  simp [holonomyDefect, internalHolonomy]

/-- **Curvature defect detects commutativity.**

The elementary-square defect vanishes exactly when the two transports commute,
i.e. path independence around the square is equivalent to vanishing curvature. -/
```

### 3. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [internalHolonomy_gaugeCovariant_path]

Score: `0.794`

```text
theorem internalHolonomy_gaugeCovariant_path {N : ℕ} {d : Type*}
    [Fintype d] [DecidableEq d] (U : Matrix.unitaryGroup d ℂ) (Δs : Fin (N + 1) → ℝ)
    (M : Fin (N + 1) → Matrix d d ℂ) :
    internalHolonomyPath Δs (fun i => (U : Matrix d d ℂ) * M i * ((U : Matrix d d ℂ))⁻¹) =
      (U : Matrix d d ℂ) * internalHolonomyPath Δs M * ((U : Matrix d d ℂ))⁻¹ := by
  unfold internalHolonomyPath
  induction N with
  | zero =>
    simp only [List.ofFn_succ, List.ofFn_zero]
    simp [internalHolonomy, internalSegment_conj]
  | succ k ih =>
    have hUU := U.2.2
    have hcong :=
      congr_arg (fun x => internalSegment (Δs 0) (U.val * M 0 * U.val⁻¹) * x)
        (ih (fun i => Δs i.succ) (fun i => M i.succ))
    convert hcong using 1
    · simp only [internalHolonomy, List.ofFn_succ, List.prod_cons]
    · unfold internalHolonomy
      simp only [← mul_assoc, internalSegment_conj]
      simp [mul_assoc, Matrix.inv_eq_right_inv hUU]

/-! ## Synchronization: commuting transports, path independence, holonomy defect

This section connects three notions in the synchronization lane of the
NullStrand roadmap:

* **commuting local transports** (the internal segments commute),
* **path independence** of the ordered internal holonomy (reordering the
  transports leaves the holonomy unchanged), and
* a finite **holonomy/curvature defect** that measures, and exactly detects, the
  failure of path independence.

All statements are finite, kernel-checkable group/ring facts about ordered
matrix products. They do not assert any continuum Stokes theorem or continuum
field strength. The additive elementary-square defect is the matrix (Lie)
commutator `A * B - B * A`; the multiplicative defect lives in the unitary
group and is the group commutator. -/

/-- **Path independence from commuting trans
```

### 4. `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean` [holonomyDefect_swap_eq_zero_iff_commute]

Score: `0.794`

```text
theorem holonomyDefect_swap_eq_zero_iff_commute {d : Type*} [Fintype d] [DecidableEq d]
    (A B : Matrix d d ℂ) :
    holonomyDefect [A, B] [B, A] = 0 ↔ Commute A B := by
  rw [holonomyDefect_swap_eq_commutator, sub_eq_zero]
  exact Iff.rfl

/-- **Failure of path independence from nonvanishing curvature.**

If the matrix commutator (curvature defect) is nonzero, then the two ways around
the elementary square give genuinely different holonomies: synchronization is
path dependent. This is the contrapositive direction of the defect/flatness
correspondence. -/
```

### 5. `AgentTasks/aristotle-downloads-wave12-13-20260626/fur-h6-dvt-jordan-yukawa-constraint-audit/fur-h6-dvt-jordan-yukawa-constraint-audit_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [19.5 Covariance and local frame discipline]

Score: `0.792`

```text
### 19.5 Covariance and local frame discipline

The strongest new warning in this note is covariance:

```text
A fixed null lattice is not relativistic enough.
```

The null frame and dual soldering data must be local:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature must enter through holonomy around finite null diamonds, and the continuum limit must recover the Lorentzian Dirac/Lichnerowicz structure with audited signs and normalizations.

Continue to reject the diagonal architecture:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

as the basic Dirac symbol. The active architecture is dual-soldered:

```text
sum_a c(alpha^a) nabla_{ell_a}
```

This covariance/local-frame point should be added to P2 handoffs and to any no-doubling or continuum-symbol Aristotle job. It is one of the cleanest lines between a suggestive fixed-null-lattice model and a viable relativistic finite geometry.
```

### 6. `AgentTasks/aristotle-downloads-wave12-13-20260626/c59-post-c21-projected-release-criterion/c59-post-c21-projected-release-criterion_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [19.5 Covariance and local frame discipline]

Score: `0.792`

```text
### 19.5 Covariance and local frame discipline

The strongest new warning in this note is covariance:

```text
A fixed null lattice is not relativistic enough.
```

The null frame and dual soldering data must be local:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature must enter through holonomy around finite null diamonds, and the continuum limit must recover the Lorentzian Dirac/Lichnerowicz structure with audited signs and normalizations.

Continue to reject the diagonal architecture:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

as the basic Dirac symbol. The active architecture is dual-soldered:

```text
sum_a c(alpha^a) nabla_{ell_a}
```

This covariance/local-frame point should be added to P2 handoffs and to any no-doubling or continuum-symbol Aristotle job. It is one of the cleanest lines between a suggestive fixed-null-lattice model and a viable relativistic finite geometry.
```

### 7. `AgentTasks/aristotle-downloads-wave12-13-20260626/c58-projected-branch-weyl-projector/c58-projected-branch-weyl-projector_aristotle/Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` [19.5 Covariance and local frame discipline]

Score: `0.792`

```text
### 19.5 Covariance and local frame discipline

The strongest new warning in this note is covariance:

```text
A fixed null lattice is not relativistic enough.
```

The null frame and dual soldering data must be local:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature must enter through holonomy around finite null diamonds, and the continuum limit must recover the Lorentzian Dirac/Lichnerowicz structure with audited signs and normalizations.

Continue to reject the diagonal architecture:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

as the basic Dirac symbol. The active architecture is dual-soldered:

```text
sum_a c(alpha^a) nabla_{ell_a}
```

This covariance/local-frame point should be added to P2 handoffs and to any no-doubling or continuum-symbol Aristotle job. It is one of the cleanest lines between a suggestive fixed-null-lattice model and a viable relativistic finite geometry.
```

### 8. `Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md` [19.5 Covariance and local frame discipline]

Score: `0.792`

```text
### 19.5 Covariance and local frame discipline

The strongest new warning in this note is covariance:

```text
A fixed null lattice is not relativistic enough.
```

The null frame and dual soldering data must be local:

```text
ell_a = ell_a(x)
alpha^a = alpha^a(x)
```

Curvature must enter through holonomy around finite null diamonds, and the continuum limit must recover the Lorentzian Dirac/Lichnerowicz structure with audited signs and normalizations.

Continue to reject the diagonal architecture:

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

as the basic Dirac symbol. The active architecture is dual-soldered:

```text
sum_a c(alpha^a) nabla_{ell_a}
```

This covariance/local-frame point should be added to P2 handoffs and to any no-doubling or continuum-symbol Aristotle job. It is one of the cleanest lines between a suggestive fixed-null-lattice model and a viable relativistic finite geometry.
```

## Scoped paper hits

### 1. Spinors and Twistors in Loop Gravity and Spin Foams

Score: `0.753`
Zotero key: `TCC2N3U6`
arXiv: `1201.2120`
URL: http://arxiv.org/abs/1201.2120

Abstract:

Spinorial tools have recently come back to fashion in loop gravity and spin foams. They provide an elegant tool relating the standard holonomy-flux algebra to the twisted geometry picture of the classical phase space on a fixed graph, and to twistors. In these lectures we provide a brief and technical introduction to the formalism and some of its applications.

### 2. Connections on non-abelian Gerbes and their Holonomy

Score: `0.745`
URL: http://arxiv.org/abs/0808.1923

### 3. Torsion Degrees of Freedom in the Regge Calculus as Dislocations on the Simplicial Lattice

Score: `0.728`
Zotero key: `IJ2MZ3FH`
arXiv: `gr-qc/0103111`
DOI: `10.1023/A:1013031402382`
URL: http://arxiv.org/abs/gr-qc/0103111

Abstract:

Using the notion of a general conical defect, the Regge Calculus is generalized by allowing for dislocations on the simplicial lattice in addition to the usual disclinations. Since disclinations and dislocations correspond to curvature and torsion singularities, respectively, the method we propose provides a natural way of discretizing gravitational theories with torsion degrees of freedom like the Einstein-Cartan theory. A discrete version of the Einstein-Cartan action is given and field equations are derived, demanding stationarity of the action with respect to the discrete variables of the theory.

### 4. On the definition of spacetimes in Noncommutative Geometry, Part I

Score: `0.714`
Zotero key: `5VWPZ8BP`
arXiv: `1611.07830`
DOI: `10.48550/arXiv.1611.07830`
URL: https://arxiv.org/abs/1611.07830

Abstract:

Part I develops Lorentzian spectral-spacetime foundations in the commutative continuous case, including signature characterization by time-orientation one-forms and a Krein product on spinors.

### 5. Teleparallel Gravity as a Higher Gauge Theory

Score: `0.712`
Zotero key: `IA95AD45`
arXiv: `1204.4339`
DOI: `10.1007/s00220-014-2178-7`
URL: https://www.zotero.org/19894138/items/IA95AD45

Abstract:

We show that general relativity can be viewed as a higher gauge theory involving a categorical group, or 2-group, called the teleparallel 2-group. On any semi-Riemannian manifold M, we first construct a principal 2-bundle with the Poincaré 2-group as its structure 2-group. Any flat metric-preserving connection on M gives a flat 2-connection on this 2-bundle, and the key ingredient of this 2-connection is the torsion. Conversely, every flat strict 2-connection on this 2-bundle arises in this way if M is simply connected and has vanishing 2nd deRham cohomology. Extending from the Poincaré 2-group to the teleparallel 2-group, a 2-connection includes an additional piece: a coframe field. Taking advantage of the teleparallel reformulation of general relativity, which uses a coframe field, a flat connection and its torsion, this lets us rewrite general relativity as a theory with a 2-connection for the teleparallel 2-group as its only field.
