# Buffered Alexandrov core: exact flat 4D feasibility law

## Scope

This note repairs the scale normalization used in the A3e interpretation and
the first A3f preregistration. It supplies an external flat-space calibration
for designing order-only causal-atlas experiments. It does not derive a metric
from order, prove curved-spacetime convergence, establish operator locality, or
close G2.

Claim labels follow the manuscript calculus.

## Volume radius is not proper time

For a four-dimensional Minkowski Alexandrov interval of proper duration
`tau`,

```text
V_4(tau) = kappa_4 tau^4,    kappa_4 = pi/24.
```

The experiment's scale variable is the fourth-root volume radius

```text
u = V_4(tau)^(1/4) = kappa_4^(1/4) tau,
kappa_4^(1/4) = 0.6014986511033369.
```

Therefore `tau = u kappa_4^(-1/4)`. Count formulas written as
`(s/ell)^4` are consistent when both `s` and `ell` are volume radii, but `s`
must not then be called proper time without the conversion. **`T|H [import]`**
under flat four-dimensional Minkowski geometry.

## Exact two-sided protected-core fraction

Put the outer endpoints at `(-T/2,0)` and `(T/2,0)`. Requiring an event
`x=(t,r)` to have proper-time depth at least `s` from both endpoints gives

```text
r^2 <= (T/2 - |t|)^2 - s^2.
```

At fixed `t`, the admitted spatial region is a three-ball. With
`v=T/2-|t|`, its integrated four-volume is

```text
V_core = (8pi/3) integral_s^(T/2) (v^2-s^2)^(3/2) dv.
```

Divide by `V_4(T)=pi T^4/24` and set `z=2s/T`. Then

```text
F_4(z) = 4 integral_z^1 (y^2-z^2)^(3/2) dy
       = 1/2 ((2-5z^2)sqrt(1-z^2) + 3z^4 acosh(1/z))
```

for `0<z<1`, with `F_4(0)=1` and `F_4(z)=0` for `z>=1`.
**`T|H [orig]`** from direct spatial-ball integration under the displayed flat
geometry.

If `M` is the expected outer count and `H` the expected count associated with
one-sided depth `s`, then

```text
z = 2(H/M)^(1/4),
E[N_core] = M F_4(z).
```

The Alexandrov coefficient and sprinkling density cancel. This makes the law
useful for count-side preregistration even though it remains an external
flat-space calibration.

## Correction to the first A3f target

The invalidated formula

```text
M_old(H,m) = (2H^(1/4) + m^(1/4))^4
```

sets the volume of a centered shifted subdiamond to `m`. That subdiamond lies
inside the protected core but does not exhaust it. For target `m=64`:

| `H` | old `M` | exact core at old `M` | exact `M` for core 64 |
|---:|---:|---:|---:|
| 4 | 1024.00 | 458.98 | 320.22 |
| 8 | 1470.03 | 557.94 | 468.98 |
| 16 | 2174.12 | 683.75 | 721.31 |
| 32 | 3310.40 | 844.11 | 1160.75 |

Thus the original independent-placement baseline understated the expected core
volume by factors between about 7 and 13. No empirical A3f code or output was
produced before this correction. **`M [comp]`** from the tested analytic
calculator.

## Correction to the A3e availability interpretation

A3e used one-sided count targets

```text
H_B = B (L/ell)^4
```

with `ell=0.10219728214404318`, `L=0.18`, and global count `9600`.
The exact ideal global protected-core fractions are

| rung | `H_B` | `z` | `F_4(z)` |
|---:|---:|---:|---:|
| `B=24` | 230.9638 | 0.787677 | 0.075452 |
| `B=32` | 307.9517 | 0.846414 | 0.035800 |

The previous roughly 7.7 percent statement describes the tight rung only to
rounding. The required refinement rung has an ideal fraction about 3.58
percent before endpoint-band, excess, nesting, and finite-count losses. The
observed one available refinement bracket among 40 marks is therefore
qualitatively compatible with the corrected geometric ceiling, although this
is not a statistical fit. **`M [comp]`**.

## Coverage costs

Inverting `F_4` gives the required expected-count ratio `M/H`:

| target core fraction | required `M/H` | radius ratio `R/S` |
|---:|---:|---:|
| 0.80 | 2905.90 | 7.342 |
| 0.50 | 333.47 | 4.273 |
| 0.25 | 101.11 | 3.171 |
| 0.10 | 48.14 | 2.634 |
| 0.01 | 23.31 | 2.197 |

Any positive protected core requires `R/S>2`; high typical-event coverage is
far more expensive. This makes an atlas of multiple moderate-coverage outer
intervals more plausible than one outer interval centered on each mark.
**`M [comp]`**.

## Genuine shrinking schedule

At fixed global four-volume, `ell proportional to N^(-1/4)`. Freeze

```text
R proportional to ell^(1/4),
S proportional to ell^(1/2),
L proportional to ell^(3/4).
```

Then

```text
n_R proportional to ell^(-3) proportional to N^(3/4),
n_S proportional to ell^(-2) proportional to N^(1/2),
n_L proportional to ell^(-1) proportional to N^(1/4).
```

All physical scales vanish, while `ell/L`, `L/S`, and `S/R` also vanish.
The reference `(n_R,n_S,n_L)=(8192,32,sqrt(32))` has `R/S=4` and exact
core fraction `0.4482`. At computationally accessible counts the other two
ratios are only about 1.5, so the first benchmark is explicitly preasymptotic.
**`T|H [orig]`** for the exponent arithmetic; **`M [comp]`** for finite values.

## Consequence for the GR program

The corrected law makes the next gate narrower and cleaner:

1. establish typical and repeated coverage by an outer-first order atlas;
2. freeze the covered germs;
3. separately test probe data, protected evaluation centers, and row-source
   eligibility on those same germs;
4. demand polynomial controls and boundary stability before an operator rank
   or metric projector;
5. keep tetrad/spin, curvature, stress-energy, and Einstein dynamics closed
   until G2.

A protected evaluation core does not remove the unbounded rapidity direction
of a fixed timelike shell. Coverage is therefore necessary for local
reconstruction, but it is not an operator-locality theorem.

## Verification

The executable companion is
`Scripts/experiments/causal_buffered_core_feasibility.py`. Its tests compare
the closed form with direct numerical quadrature, audit the A3e values, invert
the exact target, and check the balanced refinement exponents.
