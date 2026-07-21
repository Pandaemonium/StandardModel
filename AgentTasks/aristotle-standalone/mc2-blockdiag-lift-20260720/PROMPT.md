# Lemma job: lifting a two-component estimate through block diagonalization and unitary conjugation (MC2)

Mathlib-only, abstract, scoped L2 operator norm
(`open scoped Matrix.Norms.L2Operator`).

An audit reduced this step to pure bookkeeping (the isometry and block-norm facts
are already proved elsewhere). Assemble it as a single reusable lemma.

Setting: two-component estimates `||A_+ - E_+|| <= c eps^2` and
`||A_- - E_-|| <= c eps^2` for `A_+, A_-, E_+, E_- : Matrix (Fin 2) (Fin 2) C`.
Let `D X Y := Matrix.fromBlocks X 0 0 Y` and let `U : Matrix (Fin 4) (Fin 4) C` be
unitary (a fixed Dirac-basis change).

Prove:
1. **Block lift**: `||D A_+ A_- - D E_+ E_-|| <= c eps^2`
   (the constant does NOT accumulate; use `||fromBlocks X 0 0 Y|| = max ||X|| ||Y||`,
   proving it if needed).
2. **Conjugated lift**: `||U * (D A_+ A_-) * star U - U * (D E_+ E_-) * star U||
   <= c eps^2`, i.e. the basis change preserves the estimate exactly
   (unitary conjugation is an isometry).
3. **Combined**: a single lemma taking the two two-component hypotheses and the
   unitarity of `U`, concluding the four-component conjugated estimate with the SAME
   constant `c`.
This is the "composition theorem, not a new Taylor expansion" step: no entrywise
expansion of sixteen entries should appear. No new axioms/native_decide; standard
axioms; report axioms.
