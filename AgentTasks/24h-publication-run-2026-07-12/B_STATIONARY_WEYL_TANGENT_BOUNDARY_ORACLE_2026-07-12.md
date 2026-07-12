# Stationary-Weyl omitted tangent-boundary oracle

Date: 2026-07-12  
Owner: Codex  
Status: exact external algebra oracle; not a Lean theorem

## Question and scope

The tangent-half-angle census in
`B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md` uses

```text
z_j = exp(i q_j) = (1 - t_j^2 + 2 i t_j) / (1 + t_j^2),
t_j = tan(q_j / 2).
```

That affine chart omits exactly `z_j = -1` (`q_j = pi`). This sidecar analyzes
the live ordered symbol

```text
weylStep(zx, zy, zz) = Ux(zx) Uy(zy) Uz(zz)
```

from
`PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean` on every
omitted stratum. The seven disjoint charts are the three faces with exactly
one phase fixed at `-1`, the three edges with exactly two phases fixed at
`-1`, and the all-`-1` corner. Every remaining phase is represented by a
finite real tangent variable, so the charts are disjoint and exhaustive.

The calculation uses exact rational arithmetic and Groebner bases over `QQ`.
It is reproducible evidence and theorem discovery, not kernel-checked proof.

## Reproduction

Environment used:

```text
Python 3.12.10
SymPy 1.14.0
```

Command from the repository root:

```powershell
python Scripts/oracle/classify_stationary_amplitude_weyl_tangent_boundaries.py
```

The script independently transcribes the six live rational projectors, derives
the stationary-axis matrices, checks the Pauli reconstruction, derives each
primitive polynomial numerator, computes each reduced lexicographic Groebner
basis, and asserts the final census.

## Exact result

Write the SU(2)-shaped product as

```text
U = u0 I + i (Fx sigmaX + Fy sigmaY + Fz sigmaZ).
```

An identity crossing requires all three Pauli coefficients to vanish and then
requires `u0 = +1`. The reduced exact ideals are:

| Fixed `-1` phases | Finite variables | Reduced ideal | Exact conclusion |
|---|---:|---:|---|
| `x` | `ty,tz` | `<1>` | no Pauli-vector zero, even over `C` |
| `y` | `tx,tz` | `<1>` | no Pauli-vector zero, even over `C` |
| `z` | `tx,ty` | `<1>` | no Pauli-vector zero, even over `C` |
| `x,y` | `tz` | `<1>` | no Pauli-vector zero, even over `C` |
| `x,z` | `ty` | `<ty>` | unique zero at `ty=0` |
| `y,z` | `tx` | `<1>` | no Pauli-vector zero, even over `C` |
| `x,y,z` | none | direct evaluation | Pauli vector is nonzero |

At the exceptional `x,z` edge, `ty=0` means `zy=1`. Direct exact matrix
evaluation gives

```text
weylStep(-1, 1, -1) = I.
```

At the all-`-1` corner, exact evaluation gives

```text
u0 = 7/25,
wx = -12648/15625,
wy = 0,
wz = -8064/15625,
```

so the corner is not an identity crossing. Therefore the exact external
boundary census is

```text
{ (zx,zy,zz) : some phase is -1 and weylStep(zx,zy,zz)=I }
  = { (-1,1,-1) }
```

subject only to the live symbol transcription, which the proposed Lean
theorems below must eliminate as an external trust step.

## Exact numerator equations

The script prints every primitive numerator. They are recorded here so an
Aristotle package can use the exact same normalization.

### Face `x=-1`

```text
Fx = 1054 ty^2 tz^2 - 420 ty^2 tz - 350 ty^2 + 525 ty tz - 1500 tz
Fy = 168 ty^2 tz - 140 ty^2 + 625 ty tz^2 + 175 ty - 500
Fz = 1344 ty^2 tz^2 - 245 ty^2 tz + 2400 ty^2 - 3600 ty tz - 875 tz
```

Their reduced lex basis over `QQ[ty,tz]` is `[1]`.

### Face `y=-1`

```text
Fx = 2108 tx^2 tz^2 - 840 tx^2 tz - 700 tx^2 - 245 tx tz^2 - 875 tx
     - 700 tz^2 - 2500
Fy = 84 tx^2 tz - 70 tx^2 - 288 tx tz^2 + 105 tx tz
     + 70 tz^2 + 300 tz
Fz = 1344 tx^2 tz^2 - 245 tx^2 tz + 2400 tx^2 + 840 tx tz^2
     + 3600 tx tz + 2400 tz^2 - 875 tz
```

Their reduced lex basis over `QQ[tx,tz]` is `[1]`.

### Face `z=-1`

```text
Fx = 2108 tx^2 ty^2 - 245 tx ty^2 + 3600 tx ty - 875 tx - 700 ty^2
Fy = 625 tx^2 ty - 576 tx ty^2 + 140 ty^2 + 175 ty + 500
Fz = 224 tx^2 ty^2 + 140 tx ty^2 + 175 tx ty + 500 tx + 400 ty^2
```

Their reduced lex basis over `QQ[tx,ty]` is `[1]`.

### Edges

```text
x=y=-1:
  Fx = 527 tz^2 - 210 tz - 175
  Fy = 6 tz - 5
  Fz = 1344 tz^2 - 245 tz + 2400
  reduced basis = [1]

x=z=-1:
  Fx = ty^2
  Fy = ty
  Fz = ty^2
  reduced basis = [ty]

y=z=-1:
  Fx = 2108 tx^2 - 245 tx - 700
  Fy = 144 tx - 35
  Fz = 56 tx^2 + 35 tx + 100
  reduced basis = [1]
```

Overall signs of individual Pauli equations are immaterial. The script chooses
primitive polynomials with positive lexicographic leading coefficient.

## Precise Lean successor statements

The proof module should define the same finite tangent phase without any
transcendental functions, for example

```lean
def tangentPhase (t : Real) : Complex :=
  Complex.ofReal ((1 - t^2) / (1 + t^2)) +
    Complex.I * Complex.ofReal ((2 * t) / (1 + t^2))
```

with the required coercions made explicit. The exact chart theorems should be:

```lean
theorem no_x_boundary_identity (ty tz : Real) :
    Not (weylStep (-1) (tangentPhase ty) (tangentPhase tz) = 1)

theorem no_y_boundary_identity (tx tz : Real) :
    Not (weylStep (tangentPhase tx) (-1) (tangentPhase tz) = 1)

theorem no_z_boundary_identity (tx ty : Real) :
    Not (weylStep (tangentPhase tx) (tangentPhase ty) (-1) = 1)

theorem no_xy_boundary_identity (tz : Real) :
    Not (weylStep (-1) (-1) (tangentPhase tz) = 1)

theorem xz_boundary_identity_iff (ty : Real) :
    Iff (weylStep (-1) (tangentPhase ty) (-1) = 1) (ty = 0)

theorem no_yz_boundary_identity (tx : Real) :
    Not (weylStep (tangentPhase tx) (-1) (-1) = 1)

theorem all_neg_one_not_identity :
    Not (weylStep (-1) (-1) (-1) = 1)

theorem weylStep_neg_one_one_neg_one :
    weylStep (-1) 1 (-1) = 1
```

After proving that every unit complex phase other than `-1` has a finite real
tangent coordinate, the torus-facing capstone should say:

```lean
theorem boundary_identity_iff
    (zx zy zz : Complex)
    (hx : Complex.normSq zx = 1)
    (hy : Complex.normSq zy = 1)
    (hz : Complex.normSq zz = 1)
    (hboundary : Or (zx = -1) (Or (zy = -1) (zz = -1))) :
    Iff (weylStep zx zy zz = 1)
      (And (zx = -1) (And (zy = 1) (zz = -1)))
```

The chart lemmas are the preferred first Aristotle target. They expose exact
polynomial normalization and keep the transcendental-free boundary proof
separate from the unit-circle chart-surjectivity lemma. The final capstone must
not be claimed until both layers are kernel checked.

## Scientific correction

The omitted boundary is not empty. Any statement that the stationary fixture
has no `pi`-boundary identity root is false. The exact oracle finds the
nondegenerate boundary alias `(-1,1,-1)`. Combining this result with the affine
tangent census therefore adds one boundary crossing; it does not merely close
a technical chart gap.
