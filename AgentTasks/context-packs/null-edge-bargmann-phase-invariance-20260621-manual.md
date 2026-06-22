# Aristotle manual context pack

Generated: 2026-06-21

Query:

```text
closed-loop Bargmann Pancharatnam phase invariance under local unit complex
phase rescaling over the trusted Pluecker and Bargmann phase API
```

## Target idea

The previous Bargmann phase port established a canonical phase companion layer
over the trusted Pluecker API:

- Hermitian spinor pairing `spinorInner`;
- rank-one ket-bra and projector matrices;
- the two-spinor Lagrange identity;
- the Bargmann/Pancharatnam triple-trace formula;
- the normalized complement relation between Pluecker spread and Hermitian
  overlap.

This follow-up asks for the gauge/observable wrapper: local unit complex phase
rescalings of the three spinors leave the closed-loop Bargmann trace invariant.

## Included copied dependencies

The focused package includes copied versions of:

```text
PhysicsSM/Spinor/PluckerMass.lean
PhysicsSM/Draft/NullEdgeBargmannPhasePort.lean
```

Key API from `PhysicsSM.Draft.NullEdgeBargmannPhasePort`:

```lean
def spinorInner (psi phi : CSpinor) : Complex
def rankOneKetBra (psi phi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex
def rankOneProjector (psi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex
def trace2 (M : Matrix (Fin 2) (Fin 2) Complex) : Complex

theorem rankOneKetBra_mul
    (psi phi chi eta : CSpinor) :
    rankOneKetBra psi phi * rankOneKetBra chi eta =
      spinorInner phi chi • rankOneKetBra psi eta

theorem rankOneProjector_mul (psi phi : CSpinor) :
    rankOneProjector psi * rankOneProjector phi =
      spinorInner psi phi • rankOneKetBra psi phi

theorem bargmannTripleTrace_rankOne
    (psi phi chi : CSpinor) :
    trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) =
      spinorInner psi phi * spinorInner phi chi * spinorInner chi psi
```

## Proof sketch

1. Prove the Hermitian pairing scaling law:

```lean
spinorInner (a • psi) (b • phi) =
  (starRingEnd Complex a * b) * spinorInner psi phi
```

2. From that, prove the closed product scaling:

```lean
bargmannTriple (a • psi) (b • phi) (c • chi) =
  ((starRingEnd Complex a * a) *
    (starRingEnd Complex b * b) *
    (starRingEnd Complex c * c)) *
  bargmannTriple psi phi chi
```

The cancellation is only commutative complex algebra:

```text
(conj a * b) (conj b * c) (conj c * a)
  = (conj a * a) (conj b * b) (conj c * c)
```

3. Under unit-phase hypotheses `starRingEnd Complex u * u = 1`, derive the
phase-invariant product.

4. Rewrite both sides of the trace theorem with
`bargmannTripleTrace_rankOne` and use the product invariance theorem.

## Statement risks

- Keep the unit phase hypotheses explicit. Do not replace them with nonzero
  hypotheses; nonzero rescalings change the magnitude.
- Preserve the order/convention of `spinorInner`, which is conjugate-linear in
  the first argument.
- The final theorem is an observable/gauge statement, not a normalization
  theorem.
