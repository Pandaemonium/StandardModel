Close the ONE remaining `s o r r y` in
`PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean`: the RP-F node N5
Gram factorization `reflectedWilsonBlock_eq_gram` (around line 481). This file
ALREADY contains the full surrounding scaffold from a prior job: the crux
STATEMENT (with the faithful reflection-hermiticity hypothesis `hrefl`), and the
entire downstream assembly N6-N12 + `finite_fermionic_RP` proved sorry-free ON
TOP of this crux. So closing THIS ONE theorem turns the whole fermionic
reflection-positivity chain sorry-free.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean`
(currently reports exactly one `declaration uses sorry` at N5). If broader
`lake build` stalls, SKIP and return source.

## The target (preserve the statement + `hrefl` hypothesis verbatim)

```lean
theorem reflectedWilsonBlock_eq_gram [NeZero L]
    (m : ℝ) (U : Fin 4 → Site L → Matrix (Fin nc) (Fin nc) ℂ)
    (hU : ∀ μ x, (U μ x)ᴴ * (U μ x) = 1)
    (hrefl : rpFReflection L nc * wilsonDirac m U * rpFReflection L nc
        = (wilsonDirac m U)ᴴ) :
    ∃ M : Matrix (Idx L nc) (posHalf L nc) ℂ,
      reflectedWilsonBlock (L := L) (nc := nc) m U = Mᴴ * M
```

`reflectedWilsonBlock m U := E · (D·Θ) · Eᴴ` where `E = posHalfSel` selects the
positive-time half (`posHalf`), `D = wilsonDirac m U`, `Θ = rpFReflection L nc`.

## The mechanism (from the QMF5 Deliverable-1 D1.4 note, already in the docstring)

Link reflection identifies the `t=1` boundary of the positive half with the
`Θ`-image of the `t=0` boundary of the negative half. The single cross-mirror
hopping term carries the forward temporal Wilson projector `P+ = (1-γ0)/2` on the
`+` side and `P+^H = P+` on the reflected side, so the coupling is literally
`(P+ x)^H (P+ x)` - a Gram form. The Wilson mass term and all SPATIAL hopping are
block-diagonal across the mirror (the interior of `M`); `hrefl` (`Θ D Θ = D^H`)
makes the cross term Hermitian-symmetric. Construct `M` explicitly as
`M := (temporal-hopping-factor) · P+ · (half-operator) · E^H` and verify
`reflectedWilsonBlock = M^H M` by the matrix identity, using `hrefl`,
`rpFReflection_herm`/`_sq`/`_unitary`, and `liftProjPlus_herm`/`_idem` (all
already proved in the file).

## Strategy options if the general case is heavy

- **Reduce the algebra:** expand `reflectedWilsonBlock = E (D Θ) Eᴴ`, substitute
  `Θ D Θ = Dᴴ` from `hrefl` to symmetrize, and factor through `P+ = P+ᴴ = P+²`
  so the block is manifestly `(P+ V)ᴴ (P+ V)` for an explicit `V`.
- **Fallback (concrete instance):** if the general `L, nc` matrix identity is
  intractable, prove it for a concrete small case (`L = 2`, `nc = 1`, explicit
  `D`), giving a kernel-checked witness that de-risks the general proof - but
  PREFER the general theorem, and keep the general statement (do not weaken it).

## Constraints

- Preserve the statement and the `hrefl` hypothesis verbatim. Do NOT touch the
  downstream theorems (N6-N12, `finite_fermionic_RP`) - they already consume this
  crux; closing it makes them all sorry-free automatically.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. If you
  cannot fully close it, return the smallest residual with a tightened handoff.
- If `lake build` stalls, SKIP; return the proof as a patch/text.
