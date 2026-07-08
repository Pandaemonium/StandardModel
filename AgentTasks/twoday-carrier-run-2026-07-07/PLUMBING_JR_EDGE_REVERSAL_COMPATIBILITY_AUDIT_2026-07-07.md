# PLUMBING audit: real structures, reversal, and sharp - 2026-07-07

Local Codex waiting-lane work while Fable owns dynamics.

## Purpose

Several live lanes use objects that all look like "inversion" or "J", but they
are not interchangeable:

- `J_K`: linear Krein fundamental symmetry, used to define a sharp operation.
- `J_R`: antilinear real structure / charge conjugation candidate.
- Edge reversal: path-level operation that inverts decorations and reverses word
  order.
- Generator conjugation: a hypothesis `G * x * G = x^-1` that preserves word
  order letter-by-letter.
- Monodromy/triality: sector or family permutation data, not automatically a
  Krein or real-structure operation.

This audit records the current compatibility surface and the next attachment
theorems.  It is an audit document only; no theorem statements were changed.

## Current Kernel Anchors

| Operation | Anchor | What is proved | Boundary |
|---|---|---|---|
| Internal `J_R` on `Lambda(C^5)` | `PhysicsSM/Draft/NullEdge/GateI1/Q11RealStructure.lean` | `JR_involutive`, parity anticommutation, `Btop_eq_Bstd`, particle-hole identity, charge master identity. | This is antilinear finite fiber data. It is Hilbert-positive internally, not a Krein metric. |
| Even-dimensional contrast | `Q11RealStructure.even_dim_breaks_JR_sq` | Dimension 4 has a witness where the top-form sign square is `-1`. | Oddness of `5` is load-bearing; no automatic extension to other fibers. |
| Edge reversal | `GWEdgeReversalBridge.holonomy_reverseEdges` | Reversing decorated edges sends path holonomy to the genuine inverse. | It reverses word order. |
| Generator conjugation | `GWEdgeReversalBridge.conj_inv_iff` | Conjugation inverts a word iff the inverted word agrees with reversed inverted word. | General one-sided heterogeneous words fail; see the nonabelian counterexample in `GWConjecture`. |
| Transfer-power bridge | `GWEdgeReversalBridge.conj_pow_inv`, `gw_relation_transfer_power` | Homogeneous paths `x^n` do satisfy conjugation-to-inverse and hence the GW relation. | This is the straight-path/transfer-power regime, not arbitrary retarded dynamics. |
| Krein sharp / carrier square | `CarrierKreinSquare.carrier_krein_square` | Algebraic `star D * D` decomposition into `Q_A^#`, `Q_C^#`, `Q_T`, and `E_#` slots. | The star is an arbitrary involution until a concrete `J_K`/inertia model is attached. |
| HSTAR quotient action | `CarrierWardDescentWitness.lean` | A non-identity phase action descends to `ker Q / range Q` and preserves the descended Krein form in the finite `(2,1)` model. | Does not identify the actual carrier Gauss constraints or physical positivity. |

## Compatibility Table

| Pair | Status | Reason |
|---|---|---|
| `J_K` vs `J_R` | Separate | `J_K` is linear and defines a Krein sharp; `J_R` is antilinear and implements particle-hole/charge-conjugation behavior. |
| `J_R` vs top-form pairing | Kernel-checked finite fiber | `Btop_eq_Bstd` says the Q11 top-form-duality pairing is the standard positive Hermitian metric. |
| `J_R` vs Krein positivity | Not automatic | Since the Q11 internal form is Hilbert-positive, it does not supply the carrier Krein fundamental symmetry by itself. |
| Edge reversal vs generator conjugation | Conditional | Edge reversal reverses word order; conjugation preserves word order. They agree only under palindromic, abelian, or homogeneous-transfer hypotheses. |
| Edge reversal vs `J_R` | Candidate seam only | Charter language suggests `J_R` may combine edge reversal with antilinear conjugation, but no module proves that the Q11 `JR` equals a carrier edge-reversal operation. |
| Monodromy/triality vs `J_R` | Open | Triality/order-3 sector motion is not an antilinear involution. Any bridge needs an explicit sector-projection or conjugation theorem. |
| Monodromy/triality vs `J_K` | Open | A family/sector permutation is not automatically Krein-unitary or sharp-compatible. |
| Krein sharp vs complex star | Conditional | `carrier_krein_square` is stated for an arbitrary star; the physical Krein reading requires a concrete fundamental symmetry and inertia witness. |
| Q11 unimodularity vs Krein closure | Separate | `JR_charge_master` carries trace/unimodularity arithmetic in the antilinear real-structure layer; it is not a consequence of the Krein square. |

## No-Go Guardrails

1. Do not use one symbol `J` for both `J_K` and `J_R`.
2. Do not claim edge reversal supplies `G * L.prod * G = (L.prod)^-1` for general
   nonabelian one-sided words.
3. Do not read Q11's `Btop_eq_Bstd` as a Krein positivity theorem.
4. Do not say triality/monodromy is a real structure until an explicit
   antilinear involution and compatibility statement are proved.
5. Do not say the carrier `#` is physical until the chosen `J_K`, star, and
   inertia/signature data are pinned.

## Next Theorem Targets

| Target | Suggested name | Kind |
|---|---|---|
| Attach a concrete `J_K` to the carrier star used in `carrier_krein_square`. | `carrierKreinSharp_eq_concreteFundamentalSymmetry` | proof |
| Prove or refute that the Q11 `JR` can be represented as an edge-reversal plus complex conjugation on a specific finite carrier/fiber product. | `JR_eq_edgeReversal_conj_on_fiberProduct` | proof/audit |
| State the exact sector-projection equivariance needed for C8/G2 real-structure bridges. | `JR_sectorProjection_equivariance_gate` | proof/strategy |
| Isolate the triality/monodromy compatibility condition as a linear or semilinear operator equation. | `trialityMonodromy_semilinearCompatibility` | strategy |
| Connect the HSTAR quotient action to actual carrier Gauss/closure constraints, or prove the mismatch. | `gaussClosure_quotientAction_attachment` | proof/audit |

## Verdict

PLUMBING is not blocked by dynamics.  The immediate safe work is theorem-shape
design and audit: keep the five operations separate, attach them only by explicit
intertwining equations, and make each bridge state whether it is linear,
antilinear, word-order reversing, or sector-permuting.
