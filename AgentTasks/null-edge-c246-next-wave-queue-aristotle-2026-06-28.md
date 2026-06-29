# Gate C1 next-wave strategy after C240 (response to C246)

Date: 2026-06-28

This note answers the C246 prompt
(`AgentTasks/aristotle-prompts/gate-c1-next-strategy-after-c240-c246.prompt.md`).
It proposes the next-wave Aristotle job queue, a branch-dependent decision tree,
the recommended immediate first job, and the risk/stop-rule register. It is
grounded in the integrated Draft files under
`PhysicsSM/Draft/NullEdge/GateC1/` and the existing scaffolds
`TetrahedralLatticeDuality.lean` and `TetrahedralGlobalGap.lean`, plus the
already-drafted prompts C243/C247/C248/C249.

No claim of `GateC1_NU`, gauge, anomaly, Krein, determinant-line, or Standard
Model chiral closure is made here. This is a planning artifact.

---

## 0. Is scalar Wilson now the default? Yes — with one sentence of discipline

**Default decision: Branch A (scalar Wilson) is the leading path.** Branch B
(`M_br`) is held as a *proved-need-only* fallback.

Why the earlier scalar-Wilson no-go does not bind here:

```text
The no-go forbids using a scalar term as a DIRECT chirality selector that
polarizes the balanced origin kernel into a physical Weyl line.

C240/C247 use scalar Wilson in a different role: a gamma5-EVEN, Hermitian
branch-mass term W(k) sitting INSIDE the Hermitian sign kernel
H_tet = gamma5 (D_ne^0 + W). The physical chirality is then supplied by the
overlap sign epsilon = sign(H_tet) and the Ginsparg-Wilson projectors, not by
W itself.
```

So the no-go's scope (direct chiral projector) and the new usage (branch-mass
input to an overlap sign kernel) are disjoint. The single discipline sentence
to keep in every claim:

```text
C240 makes scalar Wilson viable as an overlap branch-mass input; it does not
make scalar Wilson a direct chiral projector.
```

`M_br` is *only* introduced if a proved branch/gap test fails (residual
unsplit degeneracy) or if a later gauge/internal requirement forces it. An
`M_br` introduced without a proved need can fake success — this is an explicit
stop-rule below.

---

## 1. Next-wave job queue

Each job lists: (1) purpose, (2) target theorem/API, (3) required inputs,
(4) expected output, (5) job type, (6) success/failure interpretation. Job IDs
reuse the already-prepared numbering where scaffolds exist.

### Job C244 — tetrahedral lattice-duality / Brillouin-torus theorem

1. **Purpose.** Discharge the "independent-angle / lattice-duality" hypothesis
   that C240's branch table is conditioned on. Turn the caveat into a theorem:
   the four `k_A = n_A · p` are genuine independent character coordinates on the
   rank-4 oblique null-edge torus `(R/2πZ)^4`, not blurred hypercubic momenta.
2. **Target.** Finite layer first: `homogeneousTetraMap_eq_zero_imp` and
   injectivity of the homogeneous coordinate map (already scaffolded), then the
   quotient statement `Λ_tet ≅ Z^4`, dual torus `Hom(Λ_tet,U(1)) ≅ (R/2πZ)^4`,
   `T_A ↦ exp(i k_A)`, naming the exact integral lattice.
3. **Inputs.** `TetrahedralLatticeDuality.lean` (scaffold present),
   `TetrahedralBranchWindow.lean` (`tetra_homogeneous_injective`).
4. **Output.** Lean proof of the finite kernel/injectivity lemma; either the
   full quotient-torus theorem or a precise statement of the residual integral
   lattice that must be fixed, with the Mathlib API needed.
5. **Type.** Focused standalone (finite linear algebra), live-repo integration
   into the scaffold file.
6. **Interpretation.** Success removes the C240 caveat and makes the branch
   table unconditional. Failure (non-injective / wrong lattice) means the branch
   count is geometry-dependent and the whole branch table must be re-derived —
   a foundational red flag.

### Job C247 — Euclidean Clifford / coframe convention theorem

1. **Purpose.** Pin the Hilbert/Euclidean Hermitian gamma convention so the sign
   kernel proof is self-adjoint, and explicitly bar Lorentzian null-slash
   singularities from the spectral-gap proof.
2. **Target.** `B_A† = B_A`; `{γ5,B_A}=0`; `D_ne^0(k)=(i/a)ΣB_A sin k_A` is
   anti-Hermitian and anticommutes with γ5; `W(k)` Hermitian and commutes with
   γ5; therefore `H_tet=γ5(D_ne^0+W)` Hermitian. Plus the convention guard:
   `γ5·B_A` is **anti**-Hermitian (not Hermitian) when `B_A`† = `B_A`,
   `{γ5,B_A}=0`.
3. **Inputs.** `TetrahedralBranchWindow.lean`, `NullEdgeOverlapKernel.lean`,
   C239 star-algebra API.
4. **Output.** Lean theorems over the abstract star algebra plus a stated
   verdict on any convention mismatch found.
5. **Type.** Focused standalone over an abstract star algebra (no analysis),
   integrate into `NullEdgeOverlapKernel.lean`.
6. **Interpretation.** Success gives the Hermiticity precondition for
   `sign(H_tet)`. Failure means a sign/convention error that would invalidate
   the entire overlap-sign construction — must be fixed before C243/C248.

### Job C243 — global free gap theorem for H_tet

1. **Purpose.** Upgrade C240's exact-branch-point signs to a global no-zero /
   gap statement on the whole rank-4 torus. This is the technical heart of the
   free model.
2. **Target.** `F(k)=|ΣB_A sin k_A|² + (r Σ(1-cos k_A) - ρ)² ≠ 0` for `r>0`,
   `0<ρ<2r`; ideally the quantitative `H_tet(k)² ≥ (c²/a²)·1` with the explicit
   `c` from Pro's `λ=ρ/r`, `δ`, `α`, `β` split. Discharge the two scaffold
   handoffs `sin_zero_to_branchAngles` and `tetraKineticCoeffNormSq_detection`.
3. **Inputs.** `TetrahedralGlobalGap.lean` (scaffold present), C240 branch
   window; **depends on C244** (independence) and **C247** (Hermitian square
   `K†K = (q²+M²)·1`).
4. **Output.** Lean no-zero theorem; if the uniform numerical gap is too heavy,
   the no-zero theorem plus the named compactness theorem required for uniform
   positivity.
5. **Type.** Focused standalone (real-analytic inequality), integrate into
   `TetrahedralGlobalGap.lean`.
6. **Interpretation.** Success: `sign(H_tet)` is well defined everywhere → green
   light for C248/C249. Failure reveals a residual zero branch → triggers the
   decision-tree pivot toward Branch B `M_br` (proved need).

### Job C248 — sign(H_ne) + Ginsparg-Wilson assembly with corrected projectors

1. **Purpose.** Algebraic release from the gapped Hermitian kernel to the
   overlap operator and the GW relation, with the projector correction.
2. **Target.** From `γ5†=γ5, γ5²=1, ε†=ε, ε²=1`,
   `D=(ρ/a)(1+γ5 ε)`, `a,ρ≠0`: derive
   `Dγ5+γ5 D=(a/ρ)Dγ5 D`;
   `ĝ5 = γ5(1-(a/ρ)D) = -ε`; `ĝ5†=ĝ5`; `ĝ5²=1`;
   `P̂± = (1±ĝ5)/2` idempotent. Correct the existing
   `normalized_ginspargWilson_of_involutions` if it mis-states `γ5 ε` as a
   self-adjoint involution (it is γ5-unitary, not self-adjoint).
3. **Inputs.** `NullEdgeOverlapKernel.lean`, C239 API, **depends on C247** (ε
   well-defined Hermitian) and **C243** (ε² = 1 from the gap).
4. **Output.** Lean GW/projector theorems plus any correction to the existing
   theorem.
5. **Type.** Focused standalone (pure star-algebra), integrate into
   `NullEdgeOverlapKernel.lean`.
6. **Interpretation.** Success gives the corrected chiral projector API.
   Failure (non-idempotent / non-self-adjoint ĝ5) means the projector
   definition is wrong — must be fixed before any index/anomaly work.

### Job C249 — free no-mirror-pole theorem for D_ov,tet

1. **Purpose.** Prove mirror doublers are removed by an inverse-propagator gap,
   **not** by propagator zeros — preserving the no-propagator-zero
   mirror-removal rule.
2. **Target.** `D_ov,tet(k)=0 ⇔ Q(k)=0 ∧ M(k)<0`; under `0<ρ<2r` this holds
   only at the origin branch `k_A=0`; at every lifted doubler corner
   `D_ov,tet(k)=2ρ/a`. Acceptable Levels 1 (scalar `K=M+iq`), 2 (Clifford
   scalar-square `K†K=F·1`), 3 (direct branch-corner from C240/C243).
3. **Inputs.** `NullEdgeOverlapKernel.lean`, **depends on C243** (gap) and
   **C247** (`K†K=(q²+M²)·1`).
4. **Output.** Lean no-mirror-pole theorem at the highest feasible level, plus
   proof plan if the full operator model is too heavy.
5. **Type.** Focused standalone, integrate into `NullEdgeOverlapKernel.lean`.
6. **Interpretation.** Success: the single physical zero sits at the origin and
   doublers are gap-lifted, exactly the desired free spectrum. Failure means a
   surviving mirror pole → model is not a valid overlap and Branch B is forced.

### Job C250 — transport / reference-import connection to C242 (AFTER direct free theorem)

1. **Purpose.** Only **after** C243+C249 give the direct free theorem, connect
   the tetrahedral kernel to the C242 below-margin gapped-homotopy import as an
   independent cross-check, not as the primary proof.
2. **Target.** Instantiate C242's `GappedHomotopy` / reference-import API with
   `H_tet` and `H_ref`, showing the tetrahedral kernel lies below the C242
   margin so the gap/sign is transported.
3. **Inputs.** `GappedHomotopy.lean`, `NullEdgeOverlapReferenceImport.lean`,
   `SignStability.lean`, `OperatorFreeze.lean`, `ProjectorPersistence.lean`;
   the proved C243 gap.
4. **Output.** Lean transport theorem linking the direct free result to the
   reference-import lane.
5. **Type.** Live-repo proof package (integrates several existing modules).
6. **Interpretation.** Success: two independent routes agree (robustness).
   Failure: only a localized cross-check fails; the direct theorem still stands,
   so this is non-blocking. **Do not run before C243/C249** — running it first
   risks re-importing the very hypercubic similarity Pro warned against.

### Job C251 — gauge covariance / admissibility / path-sum source-contract layer (BackgroundGauge)

1. **Purpose.** Begin the `BackgroundGauge` layer: covariance of the construction
   under non-trivial `U`, admissibility bounds, and the path-sum source-contract
   boundaries — kept strictly separate from the free layer.
2. **Target.** Gauge-covariant transform of `H_tet[U]`, ε, and the projectors;
   admissibility condition under which the gap survives a background; explicit
   statement that gauge shifts do **not** commute away from `U=1`; the
   source-contract interface lemmas.
3. **Inputs.** the completed free stack (C243/C248/C249); a new
   `BackgroundGauge` Draft module (to be scaffolded), kept out of
   `GateC1_NU_Free`.
4. **Output.** Lean covariance/admissibility statements (likely several with
   `sorry` first), in a separate module.
5. **Type.** Live-repo proof package in a new, isolated layer.
6. **Interpretation.** Success starts the gauge layer without contaminating the
   free claims. Failure is informative about which admissibility window is
   needed. **Must not be merged into the free namespace.**

### Job C252 — anomaly / determinant-line layer (Quantum)

1. **Purpose.** Begin the `Quantum` layer: determinant-line / anomaly
   accounting on top of the projectors — separate from free and gauge layers.
2. **Target.** Determinant-line cocycle / phase API for the chiral projectors;
   index-as-anomaly statement; explicit non-claim that free overlap implies SM
   chiral gauge closure.
3. **Inputs.** C248 projectors; a new `Quantum` Draft module.
4. **Output.** Skeleton theorems (`sorry`-staged) defining the determinant-line
   API and the anomaly bookkeeping.
5. **Type.** Strategy/literature audit first, then live-repo skeleton. Much of
   this needs Mathlib coverage checks (determinant lines / Pfaffian phases are
   likely absent and must be built).
6. **Interpretation.** Success scopes the quantum layer. This layer cannot, on
   its own, certify SM closure — keep that disclaimer explicit.

### Job C245 — fallback constrained M_br (ONLY if a proved need appears)

1. **Purpose.** Fallback branch-lift, activated **only** if C243 or C249 expose
   an unsplit residual branch, or a later gauge/internal requirement forces it.
2. **Target.** A `γ5`-even, Hermitian, gauge-covariant, null-edge point-group
   constrained, lowest-degree/lowest-orbit `M_br` that splits exactly the
   identified degeneracy — with the C241 Walsh interpolation as the bridge.
3. **Inputs.** `CKMWilsonWindow.lean`, `BranchMass.lean`, C241 interpolation;
   the specific failing test from C243/C249.
4. **Output.** Lean `M_br` realization tied to a *named* failing test.
5. **Type.** Focused standalone, held prepared, not launched in the first wave.
6. **Interpretation.** Activate only with a recorded proved need. Forbidden:
   using SM flavor / CKM texture as a free branch-lift knob; introducing `M_br`
   to "improve" an already-passing free table (fake success).

---

## 2. Branch-dependent decision tree

```text
START: C244 (lattice duality) — unconditionalize the branch table.
  |
  |-- C244 FAILS (non-injective / wrong lattice)
  |     -> STOP free path. Re-derive geometry; branch table is not well posed.
  |
  v  C244 OK
C247 (Euclidean Clifford convention) — Hermiticity of H_tet.
  |
  |-- C247 finds convention mismatch
  |     -> fix sign/convention FIRST; do not proceed to gap.
  |
  v  C247 OK
C243 (global free gap) — the pivotal test.
  |
  |-- C243 proves gap (no zero on the torus)
  |     -> Branch A confirmed. Proceed C248 -> C249.
  |
  |-- C243 finds a residual zero branch
  |     -> Branch B trigger: C245 M_br with the SPECIFIC failing branch as the
  |        proved need. Re-run C243 with M_br. Keep M_br minimal.
  |
  v  C243 OK
C248 (sign + GW assembly, corrected projectors)
  |
  v  C248 OK
C249 (free no-mirror-pole)
  |
  |-- C249 finds a surviving mirror pole
  |     -> Branch B trigger (proved need): C245 M_br to lift that doubler.
  |
  v  C249 OK  ==> FREE MODEL D_ov,tet COMPLETE (GateC1_NU_Free direct theorem)
  |
  v
C250 (transport / reference-import cross-check vs C242)   [non-blocking]
  |
  v
C251 (BackgroundGauge: covariance / admissibility / source-contract)  [separate layer]
  |
  v
C252 (Quantum: anomaly / determinant-line)  [separate layer]
```

Key gating rule: **C250 only after C243 AND C249**. The direct free theorem must
exist before any reference-import transport, so the hypercubic-Wilson similarity
is never silently re-imported as a hidden assumption.

---

## 3. Recommended immediate first job after C240

**C244 — tetrahedral lattice-duality / Brillouin-torus theorem.**

Rationale: every downstream theorem (the branch table in C240, the gap in C243,
the no-mirror-pole in C249) is currently conditioned on the independent-angle
hypothesis. C244 is finite linear algebra, a scaffold already exists
(`TetrahedralLatticeDuality.lean` with `homogeneousTetraMap` and
`tetra_homogeneous_injective`), and proving it removes the single shared caveat
beneath the whole free stack. It is the highest value-per-effort job and
unblocks C243.

Run C247 in parallel (independent, pure star-algebra) so the Hermiticity
precondition is ready the moment C244 lands and C243 can start immediately.

---

## 4. Risks and stop rules (hidden traps)

```text
TRAP 1 — H_tet must be gapped at k=0, and is NOT physically zero there.
  Correct: H_tet(0) = -(ρ/a) γ5, invertible. The physical zero belongs to
  D_ov,tet, not H_tet. Any statement that "H_tet has a zero at the origin"
  is a STOP-and-fix error (re-check C243/C249 phrasing).

TRAP 2 — Lorentzian Clifford null singularities do NOT belong in the Euclidean
  overlap sign-kernel proof. C247 must use Euclidean Hermitian gammas only.
  Null-slash singularities live in the later path/soldering interpretation.
  Importing them into the spectral proof is a STOP error.

TRAP 3 — finite-volume pi corners require EVEN lattice lengths if a finite
  lattice model is used. If C243/C244 are ever specialized to a finite L^4
  lattice, enforce even L so the k_A = pi corners exist; otherwise the branch
  table is incomplete. (The torus version avoids this; flag it if finite.)

TRAP 4 — gauge shifts do NOT commute away from U=1. C251 must not assume the
  free covariance argument extends linearly to backgrounds. Any "shift commutes"
  step away from U=1 is a STOP error in the BackgroundGauge layer.

TRAP 5 — M_br can fake success if introduced without a proved need. C245 is
  forbidden unless C243 or C249 records a SPECIFIC failing branch/pole. Never
  add M_br to a passing free table; never use SM flavor/CKM texture as the lift.

STOP RULES (claim discipline):
  * Do not claim Standard Model chiral gauge closure from free overlap alone.
  * Keep GateC1_NU_Free, BackgroundGauge, Quantum in separate namespaces/files.
  * Preserve the no-propagator-zero mirror-removal rule (C249 Level >= 1).
  * Preserve source-contract boundaries (C251 interface lemmas only).
  * Verify every "proved" job is sorry-free and uses only allowed axioms before
    marking it complete.
```

---

## 5. One-line queue summary

```text
C244 (lattice duality) -> C247 (Euclidean Clifford) -> C243 (global gap)
  -> C248 (sign+GW, corrected projectors) -> C249 (no-mirror-pole)
  -> [free complete] -> C250 (transport vs C242) -> C251 (BackgroundGauge)
  -> C252 (Quantum/anomaly);  C245 (M_br) only on a proved need.
```
