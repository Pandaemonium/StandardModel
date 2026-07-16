# Claude review: HNUInfraredWeylCharge (tangent -> local Weyl charge)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-193035, item QCA-3PLUS1-001
- Source: `.../charge/.../HNUInfraredWeylCharge.lean` (293, sha e6220159 MATCH).
  Namespace `PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge`; bare imports of the
  bundled `HNUInfraredTangent` + `WeylSphereChargeBridge` (aristotle-verified;
  semantic review - its main dep `HNUInfraredTangent` I independently repo-built
  in the sibling review). 10 proper `#guard_msgs`, 0 sorry/native_decide/axiom.
- Date: 2026-07-13

## Verdict: APPROVE

A clean, honest composition layer that turns the exact `-i` Pauli tangent into
the AF2-level LOCAL Weyl charge. The unconditional local results are solid
(manuscript/central-guard-worthy); the degree/Chern are honest CONDITIONAL (T|H)
architecture, correctly labeled and non-hollow but assumption-heavy - integrate
them as conditional, not as unconditional headlines.

## Requested checks (all pass)

### (1) `+1` chirality genuinely derived from the `-i` tangent; `-i` does NOT flip the orientation - YES
`endpoint_ir_tangent_weyl : d/dt endpoint(t.q)|0 = (-I) • weylHam weylJacobian q`
keeps `-i` as a SEPARATE SCALAR PREFACTOR; the real coefficient matrix is
`weylJacobian = I3` (`weylHam_weylJacobian` via `Matrix.one_mulVec`). Chirality is
`sign(det A)` of the REAL Jacobian `A = I3` (`local_chirality_one`,
`weylJacobian_det = 1`), so the `-i` (the evolution-generator prefactor
`U = exp(-iHt)`) never enters the orientation - it cannot flip a real
determinant sign. The `+1` is genuinely transported from the `-i` Pauli tangent,
and `ir_weyl_sign_conventions` displays all four conventions (`-i` prefactor,
Pauli order `s1,s2,s3`, `A = I3`, `det = chi = +1`) in one statement.

### (2) `linearized_node_isolated` sound - YES
`weylHam weylJacobian q = 0 <-> q = 0`: forward via the Clifford square
`pauliDot_sq` (`(q.sigma)^2 = ||q||^2 . I`) forcing `nrmSq q = 0` then
`nrmSq_eq_zero`; backward trivial. Mathematically and semantically sound - the
linearized crossing is isolated/non-degenerate, with genuine witnesses
(`linearized_node_axis0 : weylHam I3 [1,0,0] = s1`, `..._ne_zero`,
`ir_tangent_axis0_ne_zero : -i.s1 != 0`).

### (3) Pauli order/sign conventions match both imports - YES
`sigma1_eq/2_eq/3_eq : (sigma_j : M2) = sigma_j := rfl` - the HNUExactCore Pauli
`sigma_j` and the WeylSphereChargeBridge `sigma_j` are DEFINITIONALLY equal, and
`pauliDot_eq_sigmaSum` bridges the two `k.sigma` forms. No adapter, no convention
drift.

### (4) Degree/Chern = explicit conditional architecture, not hollow, but assumption-heavy - YES (use as conditional)
`hnu_ir_node_degree_eq_one` takes `deg` + the four named degree axioms
(`deg_id`, `deg_reflect`, `deg_pos_det`, `deg_neg_det`) and proves
`deg weylJacobian = 1` via `deg_eq_chirality` + `local_chirality_one`;
`hnu_ir_node_chern_eq_one` adds `chern_eq_deg`. These are EXPLICIT T|H reductions,
and the docstring says so verbatim: "*not* an unconditional global Brillouin-zone
charge ... the local Jacobian orientation +1 transported through the abstract
reduction." Assessment:
- NOT hollow: WeylSphereChargeBridge's `chirality_isDegreeModel` proves the degree
  axioms are SATISFIABLE (by `chirality` itself), and here the conclusion `= 1` is
  DERIVED, not assumed.
- BUT assumption-heavy (T|H under `deg` + 4-5 hypotheses standing in for the
  missing Brouwer-degree/Berry-curvature API). RECOMMENDATION: guard them (they
  are kernel-clean, and already are) but PRESENT them in the manuscript as
  conditional (`T|H`) - "degree/Chern = +1 UNDER the standard degree axioms" - NOT
  as unconditional charge headlines. The UNCONDITIONAL headline/central-guard
  results are the local ones (`local_chirality_one`, `linearized_node_isolated`,
  `weylJacobian_det`, `ir_weyl_sign_conventions`).

### (5) No global BZ / copy freedom / anomaly / PDE claim - YES
The module is emphatically LOCAL ("the honest local ladder", "honest, local
Weyl-charge statement"), and `hnu_ir_node_degree_eq_one` explicitly disclaims the
global reading ("*not* an unconditional global Brillouin-zone charge"). No copy
freedom, anomaly cancellation, or PDE convergence is asserted (all out of scope);
the topological API is imported-as-missing, not re-derived.

## Over-claim modes - all clear

- Vacuity: none (nonzero node witnesses; the degree axioms are satisfiable, so the
  conditionals are not vacuously true).
- Hollow telescoping: none - the local chain is substantive, and the degree/Chern
  conditionals are non-hollow (satisfiable + derived, not assumed).
- Docstring-outruns-kernel: none - scrupulous ("local", "not an unconditional
  global BZ charge", "honest reductions from named hypotheses").
- False shape: none - `+1` is the genuine node chirality; the degree/Chern are the
  genuine T|H reductions.

## Exact integration subset

- **Unconditional (headline / central-guard / manuscript):**
  `endpoint_ir_tangent_weyl`, `weylJacobian_det`, `weylJacobian_det_ne_zero`,
  `linearized_node_isolated` (+ `linearized_node_axis0`, `..._ne_zero`,
  `ir_tangent_axis0_ne_zero`), `local_chirality_one`, `reflected_chirality_neg_one`,
  `ir_weyl_sign_conventions`, `blochVec_hnu_ir`.
- **Conditional (integrate as T|H, label clearly, do NOT headline):**
  `hnu_ir_node_degree_eq_one`, `hnu_ir_node_chern_eq_one`.
- Integration edits: retarget the bare imports to `PhysicsSM.Draft.NullEdge.
  HNUInfraredTangent` / `...WeylSphereChargeBridge` once those two land in the repo
  (the namespace is already `PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge`).

## Bottom line

APPROVE. The local Weyl charge `+1` is genuinely derived from the exact `-i` Pauli
tangent (with `-i` kept as a scalar prefactor that cannot flip the real Jacobian
orientation), the node is provably isolated, the Pauli conventions match both
imports by `rfl`, and the degree/Chern are honest conditional (T|H) architecture -
non-hollow but assumption-heavy, to be integrated as conditional rather than
unconditional headlines. No global-BZ / copy / anomaly / PDE overclaim.
