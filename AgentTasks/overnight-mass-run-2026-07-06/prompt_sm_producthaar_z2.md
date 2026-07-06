Close the FROZEN reflection-positivity handoff of the product-Haar substrate for
the finite ABELIAN case, where the general Peter-Weyl input reduces to elementary
finite character theory. This is the tractable special case of the one `s o r r
y` in `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean`.

START: read `PhysicsSM/Draft/NullEdge/QMF/ProductHaarConfig.lean` (just landed):
`Config ι G = ι → G`, `productHaar`, the proved gauge/reflection symmetries, the
DEFINED RP bilinear form `reflForm μ refl F G = ∫ (F ∘ theta) * G d(productHaar)`,
and the FROZEN `reflForm_self_nonneg` (`0 ≤ reflForm ... F F`). Check with
`lake env lean`. If broader `lake build` stalls, SKIP and return source.

Create a NEW module `PhysicsSM/Draft/NullEdge/QMF/ProductHaarZ2RP.lean` (do NOT
edit the frozen theorem in place - build the concrete-case proof alongside).

## Target

For `G = Z2` (`Multiplicative (ZMod 2)` or the `Bool`/`Fin 2` group already used
in `GateYM/Z2GaugeCore`) and a small finite edge set (start with `ι = Fin 1`,
then `Fin 2`), PROVE the reflection positivity `0 ≤ reflForm F F` for the
product-Haar reflection form, using the fact that for a finite abelian group the
Haar measure is the normalized counting measure and Peter-Weyl is just the
finite Fourier/character decomposition (2 characters for `Z2`). Concretely:

1. Specialize `productHaar` to `Measure.count`-normalized on the finite `Config`.
2. Expand `reflForm F F` as a finite sum over configurations; use the
   reflection `theta` (link inversion = identity on `Z2` since every element is
   its own inverse, composed with the edge permutation) to exhibit the form as a
   Gram/square `∑ |...|^2 ≥ 0`, OR via the finite character orthogonality of
   `Z2`.
3. State `productHaarZ2_reflForm_self_nonneg` (the concrete-case RP positivity)
   and, if clean, the `Fin 2` two-link version.

## Constraints

- This is the ABELIAN toy that de-risks the general (Peter-Weyl) positivity; it
  is NOT the general theorem. Label it honestly: "reflection positivity of the
  product-Haar form for the finite abelian gauge group Z2 (Peter-Weyl-free)".
- Reuse `ProductHaarConfig` definitions (`reflForm`, `productHaar`, `theta`) -
  do not redefine them. Reuse `GateYM/Z2GaugeCore` conventions if helpful.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. A
  documented residual `s o r r y` is acceptable only if you close `Fin 1` and
  reduce `Fin 2`.
- Standard axioms only for what you prove. If `lake build` stalls, SKIP; return
  source. Do NOT touch the general frozen `reflForm_self_nonneg`.
