# θ-family wave 2 — completion memo

Kernel-only (standard three axioms: `propext`, `Classical.choice`, `Quot.sound`;
**no** `native_decide`, verified via `#print axioms` on every deliverable).
All results live in `ThetaFamilyCompletion.lean`, extending the namespaces
`PhysicsSM.Draft.NullEdge.ThetaFamilyProtection` (T1–T3) and
`PhysicsSM.Draft.NullEdge.CGGSVWZDictionary` (T4).

Build note: the five context modules import each other under the
`PhysicsSM.Draft.NullEdge.*` module path but ship in `context/`. They were left
byte-unchanged; a symlink tree `PhysicsSM/Draft/NullEdge/*.lean → context/*.lean`
plus two `lean_lib` stanzas in `lakefile.toml` make the import closure resolve.

## Deliverables

- **T1** `atlas_two_charts_family (θ b) (hb : wallCount b = 2)` :
  `M13 θ b = (M13 θ b)ᵀ ∨ M02 θ b = (M02 θ b)ᵀ`.
  The `modes_persist` body minus the engine step: `two_wall_chart` dispatch +
  `M13_selfadj_of`/`M02_selfadj_of`. Kernel + all-θ replacement of the
  fixed-angle `native_decide` atlas.
- **T2** entry witnesses + positional IFF (gate PASSED, see below):
  - `M13_antisymm_entry`, `M02_antisymm_entry`
  - `M13_selfadj_iff (θ b) : M13 θ b = (M13 θ b)ᵀ ↔ (signB (b 0) + signB (b 2)) * sin θ = 0`
  - `M02_selfadj_iff (θ b) : M02 θ b = (M02 θ b)ᵀ ↔ (signB (b 1) + signB (b 3)) * sin θ = 0`
- **T3** `Wth_eq_landed (θ₀) (hc : cos θ₀ = 4/5) (hs : sin θ₀ = 3/5) (b)` :
  `Wth θ₀ b = (Wof b).map (Rat.cast)` (with supporting
  `shiftR_eq_shiftQ_cast`, `coinR_eq_coinQ_cast`).
- **T4** `wallCount_compat`, `loneAt_compat`, `fixedSingleton_compat`
  (`by decide`, kernel): the `CGGSVWZDictionary` helper defs agree field-for-field
  with the landed `HalfPeriodInvariant` ones.

## T2 Step-1 GATE — closed form of every entry of `M13 θ b − (M13 θ b)ᵀ`

Chart `{1,3}` uses the fixed legs, in order, `(1,0),(1,1),(3,0),(3,1)` (rows /
cols `0,1,2,3`). Write `c = cos θ`, `sin = sin θ`, `sₖ = signB (b k)`. From the
pinned closed form `Wth = Wexp`, the compression is

```
        c0        c1        c2        c3
 r0 [   0      -s0·sin      c         0    ]
 r1 [ s2·sin      0         0         c    ]
 r2 [   c        0          0     -s2·sin  ]
 r3 [   0        c        s0·sin      0    ]   =  M13 θ b
```

so the antisymmetric part `A := M13 θ b − (M13 θ b)ᵀ` has all 16 entries:

| A(r,c) | c=0 | c=1 | c=2 | c=3 |
|--------|-----|-----|-----|-----|
| r=0 | 0 | −(s0+s2)·sin | 0 | 0 |
| r=1 | +(s0+s2)·sin | 0 | 0 | 0 |
| r=2 | 0 | 0 | 0 | −(s0+s2)·sin |
| r=3 | 0 | 0 | +(s0+s2)·sin | 0 |

**Every nonzero entry is `±(signB (b 0) + signB (b 2)) · sin θ`** — a single trig
monomial. The kill condition does NOT fire: the gate PASSES, so the entrywise
IFF is honest (not an entrywise-by-luck coincidence). The distinguished entry is
`A(0,1) = −(signB (b 0) + signB (b 2))·sin θ` (`M13_antisymm_entry`).

Mirror chart `{0,2}` (fixed legs `(0,0),(0,1),(2,0),(2,1)`) gives, identically,
every nonzero entry `±(signB (b 1) + signB (b 3))·sin θ`, e.g.
`(M02 θ b − (M02 θ b)ᵀ)(0,1) = −(signB (b 1) + signB (b 3))·sin θ`
(`M02_antisymm_entry`).

### Why the IFF holds

`(→)` If the compression is self-adjoint, its antisymmetric part is `0`, so in
particular `A(0,1) = −(s0+s2)·sin = 0`, i.e. `(s0+s2)·sin θ = 0`.

`(←)` If `(s0+s2)·sin θ = 0`, then **every** entry of `A` is `±(s0+s2)·sin θ = 0`
(the table above has no other monomial), so `M13 θ b = (M13 θ b)ᵀ`. Note this is
strictly weaker than the sufficiency hypothesis `signB (b 0)+signB (b 2)=0` of
`M13_selfadj_of`: the massless boundary `sin θ = 0` also makes the chart
self-adjoint, and the IFF captures both branches exactly.

This subsumes the fixed-angle fixture iff and the T5 negative controls as
instances: e.g. the blind singleton `![true,true,true,false]` has
`signB (b 0)+signB (b 2) = 1+1 = 2 ≠ 0`, so it is self-adjoint in `{1,3}` iff
`sin θ = 0` — exactly the `−2·sin θ` failure recorded in `control_blind_entry`.
```
