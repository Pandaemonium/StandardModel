# B off-axis elimination audit report

Date: 2026-07-12
Mode: review-only (no project files edited, no broad build run)
Auditor: Aristotle

Scope: independent audit of the stationary-amplitude Weyl off-axis elimination
across the five sources named in the contract:

- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeProjectorWalk.lean`
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`
- `Scripts/oracle/analyze_stationary_amplitude_weyl.py`
- `AgentTasks/24h-publication-run-2026-07-12/B_STATIONARY_WEYL_TANGENT_ELIMINATION_2026-07-12.md`
- `AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_algebraic_offaxis_alias.lean`

Method: the live matrix fixture (`Px..Qz`, `stationaryWalk = forwardPhase *
backwardPhase`) was rebuilt from the Lean definitions and recomputed
independently in exact arithmetic (SymPy 1.14.0), plus a 50-digit numerical
evaluation of the reconstructed crossing. No number below is taken from the
project's own oracle output; every figure was recomputed here.

---

## Executive verdict

Every displayed algebraic object checks out exactly, and every theorem
*statement* in the algebraic-witness target is mathematically true as written,
including the load-bearing `weylStep = I` (sign `+I`, not `-I`). The witness is
a genuine, fully off-axis, chart-interior identity crossing.

The single material caveat is scope, not correctness: the target proves **one**
exact crossing, not a census. The `tz = 0` branch, the sextic branch's
real-root absence, and the omitted `q_j = pi` (i.e. `z_j = -1`) charts are not
yet kernel theorems, and — separately — **every theorem in the target file is
still `:= by sorry`**, so nothing in that file is currently kernel-checked. The
two `PhysicsSM/.../StationaryAmplitude*.lean` source files are complete and
carry honest `#print axioms` pins.

---

## 1. Phase convention and tangent-half-angle map

Verdict: **consistent; no sign or orientation mismatch.**

- The oracle sets `z = c + I s`, `zbar = c - I s`, and forms
  `z*gammaPlus + gammaZero + zbar*gammaMinus`. This is exactly
  `stationaryWalk_expansion` with the on-circle substitution `z⁻¹ = zbar`
  (`conj z = z⁻¹`), matching `stationaryWalk = forwardPhase z P * backwardPhase z Q`
  with `forwardPhase = z•P + (1-P)`, `backwardPhase = Q + z⁻¹•(1-Q)`.
- The memo's chart is `z_j = exp(i q_j)`, `t_j = tan(q_j/2)`,
  `z_j = (1 - t_j^2 + 2 i t_j)/(1 + t_j^2)`. The target's
  `unitPhase t = (1-t^2)/(1+t^2) + I·(2t/(1+t^2))` is identical to this map.
- Independent recomputation of the three Pauli-vector coefficients of the live
  `weylStep` under this chart gives coefficients whose **imaginary parts are
  identically zero** (checked symbolically). A real Pauli vector is the correct
  orientation signature; a sign/orientation error would have produced a nonzero
  imaginary part. No mismatch found.

## 2. The three integer numerator polynomials vs. the live matrix

Verdict: **exact match on the vanishing locus.**

Rebuilding `weylStep` from the Lean definitions, taking each Pauli-vector
coefficient `tr(sigma·U)/(2i)`, and clearing the denominators
`(1+t_x^2)(1+t_y^2)(1+t_z^2)` gives polynomials that equal the memo's
`F_x, F_y, F_z` up to a single nonzero rational constant per axis:

- `F_x^{live} = (-6/15625) · F_x^{memo}`
- `F_y^{live} = ( 6/3125 ) · F_y^{memo}`
- `F_z^{live} = (-6/15625) · F_z^{memo}`

The scale factors are nonzero, so the zero sets coincide exactly; the memo's
integer polynomials are faithful numerators of the live Pauli-vector equations
after cancelling only the (strictly positive) real denominators. The division
of the live numerator by `(1+t_x^2)(1+t_y^2)(1+t_z^2)` is exact (zero
remainder), confirming that only nonzero real denominators were cancelled.

Note: the memo says these "should be reproved by entrywise normalization before
being used in a kernel census." That is correct — the numerators are a
CAS-derived certificate and are not yet Lean-checked.

## 3. Quintic-branch Groebner (triangular) identities

Verdict: **correct.**

- The `tangentX` / `tangentY` definitions in the target reproduce the memo's
  triangular numerators over `430976` and `820352` verbatim.
- Substituting `t_x = tangentX(t_z)`, `t_y = tangentY(t_z)` into
  `F_x, F_y, F_z` and reducing modulo the quintic
  `q(t) = 480 t^5 - 575 t^4 - 1026 t^2 + 1440 t - 575` yields exactly `0` for
  all three (checked by polynomial division; zero remainder). So on the quintic
  branch the triangular certificate does imply `F_x = F_y = F_z = 0`.
- Independent lexicographic Groebner elimination of `t_x, t_y` from
  `<F_x, F_y, F_z>` gives the univariate generator
  `t_z · (t_z^2+1)^2 · q(t_z) · s(t_z)`, where
  `s(t_z) = 16384 t_z^6 + 11040 t_z^5 + 56375 t_z^4 + 48000 t_z^3 + 44050 t_z^2 + 19680 t_z + 5175`.
  The memo's stated univariate factor `t_z · q · s` is genuinely a factor of
  this generator, so the memo claim ("contains the univariate factor …") is
  correct. **Minor imprecision:** the memo omits the extra `(t_z^2+1)^2`
  factor. It has no real roots, so it does not affect the real census, but a
  complete write-up should mention it.

Root counts (exact, recomputed): the quintic has **exactly one** real root; the
sextic has **no** real root. This matches the memo. (Still CAS-only, not
kernel-checked — see §7.)

## 4. Rational sign interval and nonzero tangent coordinates

Verdict: **correct; the interval does force all three coordinates nonzero.**

- Sign controls recomputed exactly:
  `rootPoly(149/100) = -8099334899/500000000 < 0` and
  `rootPoly(3/2) = 169/16 > 0`. Both match the memo and the target's
  `rootPoly_at_lower` / `rootPoly_at_upper`.
- `t_z ≠ 0`: trivial on `(149/100, 3/2)`.
- `tangentX(t) ≠ 0` on the interval: the real roots of its numerator are
  `≈ 0.4318` and `≈ 1.5463`; both lie outside `(1.49, 1.5)` (the upper root
  `1.5463 > 3/2`), so `tangentX` is nonzero throughout, with a small but
  genuine margin.
- `tangentY(t) ≠ 0` on the interval: numerator real roots `≈ 1.0962` and
  `≈ 2.1159`, both outside `(1.49, 1.5)`.
- Hence `tangent_coordinates_nonzero` holds for **every** `t` in the interval,
  not merely at the root. This is what feeds the "fully off-axis" conclusion.

## 5. Are all target theorem statements true as written?

Verdict: **yes — all statements are mathematically true**, but note every one
is currently `:= by sorry` (unproven in kernel).

- `rootPoly_at_lower`, `rootPoly_at_upper`: true (see §4).
- `exists_rootPoly_in_interval`: true (continuity + sign change; the unique real
  root `≈ 1.49611792` lies in `(149/100, 3/2)`).
- `unitPhase_on_circle`: true for all real `t`, since
  `(1-t^2)^2 + (2t)^2 = (1+t^2)^2`.
- `tangent_coordinates_nonzero`: true (see §4).
- `unitPhase_ne_one_of_ne_zero`: true; `unitPhase t = 1` forces `2t/(1+t^2)=0`,
  i.e. `t = 0`.
- `exact_alias_of_root` (the load-bearing claim): **true, and the sign is `+I`.**
  Reconstructing the phases at the real root
  `t_z ≈ 1.49611792`, `t_x = tangentX(t_z) ≈ -0.83080848`,
  `t_y = tangentY(t_z) ≈ -1.07271776`, and evaluating the live
  `weylStep(unitPhase t_x, unitPhase t_y, unitPhase t_z)` to 30 digits gives the
  identity matrix with `u0 = tr/2 = +1.000…` (off-diagonal and imaginary parts
  at the `1e-38` numerical-noise floor). It is `+I`, **not** `-I`. This is the
  most important single check and it passes.
- `exists_exact_fully_offaxis_alias`: true, assembled from the above.

## 6. Audit of "fully off-axis"; which phases differ from 1; hidden boundary

Verdict: **the witness is genuinely fully off-axis and chart-interior.**

- "Off-axis" here means each axis phase `z_j ≠ 1` (equivalently `q_j ≠ 0`,
  equivalently `t_j ≠ 0`). At the witness all three tangents are nonzero, so
  all three phases differ from `1`:
  `q/pi ≈ (-0.4413, -0.5223, +0.6249)`. None of the three momenta is `0`, so
  the point is off all three coordinate axes — "fully off-axis" is accurate.
- No chart boundary is hidden **in this single witness**: none of the `q_j`
  equals `±pi`, so the crossing sits strictly inside the tangent chart (`z_j`
  never `-1`).
- The hidden-boundary risk is a *census-level* issue, not a defect of the
  witness statement: the tangent parametrization `unitPhase` can never output
  `z_j = -1` (that is the `t_j → ∞`, `q_j = pi` limit), so any crossing living
  on a `q_j = pi` face is invisible to this chart. This must be flagged if the
  single witness is ever promoted to a statement about the full off-axis
  structure.

## 7. Why the witness is not yet a complete four-root census

The target explicitly disclaims global uniqueness / completeness, correctly.
The outstanding obligations before a numerical four-root census can be promoted
to an exact theorem are:

1. **`t_z = 0` branch.** The univariate elimination generator carries an
   explicit factor `t_z`. Solutions with `t_z = 0` (i.e. `z_z = 1`, an on-axis
   face) are part of the variety and are excluded from the current target by the
   `t ≠ 0` / interval hypotheses. They must be classified separately.
2. **Sextic branch.** `s(t_z)` must be shown to have no real root by a
   kernel-checkable certificate (Sturm sequence or an explicit
   sum-of-squares/positivity witness). At present its real-root absence is only
   a CAS `real_roots` count. The same applies to the quintic's "exactly one real
   root" claim.
3. **Omitted `q_j = pi` charts.** For each of the three axes the tangent chart
   drops `q_j = pi` (`z_j = -1`). Every such boundary face (and their
   intersections) must be enumerated and glued to the tangent-chart count.
4. (Bookkeeping) the complex-only factor `(t_z^2 + 1)^2` in the elimination
   generator should be acknowledged so the real-root accounting is airtight.

Only after 1–3 (and the entrywise re-derivation of `F_x,F_y,F_z` from §2, and
discharging the target's `sorry`s) may "four nodes" become an exact theorem.

## 8. Four overclaim checks and the manuscript-safe sentence

Overclaim mode A — "complete census / exactly four Weyl nodes":
**UNSAFE.** Blocked by §7 (tz=0 branch, sextic/quintic root counts, and
`q_j=pi` charts are not kernel-checked; the numerical four-root finding is
CAS/numerical only).

Overclaim mode B — "the crossing is globally unique":
**UNSAFE.** The witness establishes only a root isolated within the rational
interval `(149/100, 3/2)` on the quintic branch; global uniqueness needs the
full census (§7).

Overclaim mode C — "weylStep equals the identity at the crossing":
**SAFE.** Independently verified to 30 digits that it is `+I` (not `-I`, not a
mere `±I` up to phase). The statement `exact_alias_of_root` is true as written.

Overclaim mode D — "fully off-axis / captures the off-axis structure across the
Brillouin zone":
**SAFE only in the single-point reading** (all three phases `≠ 1`, chart
interior). **UNSAFE if read as covering all charts**, because the `q_j = pi`
faces are outside the tangent parametrization (§6).

Additional cross-cutting caveat (applies to A–D): the algebraic-witness file
`codex_24h_b_stationary_weyl_algebraic_offaxis_alias.lean` currently contains
**only `sorry` proofs**. Until those are discharged, even mode C is a
*mathematically true but not-yet-kernel-verified* statement. The upstream
`StationaryAmplitudeWeylTangent.lean` results it depends on (`weylStep_unitary`,
`weylStep_one`, the Pauli moments, nonzero onsite terms) are complete and
axiom-pinned to `[propext, Classical.choice, Quot.sound]`.

Strongest manuscript-safe sentence (valid once the target's `sorry`s land):

> "For the explicit rational stationary-amplitude Weyl fixture there is an
> exactly constructed, fully off-axis point of the tangent-chart three-torus —
> the reconstruction, via an explicit triangular certificate, of the unique real
> root (isolated in the rational interval (149/100, 3/2)) of the integer quintic
> 480 t^5 - 575 t^4 - 1026 t^2 + 1440 t - 575 — at which all three unit-circle
> axis phases differ from 1 and the ordered live `weylStep` matrix equals the
> identity exactly."

Do **not** upgrade "an exactly constructed point" to "the unique node" or "the
four nodes," and do not describe it as covering the full Brillouin zone, until
obligations §7.1–§7.3 are kernel-checked.

---

## Appendix: independently reproduced quantities

- Pauli-numerator scale factors live/memo: `(-6/15625, 6/3125, -6/15625)`.
- Univariate elimination generator: `t_z (t_z^2+1)^2 q(t_z) s(t_z)`.
- Quintic real roots: 1; sextic real roots: 0.
- `rootPoly(149/100) = -8099334899/500000000`; `rootPoly(3/2) = 169/16`.
- Real root `t_z ≈ 1.49611792480646`;
  `t_x ≈ -0.83080848399`, `t_y ≈ -1.07271776386`.
- `q/pi ≈ (-0.44133433, -0.52232556, +0.62490412)`.
- `weylStep` at the crossing = identity, `u0 = +1` (residuals `≤ 1e-38`).
- `tangentX` numerator real roots `≈ {0.4318, 1.5463}`; `tangentY` numerator
  real roots `≈ {1.0962, 2.1159}` — all outside `(149/100, 3/2)`.
