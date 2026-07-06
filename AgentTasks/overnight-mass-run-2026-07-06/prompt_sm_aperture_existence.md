Close the ONE documented handoff `s o r r y` in
`PhysicsSM/Draft/NullEdge/GateI1/ApertureEqualsTurn.lean`:
`twoNull_resolution_exists` (~line 153). Closing it makes the fully-quantified
flagship `apertureEqualsTurn_exists` UNCONDITIONAL (the binding theorem
`apertureEqualsTurn_onShell` is already fully proved and does not depend on this).

START: `lake env lean PhysicsSM/Draft/NullEdge/GateI1/ApertureEqualsTurn.lean`
(reports exactly one `s o r r y`, this one). If broader `lake build` stalls, SKIP.

## Target (preserve verbatim)

```lean
theorem twoNull_resolution_exists (p : Momentum4) (hfut : 0 ≤ p 0)
    (hm : 0 ≤ minkowskiSq p) :
    ∃ kPlus kMinus : Momentum4, IsFutureNull kPlus ∧ IsFutureNull kMinus
      ∧ p = kPlus + kMinus
```

`Momentum4 = Fin 4 → ℝ` (index 0 = time, 1,2,3 = space). `minkowskiSq p =
p0^2 - p1^2 - p2^2 - p3^2`. `IsNull p := minkowskiSq p = 0`,
`IsFutureNull p := IsNull p ∧ 0 ≤ p 0` (see `CompositeApertureMass`).

## Construction (the canonical two-null split; 3+1D analogue of
`MassCoinBridge.twoNull_resolution`)

Let `r = Real.sqrt (p1^2 + p2^2 + p3^2)` (the spatial magnitude `|p_vec|`).

- If `r = 0` (p is purely temporal, `p = (p0, 0,0,0)` with `p0 >= 0`): split
  along ANY fixed null direction, e.g.
  `kPlus = (p0/2, p0/2, 0, 0)`, `kMinus = (p0/2, -p0/2, 0, 0)`. Each is null
  (`(p0/2)^2 - (p0/2)^2 = 0`), future (`p0/2 >= 0`), and sums to `(p0,0,0,0)=p`.
- If `r > 0`: let `n = (p1,p2,p3)/r` (unit spatial vector). Set
  `kPlus = ((p0+r)/2) * (1, n)`, `kMinus = ((p0-r)/2) * (1, -n)`, i.e.
  `kPlus = ((p0+r)/2, (p0+r)/(2r) * p1, ..., ...)` etc. Then:
  - `minkowskiSq kPlus = ((p0+r)/2)^2 (1 - |n|^2) = 0` since `|n|^2 = 1`
    (`(p1^2+p2^2+p3^2)/r^2 = 1`); likewise `kMinus` null.
  - future: `(p0+r)/2 >= 0` (both nonneg); and `(p0-r)/2 >= 0` because
    `p0 >= r` follows from `0 <= minkowskiSq p = p0^2 - r^2` and `p0 >= 0`
    (so `p0 >= |p_vec| = r`). This is where `hfut` and `hm` are used.
  - sum: `kPlus + kMinus`: time `= (p0+r)/2 + (p0-r)/2 = p0`; space-i
    `= ((p0+r)/2 - (p0-r)/2) * n_i = r * (p_i / r) = p_i`. So `= p`.

Key lemmas: `Real.sq_sqrt`, `Real.sqrt_nonneg`, `Real.sqrt_eq_zero'`,
`Real.le_sqrt`/`Real.sqrt_le_sqrt`, and for `p0 >= r`:
`Real.sqrt (p1^2+p2^2+p3^2) <= p0` from `p1^2+p2^2+p3^2 <= p0^2` (`= minkowskiSq p
+ ... `; use `hm` and `hfut`) via `Real.sqrt_le_left`/`Real.sqrt_le_sqrt` +
`Real.sqrt_sq hfut`.

## Constraints

- Preserve the statement verbatim. Reuse `minkowskiSq`, `IsNull`, `IsFutureNull`,
  `minkDot`; define the split vectors with `![...]` / `fun i => ...` (Momentum4
  is `Fin 4 -> R`). Handle the `r = 0` case explicitly (`by_cases hr : r = 0`).
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. If the
  general case is heavy, close the `r = 0` (purely temporal) branch first and
  reduce the `r > 0` branch to a concrete residual.
- Do NOT touch `apertureEqualsTurn_onShell` or the other proved theorems.
- If `lake build` stalls, SKIP; return the proof as a patch.
