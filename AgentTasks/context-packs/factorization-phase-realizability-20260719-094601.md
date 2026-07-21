# Aristotle semantic context pack

Generated: 2026-07-19T09:46:58
Query: `positive 2x2 momentum factorization fixed determinant phase U(2) SU(2) fiber common null data realizability`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean` [factorization_fiber_unitary]

Score: `0.856`

```text
theorem factorization_fiber_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) :
    ∃! U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  refine' ⟨ L0 * M, _, _ ⟩ <;> simp_all +decide;
  · simp_all +decide [ Matrix.mem_unitaryGroup_iff ];
    simp_all +decide [ ← Matrix.mul_assoc, SameMomentumGram ];
    simp_all +decide [ mul_assoc, star ];
    simp_all +decide [ ← Matrix.conjTranspose_mul ];
  · simp_all +decide [ ← Matrix.mul_assoc ]

/-
**Phase-fixed fiber.**  If determinant is fixed as well, the unique
unitary factor lies in `SU(2)`.
-/
```

### 2. `AgentTasks/overnight-allmass-run-2026-07-09/ARISTOTLE_PROMPT_codex_null_factorization_spin_fiber_20260709.md` [Objective]

Score: `0.838`

```text
## Objective

Prove the finite matrix theorem that an invertible complex `2 x 2` factor of a
fixed positive momentum matrix has a right `U(2)` fiber, and that fixing its
determinant reduces the fiber to `SU(2)`. Close every proof hole in:

`SpinFiber/Factorization.lean`

Run the narrow command first:

```text
lake env lean SpinFiber/Factorization.lean
```

The input file already typechecks modulo its executable proof holes. Preserve
all theorem statements. Small helper lemmas are welcome. Do not replace any
proof by an escape hatch or compiler-trusted finite decision procedure.
```

### 3. `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean`

Score: `0.838`

```text
import Mathlib

/-!
# The unitary fiber of a positive momentum factorization

For a complex `2 x 2` factor `M`, the positive matrix `P = M M^H` forgets a
right-unitary degree of freedom.  This file asks for the exact finite theorem:
relative to any chosen invertible factor `M0`, every other factor of the same
`P` is uniquely `M0 U` for a unitary `U`.  If the determinant phase is also
fixed, `U` is special unitary.

This is the algebraic little-group fiber used by massive spinor-helicity.  Its
honest scope is the `U(2)`/`SU(2)` factorization theorem; it does not construct
spin representations, Wigner rotations, or a spin-statistics theorem.

Conventions: matrices act on columns from the left; `M^H` is conjugate
transpose; the group acts on factor columns from the right.

Provenance: clean-room finite matrix formalization completed by Aristotle
project `ccff7fc8-bba7-4260-a335-25597d622551` during the 2026-07-09 all-mass
run and independently checked under the repository's pinned Lean toolchain.
-/

open scoped Matrix ComplexOrder
```

### 4. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_LATEST_KINEMATICS_SPIN_AUDIT_04.md` [F3 — SU(2) spin-half action: correct defining representation + double-cover fingerprint, no particle/spin-statistics overreach]

Score: `0.832`

```text
iber`. The kernel here only asserts that this particular
   matrix satisfies the SU(2) relations; that it *is* the factorization fiber is
   inherited, not re-derived.
3. Minor convention note: `IsSU2` states unitarity one-sided (`Uᴴ*U = 1`) plus
   `det = 1`; harmless in finite dimension and reconciled with
   `specialUnitaryGroup` via `mem_unitaryGroup_iff'`.

---
```

### 5. `AgentTasks/overnight-allmass-run-2026-07-09/2026-07-09_PRO_broader-physics-null-information.md` [Null-factorization spin fiber: submitted]

Score: `0.830`

```text
### Null-factorization spin fiber: submitted

The focused Aristotle target
`ARISTOTLE_PROMPT_codex_null_factorization_spin_fiber_20260709.md` asks for the
exact finite theorem

```text
M M^H = M0 M0^H  <->  M = M0 U,  U in U(2),
```

relative to an invertible base factor `M0`, with uniqueness of `U`. Fixing
`det M = det M0` reduces the fiber to `SU(2)`. The package includes an explicit
nontrivial determinant-fixed witness. Aristotle project:
`ccff7fc8-bba7-4260-a335-25597d622551`.

This identifies the algebraic little-group fiber. Deriving spin
representations, Wigner holonomy, and spin-statistics remains later work.
```

### 6. `AgentTasks/overnight-null-information-run-2026-07-10/2026-07-10_ARISTOTLE_COMPOSITION_LANDINGS_AUDIT_01.md` [D. Null factorization spin fiber (self-contained; all derived from Mathlib)]

Score: `0.822`

```text
### D. Null factorization spin fiber (self-contained; all derived from Mathlib)
```
[primitive: Mathlib]  unitaryGroup, specialUnitaryGroup, det_fin_two, conjTranspose ═▶
   │
   ├─ unitary_right_action_preserves ─┐
   │                                   ▼
   ├─ factorization_fiber_unitary (∃! U∈U(2), M=M0·U)
   │                                   ▼
   └─ factorization_fiber_special_unitary (∃! U∈SU(2)) ──▶ OBSERVABLE: U(2)/SU(2) factor fiber
   witnessBase/Inverse/Rotation/Factor ─▶ witness_* ─▶ nontrivial_special_unitary_fiber_witness (control)
```
```

### 7. `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean` [witness_factor_nontrivial]

Score: `0.817`

```text
theorem witness_factor_nontrivial : witnessFactor ≠ witnessBase := by
  norm_num [ witnessFactor, witnessBase ];
  norm_num [ ← List.ofFn_inj, witnessRotation ]

/-
A concrete nontrivial point in the determinant-fixed `SU(2)` fiber.
-/
```

### 8. `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean` [factorization_fiber_special_unitary]

Score: `0.815`

```text
theorem factorization_fiber_special_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  have hdet0 : M0.det ≠ 0 := by
    intro hzero
    have hdetLeft := congrArg Matrix.det hleft
    rw [Matrix.det_mul, Matrix.det_one, hzero, mul_zero] at hdetLeft
    exact zero_ne_one hdetLeft
  -- Existence: find U := L0 * M. By factorization_fiber_unitary, this U is in unitaryGroup, and since determinant is fixed, U ∈ specialUnitaryGroup.
  have hu_exists : ∃ (U : Mat2), U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U ∧ U.det = 1 := by
    have h_unitary : ∃ U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
      exact ExistsUnique.exists ( factorization_fiber_unitary M0 L0 M hleft hright hgram )
    obtain ⟨U, hU_unitary, hU⟩ := h_unitary
    use U
    simp_all +decide [ SameMomentumGram ];
  obtain ⟨ U, hU₁, hU₂, hU₃ ⟩ := hu_exists; use U; simp_all +decide [ Matrix.mem_specialUnitaryGroup_iff ] ;
  intro V hV₁ hV₂ hV₃; apply_fun ( fun x => L0 * x ) at hV₃; simp_all +decide [ ← mul_assoc ] ;

/-! ## Explicit nondegenerate `SU(2)` orbit witness -/
```

## Scoped paper hits

### 1. Twisted geometries: A geometric parametrisation of SU(2) phase space

Score: `0.787`
Zotero key: `63MQ6KC3`
arXiv: `1001.2748v3`
URL: http://arxiv.org/abs/1001.2748v3

Abstract:

Twisted-geometry parametrization of SU(2) loop-gravity phase space, including face areas, normals, extrinsic angle, gauge-invariant reduced phase space, and connection to closure/geometricity constraints.

### 2. Commutator of the Quark Mass Matrices in the Standard Electroweak Model and a Measure of Maximal CP Nonconservation

Score: `0.740`
Zotero key: `D6TGC96N`
DOI: `10.1103/PhysRevLett.55.1039`
URL: https://doi.org/10.1103/physrevlett.55.1039

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.736`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 4. Momentum bispinor, two-qubit entanglement and twistor space

Score: `0.734`
Zotero key: `3VBEK82X`
arXiv: `1407.2492`
URL: http://arxiv.org/abs/1407.2492

Abstract:

Re-examines massive momentum bispinor symmetry and connects unit-energy future-lightcone geometry with two-qubit entanglement and twistor-space normalization. Important prior-art guardrail for observer-conditioned Pluecker mixedness.

### 5. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.734`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011
