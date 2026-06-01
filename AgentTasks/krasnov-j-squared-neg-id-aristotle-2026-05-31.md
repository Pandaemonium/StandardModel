# Aristotle task: Krasnov J² = −id

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `a4828593-2ad6-43ae-91c9-6dfa2de9456c`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave2-20260531`
**Output**: `AgentTasks/aristotle-output/krasnov-j-squared-neg-id-20260531`
**Type**: Krasnov complex structure concrete calculation

## Goal

Prove that the complex structure `J = rightMulE111` squares to −id on
`OctonionicQubit`:

```lean
theorem rightMulE111_sq_neg (q : OctonionicQubit) :
    rightMulE111 (rightMulE111 q) = -q
```

Add this theorem to:

```text
PhysicsSM/Spinor/KrasnovComplexStructure.lean
```

in the namespace `PhysicsSM.Spinor.KrasnovComplexStructure`.

If the file is sorry-free after the addition, add the module to `PhysicsSM.lean`.

## Mathematical context

In Krasnov's approach (arXiv:1912.11282), the key object is the complex
structure `J = R_{e111}` (right multiplication by `e111`) on the
octonionic spinor space `O²`. The property `J² = -id` is what makes `J`
a genuine complex structure, and it is the foundation for the centralizer
construction.

## Existing infrastructure to use

The file `PhysicsSM/Spinor/KrasnovComplexStructure.lean` already contains:

- `rightMulE111 : OctonionicQubit → OctonionicQubit` — the complex structure map.
- `rightMulE111_line_coords (z : ChosenComplex) :
    (z.toOctonion * e111).toChosenComplex = ⟨-z.im, z.re⟩`
  This shows J maps `(re, im) ↦ (-im, re)` on the complex-line summand.
- `rightMulE111_complement_coords (w : ComplexTriple) :
    (w.toOctonion * e111).toComplexTriple =
      ⟨w.w1_im, -w.w1_re, w.w2_im, -w.w2_re, w.w3_im, -w.w3_re⟩`
  This shows J maps `(re, im) ↦ (im, -re)` on each complement component.
- `splitQubit (q : OctonionicQubit) : OctonionicQubitSplitting` —
  decomposes `q` into `(fst_line, fst_complement, snd_line, snd_complement)`.
- `splitQubit_roundtrip (q : OctonionicQubit) :
    (splitQubit q).toQubit = q`

## Informal proof sketch

The theorem follows by a two-step coordinate calculation.

**On the line summand**: `rightMulE111_line_coords` gives
`J(re, im) = (-im, re)`. Applying twice: `J²(re, im) = J(-im, re) = (-re, -im) = -(re, im)`.

**On the complement summand**: `rightMulE111_complement_coords` gives
`J(re, im) = (im, -re)` for each pair. Applying twice:
`J²(re, im) = J(im, -re) = (-re, -im) = -(re, im)`.

Since `q` splits into its line and complement parts, and J² = -id on each,
we get `J²(q) = -q`.

The cleanest proof strategy is likely:
1. Use `splitQubit_roundtrip` to reduce to the split representation.
2. Apply the coordinate results twice for the line and complement.
3. Conclude via `OctonionicQubit.ext`.

Alternatively, the existing lemma `rightMul_e111_sq_neg` in
`ComplexLine.lean` (if present) may give a shortcut via:
```lean
rightMulE111 (rightMulE111 q) = ⟨q.fst * e111 * e111, q.snd * e111 * e111⟩
                               = ⟨-q.fst, -q.snd⟩
                               = -q
```
using the fact `e111 * e111 = -1` from `e111_sq` in
`PhysicsSM.Algebra.Octonion.ComplexLine`.

## Corollary to also prove

```lean
/-- The complex structure `J = rightMulE111` has order 4 (equivalently,
    J² is a linear involution equal to -id). -/
theorem rightMulE111_sq_neg_linearMap :
    (rightMulE111 ∘ rightMulE111) = fun q => -q
```

## Claim boundary

These theorems verify the complex-structure property `J² = -id` for the
Krasnov construction. They do **not** claim intersection with Spin(9),
nor the Standard Model gauge group identification.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the proof readable; avoid long `decide`-only finishes.
- Do not restructure unrelated parts of `KrasnovComplexStructure.lean`.

## Verification

```bash
lake env lean PhysicsSM/Spinor/KrasnovComplexStructure.lean
lake build PhysicsSM.Spinor.KrasnovComplexStructure
```
