# Aristotle semantic context pack

Generated: 2026-07-16T21:21:53
Query: `finite strict causal order layer zero immediate predecessor antichain disjoint interval count layers order isomorphism equivariance`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean` [FiniteCausalOrder.pastLayer]

Score: `0.883`

```text
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- An isomorphism of finite causal orders. -/
```

### 2. `AgentTasks/marked-alexandrov-layer-shell-aristotle-2026-07-16.md` [Objective]

Score: `0.877`

```text
## Objective

Prove the exact order-only gates for the marked-Alexandrov shell proposal. For
every finite strict causal order, the zero-open-interval past layer of a marked
event is an antichain, is disjoint from the proposed positive layers one and
three, and is transported exactly by every causal-order isomorphism.
```

### 3. `AgentTasks/model-calls/claude/2026-07-16-170842-corrected-pairing-carrier-inertia.md` [Finite causal-order construction of the scalar metric operator]

Score: `0.866`

```text
of events strictly between `y` and `x`. -/
def FiniteCausalOrder.OpenInterval
    (C : FiniteCausalOrder V) (y x : V) :=
  {z : V // C.before y z ∧ C.before z x}

instance (C : FiniteCausalOrder V) (y x : V) :
    Fintype (C.OpenInterval y x) := by
  unfold FiniteCausalOrder.OpenInterval
  infer_instance

/-- Number of events in the strict open interval from `y` to `x`. -/
def FiniteCausalOrder.openIntervalCount
    (C : FiniteCausalOrder V) (y x : V) : Nat :=
  Fintype.card (C.OpenInterval y x)

/-- The `n`th past layer of `x`: predecessors with exactly `n` intervening
events. -/
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- An isomorphism of finite causal orders. -/
structure OrderIso (C : FiniteCausalOrder V) (D : FiniteCausalOrder W) where
  toEquiv : V ≃ W
  map_before_iff : forall x y,
    D.before (toEquiv x) (toEquiv y) ↔ C.before x y

/-- An order isomorphism induces an equivalence of every open interval. -/
def OrderIso.openIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    C.OpenInterval y x ≃
      D.OpenInterval (e.toEquiv y) (e.toEquiv x) where
  toFun z := ⟨e.toEquiv z.1,
    (e.map_before_iff y z.1).2 z.property.1,
    (e.map_before_iff z.1 x).2 z.property.2⟩
  invFun z := ⟨e.toEquiv.symm z.1,
    (e.map_before_iff y (e.toEquiv.symm z.1)).1
      (by simpa using z.property.1),
    (e.map_before_iff (e.toEquiv.symm z.1) x).1
      (by simpa using z.property.2)⟩
  left_inv z := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C
```

### 4. `AgentTasks/model-calls/gemini/2026-07-16-170951-corrected-pairing-carrier-inertia.md` [Finite causal-order construction of the scalar metric operator]

Score: `0.865`

```text
of events strictly between `y` and `x`. -/
def FiniteCausalOrder.OpenInterval
    (C : FiniteCausalOrder V) (y x : V) :=
  {z : V // C.before y z ∧ C.before z x}

instance (C : FiniteCausalOrder V) (y x : V) :
    Fintype (C.OpenInterval y x) := by
  unfold FiniteCausalOrder.OpenInterval
  infer_instance

/-- Number of events in the strict open interval from `y` to `x`. -/
def FiniteCausalOrder.openIntervalCount
    (C : FiniteCausalOrder V) (y x : V) : Nat :=
  Fintype.card (C.OpenInterval y x)

/-- The `n`th past layer of `x`: predecessors with exactly `n` intervening
events. -/
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- An isomorphism of finite causal orders. -/
structure OrderIso (C : FiniteCausalOrder V) (D : FiniteCausalOrder W) where
  toEquiv : V ≃ W
  map_before_iff : forall x y,
    D.before (toEquiv x) (toEquiv y) ↔ C.before x y

/-- An order isomorphism induces an equivalence of every open interval. -/
def OrderIso.openIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    C.OpenInterval y x ≃
      D.OpenInterval (e.toEquiv y) (e.toEquiv x) where
  toFun z := ⟨e.toEquiv z.1,
    (e.map_before_iff y z.1).2 z.property.1,
    (e.map_before_iff z.1 x).2 z.property.2⟩
  invFun z := ⟨e.toEquiv.symm z.1,
    (e.map_before_iff y (e.toEquiv.symm z.1)).1
      (by simpa using z.property.1),
    (e.map_before_iff (e.toEquiv.symm z.1) x).1
      (by simpa using z.property.2)⟩
  left_inv z := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C
```

### 5. `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`

Score: `0.857`

```text
namespace PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-! ## Finite strict causal orders and their intervals -/

/-- A finite strict causal order. Irreflexivity and transitivity exclude
directed causal cycles. -/
```

### 6. `AgentTasks/model-calls/claude/2026-07-16-170842-corrected-pairing-carrier-inertia.md` [Finite causal-order construction of the scalar metric operator]

Score: `0.849`

```text
:= by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    D.openIntervalCount (e.toEquiv y) (e.toEquiv x) =
      C.openIntervalCount y x := by
  exact (Fintype.card_congr (e.openIntervalEquiv y x)).symm

/-- Relabel a scalar field along an order isomorphism. -/
def OrderIso.relabelField
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) : W -> K :=
  fun w => phi (e.toEquiv.symm w)

@[simp] theorem OrderIso.relabelField_apply
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) (x : V) :
    e.relabelField phi (e.toEquiv x) = phi x := by
  simp [OrderIso.relabelField]

/-! ## Layered order/count operators -/

/-- Weighted sum over all strict causal predecessors. The weight may depend
only on the open-interval count. -/
def FiniteCausalOrder.layeredPastSum
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (coefficient : Nat -> K) (phi : V -> K) (x : V) : K :=
  ∑ y : V, if C.before y x then
    coefficient (C.openIntervalCount y x) * phi y else 0

/-- A normalized diagonal-plus-past layered operator. -/
def FiniteCausalOrder.layeredOperator
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) : K :=
  prefactor * (diagonal * phi x + C.layeredPastSum coefficient phi x)

/-- The weighted past sum commutes with every order isomorphism. -/
theorem OrderIso.layeredPastSum_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : Orde
```

### 7. `AgentTasks/model-calls/gemini/2026-07-16-170951-corrected-pairing-carrier-inertia.md` [Finite causal-order construction of the scalar metric operator]

Score: `0.848`

```text
:= by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    D.openIntervalCount (e.toEquiv y) (e.toEquiv x) =
      C.openIntervalCount y x := by
  exact (Fintype.card_congr (e.openIntervalEquiv y x)).symm

/-- Relabel a scalar field along an order isomorphism. -/
def OrderIso.relabelField
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) : W -> K :=
  fun w => phi (e.toEquiv.symm w)

@[simp] theorem OrderIso.relabelField_apply
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) (x : V) :
    e.relabelField phi (e.toEquiv x) = phi x := by
  simp [OrderIso.relabelField]

/-! ## Layered order/count operators -/

/-- Weighted sum over all strict causal predecessors. The weight may depend
only on the open-interval count. -/
def FiniteCausalOrder.layeredPastSum
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (coefficient : Nat -> K) (phi : V -> K) (x : V) : K :=
  ∑ y : V, if C.before y x then
    coefficient (C.openIntervalCount y x) * phi y else 0

/-- A normalized diagonal-plus-past layered operator. -/
def FiniteCausalOrder.layeredOperator
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) : K :=
  prefactor * (diagonal * phi x + C.layeredPastSum coefficient phi x)

/-- The weighted past sum commutes with every order isomorphism. -/
theorem OrderIso.layeredPastSum_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : Orde
```

### 8. `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean` [IntrinsicProbeSector.probe_constant_of_automorphismTransitive]

Score: `0.843`

```text
theorem IntrinsicProbeSector.probe_constant_of_automorphismTransitive
    {r : Nat} (P : IntrinsicProbeSector r)
    {U : Type} [Fintype U]
    (C : FiniteCausalOrder U) (htrans : C.AutomorphismTransitive)
    (a : Fin r) (x y : U) :
    P.probe C a x = P.probe C a y := by
  obtain ⟨e, he⟩ := htrans x y
  simpa [he] using
    (P.probe_orderAutomorphism_invariant C e a x).symm

/-- The two-event antichain is a concrete symmetric strict causal order. -/
```

### 9. `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean` [twoEventAntichain]

Score: `0.835`

```text
def twoEventAntichain : FiniteCausalOrder (Fin 2) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the two-event antichain lies in one order-automorphism
orbit. This witnesses that the symmetry hypothesis in the probe no-go is
nonvacuous. -/
```

### 10. `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean` [OrderIso.layeredPastSum_equivariant]

Score: `0.835`

```text
theorem OrderIso.layeredPastSum_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} [Semiring K]
    (coefficient : Nat -> K) (phi : V -> K) (x : V) :
    D.layeredPastSum coefficient (e.relabelField phi) (e.toEquiv x) =
      C.layeredPastSum coefficient phi x := by
  unfold FiniteCausalOrder.layeredPastSum
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro y
  by_cases hbefore : C.before y x
  · have hmap : D.before (e.toEquiv y) (e.toEquiv x) :=
      (e.map_before_iff y x).2 hbefore
    simp [hbefore, hmap, e.openIntervalCount_eq]
  · have hmap : ¬ D.before (e.toEquiv y) (e.toEquiv x) :=
      fun h => hbefore ((e.map_before_iff y x).1 h)
    simp [hbefore, hmap]

/-- Every layered operator commutes with order isomorphisms. -/
```

## Scoped paper hits

### 1. Tri-partitions and Bases of an Ordered Complex

Score: `0.771`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 2. Local d'Alembertian for causal sets

Score: `0.762`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 3. Space-time as a causal set

Score: `0.744`
Zotero key: `I8DJ26QC`
DOI: `10.1103/PhysRevLett.59.521`
URL: https://www.zotero.org/19894138/items/I8DJ26QC

### 4. Symmetry-breaking and zero-one laws

Score: `0.734`
Zotero key: `342HA4DS`
arXiv: `1909.06070`
DOI: `10.1088/1361-6382/ab81cd`
URL: http://arxiv.org/abs/1909.06070

Abstract:

We offer further evidence that discreteness of the sort inherent in a causal set cannot, in and of itself, serve to break Poincar{é} invariance. In particular we prove that a Poisson sprinkling of Minkowski spacetime cannot endow spacetime with a distinguished spatial or temporal orientation, or with a distinguished lattice of spacetime points, or with a distinguished lattice of timelike directions (corresponding respectively to breakings of reflection-invariance, translation-invariance, and Lorentz invariance). Along the way we provide a proof from first principles of the zero-one law on which our new arguments are based.

### 5. Localized States for Elementary Systems

Score: `0.730`
Zotero key: `74NU4C33`
DOI: `10.1103/revmodphys.21.400`
URL: https://doi.org/10.1103/revmodphys.21.400

### 6. Spacelike distance from discrete causal order

Score: `0.726`
Zotero key: `RQ6WWH5I`
arXiv: `0810.1768`
DOI: `10.1088/0264-9381/26/15/155013`
URL: http://arxiv.org/abs/0810.1768

Abstract:

Any discrete approach to quantum gravity must provide some prescription as to how to deduce continuum properties from the discrete substructure. In the causal set approach it is straightforward to deduce timelike distances, but surprisingly difficult to extract spacelike distances, because of the unique combination of discreteness with local Lorentz invariance in that approach. We propose a number of methods to overcome this difficulty, one of which reproduces the spatial distance between two points in a finite region of Minkowski space. We provide numerical evidence that this definition can be used to define a `spatial nearest neighbor' relation on a causal set, and conjecture that this can be exploited to define the length of `continuous curves' in causal sets which are approximated by curved spacetime. This provides evidence in support of the ``Hauptvermutung'' of causal sets.
