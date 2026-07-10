# Summary of changes for run 715ab78c-f5e9-4f44-b578-6a83169d9ebb
Delivered `RequestProject/Main.lean` (namespace `PauliMomentumPhysLean`) and `ARISTOTLE_SUMMARY.md`, formalizing the four-momentum → Hermitian 2×2 spinor map `P(p) = p_μ σ^μ` grounded in PhysLean's Pauli-matrix convention (reference only; Mathlib-only build, PhysLean not imported, version-pinned off v4.28.0).

All targets are proved and the file builds cleanly (no `sorry`/`admit`/`native_decide`/new axiom):
- `P_closed` — explicit Hermitian closed form `!![p0+p3, p1-I·p2; p1+I·p2, p0-p3]`.
- `P_selfAdjoint` — `P(p)` is self-adjoint for real components.
- `det_P_eq_massSq` (payload) — `det(P p) = p0²-p1²-p2²-p3²`, the invariant mass squared in mostly-plus `(+,-,-,-)`.
- `null_iff_massless` (payload) — `det = 0 ↔ p0² = p1²+p2²+p3²` (null cone = massless).
- `pauli_momentum_verdict` — packaged verdict bundling all of the above with the witnesses.

Mandatory non-degeneracy witnesses are all in-file: massive `p=(1,0,0,0)` (`det=1`), null `p=(1,0,0,1)` (`det=0`), spacelike `p=(0,1,0,0)` (`det=-1`), off-diagonal `σ²` entry `-I ≠ 0`, plus self-adjointness at every explicit `p`.

Method honored the constraints: explicit-constant complex 2×2 via `fin_cases`/`simp`/`norm_num`/`Matrix.det_fin_two_of`/`Complex.I_sq`/`ring`/`push_cast`/`linarith`; no symbolic complex analysis, no `Real.sqrt`/trig, no `nlinarith`. Each headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. Build completes in well under 3 minutes. `ARISTOTLE_SUMMARY.md` includes the PhysLean provenance line (package HEPLean/PhysLean, decl PauliMatrix / pauliContrDown, version gap pinned off v4.28.0, not imported) and the honest scope note (finite σ-map + determinant identity only). Work committed and pushed.

# PauliMomentumPhysLean — the σ-map `p_μ → P(p) = p_μ σ^μ` with `det P = m²`

Clean-room, Mathlib-only formalization (namespace `PauliMomentumPhysLean`, file
`RequestProject/Main.lean`) of the four-momentum → Hermitian `2×2` spinor matrix map that
underpins the "mass = det P" invariant of spinor-helicity.

## Provenance line

Grounded in **PhysLean's Pauli-matrix convention** — package `HEPLean/PhysLean`, declarations
`PauliMatrix.pauliBasis` / `pauliContrDown` ("Pauli matrices as a Lorentz tensor").  This is a
**reference / provenance only, NOT an import**. Version gap: PhysLean is pinned **OFF** Lean/Mathlib
`v4.28.0` and is not depended upon; the build uses Mathlib only.

## The model

Standard self-adjoint Pauli basis (PhysLean convention), explicit complex `2×2` constants:

```
s0 = !![1,0; 0,1]              s1 = !![0,1; 1,0]
s2 = !![0,-I; I,0]             s3 = !![1,0; 0,-1]
```

Four-momentum map (real `p0 p1 p2 p3 : ℝ`, coerced to ℂ):
`P p0 p1 p2 p3 = p0·s0 + p1·s1 + p2·s2 + p3·s3`, a Hermitian `2×2`.

## Results (all kernel-checked, no `sorry`/`admit`/`native_decide`/new axiom)

- `P_closed` — explicit Hermitian form `!![p0+p3, p1-I·p2; p1+I·p2, p0-p3]`.
- `P_selfAdjoint` — `(P p).conjTranspose = P p` (Hermitian, real components).
- `det_P_eq_massSq` (payload) — `det (P p) = (p0² - p1² - p2² - p3² : ℂ)`, the invariant mass
  squared `m²` in the mostly-plus `(+,-,-,-)` signature.
- `null_iff_massless` (payload) — `det (P p) = 0 ↔ p0² = p1² + p2² + p3²` (null cone = massless).
- `pauli_momentum_verdict` — packaged statement bundling the determinant identity, self-adjointness,
  the null-cone characterization, and the non-degeneracy witnesses.

### Mandatory non-degeneracy witnesses (in-file theorems)
- massive `p = (1,0,0,0)`: `det = 1` (`det_massive_witness`);
- null `p = (1,0,0,1)`: `det = 0` (`det_null_witness`);
- spacelike `p = (0,1,0,0)`: `det = -1` (`det_spacelike_witness`);
- off-diagonal `σ²` entry `-I ≠ 0` (`s2_offdiag_ne_zero`);
- self-adjointness holds at every explicit `p` via `P_selfAdjoint`.

## Method / constraints honored

Explicit-constant complex `2×2` throughout: proofs use `fin_cases` + `simp` + `norm_num` +
`Matrix.det_fin_two_of` + `Complex.I_sq` + `ring`/`push_cast` + `linarith`. No symbolic complex
analysis, no `Real.sqrt`/`cos`/`sin`, no `nlinarith`. Build completes well under 3 minutes.

Axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`, checked in-file by
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline theorem.

## Honest scope

The finite σ-map plus the determinant identity only — **not** the full Lorentz representation or the
spinor decomposition. This is the little-group spinor matrix `P(p) = p_μ σ^μ` grounding the
`det P = m²` / `det P = 0 ⇔ null` mass mechanism in PhysLean's Pauli convention.
