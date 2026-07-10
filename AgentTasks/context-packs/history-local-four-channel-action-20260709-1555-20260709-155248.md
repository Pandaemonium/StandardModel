# Aristotle semantic context pack

Generated: 2026-07-09T15:52:56
Query: `checkerboard null histories local action aperture closure turn soldering corner phase exp i pi over two`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/checkerboard-corner-closed-forms-split-aristotle-2026-06-13.md` [Aristotle task: checkerboard corner closed forms split]

Score: `0.757`

```text
# Aristotle task: checkerboard corner closed forms split

Date: 2026-06-13
```

### 2. `PhysicsSM/Draft/NullEdgeP9BFClosure.lean`

Score: `0.753`

```text
namespace PhysicsSM.Draft.NullEdgeP9BFClosure
```

### 3. `AgentTasks/context-packs/null-edge-bargmann-phase-invariance-20260621-manual.md` [Aristotle manual context pack]

Score: `0.749`

```text
# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
closed-loop Bargmann Pancharatnam phase invariance under local unit complex
phase rescaling over the trusted Pluecker and Bargmann phase API
```
```

### 4. `PhysicsSM/Draft/CheckerboardCornerCountAristotle.lean` [sequence]

Score: `0.747`

```text
tes endpoints, flips terminal directions, and preserves
  `turnCount`; transport the count along it
  (`List.length_filter`-respecting bijection, or `List.count` via an
  injective map on `histories n`).

Do not change any definition of `PhysicsSM.Spinor.Checkerboard`.  Helper
lemmas are welcome.  No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, and
**no `n a t i v e _ d e c i d e`** in the final state.

This is draft code: the statements below contain documented `s o r r y`s and
must not be imported from trusted code until the holes are eliminated.
-/
```

### 5. `PhysicsSM/Draft/NullEdgeP9ClosureDefect.lean`

Score: `0.742`

```text
namespace PhysicsSM.Draft.NullEdgeP9ClosureDefect
```

### 6. `PhysicsSM/NullStrand/Master/Checkerboard.lean` [checkerboardBohmBell_master]

Score: `0.740`

```text
eable_nStep_equivariant model.beable model.density n
  · exact coinBornTransport_isStochastic model.beable model.density model.density_nonneg
  · intro x d n y e
    exact pathSum_eq_iterate_evolve model.cornerWeight x d n y e
  · exact iidTrajMeasure_isProbability stepLaw

/-- Concrete non-vacuity witness for the strengthened checkerboard model: a
single lattice site, the identity coin kernel, the zero Born density, an
arbitrary corner weight, and a genuine **null** zig-zag shift whose two
chirality branches move at the speed of light along `±x`
(`step c = ![1, ±1, 0, 0]`, each Minkowski-null in the `(+---)` convention). This
exhibits `CheckerboardBohmBellModel` as inhabited *with the Minkowski-nullity
constraint `NullShift.null` active*, so the strengthened conjunct (1) of
`checkerboardBohmBell_master` is non-vacuous. -/
```

### 7. `PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean` [length_turnHistories_right_right_odd]

Score: `0.739`

```text
theorem length_turnHistories_right_right_odd (n : Nat) (dx : Int) (r : Nat) :
    (turnHistories n Direction.right dx Direction.right (2 * r + 1)).length
      = 0 := by
  unfold turnHistories;
  rw [ List.filter_eq_nil_iff.mpr ] ; simp +decide;
  intro h hh H; have := terminalDirection_eq_ite right h; simp_all +decide ;
  grind

end PhysicsSM.Draft.CheckerboardCornerClosedForms
```

### 8. `AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md` [Aristotle task: checkerboard endpoint kernel closed forms]

Score: `0.737`

```text
# Aristotle task: checkerboard endpoint kernel closed forms

Date: 2026-06-21
```

## Scoped paper hits

### 1. Locality properties of Neuberger's lattice Dirac operator

Score: `0.677`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 2. Notes on The Feynman Checkerboard Problem

Score: `0.676`
Zotero key: `7Z3X3HMK`
arXiv: `1012.1564`
URL: https://www.zotero.org/19894138/items/7Z3X3HMK

Abstract:

The Feynman checkerboard problem is an interesting path integral approach to the Dirac equation in `1+1' dimensions. I compare two approaches reported in the literature and show how they may be reconciled. Some physical insights may be gleaned from this approach.

### 3. Local d'Alembertian for causal sets

Score: `0.674`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 4. The Spectral Action Principle

Score: `0.673`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 5. Normalized Laplacians for gain graphs

Score: `0.673`
Zotero key: `S78BASEN`
DOI: `10.63151/amjc.v1i.3`
URL: https://doi.org/10.63151/amjc.v1i.3
